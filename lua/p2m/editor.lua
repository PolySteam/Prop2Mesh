-- -----------------------------------------------------------------------------
local color_deleted = Color(200, 85, 85)
local color_changed = Color(85, 200, 85)

local icon_file = "icon16/page_white_text.png"
local icon_cancel = "icon16/cancel.png"
local icon_part_default = "icon16/brick.png"
local icon_part_changed = "icon16/brick_add.png"
local icon_part_deleted = "icon16/brick_delete.png"


-- -----------------------------------------------------------------------------
local csent

local editors   = {}
local mcol_hov  = { r = 200/255, g = 200/255, b = 200/255 }
local mcol_del  = { r = color_deleted.r/255, g = color_deleted.g/255, b = color_deleted.b/255 }
local mcol_chn  = { r = color_changed.r/255, g = color_changed.g/255, b = color_changed.b/255 }
local wireframe = Material("models/wireframe")

local scalem = Matrix()
local scalev = Vector(1, 1, 1)

local surface = surface
local render = render
local cam = cam

local enable_clipping = CreateClientConVar("prop2mesh_editor_enableclipping", "1", true, false)

hook.Add("PostDrawOpaqueRenderables", "P2MDrawEditorGhosts", function()
	if next(editors) == nil then
		return
	end
	if not IsValid(csent) then
		csent = ClientsideModel("models/error.mdl")
		csent:SetNoDraw(true)
	end

	cam.IgnoreZ(true)
	render.ModelMaterialOverride(wireframe)
	render.SetColorModulation(1, 1, 1)

	local doClipping = enable_clipping:GetBool()

	for editor, partDataHover in pairs(editors) do
		for partID, partData in ipairs(editor.Data) do
			if next(editor.changes[partID]) == nil or not partData.mdl then
				continue
			end

			scalem:SetScale(partData.scale or scalev)

			csent:SetModel(partData.mdl)
			csent:SetPos(editor.Entity:LocalToWorld(partData.pos))
			csent:SetAngles(editor.Entity:LocalToWorldAngles(partData.ang))
			csent:EnableMatrix("RenderMultiply", scalem)
			csent:SetupBones()

			if editor.changes[partID].delete then
				render.SetColorModulation(mcol_del.r, mcol_del.g, mcol_del.b)
			else
				render.SetColorModulation(mcol_chn.r, mcol_chn.g, mcol_chn.b)
			end

			if doClipping and partData.clips then
				render.EnableClipping(true)
				for clipID, clipData in ipairs(partData.clips) do
					local normal = csent:LocalToWorld(clipData.n) - csent:GetPos()
					render.PushCustomClipPlane(normal, normal:Dot(csent:LocalToWorld(clipData.n * clipData.d)))
				end
			end

			csent:DrawModel()

			if doClipping and partData.clips then
				for clipID, clipData in ipairs(partData.clips) do
					render.PopCustomClipPlane()
				end
				render.EnableClipping(false)
			end
		end

		if partDataHover.mdl then
			scalem:SetScale(partDataHover.scale or scalev)

			csent:SetModel(partDataHover.mdl)
			csent:SetPos(editor.Entity:LocalToWorld(partDataHover.pos))
			csent:SetAngles(editor.Entity:LocalToWorldAngles(partDataHover.ang))
			csent:EnableMatrix("RenderMultiply", scalem)
			csent:SetupBones()

			render.SetColorModulation(mcol_hov.r, mcol_hov.g, mcol_hov.b)

			if doClipping and partDataHover.clips then
				render.EnableClipping(true)
				for clipID, clipData in ipairs(partDataHover.clips) do
					local normal = csent:LocalToWorld(clipData.n) - csent:GetPos()
					render.PushCustomClipPlane(normal, normal:Dot(csent:LocalToWorld(clipData.n * clipData.d)))
				end
			end

			csent:DrawModel()

			if doClipping and partDataHover.clips then
				for clipID, clipData in ipairs(partDataHover.clips) do
					render.PopCustomClipPlane()
				end
				render.EnableClipping(false)
			end
		end
	end

	cam.IgnoreZ(false)
	render.ModelMaterialOverride(nil)
	render.SetColorModulation(1, 1, 1)
end)


-- -----------------------------------------------------------------------------
local PANEL = {}


-- -----------------------------------------------------------------------------
function PANEL:Init()
	self.editor = vgui.Create("DTree", self)
	self.editor:Dock(FILL)
	self.editor.OnNodeSelected = function() self.editor:SetSelectedItem() end

	self.confirm = vgui.Create("DButton", self)
	self.confirm:Dock(BOTTOM)
	self.confirm:DockMargin(0, 2, 0, 0)
	self.confirm:SetText("Confirm changes")

	self.confirm.DoClick = function()
		if not IsValid(self.Entity) then
			return
		end

		local changes = {}

		for k, v in pairs(self.changes) do
			if next(v) ~= nil then
				changes[k] = v
			end
		end

		if next(changes) == nil then
			return
		end

		net.Start("NetP2M.MakeChanges")
		net.WriteEntity(self.Entity)
		local data = util.Compress(util.TableToJSON(changes))
		local size = string.len(data)
		net.WriteUInt(size, 32)
		net.WriteData(data, size)
		net.SendToServer()

		self:Close()
	end

	self.editor.Paint = function(pnl, w, h)
		surface.SetDrawColor(245, 245, 245)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	self.Paint = function(pnl, w, h)
		surface.SetDrawColor(55, 55, 60)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(85, 85, 90)
		surface.DrawRect(0, 0, w, 24)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
end

-- -----------------------------------------------------------------------------
function PANEL:OnClose()
	editors[self] = nil
	if IsValid(self.Entity) then
		self.Entity:RemoveCallOnRemove("RemoveP2MEditor")
	end
end


-- -----------------------------------------------------------------------------
function PANEL:SetEntity(ent)
	if not IsValid(ent) or ent:GetClass() ~= "gmod_ent_p2m" then
		return
	end

	self.Entity = ent
	self:SetTitle(tostring(self.Entity))

	self.Entity:CallOnRemove("RemoveP2MEditor", function()
		self:Close()
	end)

	self.changes = {}

	local crc = self.Entity:GetCRC()
	local tbl = p2mlib.models[crc]

	if tbl then
		self.Data = util.JSONToTable(util.Decompress(tbl.data))
	end

	self:RebuildTree()
end


-- -----------------------------------------------------------------------------
local menuFunctions = {}

function PANEL:RebuildTree()
	self.editor:Clear()

	local root = self.editor:AddNode("parts", "icon16/world.png")

	self.obj_root = root:AddNode(".obj", "icon16/car.png")

	self.obj_file = self.obj_root:AddNode("data/p2m/*.txt", "icon16/bullet_disk.png")
	self:PopulateFiles()

	self.obj_data = self.obj_root:AddNode("attachments", "icon16/bullet_picture.png")
	self.mdl_data = root:AddNode(".mdl", "icon16/bricks.png")
	if self.Data then
		self:PopulateData()
	end

	self.editor.DoRightClick = function(_, node)
		if menuFunctions[node.menu_type] then
			menuFunctions[node.menu_type](self, node)
		end
	end

	self.obj_data:AddNode("not yet implemented", "icon16/bullet_error.png")

	root:SetExpanded(true)
end


-- -----------------------------------------------------------------------------
function PANEL:PopulateData()
	self.obj_data.subnodes = {}
	self.mdl_data.subnodes = {}

	for partID, partData in ipairs(self.Data) do
		if partData.obj then
			self.changes[partID] = {}
			self:PopulateOBJ(partID, partData)
		elseif partData.mdl then
			self.changes[partID] = {}
			self:PopulateMDL(partID, partData)
		end
	end

	self.mdl_data:SetText(string.format(".mdl [%d]", table.Count(self.mdl_data.subnodes)))
end


-- -----------------------------------------------------------------------------
file.CreateDir("p2m")

function PANEL:PopulateFiles()
	local files, folders = file.Find("p2m/*.txt", "DATA")
	for i = 1, #files do
		local node = self.obj_file:AddNode(string.format("p2m/%s", files[i]), icon_file)
		node.menu_type = "file"
	end
end

menuFunctions.file = function(self, node)
	local dmenu = DermaMenu()

	dmenu:AddSpacer()
	dmenu:AddOption("Cancel"):SetIcon(icon_cancel)

	dmenu:Open()
end


-- -----------------------------------------------------------------------------
function PANEL:PopulateOBJ(partID, partData)

end

menuFunctions.obj = function(self, node)
	local dmenu = DermaMenu()

	if self.changes[node.partID].delete then
		dmenu:AddSpacer()
		dmenu:AddOption("Undo remove .obj", function()
			node:SetIcon(icon_part_default)
			node.Label:SetTextColor()
			self.changes[node.partID] = {}
		end):SetIcon(icon_part_changed)
	else
		dmenu:AddSpacer()
		dmenu:AddOption("Remove .obj", function()
			node:SetIcon(icon_part_deleted)
			node.Label:SetTextColor(color_deleted)
			self.changes[node.partID] = { delete = true }
		end):SetIcon(icon_part_deleted)
	end

	dmenu:AddSpacer()
	dmenu:AddOption("Cancel"):SetIcon(icon_cancel)

	dmenu:Open()
end


-- -----------------------------------------------------------------------------
function PANEL:PopulateMDL(partID, partData)
	local node = self.mdl_data:AddNode(string.format("[%d] %s", partID, string.GetFileFromFilename(partData.mdl)), icon_part_default)
	node.menu_type = "mdl"
	node.partID = partID

	node.flags = {
		node:AddNode(string.format("render_inside = %s", partData.inv and "true" or "false"), "icon16/bullet_black.png"),
		node:AddNode(string.format("flat_shading = %s", partData.flat and "true" or "false"), "icon16/bullet_black.png"),
	}

	self.mdl_data.subnodes[partID] = node

	node.Label.OnCursorEntered = function()
		editors[self] = partData
		node.Label:InvalidateLayout(true)
	end
end

local flags = {
	{
		text  = "Render inside",
		data  = "inv",
		icons = { "icon16/camera.png", "icon16/camera_add.png", "icon16/camera_delete.png" },
		toggle = function(node, dValue, cValue)
			if cValue ~= nil then
				node.Label:SetTextColor(color_changed)
				node:SetIcon("icon16/bullet_green.png")
				node:SetText(string.format("render_inside = %s", cValue and "true" or "false"))
			else
				node.Label:SetTextColor()
				node:SetIcon("icon16/bullet_black.png")
				node:SetText(string.format("render_inside = %s", dValue and "true" or "false"))
			end
		end
	},
	{
		text  = "Flat shading",
		data  = "flat",
		icons = { "icon16/contrast.png", "icon16/contrast_high.png", "icon16/contrast_low.png" },
		toggle = function(node, dValue, cValue)
			if cValue ~= nil then
				node.Label:SetTextColor(color_changed)
				node:SetIcon("icon16/bullet_green.png")
				node:SetText(string.format("flat_shading = %s", cValue and "true" or "false"))
			else
				node.Label:SetTextColor()
				node:SetIcon("icon16/bullet_black.png")
				node:SetText(string.format("flat_shading = %s", dValue and "true" or "false"))
			end

		end
	}
}

menuFunctions.mdl = function(self, node)
	local dmenu = DermaMenu()

	if self.changes[node.partID].delete then
		dmenu:AddSpacer()
		dmenu:AddOption("Undo remove .mdl", function()
			node:SetIcon(icon_part_default)
			node.Label:SetTextColor()
			self.changes[node.partID] = {}
		end):SetIcon(icon_part_changed)
	else
		for i, flag in ipairs(flags) do
			local sub, opt = dmenu:AddSubMenu(flag.text)
			opt:SetIcon(flag.icons[1])

			if self.changes[node.partID][flag.data] ~= nil then
				sub:AddOption(self.changes[node.partID][flag.data] and "Undo (Set false)" or "Undo (Set true)", function()
					self.changes[node.partID][flag.data] = nil
					flag.toggle(node.flags[i], self.Data[node.partID][flag.data], nil)
					if next(self.changes[node.partID]) == nil then
						node:SetIcon(icon_part_default)
						node.Label:SetTextColor()
					end
				end):SetIcon(flag.icons[3])
			else
				if self.Data[node.partID][flag.data] then
					sub:AddOption("Set false", function()
						if next(self.changes[node.partID]) == nil then
							node:SetIcon(icon_part_changed)
							node.Label:SetTextColor(color_changed)
						end
						self.changes[node.partID][flag.data] = false
						flag.toggle(node.flags[i], nil, false)
					end):SetIcon(flag.icons[3])
				else
					sub:AddOption("Set true", function()
						if next(self.changes[node.partID]) == nil then
							node:SetIcon(icon_part_changed)
							node.Label:SetTextColor(color_changed)
						end
						self.changes[node.partID][flag.data] = true
						flag.toggle(node.flags[i], nil, true)
					end):SetIcon(flag.icons[2])
				end
			end

			sub:AddSpacer()
			sub:AddOption("Set true all", function()
				for partID, partData in ipairs(self.Data) do
					if self.changes[partID].delete or self.changes[partID][flag.data] == true then
						continue
					end
					if partData[flag.data] then
						self.changes[partID][flag.data] = nil
					else
						self.changes[partID][flag.data] = true
					end
					if next(self.changes[partID]) == nil then
						self.mdl_data.subnodes[partID]:SetIcon(icon_part_default)
						self.mdl_data.subnodes[partID].Label:SetTextColor()
					else
						self.mdl_data.subnodes[partID]:SetIcon(icon_part_changed)
						self.mdl_data.subnodes[partID].Label:SetTextColor(color_changed)
					end
					flag.toggle(self.mdl_data.subnodes[partID].flags[i], partData[flag.data], self.changes[partID][flag.data])
				end
			end):SetIcon(flag.icons[2])

			sub:AddOption("Set false all", function()
				for partID, partData in ipairs(self.Data) do
					if self.changes[partID].delete or self.changes[partID][flag.data] == false then
						continue
					end
					if partData[flag.data] then
						self.changes[partID][flag.data] = false
					else
						self.changes[partID][flag.data] = nil
					end
					if next(self.changes[partID]) == nil then
						self.mdl_data.subnodes[partID]:SetIcon(icon_part_default)
						self.mdl_data.subnodes[partID].Label:SetTextColor()
					else
						self.mdl_data.subnodes[partID]:SetIcon(icon_part_changed)
						self.mdl_data.subnodes[partID].Label:SetTextColor(color_changed)
					end
					flag.toggle(self.mdl_data.subnodes[partID].flags[i], partData[flag.data], self.changes[partID][flag.data])
				end
			end):SetIcon(flag.icons[3])

			sub:AddSpacer()
			sub:AddOption("Cancel"):SetIcon(icon_cancel)
		end

		dmenu:AddSpacer()
		dmenu:AddOption("Remove .mdl", function()
			node:SetIcon(icon_part_deleted)
			node.Label:SetTextColor(color_deleted)
			self.changes[node.partID] = { delete = true }
			for i, flag in ipairs(flags) do
				flag.toggle(node.flags[i], self.Data[node.partID][flag.data], nil)
			end
		end):SetIcon(icon_part_deleted)
	end

	dmenu:AddSpacer()
	dmenu:AddOption("Cancel"):SetIcon(icon_cancel)

	dmenu:Open()
end


-- -----------------------------------------------------------------------------
vgui.Register("p2m_editor", PANEL, "DFrame")
