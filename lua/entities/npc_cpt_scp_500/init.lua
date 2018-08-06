if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/500.mdl"}
ENT.StartHealth = 10
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(2,2,2)

ENT.Faction = "FACTION_NONE"

ENT.Bleeds = false
ENT.TurnsOnDamage = false
ENT.IsEssential = false
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
		if event == "Use" && IsValid(activator) && activator:IsPlayer() && activator:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 then
			activator:SetHealth(activator:Health() +80)
			activator:ChatPrint("Your wounds heal instantly..")
			self:Remove()
		end
		self.NextUseT = CurTime() +0.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end