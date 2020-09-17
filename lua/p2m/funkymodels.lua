-- -----------------------------------------------------------------------------
local p2mlib = p2mlib

local string = string
local path = string.GetPathFromFilename
local lower = string.lower


-- -----------------------------------------------------------------------------
local funkyFolder = {}
local funkyModel  = {}
local blockModel  = {}

function p2mlib.isBlocked(model)
	return blockModel[model]
end

function p2mlib.blockModel(model, bool)
	blockModel[model] = bool
end

function p2mlib.isFunky(model)
	if funkyModel[model] then
		return funkyModel[model]
	elseif funkyFolder[path(model)] then
		return funkyFolder[path(model)]
	end
	return false
end

local pushTo
local function push(str, func)
	if pushTo then
		pushTo[lower(str)] = func or true
	end
end

concommand.Add("prop2mesh_tempfixmodel", function(ply, cmd, args)
	if not args or not args[1] then
		return
	end
	local mdl = tostring(args[1])
	if IsUselessModel(mdl) then
		return
	end
	funkyModel[mdl] = true
end)


-- -----------------------------------------------------------------------------
-- BADDIES
p2mlib.blockModel("models/lubprops/seat/raceseat2.mdl", true)
p2mlib.blockModel("models/lubprops/seat/raceseat.mdl", true)


-- -----------------------------------------------------------------------------
-- FOLDERS
pushTo = funkyFolder
push("models/cheeze/pcb/")
push("models/props_phx/construct/glass/")
push("models/props_phx/construct/plastic/")
push("models/props_phx/construct/windows/")
push("models/props_phx/construct/wood/")
push("models/props_phx/misc/")
push("models/props_phx/trains/tracks/")
push("models/squad/sf_bars/")
push("models/squad/sf_plates/")
push("models/squad/sf_tris/")
push("models/squad/sf_tubes/")
push("models/weapons/")
push("models/fueltank/")
push("models/phxtended/")
push("models/combine_turrets/")
push("models/bull/gates/")
push("models/bull/various/")
push("models/jaanus/wiretool/")
push("models/kobilica/")
push("models/sprops/trans/wheel_f/")
push("models/sprops/trans/wheels_g/")
push("models/sprops/trans/wheel_big_g/")


-- -----------------------------------------------------------------------------
-- MODELS
pushTo = funkyModel
push("models/wingf0x/ethernetplug.mdl")
push("models/props_survival/repulsor/repulsor.mdl")
push("models/shells/shell_9mm.mdl")
push("models/shells/shell_762nato.mdl")
push("models/shells/shell_556.mdl")
push("models/shells/shell_338mag.mdl")
push("models/shells/shell_12gauge.mdl")
push("models/shells/shell_57.mdl")
push("models/items/ammopack_small.mdl")
push("models/items/ammopack_medium.mdl")
push("models/nova/jeep_seat.mdl")
push("models/nova/jalopy_seat.mdl")
push("models/nova/airboat_seat.mdl")
push("models/props_c17/tv_monitor01.mdl")
push("models/sprops/trans/fender_a/a_fender30.mdl")
push("models/sprops/trans/fender_a/a_fender35.mdl")
push("models/sprops/trans/fender_a/a_fender40.mdl")
push("models/sprops/trans/fender_a/a_fender45.mdl")
push("models/balloons/balloon_classicheart.mdl")
push("models/balloons/balloon_dog.mdl")
push("models/balloons/balloon_star.mdl")
push("models/balloons/hot_airballoon.mdl")
push("models/balloons/hot_airballoon_basket.mdl")
push("models/chairs/armchair.mdl")
push("models/combinecannon/cironwall.mdl")
push("models/combinecannon/remnants.mdl")
push("models/dynamite/dynamite.mdl")
push("models/extras/info_speech.mdl")
push("models/food/burger.mdl")
push("models/food/hotdog.mdl")
push("models/gibs/helicopter_brokenpiece_01.mdl")
push("models/gibs/helicopter_brokenpiece_02.mdl")
push("models/gibs/helicopter_brokenpiece_03.mdl")
push("models/gibs/helicopter_brokenpiece_04_cockpit.mdl")
push("models/gibs/helicopter_brokenpiece_05_tailfan.mdl")
push("models/gibs/helicopter_brokenpiece_06_body.mdl")
push("models/gibs/shield_scanner_gib1.mdl")
push("models/gibs/shield_scanner_gib2.mdl")
push("models/gibs/shield_scanner_gib3.mdl")
push("models/gibs/shield_scanner_gib4.mdl")
push("models/gibs/shield_scanner_gib5.mdl")
push("models/gibs/shield_scanner_gib6.mdl")
push("models/gibs/strider_gib1.mdl")
push("models/gibs/strider_gib2.mdl")
push("models/gibs/strider_gib3.mdl")
push("models/gibs/strider_gib4.mdl")
push("models/gibs/strider_gib5.mdl")
push("models/gibs/strider_gib6.mdl")
push("models/gibs/strider_gib7.mdl")
push("models/hunter/plates/plate1x3x1trap.mdl")
push("models/hunter/plates/plate1x4x2trap.mdl")
push("models/hunter/plates/plate1x4x2trap1.mdl")
push("models/items/357ammo.mdl")
push("models/items/357ammobox.mdl")
push("models/items/ammocrate_ar2.mdl")
push("models/items/ammocrate_grenade.mdl")
push("models/items/ammocrate_rockets.mdl")
push("models/items/ammocrate_smg1.mdl")
push("models/items/crossbowrounds.mdl")
push("models/items/cs_gift.mdl")
push("models/lamps/torch.mdl")
push("models/maxofs2d/button_01.mdl")
push("models/maxofs2d/button_03.mdl")
push("models/maxofs2d/button_04.mdl")
push("models/maxofs2d/button_06.mdl")
push("models/maxofs2d/button_slider.mdl")
push("models/maxofs2d/camera.mdl")
push("models/maxofs2d/logo_gmod_b.mdl")
push("models/mechanics/articulating/arm_base_b.mdl")
push("models/props_c17/doll01.mdl")
push("models/props_c17/door01_left.mdl")
push("models/props_c17/door02_double.mdl")
push("models/props_c17/suitcase_passenger_physics.mdl")
push("models/props_c17/trappropeller_blade.mdl")
push("models/props_canal/mattpipe.mdl")
push("models/props_canal/winch01b.mdl")
push("models/props_canal/winch02b.mdl")
push("models/props_canal/winch02c.mdl")
push("models/props_canal/winch02d.mdl")
push("models/props_combine/breen_tube.mdl")
push("models/props_combine/breenbust.mdl")
push("models/props_combine/breenbust_chunk01.mdl")
push("models/props_combine/breenbust_chunk02.mdl")
push("models/props_combine/breenbust_chunk04.mdl")
push("models/props_combine/breenbust_chunk05.mdl")
push("models/props_combine/breenbust_chunk06.mdl")
push("models/props_combine/breenbust_chunk07.mdl")
push("models/props_combine/breenchair.mdl")
push("models/props_combine/breenclock.mdl")
push("models/props_combine/breenpod.mdl")
push("models/props_combine/breenpod_inner.mdl")
push("models/props_combine/bunker_gun01.mdl")
push("models/props_combine/bustedarm.mdl")
push("models/props_combine/cell_01_pod_cheap.mdl")
push("models/props_combine/combine_ballsocket.mdl")
push("models/props_combine/combine_mine01.mdl")
push("models/props_combine/combine_tptimer.mdl")
push("models/props_combine/combinebutton.mdl")
push("models/props_combine/combinethumper001a.mdl")
push("models/props_combine/combinethumper002.mdl")
push("models/props_combine/eli_pod_inner.mdl")
push("models/props_combine/health_charger001.mdl")
push("models/props_combine/introomarea.mdl")
push("models/props_combine/soldier_bed.mdl")
push("models/props_combine/stalkerpod_physanim.mdl")
push("models/props_doors/door01_dynamic.mdl")
push("models/props_doors/door03_slotted_left.mdl")
push("models/props_doors/doorklab01.mdl")
push("models/props_junk/ravenholmsign.mdl")
push("models/props_lab/blastdoor001a.mdl")
push("models/props_lab/blastdoor001b.mdl")
push("models/props_lab/blastdoor001c.mdl")
push("models/props_lab/citizenradio.mdl")
push("models/props_lab/clipboard.mdl")
push("models/props_lab/crematorcase.mdl")
push("models/props_lab/hevplate.mdl")
push("models/props_lab/huladoll.mdl")
push("models/props_lab/kennel_physics.mdl")
push("models/props_lab/keypad.mdl")
push("models/props_lab/ravendoor.mdl")
push("models/props_lab/tpswitch.mdl")
push("models/props_phx/amraam.mdl")
push("models/props_phx/box_amraam.mdl")
push("models/props_phx/box_torpedo.mdl")
push("models/props_phx/cannon.mdl")
push("models/props_phx/carseat2.mdl")
push("models/props_phx/carseat3.mdl")
push("models/props_phx/construct/metal_angle180.mdl")
push("models/props_phx/construct/metal_angle90.mdl")
push("models/props_phx/construct/metal_dome180.mdl")
push("models/props_phx/construct/metal_dome90.mdl")
push("models/props_phx/construct/metal_plate1.mdl")
push("models/props_phx/construct/metal_plate1x2.mdl")
push("models/props_phx/construct/metal_plate2x2.mdl")
push("models/props_phx/construct/metal_plate2x4.mdl")
push("models/props_phx/construct/metal_plate4x4.mdl")
push("models/props_phx/construct/metal_plate_curve.mdl")
push("models/props_phx/construct/metal_plate_curve180.mdl")
push("models/props_phx/construct/metal_plate_curve2.mdl")
push("models/props_phx/construct/metal_plate_curve2x2.mdl")
push("models/props_phx/construct/metal_wire1x1x1.mdl")
push("models/props_phx/construct/metal_wire1x1x2.mdl")
push("models/props_phx/construct/metal_wire1x1x2b.mdl")
push("models/props_phx/construct/metal_wire1x2.mdl")
push("models/props_phx/construct/metal_wire1x2b.mdl")
push("models/props_phx/construct/metal_wire_angle180x1.mdl")
push("models/props_phx/construct/metal_wire_angle180x2.mdl")
push("models/props_phx/construct/metal_wire_angle90x1.mdl")
push("models/props_phx/construct/metal_wire_angle90x2.mdl")
push("models/props_phx/facepunch_logo.mdl")
push("models/props_phx/games/chess/black_king.mdl")
push("models/props_phx/games/chess/black_knight.mdl")
push("models/props_phx/games/chess/board.mdl")
push("models/props_phx/games/chess/white_king.mdl")
push("models/props_phx/games/chess/white_knight.mdl")
push("models/props_phx/gears/bevel9.mdl")
push("models/props_phx/gears/rack18.mdl")
push("models/props_phx/gears/rack36.mdl")
push("models/props_phx/gears/rack70.mdl")
push("models/props_phx/gears/rack9.mdl")
push("models/props_phx/gears/spur9.mdl")
push("models/props_phx/huge/road_curve.mdl")
push("models/props_phx/huge/road_long.mdl")
push("models/props_phx/huge/road_medium.mdl")
push("models/props_phx/huge/road_short.mdl")
push("models/props_phx/mechanics/slider1.mdl")
push("models/props_phx/mechanics/slider2.mdl")
push("models/props_phx/mk-82.mdl")
push("models/props_phx/playfield.mdl")
push("models/props_phx/torpedo.mdl")
push("models/props_phx/trains/double_wheels_base.mdl")
push("models/props_phx/trains/fsd-overrun.mdl")
push("models/props_phx/trains/fsd-overrun2.mdl")
push("models/props_phx/trains/monorail1.mdl")
push("models/props_phx/trains/monorail_curve.mdl")
push("models/props_phx/trains/wheel_base.mdl")
push("models/props_phx/wheels/breakable_tire.mdl")
push("models/props_phx/wheels/magnetic_large_base.mdl")
push("models/props_phx/wheels/magnetic_med_base.mdl")
push("models/props_phx/wheels/magnetic_small_base.mdl")
push("models/props_phx/ww2bomb.mdl")
push("models/props_trainstation/passengercar001.mdl")
push("models/props_trainstation/passengercar001_dam01a.mdl")
push("models/props_trainstation/passengercar001_dam01c.mdl")
push("models/props_trainstation/train_outro_car01.mdl")
push("models/props_trainstation/train_outro_porch01.mdl")
push("models/props_trainstation/train_outro_porch02.mdl")
push("models/props_trainstation/train_outro_porch03.mdl")
push("models/props_trainstation/wrecked_train.mdl")
push("models/props_trainstation/wrecked_train_02.mdl")
push("models/props_trainstation/wrecked_train_divider_01.mdl")
push("models/props_trainstation/wrecked_train_door.mdl")
push("models/props_trainstation/wrecked_train_panel_01.mdl")
push("models/props_trainstation/wrecked_train_panel_02.mdl")
push("models/props_trainstation/wrecked_train_panel_03.mdl")
push("models/props_trainstation/wrecked_train_rack_01.mdl")
push("models/props_trainstation/wrecked_train_rack_02.mdl")
push("models/props_trainstation/wrecked_train_seat.mdl")
push("models/props_vehicles/mining_car.mdl")
push("models/props_vehicles/van001a_nodoor_physics.mdl")
push("models/props_wasteland/cranemagnet01a.mdl")
push("models/props_wasteland/wood_fence01a.mdl")
push("models/props_wasteland/wood_fence01b.mdl")
push("models/props_wasteland/wood_fence01c.mdl")
push("models/quarterlife/fsd-overrun-toy.mdl")
push("models/sprops/trans/train/double_24.mdl")
push("models/sprops/trans/train/double_36.mdl")
push("models/sprops/trans/train/double_48.mdl")
push("models/sprops/trans/train/double_72.mdl")
push("models/sprops/trans/train/single_24.mdl")
push("models/sprops/trans/train/single_36.mdl")
push("models/sprops/trans/train/single_48.mdl")
push("models/sprops/trans/train/single_72.mdl")
push("models/thrusters/jetpack.mdl")
push("models/vehicles/prisoner_pod.mdl")
push("models/vehicles/prisoner_pod_inner.mdl")
push("models/vehicles/vehicle_van.mdl")
push("models/vehicles/vehicle_vandoor.mdl")
push("models/props_mining/control_lever01.mdl")
push("models/props_lab/tpplug.mdl")
push("models/vehicles/pilot_seat.mdl")
push("models/autocannon/semiautocannon_25mm.mdl")
push("models/autocannon/semiautocannon_37mm.mdl")
push("models/autocannon/semiautocannon_45mm.mdl")
push("models/autocannon/semiautocannon_57mm.mdl")
push("models/autocannon/semiautocannon_76mm.mdl")
push("models/engines/emotorlarge.mdl")
push("models/engines/emotormed.mdl")
push("models/engines/emotorsmall.mdl")
push("models/engines/gasturbine_l.mdl")
push("models/engines/gasturbine_m.mdl")
push("models/engines/gasturbine_s.mdl")
push("models/engines/linear_l.mdl")
push("models/engines/linear_m.mdl")
push("models/engines/linear_s.mdl")
push("models/engines/radial7l.mdl")
push("models/engines/radial7m.mdl")
push("models/engines/radial7s.mdl")
push("models/engines/transaxial_l.mdl")
push("models/engines/transaxial_m.mdl")
push("models/engines/transaxial_s.mdl")
push("models/engines/turbine_l.mdl")
push("models/engines/turbine_m.mdl")
push("models/engines/turbine_s.mdl")
push("models/engines/wankel_2_med.mdl")
push("models/engines/wankel_2_small.mdl")
push("models/engines/wankel_3_med.mdl")
push("models/engines/wankel_4_med.mdl")
push("models/howitzer/howitzer_105mm.mdl")
push("models/howitzer/howitzer_122mm.mdl")
push("models/howitzer/howitzer_155mm.mdl")
push("models/howitzer/howitzer_203mm.mdl")
push("models/howitzer/howitzer_240mm.mdl")
push("models/howitzer/howitzer_290mm.mdl")
push("models/howitzer/howitzer_75mm.mdl")
push("models/machinegun/machinegun_20mm_compact.mdl")
push("models/machinegun/machinegun_30mm_compact.mdl")
push("models/machinegun/machinegun_40mm_compact.mdl")
push("models/rotarycannon/kw/14_5mmrac.mdl")
push("models/rotarycannon/kw/20mmrac.mdl")
push("models/rotarycannon/kw/30mmrac.mdl")
push("models/holograms/tetra.mdl")
push("models/holograms/hexagon.mdl")
push("models/holograms/icosphere.mdl")
push("models/holograms/icosphere2.mdl")
push("models/holograms/icosphere3.mdl")
push("models/holograms/prism.mdl")
push("models/holograms/sphere.mdl")
push("models/props_mining/switch01.mdl")
push("models/props_mining/switch_updown01.mdl")
push("models/props_mining/diesel_generator.mdl")
push("models/props_mining/ceiling_winch01.mdl")
push("models/props_mining/elevator_winch_cog.mdl")
push("models/nova/chair_plastic01.mdl")
push("models/nova/chair_wood01.mdl")
push("models/nova/chair_office02.mdl")
push("models/nova/chair_office01.mdl")
push("models/props/de_inferno/hr_i/inferno_vintage_radio/inferno_vintage_radio.mdl")
push("models/radar/radar_sp_mid.mdl")
push("models/radar/radar_sp_sml.mdl")
push("models/radar/radar_sp_big.mdl")
push("models/props/coop_kashbah/coop_stealth_boat/coop_stealth_boat_animated.mdl")
push("models/cheeze/wires/gyroscope.mdl")
push("models/cheeze/wires/ram.mdl")
push("models/cheeze/wires/router.mdl")
push("models/cheeze/wires/wireless_card.mdl")


-- -----------------------------------------------------------------------------
-- SPECIAL FOLDERS
pushTo = funkyFolder

push("models/sprops/trans/wheel_b/", function(partnum, numparts, rotated, normal)
	if partnum == 1 then return rotated else return normal end
end)
push("models/sprops/trans/wheel_d/", function(partnum, numparts, rotated, normal)
	if partnum == 1 or partnum == 2 then return rotated else return normal end
end)


-- -----------------------------------------------------------------------------
-- SPECIAL MODELS
pushTo = funkyModel

local fix = function(partnum, numparts, rotated, normal)
	if partnum == 1 then return rotated else return normal end
end
push("models/sprops/trans/miscwheels/thin_moto15.mdl", fix)
push("models/sprops/trans/miscwheels/thin_moto20.mdl", fix)
push("models/sprops/trans/miscwheels/thin_moto25.mdl", fix)
push("models/sprops/trans/miscwheels/thin_moto30.mdl", fix)
push("models/sprops/trans/miscwheels/thick_moto15.mdl", fix)
push("models/sprops/trans/miscwheels/thick_moto20.mdl", fix)
push("models/sprops/trans/miscwheels/thick_moto25.mdl", fix)
push("models/sprops/trans/miscwheels/thick_moto30.mdl", fix)

local fix = function(partnum, numparts, rotated, normal)
	if partnum == 1 or partnum == 2 then return rotated else return normal end
end
push("models/sprops/trans/miscwheels/tank15.mdl", fix)
push("models/sprops/trans/miscwheels/tank20.mdl", fix)
push("models/sprops/trans/miscwheels/tank25.mdl", fix)
push("models/sprops/trans/miscwheels/tank30.mdl", fix)

push("models/props_mining/diesel_generator_crank.mdl", function(partnum, numparts, rotated, normal)
	local angle = Angle(rotated)
	angle:RotateAroundAxis(angle:Forward(), 90)
	return angle
end)
