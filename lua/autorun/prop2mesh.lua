--[[

]]
if not prop2mesh then prop2mesh = {} end


--[[

]]
prop2mesh.enablelog = false
function prop2mesh.log(msg)
	MsgC(Color(255,255,0), "prop2mesh> ", Color(255,255,255), msg, "\n")
end

local validClasses = { ["sent_prop2mesh"] = true, ["sent_prop2mesh_legacy"] = true }
function prop2mesh.isValid(self)
	return IsValid(self) and validClasses[self:GetClass()]
end

prop2mesh.defaultmat = "hunter/myplastic"


--[[

]]
if SERVER then
	AddCSLuaFile("prop2mesh/cl_meshlab.lua")
	AddCSLuaFile("prop2mesh/cl_modelfixer.lua")
	AddCSLuaFile("prop2mesh/cl_editor.lua")
	AddCSLuaFile("prop2mesh/sh_netstream.lua")

	include("prop2mesh/sh_netstream.lua")
	include("prop2mesh/sv_entparts.lua")
	include("prop2mesh/sv_editor.lua")

	function prop2mesh.getEmpty()
		return {
			crc = "!none",
			uvs = 0,
			col = Color(255, 255, 255, 255),
			mat = prop2mesh.defaultmat,
			scale = Vector(1, 1, 1),
			clips = {},
		}
	end

	local function makeEntity(class, pl, dupedata) -- limits would go here?
		local self = ents.Create(class)
		if not (self and self:IsValid()) then
			return false
		end

		if dupedata then
			duplicator.DoGeneric(self, dupedata)
		end
		self:Spawn()
		self:Activate()

		return self
	end
	prop2mesh.makeEntity = makeEntity

	duplicator.RegisterEntityClass("sent_prop2mesh", function(pl, data)
		return makeEntity("sent_prop2mesh", pl, data)
	end, "Data")

	duplicator.RegisterEntityClass("sent_prop2mesh_legacy", function(pl, data)
		return makeEntity("sent_prop2mesh_legacy", pl, data)
	end, "Data")

elseif CLIENT then
	include("prop2mesh/sh_netstream.lua")
	include("prop2mesh/cl_meshlab.lua")
	include("prop2mesh/cl_modelfixer.lua")
	include("prop2mesh/cl_editor.lua")

end

--[[
	local concat = {}
	for k, v in SortedPairs(wire_expression2_funcs) do
		if string.StartWith(k, "p2m") then
			concat[#concat + 1] = string.format("**%s** | `%s`", "function", v[1])
			concat[#concat + 1] = "------------ | -------------"
			concat[#concat + 1] = string.format("**%s** | `%s`", "return", v[2] == "" and "void" or v[2])
			concat[#concat + 1] = "**args** | "
			for i = 1, #v.argnames do
				concat[#concat + 1] = string.format("&nbsp; | `%s`", v.argnames[i])
			end
			concat[#concat + 1] = "\n"
		end
	end
	file.Write("test.txt", table.concat(concat, "\n"))
]]
