/*--------------------------------------------------
	Copyright (c) 2018 by Cpt. Hazama, All rights reserved.
	Nothing in these files or/and code may be reproduced, adapted, merged or
	modified without prior written consent of the original author, Cpt. Hazama
--------------------------------------------------*/
include('server/cpt_utilities.lua')

CPTBase.RegisterMod("SCP:CB SNPCs","0.1.7")

CPTBase.DefineDecal("SCP_PDCorrosion",{"decals/decalpd3"})
CPTBase.AddParticleSystem("particles/cpt_scp_pocketdimension.pcf",{})

local category = "SCP:CB"
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
CPTBase.AddNPC("SCP-173","npc_cpt_scp_173",category)
-- CPTBase.AddNPC("SCP-173 (Box)","npc_cpt_scp_173_box",category) // Shouldn't be spawnable
CPTBase.AddNPC("SCP-178","npc_cpt_scp_178",category)
-- CPTBase.AddNPC("SCP-205","npc_cpt_scp_205",category) // Stupid
-- CPTBase.AddNPC("SCP-205-A","npc_cpt_scp_205a",category)
-- CPTBase.AddNPC("SCP-205-B","npc_cpt_scp_205b",category)
-- CPTBase.AddNPC("SCP-205-C","npc_cpt_scp_205c",category)
-- CPTBase.AddNPC("SCP-205-D","npc_cpt_scp_205d",category) // H o t
CPTBase.AddNPC("SCP-372","npc_cpt_scp_372",category) // Should this even be here lol
CPTBase.AddNPC("SCP-420-J","npc_cpt_scp_420",category)
CPTBase.AddNPC("SCP-427","npc_cpt_scp_427",category)
CPTBase.AddNPC("SCP-500","npc_cpt_scp_500",category)
CPTBase.AddNPC("SCP-513","npc_cpt_scp_513",category)
-- CPTBase.AddNPC("SCP-513-1","npc_cpt_scp_513_1",category) // Shouldn't be spawnable
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
CPTBase.AddNPC("MTF Epislon-11 Nine-Tailed Fox","npc_cpt_scp_ntf",category)
CPTBase.AddNPC("MTF Lambda-5 White Rabbits","npc_cpt_scp_lambda",category)
CPTBase.AddNPC("MTF Nu-7 Hammer Down","npc_cpt_scp_nu",category)

CPTBase.AddNPC("Class D Subject","npc_cpt_scp_dclass",category)
CPTBase.AddNPC("Scientist","npc_cpt_scp_scientist",category)

CPTBase.AddNPC("Nightvision Goggles","ent_cpt_scp_nightvision",category)

if CLIENT then
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

	local CLIENT_SCP_NV = false
	concommand.Add("cpt_scp_togglenightvision", function(ply,cmd,args)
		CLIENT_SCP_NV = not CLIENT_SCP_NV
	end)

	hook.Add("RenderScreenspaceEffects","CPTBase_SCP_Nightvision",function(ply)
		if CLIENT_SCP_NV == true then
			DrawColorModify(tab_nightvision)
		end
	end)
	
	hook.Add("Think","CPTBase_SCP_Nightvision966",function()
		if CLIENT then
			if CLIENT_SCP_NV then
				local light = DynamicLight(LocalPlayer():EntIndex())
				if (light) and CLIENT_SCP_NV then
					light.Pos = LocalPlayer():GetPos() +Vector(0,0,30)
					light.r = 33
					light.g = 255
					light.b = 0
					light.Brightness = 0
					light.Size = 600
					light.Decay = 1800
					light.DieTime = CurTime() +0.2
					light.Style = 0
				end
				for _,v in ipairs(ents.GetAll()) do
					if v:IsValid() && v:IsNPC() && v:GetClass() == "npc_cpt_scp_966" then
						v:SetNoDraw(false)
					end
				end
			else
				for _,v in ipairs(ents.GetAll()) do
					if v:IsValid() && v:IsNPC() && v:GetClass() == "npc_cpt_scp_966" then
						v:SetNoDraw(true)
					end
				end
			end
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
		ply:SetNWBool("SCP_895Horror",false)
		ply:SetNWString("SCP_895HorrorID",nil)
		ply:SetNWBool("SCP_IsBlinking",false)
		ply:SetNWBool("SCP_Touched1123",false)
		ply:SetNWBool("SCP_Touched1123_Horror",false)
		ply:SetNWInt("SCP_BlinkTime",CurTime() +math.random(4,7))
		ply:SetNWInt("SCP_LastBlinkAmount",0)
	-- end
end)

hook.Add("OnEntityCreated","CPTBase_SCP_SpawnData_NPCs",function(ent)
	if ent:IsNPC() then
		ent.SCP_IsBlinking = false
		ent.SCP_BlinkTime = CurTime() +math.random(4,7)
	end
end)

hook.Add("PlayerSpawn","CPTBase_SCP_SpawnData",function(ply)
	if CLIENT then
		ply:SetNWBool("SCP_HasNightvision",false)
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

hook.Add("PreDrawHalos","CPTBase_SCP_939Possession",function()
	if !game.SinglePlayer() then return end
	if CLIENT then
		local movers = {}
		local movernum = 0
		for _,v in ipairs(player.GetAll()) do
			if IsValid(v) then
				if v:GetMoveType() == MOVETYPE_WALK && !v:Crouching() && (v:KeyDown(IN_FORWARD) or v:KeyDown(IN_BACK) or v:KeyDown(IN_MOVELEFT) or v:KeyDown(IN_MOVERIGHT) or v:KeyDown(IN_JUMP)) then
					movernum = movernum +1
					movers[movernum] = v
					if IsValid(v:GetActiveWeapon()) then
						movernum = movernum +1
						movers[movernum] = v:GetActiveWeapon()
					end
					for _,ply in ipairs(player.GetAll()) do
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
		end

		for _,v in ipairs(ents.GetAll()) do
			if IsValid(v) && v:IsNPC() then
				if v:GetVelocity():Length() > 0 then
					if !string.find(v:GetClass(),"scp_939") then
						movernum = movernum +1
						movers[movernum] = v
						if IsValid(v:GetActiveWeapon()) then
							movernum = movernum +1
							movers[movernum] = v:GetActiveWeapon()
						end
					end
					for _,ply in ipairs(player.GetAll()) do
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
				halo.Add(movers,Color(255,191,0),2,2,2,true,true)
			end
		end
	end
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

hook.Add("Think","CPTBase_SCP_BlinkSystem_NPCs",function()
	local canevenblink = false
	for _,scp in ipairs(ents.GetAll()) do
		if scp:IsNPC() && (scp:GetClass() == "npc_cpt_scp_173" or scp:GetClass() == "npc_cpt_scp_087_b") then
			canevenblink = true
		end
	end
	if canevenblink == true then
		local tb = {}
		for _,v in ipairs(ents.GetAll()) do
			if v:IsNPC() && (v:GetClass() != "npc_cpt_scp_173" && v:GetClass() != "npc_cpt_scp_087_b") && v:Health() > 0 then
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
			surface.SetMaterial(Material("engine/modulatesinglecolor"))
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
		if !ply:GetNWBool("SCP_IsBlinking") && ply:GetNWBool("SCP_Touched1123") && ply:GetNWBool("SCP_Touched1123_Horror") == false then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(Material("engine/singlecolor"))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			surface.SetDrawColor(255,255,255,0)
			surface.DrawRect(0,0,ScrW(),ScrH())
		end
		if !ply:GetNWBool("SCP_IsBlinking") && ply:GetNWBool("SCP_Touched1123") && ply:GetNWBool("SCP_Touched1123_Horror") == true then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(Material("overlay/1123"))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			surface.SetDrawColor(255,255,255,0)
			surface.DrawRect(0,0,ScrW(),ScrH())
		end
	end
end)

hook.Add("Think","CPTBase_SCP_BlinkSystem",function()
	if GetConVarNumber("ai_ignoreplayers") == 0 then
		local canevenblink = false
		for _,scp in ipairs(ents.GetAll()) do
			if scp:IsNPC() && (scp:GetClass() == "npc_cpt_scp_173" or scp:GetClass() == "npc_cpt_scp_087_b" or scp:GetClass() == "npc_cpt_scpunity_173") then
				canevenblink = true
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
					if tb[i]:GetNWBool("CPTBase_IsPossessing") == false && tb[i].IsPossessing == false && tb[i]:Alive() && CurTime() > tb[i]:GetNWInt("SCP_BlinkTime") && tb[i]:GetNWBool("SCP_IsBlinking") == false then
						local deaths = tb[i]:Deaths()
						if tb[i]:Deaths() > deaths then return end
						tb[i]:SetNWBool("SCP_IsBlinking",true)
						if tb[i]:GetNWBool("SCP_IsBlinking") == true then
							timer.Simple(0.5,function()
								if tb[i]:IsValid() && tb[i]:Alive() then
									tb[i]:SetNWBool("SCP_IsBlinking",false)
									local time = math.random(5,9)
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

function NPC_Meta:SCP_CanBeSeen()
	local tb = {}
	for _,v in ipairs(player.GetAll()) do
		if GetConVarNumber("ai_ignoreplayers") == 1 then return false end
		if v:IsPlayer() && v:Visible(self) then
			if v:GetNWBool("SCP_IsBlinking") == false && v.IsPossessing == false && v:Alive() && self:Disposition(v) != D_LI && v:Visible(self) && (v:GetForward():Dot(((self:GetPos() +self:OBBCenter()) -v:GetPos() +v:OBBCenter() -self:GetForward() *15):GetNormalized()) > math.cos(math.rad(SCP_SightAngle))) then
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
			if v != self && v.SCP_IsBlinking == false && v:GetClass() != "npc_bullseye" && self:Disposition(v) != D_LI && v:GetClass() != self:GetClass() && v:Visible(self) && (v:GetForward():Dot(((self:GetPos() +self:OBBCenter()) -v:GetPos() +v:OBBCenter()):GetNormalized()) > math.cos(math.rad(SCP_SightAngle))) then
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

if (CLIENT) then
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
		panel:AddControl("Slider", { Label 	= "SCP-008 infection time", Command = "cpt_scp_008infectiontime", Type = "Float", Min = "10", Max = "800"})
		panel:AddControl("Slider", { Label 	= "SCP-049 infection time", Command = "cpt_scp_049infectiontime", Type = "Float", Min = "10", Max = "800"})
		panel:AddControl("Slider", { Label 	= "SCP-420-J effects time", Command = "cpt_scp_420effectstime", Type = "Float", Min = "5", Max = "120"})
		panel:AddControl("Slider", { Label 	= "SCP-513 effects time", Command = "cpt_scp_513effectstime", Type = "Float", Min = "30", Max = "360"})
		panel:AddControl("Slider", { Label 	= "SCP-939 view distance", Command = "cpt_scp_939viewdistance", Type = "Float", Min = "100", Max = "7500"})
		panel:AddControl("Button", {Label = "Reset Femur Breaker (if it's broken)", Command = "cpt_scp_resetfemurbreaker"})
		panel:AddControl("Label",{Text = "Cpt. Hazama"})
	end
	function CPTBaseMenu_Add_SCP()
		spawnmenu.AddToolMenuOption("CPTBase","Mod Settings","SCP:CB SNPCs","SCP:CB SNPCs Settings","","",CPTBaseMenu_SCP_SNPC) -- Tab, Dropdown, Select, Title
	end
	hook.Add("PopulateToolMenu","CPTBaseMenu_Add_SCP",CPTBaseMenu_Add_SCP)
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
	if lowered == "!removenvg" then
		ply:SetNWBool("SCP_HasNightvision",false)
		ply:ChatPrint("You take off the nightvision goggles.")
	end
end)