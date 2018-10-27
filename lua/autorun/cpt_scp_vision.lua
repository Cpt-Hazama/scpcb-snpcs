/*--------------------------------------------------
	Copyright (c) 2018 by Cpt. Hazama, All rights reserved.
	Nothing in these files or/and code may be reproduced, adapted, merged or
	modified without prior written consent of the original author, Cpt. Hazama
--------------------------------------------------*/
if CLIENT then
	// 079 -----------------------------------------------------------------------------------------------------------------
		local tab_computer = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0.2,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}

		local CLIENT_SCP_PC = false
		concommand.Add("cpt_scp_togglepcvision", function(ply,cmd,args)
			CLIENT_SCP_PC = not CLIENT_SCP_PC
		end)
	//----------------------------------------------------------------------------------------------------------------------------

	// Red vision -----------------------------------------------------------------------------------------------------------------
		local tab_redvis = {
			["$pp_colour_addr"] = 0.02,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 3,
			["$pp_colour_mulr"] = 100,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}
	//----------------------------------------------------------------------------------------------------------------------------
	
	// Grey vision -----------------------------------------------------------------------------------------------------------------
		local tab_greyvis = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = -0.2,
			["$pp_colour_contrast"] = 8,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}
	//----------------------------------------------------------------------------------------------------------------------------

	// 106 vision -----------------------------------------------------------------------------------------------------------------
		local tab_106vis = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0.02,
			["$pp_colour_brightness"] = -0.2,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 100
		}
	//----------------------------------------------------------------------------------------------------------------------------

	// zombie vision -----------------------------------------------------------------------------------------------------------------
		local tab_zomvis = {
			["$pp_colour_addr"] = 0.02,
			["$pp_colour_addg"] = 0.02,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = -0.2,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 100,
			["$pp_colour_mulg"] = 100,
			["$pp_colour_mulb"] = 0
		}
	//----------------------------------------------------------------------------------------------------------------------------
	
	// 372 vision -----------------------------------------------------------------------------------------------------------------
		local tab_372vis = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0.05,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = -0.2,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 50,
			["$pp_colour_mulb"] = 0
		}
	//----------------------------------------------------------------------------------------------------------------------------
	
	// 457 vision -----------------------------------------------------------------------------------------------------------------
		local tab_457vis = {
			["$pp_colour_addr"] = 0.06,
			["$pp_colour_addg"] = 0.06,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = -0.6,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 200,
			["$pp_colour_mulg"] = 200,
			["$pp_colour_mulb"] = 0
		}
	//----------------------------------------------------------------------------------------------------------------------------
	
	hook.Add("RenderScreenspaceEffects","CPTBase_SCP_RealVision",function(ply)
		if CLIENT_SCP_PC == true then
			DrawColorModify(tab_computer)
		end
	end)
end