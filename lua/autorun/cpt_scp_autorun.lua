/*--------------------------------------------------
	Copyright (c) 2019 by Cpt. Hazama, All rights reserved.
	Nothing in these files or/and code may be reproduced, adapted, merged or
	modified without prior written consent of the original author, Cpt. Hazama
--------------------------------------------------*/
include('server/cpt_utilities.lua')
include('cpt_scp_vision.lua')
include('cpt_scp_map.lua')

-- if !CPTBase.IsAddonUpdated("cptbase","54") then return end

CPTBase.RegisterMod("SCP:CB SNPCs","0.2.1")
-- CPTBase.AddAddon("scp","10")

CPTBase.DefineDecal("SCP_PDCorrosion",{"decals/decalpd3"})
-- CPTBase.DefineDecal("SCP_457Scorch",{"decals/decal_footprint_scorch"})
CPTBase.AddParticleSystem("particles/cpt_scp_pocketdimension.pcf",{})
CPTBase.AddParticleSystem("particles/DOOR_EXPLOSION.pcf",{})

local category = "SCP:CB"
-- CPTBase.AddNPC("SCP-106 (Isolation)","npc_cpt_scpiso_106",category)
CPTBase.AddNPC("SCP-173 (Isolation)","npc_cpt_scpiso_173",category)
CPTBase.AddAdminNPC("SCP-303 (Isolation)","npc_cpt_scpiso_303",category)
CPTBase.AddNPC("SCP-650 (Isolation)","npc_cpt_scpiso_650",category)

CPTBase.AddNPC("(Classic) SCP-008-1","npc_cpt_scp_008_1_old",category)
CPTBase.AddNPC("(Classic) SCP-096","npc_cpt_scp_096_old",category)
CPTBase.AddNPC("(Classic) SCP-106","npc_cpt_scp_106_old",category)
CPTBase.AddNPC("(Classic) SCP-173","npc_cpt_scp_173_old",category)
CPTBase.AddNPC("(Classic) MTF Guard","npc_cpt_scp_guard_old",category)

CPTBase.AddAdminNPC("SCP-005","npc_cpt_scp_005",category)
CPTBase.AddAdminNPC("SCP-008","npc_cpt_scp_008",category)
CPTBase.AddNPC("SCP-008-1","npc_cpt_scp_008_1",category)
CPTBase.AddAdminNPC("SCP-012","npc_cpt_scp_012",category)
CPTBase.AddNPC("SCP-035","npc_cpt_scp_035",category)
CPTBase.AddNPC("SCP-049","npc_cpt_scp_049",category)
CPTBase.AddNPC("SCP-049-2","npc_cpt_scp_049_2",category)
CPTBase.AddNPC("SCP-049-2 Soldier","npc_cpt_scp_049_2_ntf",category)
CPTBase.AddNPC("SCP-066","npc_cpt_scp_066",category)
CPTBase.AddAdminNPC("SCP-079","npc_cpt_scp_079",category)
CPTBase.AddAdminNPC("SCP-079 Camera","ent_cpt_scp_camera",category)
CPTBase.AddNPC("SCP-087-1","npc_cpt_scp_087_1",category)
CPTBase.AddNPC("SCP-087-B","npc_cpt_scp_087_b",category)
CPTBase.AddNPC("SCP-096","npc_cpt_scp_096",category)
CPTBase.AddNPC("SCP-106","npc_cpt_scp_106",category)
CPTBase.AddAdminNPC("SCP-106 Pocket Dimension Plane","npc_cpt_scp_106pdplane",category)
CPTBase.AddNPC("SCP-173","npc_cpt_scp_173",category)
-- CPTBase.AddNPC("SCP-173 (Box)","npc_cpt_scp_173_box",category) // Shouldn't be spawnable
CPTBase.AddNPC("SCP-178","npc_cpt_scp_178specs",category)
CPTBase.AddNPC("SCP-178-1","npc_cpt_scp_178",category)
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
CPTBase.AddNPC("SCP-650","npc_cpt_scp_650",category)
CPTBase.AddAdminNPC("SCP-682","npc_cpt_scp_682",category)
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

-- CPTBase.AddNPC("MTF Guard","npc_cpt_scp_guard",category)
CPTBase.AddNPC("MTF Epsilon-11 Nine-Tailed Fox","npc_cpt_scp_ntf",category)
CPTBase.AddNPC("MTF Lambda-5 White Rabbits","npc_cpt_scp_lambda",category)
CPTBase.AddNPC("MTF Nu-7 Hammer Down","npc_cpt_scp_nu",category)
CPTBase.AddAdminNPC("MTF AH-64 Apache","npc_cpt_scp_apache",category)

CPTBase.AddNPC("Class D Subject","npc_cpt_scp_dclass",category)
CPTBase.AddNPC("Scientist","npc_cpt_scp_scientist",category) // STAHP! NO!

CPTBase.AddNPC("Nightvision Goggles","ent_cpt_scp_nightvision",category) // The object itself isn't a NPC but technically speaking, it is a NPC since well, it's running on my SNPC base

hook.Add("OnNPCKilled","CPTBase_SCP079_KillPoints",function(victim,inflictor,killer)
	local canRun = false
	local SCP = NULL
	if killer.CPTBase_NPC then
		if killer != victim then
			for _,v in ipairs(ents.GetAll()) do
				if v:IsNPC() && v:GetClass() == "npc_cpt_scp_079" then
					canRun = true
					SCP = v
					break
				end
			end
			if canRun then
				if table.Count(SCP.tbl_LockedDoors) > 0 then
					for _,v in ipairs(SCP.tbl_LockedDoors) do
						if victim:GetPos():Distance(v:GetPos()) <= 450 then
							SCP.ExperiencePoints = SCP.ExperiencePoints +15
							break
						end
					end
				end
			end
		end
	end
end)

hook.Add("PlayerDeath","CPTBase_SCP079_KillPoints_Player",function(victim,inflictor,killer)
	local canRun = false
	local SCP = NULL
	if killer.CPTBase_NPC then
		if killer != victim then
			for _,v in ipairs(ents.GetAll()) do
				if v:IsNPC() && v:GetClass() == "npc_cpt_scp_079" then
					canRun = true
					SCP = v
					break
				end
			end
			if canRun then
				if table.Count(SCP.tbl_LockedDoors) > 0 then
					for _,v in ipairs(SCP.tbl_LockedDoors) do
						if victim:GetPos():Distance(v:GetPos()) <= 450 then
							SCP.ExperiencePoints = SCP.ExperiencePoints +15
							break
						end
					end
				end
			end
		end
	end
end)

hook.Add("PlayerUse","CPTBase_SCP005",function(ply,ent)
	if !ply.SCP_Has005 then return end
	if ply.SCP_NextUnlockDoorT == nil then ply.SCP_NextUnlockDoorT = 0 end
	if CurTime() > ply.SCP_NextUnlockDoorT && ent:IsValid() && string.find(ent:GetClass(),"door") && string.find(ent:GetSequenceName(ent:GetSequence()),"locked") then
		ent:Fire("Unlock")
		ply:ChatPrint("Door unlocked with SCP-005")
		ply:ChatPrint("SCP-005 cooldown time is 3 seconds")
		ent:EmitSound("doors/default_locked.wav",70,100)
		ply.SCP_NextUnlockDoorT = CurTime() +3
	end
end)

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
				halo.Add(tbl,Color(0,161,255),15,15,15,true,true)
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
					-- local pos = ent:CPT_SetClearPos(VectorRand())
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
	ply.SCP_Has005 = false
	ply.SCP_NextUse1123T = CurTime()
	ply.SCP_Using420 = false
	ply.CPTBase_SCP_Zombie = NULL
	ply.SCP_SpawnedZombieEntity = false
end)

hook.Add("Think","CPTBase_SCP_BlinkSystem_NPCs",function()
	local canevenblink = false
	for _,scp in ipairs(ents.GetAll()) do
		if scp:IsNPC() && (string.find(scp:GetClass(),"173") or string.find(scp:GetClass(),"087_b")) then
			canevenblink = true
		end
	end
	if canevenblink == true then
		local tb = {}
		for _,v in ipairs(ents.GetAll()) do
			if v:IsNPC() && !(string.find(v:GetClass(),"173") or string.find(v:GetClass(),"087_b")) && v:Health() > 0 then
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
			if scp:IsNPC() && (string.find(scp:GetClass(),"173") or string.find(scp:GetClass(),"087_b")) then
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
CPTBase.AddConVar("cpt_scp_682theme","0")
CPTBase.AddConVar("cpt_scp_guardduty","0")
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
			cpt_scp_682theme = "0",
			cpt_scp_guardduty = "0",
		}
		panel:AddControl("ComboBox",CPTBaseMenu_SCP_SNPC)
		panel:AddControl("CheckBox",{Label = "Allow custom code on gm_site19",Command = "cpt_scp_site19"})
		panel:AddControl("CheckBox",{Label = "Allow Guards to boss you around?",Command = "cpt_scp_guardduty"})
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