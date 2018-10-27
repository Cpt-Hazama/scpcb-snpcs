ENT.Base = "npc_cpt_base"
ENT.Type = "ai"
ENT.PrintName = "SCP"
ENT.Author = "Cpt. Hazama"
ENT.Category = "SCP:CB"

if (CLIENT) then
	function ENT:OnClientInit()
		if GetConVarNumber("cpt_scp_682theme") == 1 then
			local track = "cpthazama/scp/682/Theme.mp3"
			local len = 120
			self:CreateThemeSong(track,len)
		end
	end
end