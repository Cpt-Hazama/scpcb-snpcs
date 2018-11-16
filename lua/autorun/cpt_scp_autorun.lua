/*--------------------------------------------------
	Copyright (c) 2018 by Cpt. Hazama, All rights reserved.
	Nothing in these files or/and code may be reproduced, adapted, merged or
	modified without prior written consent of the original author, Cpt. Hazama
--------------------------------------------------*/
include('server/cpt_utilities.lua')
include('cpt_scp_vision.lua')

CPTBase.RegisterMod("SCP:CB SNPCs","0.1.7")

CPTBase.DefineDecal("SCP_PDCorrosion",{"decals/decalpd3"})
-- CPTBase.DefineDecal("SCP_457Scorch",{"decals/decal_footprint_scorch"})
CPTBase.AddParticleSystem("particles/cpt_scp_pocketdimension.pcf",{})

local category = "SCP:CB"
CPTBase.AddNPC("(Classic) SCP-106","npc_cpt_scp_106_old",category)

CPTBase.AddNPC("SCP-008","npc_cpt_scp_008",category)
CPTBase.AddNPC("SCP-008-1","npc_cpt_scp_008_1",category)
CPTBase.AddNPC("SCP-012","npc_cpt_scp_012",category)
CPTBase.AddNPC("SCP-035","npc_cpt_scp_035",category)
CPTBase.AddNPC("SCP-049","npc_cpt_scp_049",category)
CPTBase.AddNPC("SCP-049-2","npc_cpt_scp_049_2",category)
CPTBase.AddNPC("SCP-049-2 Soldier","npc_cpt_scp_049_2_ntf",category)
CPTBase.AddNPC("SCP-066","npc_cpt_scp_066",category)
CPTBase.AddNPC("SCP-079","npc_cpt_scp_079",category)
CPTBase.AddNPC("SCP-087-1","npc_cpt_scp_087_1",category)
CPTBase.AddNPC("SCP-087-B","npc_cpt_scp_087_b",category)
CPTBase.AddNPC("SCP-096","npc_cpt_scp_096",category)
CPTBase.AddNPC("SCP-106","npc_cpt_scp_106",category)
CPTBase.AddNPC("SCP-106 Pocket Dimension Plane","npc_cpt_scp_106pdplane",category)
CPTBase.AddNPC("SCP-173","npc_cpt_scp_173",category)
-- CPTBase.AddNPC("SCP-173 (Box)","npc_cpt_scp_173_box",category) // Shouldn't be spawnable
CPTBase.AddNPC("SCP-178","npc_cpt_scp_178specs",category)
CPTBase.AddNPC("SCP-178-1","npc_cpt_scp_178",category) // No longer spawnable
-- CPTBase.AddNPC("SCP-205","npc_cpt_scp_205",category) // Stupid
-- CPTBase.AddNPC("SCP-205-A","npc_cpt_scp_205a",category)
-- CPTBase.AddNPC("SCP-205-B","npc_cpt_scp_205b",category)
-- CPTBase.AddNPC("SCP-205-C","npc_cpt_scp_205c",category)
-- CPTBase.AddNPC("SCP-205-D","npc_cpt_scp_205d",category)
CPTBase.AddNPC("SCP-372","npc_cpt_scp_372",category) // Should this even be here lol
CPTBase.AddNPC("SCP-420-J","npc_cpt_scp_420",category)
CPTBase.AddNPC("SCP-427","npc_cpt_scp_427",category)
CPTBase.AddNPC("SCP-457","npc_cpt_scp_457",category)
CPTBase.AddNPC("SCP-500","npc_cpt_scp_500",category)
CPTBase.AddNPC("SCP-513","npc_cpt_scp_513",category)
-- CPTBase.AddNPC("SCP-513-1","npc_cpt_scp_513_1",category) // Shouldn't be spawnable
CPTBase.AddNPC("SCP-575","npc_cpt_scp_575",category)
CPTBase.AddNPC("SCP-682","npc_cpt_scp_682",category)
CPTBase.AddNPC("SCP-714","npc_cpt_scp_714",category)
CPTBase.AddNPC("SCP-860-2","npc_cpt_scp_860",category)
CPTBase.AddNPC("SCP-895","npc_cpt_scp_895",category)
CPTBase.AddNPC("SCP-939 (Instance A)","npc_cpt_scp_939_a",category)
CPTBase.AddNPC("SCP-939 (Instance B)","npc_cpt_scp_939_b",category)
CPTBase.AddNPC("SCP-939 (Instance C)","npc_cpt_scp_939_c",category)
CPTBase.AddNPC("SCP-966","npc_cpt_scp_966",category)
CPTBase.AddNPC("SCP-1025","npc_cpt_scp_1025",category)
CPTBase.AddNPC("SCP-1048","npc_cpt_scp_1048",category)
CPTBase.AddNPC("SCP-1123","npc_cpt_scp_1123",category)
CPTBase.AddNPC("SCP-1356","npc_cpt_scp_1356",category)
CPTBase.AddNPC("SCP-1499-1","npc_cpt_scp_1499_1",category)
CPTBase.AddNPC("SCP-1499-1 King","npc_cpt_scp_1499_1_king",category)

-- CPTBase.AddNPC("MTF Site Guard","npc_cpt_scp_mtf",category)
CPTBase.AddNPC("MTF Epsilon-11 Nine-Tailed Fox","npc_cpt_scp_ntf",category)
CPTBase.AddNPC("MTF Lambda-5 White Rabbits","npc_cpt_scp_lambda",category)
CPTBase.AddNPC("MTF Nu-7 Hammer Down","npc_cpt_scp_nu",category)

CPTBase.AddNPC("Class D Subject","npc_cpt_scp_dclass",category)
CPTBase.AddNPC("Scientist","npc_cpt_scp_scientist",category) // STAHP! NO!

CPTBase.AddNPC("Nightvision Goggles","ent_cpt_scp_nightvision",category) // The object itself isn't a NPC but technically speaking, it is a NPC since well, it's running on my SNPC base

if CLIENT then
	local CPT_SCP_TBL_939_MOVERS = {}
	local CPT_SCP_TBL_939_MOVERNUM = 0
	hook.Add("PreDrawHalos","CPTBase_SCP_939Possession",function() -- Currently Disabled
		-- if !game.SinglePlayer() then return end
		-- for _,possessor in ipairs(player.GetAll()) do
			-- if IsValid(possessor) && possessor:GetNWBool("CPTBase_IsPossessing") == true && string.find(possessor:GetNWBool("CPTBase_PossessedNPCClass"),"scp_939") then
				-- print(possessor:Nick(),possessor:GetNWBool("CPTBase_IsPossessing"))
				-- for _,v in ipairs(player.GetAll()) do
					-- if IsValid(v) then
						-- if v:GetMoveType() == MOVETYPE_WALK && !v:Crouching() && (v:KeyDown(IN_FORWARD) or v:KeyDown(IN_BACK) or v:KeyDown(IN_MOVELEFT) or v:KeyDown(IN_MOVERIGHT) or v:KeyDown(IN_JUMP)) then
							-- CPT_SCP_TBL_939_MOVERNUM = CPT_SCP_TBL_939_MOVERNUM +1
							-- CPT_SCP_TBL_939_MOVERS[CPT_SCP_TBL_939_MOVERNUM] = v
							-- if IsValid(v:GetActiveWeapon()) then
								-- CPT_SCP_TBL_939_MOVERNUM = CPT_SCP_TBL_939_MOVERNUM +1
								-- CPT_SCP_TBL_939_MOVERS[CPT_SCP_TBL_939_MOVERNUM] = v:GetActiveWeapon()
							-- end
						-- end
					-- end
				-- end
				
				/*			-- for _,ply in ipairs(player.GetAll()) do
								if IsValid(ply) && ply:GetNWBool("CPTBase_IsPossessing") && string.find(ply:GetNWBool("CPTBase_PossessedNPCClass"),"scp_939") then
									v:SetNoDraw(false)
									if IsValid(v:GetActiveWeapon()) then
										v:GetActiveWeapon():SetNoDraw(false)
									end
								end
							end
						else
							for _,ply in ipairs(player.GetAll()) do
								if IsValid(ply) && ply:GetNWBool("CPTBase_IsPossessing") && string.find(ply:GetNWBool("CPTBase_PossessedNPCClass"),"scp_939") then
									v:SetNoDraw(true)
									if IsValid(v:GetActiveWeapon()) then
										v:GetActiveWeapon():SetNoDraw(true)
									end
								end
							end
						end
					end
				end*/

				-- for _,v in ipairs(ents.GetAll()) do
					-- if IsValid(v) && v:IsNPC() then
						-- if v:GetVelocity():Length() > 0 then
							-- if !string.find(v:GetClass(),"scp_939") then
								-- CPT_SCP_TBL_939_MOVERNUM = CPT_SCP_TBL_939_MOVERNUM +1
								-- CPT_SCP_TBL_939_MOVERS[CPT_SCP_TBL_939_MOVERNUM] = v
								-- if IsValid(v:GetActiveWeapon()) then
									-- CPT_SCP_TBL_939_MOVERNUM = CPT_SCP_TBL_939_MOVERNUM +1
									-- CPT_SCP_TBL_939_MOVERS[CPT_SCP_TBL_939_MOVERNUM] = v:GetActiveWeapon()
								-- end
							-- end
						-- end
					-- end
				-- end
				/*			-- for _,ply in ipairs(player.GetAll()) do
								if IsValid(ply) && ply:GetNWBool("CPTBase_IsPossessing") && string.find(ply:GetNWBool("CPTBase_PossessedNPCClass"),"scp_939") then
									v:SetNoDraw(false)
									if IsValid(v:GetActiveWeapon()) then
										v:GetActiveWeapon():SetNoDraw(false)
									end
								end
							end
						else
							for _,ply in ipairs(player.GetAll()) do
								if IsValid(ply) && ply:GetNWBool("CPTBase_IsPossessing") && string.find(ply:GetNWBool("CPTBase_PossessedNPCClass"),"scp_939") then
									if !string.find(v:GetClass(),"scp_939") then
										v:SetNoDraw(true)
										if IsValid(v:GetActiveWeapon()) then
											v:GetActiveWeapon():SetNoDraw(true)
										end
									end
								end
							end
						end
					end
				end

				for _,ply in ipairs(player.GetAll()) do
					if IsValid(ply) && ply:GetNWBool("CPTBase_IsPossessing") == true && string.find(ply:GetNWBool("CPTBase_PossessedNPCClass"),"scp_939") then
						halo.Add(CPT_SCP_TBL_939_MOVERS,Color(255,191,0),2,2,2,true,true)
					end
				end*/
				
				-- for _,move in ipairs(CPT_SCP_TBL_939_MOVERS) do
					-- if IsValid(move) then
						-- move:SetNoDraw(true)
					-- else
						-- table.remove(CPT_SCP_TBL_939_MOVERS,CPT_SCP_TBL_939_MOVERS[move])
					-- end
				-- end
				-- halo.Add(CPT_SCP_TBL_939_MOVERS,Color(255,191,0),2,2,2,true,true)
			-- end
		-- end
	end)

	hook.Add("PreDrawHalos","CPTBase_SCP_106Possession",function()
		if !game.SinglePlayer() then return end
		if CLIENT then
			local tb = {}
			local tb_point = {}
			for _,v in ipairs(ents.GetAll()) do
				if v:GetClass() == "prop_physics" && v:GetNWBool("SCP106_Point") then
					table.insert(tb_point,v)
				end
			end

			for _,ply in ipairs(player.GetAll()) do
				if IsValid(ply) && ply:GetNWBool("CPTBase_IsPossessing") && ply:GetNWBool("CPTBase_PossessedNPCClass") == "npc_cpt_scp_106" then
					halo.Add(tb_point,Color(127,0,0),4,4,3,true,true)
					for _,others in ipairs(ents.GetAll()) do
						if (others:IsNPC() && others:GetClass() != "npc_cpt_scp_106") or (others:IsPlayer() && others != v) then
							for _,point in ipairs(tb_point) do
								if others:GetPos():Distance(point:GetPos()) <= 250 then
									table.insert(tb,others)
								else
									if table.HasValue(tb,others) then
										tb[others] = nil
									end
								end
							end
						end
					end
					halo.Add(tb,Color(127,0,0),4,4,3,true,true)
				end
			end
		end
	end)

	local tab_nightvision = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 5,
		["$pp_colour_colour"] = 0,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 2000,
		["$pp_colour_mulb"] = 0
	}

	local tab_plane = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 0.3,
		["$pp_colour_colour"] = 0,
		["$pp_colour_mulr"] = 30,
		["$pp_colour_mulg"] = -1,
		["$pp_colour_mulb"] = -1
	}

	local CLIENT_SCP_NV = false
	concommand.Add("cpt_scp_togglenightvision", function(ply,cmd,args)
		CLIENT_SCP_NV = not CLIENT_SCP_NV
	end)

	local CLIENT_SCP_PLANE = false
	concommand.Add("cpt_scp_toggleplanevision", function(ply,cmd,args)
		CLIENT_SCP_PLANE = not CLIENT_SCP_PLANE
	end)

	hook.Add("RenderScreenspaceEffects","CPTBase_SCP_DrainingBlur",function(ply)
		if CLIENT_SCP_PLANE == true then
			-- DrawMotionBlur(0.2,0.99,0.04)
			-- timer.Simple(2,function()
				-- hook.Remove("RenderScreenspaceEffects","CPTBase_SCP_DrainingBlur")
				-- hook.Call("CPTBase_SCP_DrainingBlur")
			-- end)
		end
	end)

	hook.Add("RenderScreenspaceEffects","CPTBase_SCP_Nightvision",function(ply)
		if CLIENT_SCP_NV == true then
			DrawColorModify(tab_nightvision)
		end
		if CLIENT_SCP_PLANE == true then
			DrawColorModify(tab_plane)
		end
	end)
	
	hook.Add("RenderScreenspaceEffects","CPTBase_SCP_079Possessor",function()
		if !game.SinglePlayer() then return end
		local tbl = {}
		for _,ply in ipairs(player.GetAll()) do
			if ply:IsValid() && ply:GetNWBool("CPTBase_IsPossessing") && string.find(ply:GetNWBool("CPTBase_PossessedNPCClass"),"scp_079") then
				for _,v in ipairs(ents.GetAll()) do
					if v:IsValid() && (v:IsNPC() || v:IsPlayer() && v != ply) then
						table.insert(tbl,v)
					end
				end
				-- if !(ply:GetNWBool("CPTBase_IsPossessing") && string.find(ply:GetNWBool("CPTBase_PossessedNPCClass"),"scp_079")) then return end
				halo.Add(tbl,Color(255,191,0),15,15,15,true,true)
			end
		end
	end)
	
	hook.Add("Think","CPTBase_SCP_Nightvision966",function()
		if CLIENT then
			if CLIENT_SCP_NV then
				local tbl = {}
				local light = DynamicLight(LocalPlayer():EntIndex())
				if (light) and CLIENT_SCP_NV then
					light.Pos = LocalPlayer():GetPos() +Vector(0,0,30)
					light.r = 33
					light.g = 255
					light.b = 0
					light.Brightness = 0
					light.Size = 600
					light.Decay = 900
					light.DieTime = CurTime() +0.2
					light.Style = 0
				end
				for _,v in ipairs(ents.GetAll()) do
					-- if v:IsValid() && v:IsNPC() && v:GetClass() == "npc_cpt_scp_966" then
						-- v:SetNoDraw(false)
					-- end
					if v:IsValid() && v:IsNPC() && v:GetClass() == "npc_cpt_scp_895" then
						table.insert(tbl,v)
					end
				end
				halo.Add(tbl,Color(255,0,0),15,15,15,true,true)
			-- else
				-- for _,v in ipairs(ents.GetAll()) do
					-- if v:IsValid() && v:IsNPC() && v:GetClass() == "npc_cpt_scp_966" then
						-- v:SetNoDraw(true)
					-- end
				-- end
			end
		end
	end)

	local CLIENT_SCP_178 = false
	local CLIENT_SCP_178SPAWNTIME = CurTime()
	local CLIENT_SCP_178SPAWNAMOUNT = 0
	concommand.Add("cpt_scp_toggle178", function(ply,cmd,args)
		CLIENT_SCP_178 = not CLIENT_SCP_178
	end)

	hook.Add("Think","CPTBase_SCP_178",function()
		if CLIENT then
			-- if CLIENT_SCP_178 then
				-- if CurTime() > CLIENT_SCP_178SPAWNTIME && CLIENT_SCP_178SPAWNAMOUNT <= 10 then
					-- local ent = ents.Create("npc_cpt_scp_178")
					-- local pos = ent:SetClearPos(VectorRand())
					-- if util.IsInWorld(pos) then
						-- ent:Spawn()
						-- CLIENT_SCP_178SPAWNAMOUNT = CLIENT_SCP_178SPAWNAMOUNT +1
					-- end
					-- CLIENT_SCP_178SPAWNTIME = CurTime() +math.Rand(5,14)
				-- end
				-- for _,v in ipairs(ents.GetAll()) do
					-- if v:IsValid() && v:IsNPC() && v:GetClass() == "npc_cpt_scp_178" then
						-- v:SetNoDraw(false)
					-- end
				-- end
			-- else
				-- CLIENT_SCP_178SPAWNAMOUNT = 0
				-- for _,v in ipairs(ents.GetAll()) do
					-- if v:IsValid() && v:IsNPC() && v:GetClass() == "npc_cpt_scp_178" then
						-- v:SetNoDraw(true)
						-- timer.Simple(10,function()
							-- if IsValid(v) then
								-- v:Remove()
							-- end
						-- end)
					-- end
				-- end
			-- end
		end
	end)
end

	-- Custom Functions --
local NPC_Meta = FindMetaTable("NPC")
SCP_GlobalNTFCoolDown = 0
SCP_SightAngle = 50
SCP_DoorOpenDistance = 100

hook.Add("PlayerDeath","CPTBase_SCP_DeathData",function(ply)
	-- if CLIENT then
		ply:SetNWBool("SCP_HasNightvision",false)
		ply:SetNWBool("SCP_IsBeingDrained",false)
		ply:SetNWBool("SCP_Has178",false)
		ply:SetNWBool("SCP_895Horror",false)
		ply:SetNWString("SCP_895HorrorID",nil)
		ply:SetNWBool("SCP_IsBlinking",false)
		ply:SetNWBool("SCP_Touched1123",false)
		ply:SetNWBool("SCP_Touched1123_Horror",false)
		ply:SetNWInt("SCP_BlinkTime",CurTime() +math.random(4,7))
		ply:SetNWInt("SCP_LastBlinkAmount",0)
		CLIENT_SCP_NV = false
	-- end
end)

hook.Add("OnEntityCreated","CPTBase_SCP_SpawnData_NPCs",function(ent)
	if ent:IsNPC() then
		ent.SCP_Infected_008 = false
		ent.SCP_IsBlinking = false
		ent.SCP_BlinkTime = CurTime() +math.random(4,7)
	end
end)

hook.Add("Think","CPTBase_SCP_ZombieDeathFollow",function()
	for _,v in ipairs(player.GetAll()) do
		if !v:Alive() then
			if IsValid(v.CPTBase_SCP_Zombie) then
				-- v:SetPos(v.CPTBase_SCP_Zombie:GetPos() +v.CPTBase_SCP_Zombie:OBBCenter())
				if v.SCP_SpawnedZombieEntity == false then
					v.SCP_ZombieEntity = ents.Create("prop_dynamic")
					v.SCP_ZombieEntity:SetPos(v.CPTBase_SCP_Zombie:GetPos() +v.CPTBase_SCP_Zombie:OBBCenter())
					v.SCP_ZombieEntity:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
					v.SCP_ZombieEntity:SetParent(v.CPTBase_SCP_Zombie)
					v.SCP_ZombieEntity:SetRenderMode(RENDERMODE_TRANSALPHA)
					v.SCP_ZombieEntity:Spawn()
					v.SCP_ZombieEntity:SetColor(Color(0,0,0,0))
					v.SCP_ZombieEntity:SetNoDraw(false)
					v.SCP_ZombieEntity:DrawShadow(false)
					v.SCP_ZombieEntity:DeleteOnRemove(v.CPTBase_SCP_Zombie)
					v.SCP_SpawnedZombieEntity = true
				end
				if IsValid(v.SCP_ZombieEntity) then
					v:Spectate(OBS_MODE_CHASE)
					v:SpectateEntity(v.SCP_ZombieEntity)
					v:SetMoveType(MOVETYPE_OBSERVER)
				end
			end
		end
	end
end)

hook.Add("PlayerSpawn","CPTBase_SCP_SpawnData",function(ply)
	if CLIENT then
		ply:SetNWBool("SCP_HasNightvision",false)
		ply:SetNWBool("SCP_IsBeingDrained",false)
		ply:SetNWBool("SCP_Has178",false)
		ply:SetNWBool("SCP_895Horror",false)
		ply:SetNWString("SCP_895HorrorID",nil)
		ply:SetNWBool("SCP_IsBlinking",false)
		ply:SetNWBool("SCP_Touched1123",false)
		ply:SetNWBool("SCP_Touched1123_Horror",false)
		ply:SetNWInt("SCP_BlinkTime",CurTime() +math.random(4,7))
		ply:SetNWInt("SCP_LastBlinkAmount",0)
	end
	ply.SCP_Infected_008 = false
	ply.SCP_Infected_049 = false
	ply.SCP_Inflicted_1048a = false
	ply.SCP_Disease_LungCancer = false
	ply.SCP_Disease_Appendicitis = false
	ply.SCP_Disease_CommonCold = false
	ply.SCP_Disease_Chickenpox = false
	ply.SCP_Disease_Asthma = false
	ply.SCP_Disease_CardiacArrest = false
	ply.SCP_Has714 = false
	ply.SCP_Has427 = false
	ply.SCP_NextUse1123T = CurTime()
	ply.SCP_Using420 = false
	ply.CPTBase_SCP_Zombie = NULL
	ply.SCP_SpawnedZombieEntity = false
end)

if SERVER then
	FEMURACTIVATED = false
	NEXTFMT = 0
	ST_FEMUR = false
	NEXTSTT = 0
	MN_FEMUR = false
	NEXTMNT = 0
end

hook.Add("PlayerUse","CPTBase_SCP_106Containtment",function(ply,ent)
	if util.IsSCPMap() then
		if IsValid(ent) then
			if ent:GetName() == "sound_lever_106" then
				if CurTime() > NEXTSTT then
					if ST_FEMUR == false then
						ST_FEMUR = true
					else
						ST_FEMUR = false
					end
					NEXTSTT = CurTime() +1
				end
			end
			if ent:GetName() == "magnet_lever_106" then
				if CurTime() > NEXTMNT then
					if MN_FEMUR == false then
						MN_FEMUR = true
					else
						MN_FEMUR = false
					end
					NEXTMNT = CurTime() +1
				end
			end
			if ent:GetName() == "femur_button" && !FEMURACTIVATED then
				if CurTime() > NEXTFMT then
					if ST_FEMUR == true && MN_FEMUR == true then
						timer.Simple(10,function()
							if MN_FEMUR == true && FEMURACTIVATED == true then
								for _,v in ipairs(ents.GetAll()) do
									if v:IsNPC() && v:GetClass() == "npc_cpt_scp_106" then
										v:StopCompletely()
										v:BeContained()
									end
								end
							end
						end)
						FEMURACTIVATED = true
						timer.Simple(40,function()
							if FEMURACTIVATED == true then
								FEMURACTIVATED = false
							end
						end)
					end
					NEXTFMT = CurTime() +1
				end
			end
		end
	end
end)

hook.Add("Think","CPTBase_SCP_BlinkSystem_NPCs",function()
	local canevenblink = false
	for _,scp in ipairs(ents.GetAll()) do
		if scp:IsNPC() && (scp:GetClass() == "npc_cpt_scp_173" or scp:GetClass() == "npc_cpt_scpunity_173" or scp:GetClass() == "npc_cpt_scp_087_b") then
			canevenblink = true
		end
	end
	if canevenblink == true then
		local tb = {}
		for _,v in ipairs(ents.GetAll()) do
			if v:IsNPC() && (v:GetClass() != "npc_cpt_scp_173" && v:GetClass() != "npc_cpt_scpunity_173" && v:GetClass() != "npc_cpt_scp_087_b") && v:Health() > 0 then
				if !table.HasValue(tb,v) then
					table.insert(tb,v)
				end
			end
		end
		for i = 0, table.Count(tb) do
			if tb[i] != nil && IsValid(tb[i]) then
				if tb[i].SCP_BlinkTime == nil then tb[i].SCP_BlinkTime = CurTime() +1 end
				if tb[i].SCP_IsBlinking == nil then tb[i].SCP_IsBlinking = false end
				if tb[i]:GetClass() == "npc_cpt_scp_ntf" then
					timer.Simple(math.Round(tb[i].SCP_BlinkTime -CurTime()) -0.8,function()
						if IsValid(tb[i]) && tb[i].SCP_IsBlinking == false then
							if tb[i].SCP_BeforeBlinking then
								tb[i]:SCP_BeforeBlinking()
							end
						end
					end)
				end
				if CurTime() > tb[i].SCP_BlinkTime && tb[i].SCP_IsBlinking == false then
					tb[i].SCP_IsBlinking = true
					if tb[i].SCP_IsBlinking == true then
						timer.Simple(0.5,function()
							if tb[i]:IsValid() && tb[i].SCP_IsBlinking == true then
								tb[i].SCP_IsBlinking = false
								local time = math.random(5,9)
								if GetConVarNumber("cpt_scp_173blinksame") == 1 then
									time = 5
								end
								tb[i].SCP_BlinkTime = CurTime() +time
							end
						end)
					end
				end
			end
		end
	end
end)

hook.Add("HUDPaint","CPTBase_SCP_SetBlinkTexture",function()
	local ply = LocalPlayer()
	if ply then
		if ply:GetNWBool("SCP_IsBlinking") && ply:Alive() then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(Material("overlay/blink"))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			surface.SetDrawColor(255,255,255,0)
			surface.DrawRect(0,0,ScrW(),ScrH())
		end
		if ply:Alive() && ply:GetNWBool("SCP_IsBlinking") == false && ply:GetNWBool("SCP_895Horror") == true then
			surface.SetDrawColor(255,255,255,255)
			surface.SetTexture(surface.GetTextureID(ply:GetNWString("SCP_895HorrorID")))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			surface.SetDrawColor(255,255,255,0)
			surface.DrawRect(0,0,ScrW(),ScrH())
		end
		if ply:Alive() && ply:GetNWBool("SCP_IsBlinking") == false && ply:GetNWBool("SCP_Has178") == true then
			surface.SetDrawColor(255,255,255,100)
			surface.SetTexture(surface.GetTextureID("models/cpthazama/scp/178/178_view"))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			surface.SetDrawColor(255,255,255,0)
			surface.DrawRect(0,0,ScrW(),ScrH())
		end
		if !ply:GetNWBool("SCP_IsBlinking") && ply:GetNWBool("SCP_Touched1123") && ply:GetNWBool("SCP_Touched1123_Horror") == false then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(Material("engine/singlecolor"))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			surface.SetDrawColor(255,255,255,0)
			surface.DrawRect(0,0,ScrW(),ScrH())
		end
		if !ply:GetNWBool("SCP_IsBlinking") && ply:GetNWBool("SCP_Touched1123") && ply:GetNWBool("SCP_Touched1123_Horror") == true then
			surface.SetDrawColor(255,255,255,255)
			surface.SetTexture(surface.GetTextureID("overlay/1123"))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			surface.SetDrawColor(255,255,255,0)
			surface.DrawRect(0,0,ScrW(),ScrH())
		end
	end
end)

hook.Add("Think","CPTBase_SCP_BlinkSystem",function()
	if GetConVarNumber("ai_ignoreplayers") == 0 then
		local canevenblink = false
		local scps = {}
		for _,scp in ipairs(ents.GetAll()) do
			if scp:IsNPC() && (scp:GetClass() == "npc_cpt_scp_173" or scp:GetClass() == "npc_cpt_scp_087_b" or scp:GetClass() == "npc_cpt_scpunity_173") then
				canevenblink = true
				if !table.HasValue(scps,scp) then
					table.insert(scps,scp)
				end
			end
		end
		local function AllSCPs(ply)
			for _,v in ipairs(scps) do
				if IsValid(v) && v:Visible(ply) then
					return true
				else
					return false
				end
			end
		end
		if canevenblink == true then
			local tb = {}
			for _,v in ipairs(player.GetAll()) do
				if v:IsPlayer() then
					if !table.HasValue(tb,v) then
						table.insert(tb,v)
					end
				end
			end
			for i = 0, table.Count(tb) do
				if tb[i] != nil then
					if tb[i] == nil then return end
					if tb[i]:GetNWBool("CPTBase_IsPossessing") == false && tb[i].IsPossessing == false && AllSCPs(tb[i]) && tb[i]:Alive() && CurTime() > tb[i]:GetNWInt("SCP_BlinkTime") && tb[i]:GetNWBool("SCP_IsBlinking") == false then
						local deaths = tb[i]:Deaths()
						if tb[i]:Deaths() > deaths then return end
						tb[i]:SetNWBool("SCP_IsBlinking",true)
						if tb[i]:GetNWBool("SCP_IsBlinking") == true then
							timer.Simple(0.5,function()
								if tb[i]:IsValid() && tb[i]:Alive() then
									tb[i]:SetNWBool("SCP_IsBlinking",false)
									local time = math.random(5,9)
									if GetConVarNumber("cpt_scp_173blinksame") == 1 then
										time = 5
									end
									if GetConVarNumber("cpt_scp_blinkmessage") == 1 then
										tb[i]:ChatPrint("You will blink in " .. time .. " seconds.")
									end
									tb[i]:SetNWInt("SCP_BlinkTime",CurTime() +time)
								end
							end)
						end
					end
				end
			end
		end
	end
end)

function util.IsSCPMap()
	if GetConVarNumber("cpt_scp_site19") == 0 then return false end
	if game.GetMap() == "gm_site19" || game.GetMap() == "rp_site54" then
		return true
	end
	return false
end

function util.IsSite19()
	if GetConVarNumber("cpt_scp_site19") == 0 then return false end
	if game.GetMap() == "gm_site19" then
		return true
	end
	return false
end

function NPC_Meta:SCP_IsPlayerBlinking()
	for _,v in ipairs(player.GetAll()) do
		if v:IsPlayer() then
			if v:GetNWBool("SCP_IsBlinking") == false && self:Visible(v) then
				return true
			else
				return false
			end
		end
	end
end

function NPC_Meta:SCP_CanBeSeenData()
	local tb = {}
	for _,v in ipairs(player.GetAll()) do
		if GetConVarNumber("ai_ignoreplayers") == 1 then return end
		if v:IsPlayer() && v:Visible(self) then
			if v:GetNWBool("SCP_IsBlinking") == false && v.IsPossessing == false && v:Alive() && self:Disposition(v) != D_LI && v:Visible(self) && (v:GetForward():Dot(((self:GetPos() +self:OBBCenter() +self:GetForward() *-30) -v:GetPos() +v:OBBCenter()):GetNormalized()) > math.cos(math.rad(SCP_SightAngle))) then
				if !table.HasValue(tb) then
					table.insert(tb,v)
				end
			else
				if table.HasValue(tb) && tb[v] != nil then
					tb[v] = nil
				end
			end
		end
	end
	return tb
end

function NPC_Meta:SCP_CanBeSeen()
	local tb = {}
	for _,v in ipairs(player.GetAll()) do
		if GetConVarNumber("ai_ignoreplayers") == 1 then return false end
		if v:IsPlayer() && v:Visible(self) then
			if v:GetNWBool("SCP_IsBlinking") == false && v.IsPossessing == false && v:Alive() && self:Disposition(v) != D_LI && v:Visible(self) && (v:GetForward():Dot(((self:GetPos() +self:OBBCenter() +self:GetForward() *-30) -v:GetPos() +v:OBBCenter()):GetNormalized()) > math.cos(math.rad(SCP_SightAngle))) then
				if !table.HasValue(tb) then
					table.insert(tb,v)
				end
			else
				if table.HasValue(tb) && tb[v] != nil then
					tb[v] = nil
				end
			end
		end
	end
	for _,v in ipairs(tb) do
		if v == nil then
			return false
		end
		return true
	end
	return false
end

function NPC_Meta:SCP_CanBeSeen_NPC()
	local tb = {}
	for _,v in ipairs(ents.GetAll()) do
		if v:IsNPC() && v:Visible(self) then
			if v != self && v.SCP_IsBlinking == false && v:GetClass() != "npc_bullseye" && self:Disposition(v) != D_LI && v:GetClass() != self:GetClass() && v:Visible(self) && (v:GetForward():Dot(((self:GetPos() +self:OBBCenter() +self:GetForward() *-30) -v:GetPos() +v:OBBCenter()):GetNormalized()) > math.cos(math.rad(SCP_SightAngle))) then
				if !table.HasValue(tb) then
					table.insert(tb,v)
				end
			else
				if table.HasValue(tb) && tb[v] != nil then
					tb[v] = nil
				end
			end
		end
	end
	for _,v in ipairs(tb) do
		if v == nil then
			return false
		end
		return true
	end
	return false
end

	-- Menu + ConVars --

CPTBase.AddConVar("cpt_scp_008infectiontime","200")
CPTBase.AddConVar("cpt_scp_049infectiontime","150")
CPTBase.AddConVar("cpt_scp_420effectstime","20")
CPTBase.AddConVar("cpt_scp_513effectstime","60")
CPTBase.AddConVar("cpt_scp_939viewdistance","450")

CPTBase.AddConVar("cpt_scp_939slsounds","0")
CPTBase.AddConVar("cpt_scp_173slsounds","0")
CPTBase.AddConVar("cpt_scp_049slsounds","0")
CPTBase.AddConVar("cpt_scp_ntfannouncer","1")
CPTBase.AddConVar("cpt_scp_site19","1")
CPTBase.AddConVar("cpt_scp_106damage","0")
CPTBase.AddConVar("cpt_scp_realistic966","0")
CPTBase.AddConVar("cpt_scp_usemusic","1")
CPTBase.AddConVar("cpt_scp_939smallcollision","0")
CPTBase.AddConVar("cpt_scp_mtfhiding","1")
CPTBase.AddConVar("cpt_scp_895attack","0")
CPTBase.AddConVar("cpt_scp_halloween","0")
CPTBase.AddConVar("cpt_scp_173revision","0")
CPTBase.AddConVar("cpt_scp_173blinksame","0")
CPTBase.AddConVar("cpt_scp_682audio","0")
CPTBase.AddConVar("cpt_scp_682theme","1")
CPTBase.AddClientVar("cpt_scp_blinkmessage","0",true)

local function CPTBase_SCP_ResetFemurBreaker(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		if SERVER then
			FEMURACTIVATED = false
			NEXTFMT = 0
			ST_FEMUR = false
			NEXTSTT = 0
			MN_FEMUR = false
			NEXTMNT = 0
		end
	end
end
concommand.Add("cpt_scp_resetfemurbreaker",CPTBase_SCP_ResetFemurBreaker)

local function CPTBase_SCP_Decontamination(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PlayGlobalSound("cpthazama/scpsl/vo/Decont_countdown.mp3")
		for _,v in ipairs(ents.GetAll()) do
			if v:IsValid() && v:GetClass() == "prop_door_rotating" || v:GetClass() == "func_door" then
				v:Fire("Unlock")
				v:Fire("Open")
				-- v:Fire("Lock")
			end
		end
		timer.Simple(38,function() for _,v in ipairs(player.GetAll()) do v:Kill() end end)
	end
end
concommand.Add("cpt_scp_decontamination",CPTBase_SCP_Decontamination)

local function CPTBase_SCP_Nuke(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PlayGlobalSound("cpthazama/scpsl/vo/Main120.mp3")
		for _,v in ipairs(ents.GetAll()) do
			if v:IsValid() && v:GetClass() == "prop_door_rotating" || v:GetClass() == "func_door" then
				v:Fire("Unlock")
				v:Fire("Open")
				-- v:Fire("Lock")
			end
		end
		timer.Simple(131,function() for _,v in ipairs(ents.GetAll()) do v:TakeDamage(999999999,nil) end end)
	end
end
concommand.Add("cpt_scp_nuke",CPTBase_SCP_Nuke)

if (CLIENT) then
	local hookName = "CPTBaseMenu_Add_SCP"
	local menuMainTab = "CPTBase"
	local menuDropName = "Mod Settings"
	local menuTabName = "SCP:CB SNPCs"
	local function CPTBaseMenu_SCP_SNPC(panel)
		if !game.SinglePlayer() then
			if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
				panel:AddControl("CheckBox",{Label = "Remind you when you're going to blink?",Command = "cpt_scp_blinkmessage"})
				panel:AddControl("Label",{Text = "Only admins can access the other settings!"})
				return
			end
		end
		local CPTBaseMenu_SCP_SNPC = {Options = {},CVars = {},Label = "#Presets",MenuButton = "1",Folder = "SCP SNPCs Settings"}
		CPTBaseMenu_SCP_SNPC.Options["#Default"] = {
			cpt_scp_008infectiontime = "200",
			cpt_scp_049infectiontime = "150",
			cpt_scp_420effectstime = "20",
			cpt_scp_513effectstime = "60",
			cpt_scp_173slsounds = "0",
			cpt_scp_049slsounds = "0",
			cpt_scp_ntfannouncer = "1",
			cpt_scp_106damage = "0",
			cpt_scp_site19 = "1",
			cpt_scp_939viewdistance = "450",
			cpt_scp_blinkmessage = "1",
			cpt_scp_usemusic = "1",
			cpt_scp_realistic966 = "0",
			cpt_scp_939smallcollision = "0",
			cpt_scp_939slsounds = "0",
			cpt_scp_mtfhiding = "1",
			cpt_scp_895attack = "0",
			cpt_scp_173revision = "0",
			cpt_scp_173blinksame = "0",
			cpt_scp_682audio = "0",
			cpt_scp_682theme = "1",
		}
		panel:AddControl("ComboBox",CPTBaseMenu_SCP_SNPC)
		panel:AddControl("CheckBox",{Label = "Allow custom code on gm_site19",Command = "cpt_scp_site19"})
		panel:AddControl("CheckBox",{Label = "Make SCP-106 take normal damage?",Command = "cpt_scp_106damage"})
		panel:AddControl("CheckBox",{Label = "Enable SCP-939's Secret Laboratory sounds?",Command = "cpt_scp_939slsounds"})
		panel:AddControl("CheckBox",{Label = "Enable SCP-173's Secret Laboratory sounds?",Command = "cpt_scp_173slsounds"})
		panel:AddControl("CheckBox",{Label = "Enable SCP-049's Secret Laboratory sounds?",Command = "cpt_scp_049slsounds"})
		panel:AddControl("CheckBox",{Label = "Make SCP-966 actually invisible?",Command = "cpt_scp_realistic966"})
		panel:AddControl("CheckBox",{Label = "Make SCP-939 have a small collision?",Command = "cpt_scp_939smallcollision"})
		panel:AddControl("CheckBox",{Label = "Use NTF Announcer if on gm_site19?",Command = "cpt_scp_ntfannouncer"})
		panel:AddControl("CheckBox",{Label = "Allow MTF to run from certain SCPs?",Command = "cpt_scp_mtfhiding"})
		panel:AddControl("CheckBox",{Label = "Allow SCP-895 to attack players regardless of nightvision?",Command = "cpt_scp_895attack"})
		panel:AddControl("CheckBox",{Label = "Allow music on some SCPs?",Command = "cpt_scp_usemusic"})
		panel:AddControl("CheckBox",{Label = "Remind you when you're going to blink?",Command = "cpt_scp_blinkmessage"})
		panel:AddControl("CheckBox",{Label = "Allow SCP-628 extra audio?",Command = "cpt_scp_682audio"})
		panel:AddControl("CheckBox",{Label = "Allow SCP-628 battle theme?",Command = "cpt_scp_682theme"})
		panel:AddControl("CheckBox",{Label = "Use SCP-173's '2018 lore'?",Command = "cpt_scp_173revision"})
		panel:AddControl("CheckBox",{Label = "Make all NPCs and Players blink every 5 seconds?",Command = "cpt_scp_173blinksame"})
		panel:AddControl("Slider", { Label 	= "SCP-008 infection time", Command = "cpt_scp_008infectiontime", Type = "Float", Min = "10", Max = "800"})
		panel:AddControl("Slider", { Label 	= "SCP-049 infection time", Command = "cpt_scp_049infectiontime", Type = "Float", Min = "10", Max = "800"})
		panel:AddControl("Slider", { Label 	= "SCP-420-J effects time", Command = "cpt_scp_420effectstime", Type = "Float", Min = "5", Max = "120"})
		panel:AddControl("Slider", { Label 	= "SCP-513 effects time", Command = "cpt_scp_513effectstime", Type = "Float", Min = "30", Max = "360"})
		panel:AddControl("Slider", { Label 	= "SCP-939 view distance", Command = "cpt_scp_939viewdistance", Type = "Float", Min = "100", Max = "7500"})
		panel:AddControl("Button", {Label = "Reset Femur Breaker (if it's broken)", Command = "cpt_scp_resetfemurbreaker"})
		panel:AddControl("Button", {Label = "Decontamination Sequence", Command = "cpt_scp_decontamination"})
		panel:AddControl("Button", {Label = "Alpha Warhead Detonation Sequence", Command = "cpt_scp_nuke"})
		panel:AddControl("Label",{Text = "Cpt. Hazama"})
	end
	function CPTBaseMenu_Add_SCP()
		spawnmenu.AddToolMenuOption(menuMainTab,menuDropName,menuTabName,menuTabName .. " Settings","","",CPTBaseMenu_SCP_SNPC) -- Tab, Dropdown, Select, Title
	end
	hook.Add("PopulateToolMenu",hookName,CPTBaseMenu_Add_SCP)
end

	-- Set up --

// Custom stuff
POCKETDIMENSION = Vector(2301.208252,4616.074219,512.031250)
VENTA = Vector(3530.062256,1088.677856,0.031250)
VENTB = Vector(3392.920166,2365.031006,0.186196)
VENTC = Vector(4162.134277,3011.957764,1.603760)
VENTD = Vector(4800.398926,1599.382446,0.031250)
VENTE = Vector(-2420.687988,3691.424805,0.031250)
VENTF = Vector(2131.408447,-833.008423,2.629341)
VENTG = Vector(762.196350,1862.844360,128.031250)
VENTH = Vector(1467.462646,-2335.210938,5.031250)
FEMURBREAKER = Vector(2510.879639,4448.236816,-402.968750)
FEMURBREAKERBUTTON = Vector(2181.582031,5239.628906,-207.408264)

// Spawn
THESTATUE = Vector(1156.137695,1669.294189,128.031250)
THEDOCTOR = Vector(4789.070801,-2199.250488,16.031250)
DOORMONSTER = Vector(5221.532715,5611.821777,-1151.968750)
NINETAILEDFOX = Vector(-3667.533936,3008.088379,0.031250)
DCLASS_1 = Vector(-724.727173,1662.895996,128.031250)
DCLASS_2 = Vector(-1053.085205,1926.578003,128.031250)
DCLASS_3 = Vector(-1839.484009,1914.269165,128.031250)
EYEJUMPER = Vector(-1454.074585,-895.121460,1.031254)
MASKEDMAN = Vector(5700.815918,-897.143433,0.031250)
NIGHTMONSTER = Vector(4142.149902,2391.131104,0.031250)
SCHOOLESSAY = Vector(-322.574921,-226.815811,-228.013397)
SHYBOI = Vector(5108.851563,3645.203613,0.031250)
ZAMBIE = Vector(-985.775757,2585.012451,0.031250)
GATOR_1 = Vector(2323.954590,-1011.927673,-767.968750)
GATOR_2 = Vector(1793.346558,-2106.122559,-767.968750)
GATOR_3 = Vector(1104.790894,-661.958618,-767.968750)

hook.Add("PlayerSay","CPTBase_SCP_CommandsChat",function(ply,spoke)
	local lowered = string.lower(spoke)
	if ply:GetNWBool("SCP_HasNightvision") && lowered == "!removenvg" then
		ply:SetNWBool("SCP_HasNightvision",false)
		ply:ChatPrint("You take off the nightvision goggles.")
	end
	if ply:GetNWBool("SCP_Has178") && lowered == "!remove178" then
		ply:SetNWBool("SCP_Has178",false)
		ply:ChatPrint("You take off the 3D glasses.")
	end
end)