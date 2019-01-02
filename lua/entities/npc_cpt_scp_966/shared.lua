ENT.Base = "npc_cpt_base"
ENT.Type = "ai"
ENT.PrintName = "SCP"
ENT.Author = "Cpt. Hazama"
ENT.Category = "SCP:CB"

if CLIENT then
	function ENT:OnClientThink()
		local ply = LocalPlayer()
		if ply:GetNWBool("SCP_HasNightvision") || (ply:GetNWBool("CPTBase_IsPossessing") && ply:GetNWBool("CPTBase_PossessedNPCClass") == "npc_cpt_scp_966") then
			self:SetNoDraw(false)
		else
			self:SetNoDraw(true)
		end
	end
end