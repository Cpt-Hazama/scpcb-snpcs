if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/714.mdl"}
ENT.StartHealth = 80000
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(2,2,4)

ENT.Faction = "FACTION_NONE"

ENT.Bleeds = false
ENT.TurnsOnDamage = false
ENT.IsEssental = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_TINY)
	self:SetMovementType(MOVETYPE_NONE)
	self.NextUseT = 0
	self.Possessor_CanMove = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInputAccepted(event,activator)
	if CurTime() > self.NextUseT then
		if event == "Use" && activator:IsPlayer() && activator:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 && activator.SCP_Has714 == false then
			activator:ChatPrint("You pick up SCP-714 and it fits perfectly. Although you feel a bit tired..")
			activator.SCP_Has714 = true
			activator.SCP_Infected_008 = false
			activator.SCP_Infected_049 = false
			activator.SCP_Inflicted_1048a = false
			activator.SCP_Disease_LungCancer = false
			activator.SCP_Disease_Appendicitis = false
			activator.SCP_Disease_CommonCold = false
			activator.SCP_Disease_Chickenpox = false
			activator.SCP_Disease_Asthma = false
			activator.SCP_Disease_CardiacArrest = false
			activator:SetWalkSpeed(activator:GetWalkSpeed() -100)
			activator:SetRunSpeed(activator:GetRunSpeed() -100)
			self:EmitSound("physics/metal/soda_can_impact_soft1.wav",50,100)
			self:Remove()
		end
		self.NextUseT = CurTime() +0.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end