ENT.Base = "npc_cpt_base"
ENT.Type = "ai"
ENT.PrintName = "SCP"
ENT.Author = "Cpt. Hazama"
ENT.Category = "SCP:CB"

if (CLIENT) then
	function ENT:OnClientThink()
		if self:GetNWBool("Chase") then
			local track = "cpthazama/scp/_oldscp/106theme.mp3"
			local len = 20
			self:CreateThemeSong(track,len)
		else
			self:StopATrack("cpthazama/scp/_oldscp/106theme.mp3",0.2)
		end
	end
end