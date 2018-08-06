if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/513.mdl"}
ENT.StartHealth = 5
ENT.CanMutate = false
ENT.CollisionBounds = Vector(4,4,6)
ENT.CanWander = false
ENT.WanderChance = 0

ENT.Faction = "FACTION_NONE"
ENT.IsEssential = true
ENT.Bleeds = false
ENT.TurnsOnDamage = false

ENT.tbl_Sounds = {
	["Idle"] = {"cpthazama/scp/513/Light1.wav","cpthazama/scp/513/Light2.wav","cpthazama/scp/513/Light3.wav"},
}

ENT.IdleSoundVolume = 100
ENT.IdleSoundChanceA = 2
ENT.IdleSoundChanceB = 5
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_TINY)
	self:SetMovementType(MOVETYPE_NONE)
	self:SetModelScale(2,0)
	self.NextUseT = 0
	self.Possessor_CanMove = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInputAccepted(event,activator)
	if CurTime() > self.NextUseT then
		if event == "Use" && activator:IsPlayer() && activator:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 && activator.SCP_Has714 == false then
			activator:ChatPrint("You pick up SCP-513 and feel a cold sensation on your back..")
			self:EmitSound("physics/metal/weapon_footstep1.wav",72,100)
			self:Remove()
			timer.Simple(5,function()
				if activator:IsValid() then
					local curse = ents.Create("npc_cpt_scp_513_1")
					curse:SetPos(activator:GetPos() +activator:GetForward() *15)
					curse:SetAngles(activator:GetAngles())
					curse.BellToucher = activator
					curse:Spawn()
					curse:Activate()
					local deaths = activator:Deaths()
					timer.Simple(GetConVarNumber("cpt_scp_513effectstime"),function()
						if activator:IsValid() then
							if activator:Deaths() > deaths then return end
							activator:ChatPrint("The curse of SCP-513 feels as though it has worn off and you drop the bell..")
							local bell = ents.Create("npc_cpt_scp_513")
							bell:SetPos(activator:GetPos() +activator:GetForward() *30)
							bell:SetAngles(activator:GetAngles())
							bell:Spawn()
							bell:Activate()
							bell:EmitSound("physics/metal/metal_sheet_impact_bullet1.wav",72,100)
							CreateUndo(bell,"SCP-513",activator)
						end
						if curse:IsValid() then
							curse:Remove()
						end
					end)
				end
			end)
		end
		self.NextUseT = CurTime() +0.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end