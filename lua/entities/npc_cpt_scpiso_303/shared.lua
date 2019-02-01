ENT.Base = "npc_cpt_base"
ENT.Type = "ai"
ENT.PrintName = "SCP"
ENT.Author = "Cpt. Hazama"
ENT.Category = "SCP:CB"

if CLIENT then
	function ENT:OnClientThink()
		hook.Add("HUDPaint","CPTBase_SCP303",function()
			local ply = LocalPlayer()
			if ply:GetNWBool("CPTBase_SCP303") then
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(Material("overlay/pulse_blue"))
				surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			end
		end)
	end
end