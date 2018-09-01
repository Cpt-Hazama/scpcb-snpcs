ENT.Base = "npc_cpt_base"
ENT.Type = "ai"
ENT.PrintName = "SCP"
ENT.Author = "Cpt. Hazama"
ENT.Category = "SCP:CB"

if CLIENT then
	function ENT:OnClientThink()
		local ply = LocalPlayer()
		if ply:GetNWBool("SCP_HasNightvision") then
			self:SetNoDraw(false)
		else
			self:SetNoDraw(true)
		end
	end
end