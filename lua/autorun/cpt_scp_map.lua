/*--------------------------------------------------
	Copyright (c) 2019 by Cpt. Hazama, All rights reserved.
	Nothing in these files or/and code may be reproduced, adapted, merged or
	modified without prior written consent of the original author, Cpt. Hazama
--------------------------------------------------*/
include('server/cpt_utilities.lua')

CPTBASE_TBL_SCPMAPVECTORS = { -- Don't touch these
	["gm_site19"] = {},
	["rp_site54"] = {},
	["rp_site61_kaktusownia"] = {},
}

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
										v:CPT_StopCompletely()
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

function util.GetSCPMapData(dataID)
	if !CPTBASE_TBL_SCPMAPVECTORS[game.GetMap()] then
		return nil
	end
	return CPTBASE_TBL_SCPMAPVECTORS[game.GetMap()][dataID]
end

function util.AddSCPMapData(dataMap,dataVector) -- Run this in a autorun file either in a hook or just anywhere in a blank space
	if !CPTBASE_TBL_SCPMAPVECTORS[dataMap] then
		CPTBASE_TBL_SCPMAPVECTORS[dataMap] = {}
	end
	table.insert(CPTBASE_TBL_SCPMAPVECTORS[dataMap],dataVector)
end

function util.IsSCPMap()
	if GetConVarNumber("cpt_scp_site19") == 0 then return false end
	-- if game.GetMap() == "gm_site19" || game.GetMap() == "rp_site54" || game.GetMap() == "rp_site61_kaktusownia" then
		-- return true
	-- end
	if CPTBASE_TBL_SCPMAPVECTORS[game.GetMap()] then
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