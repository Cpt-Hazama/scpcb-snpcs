if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/427.mdl"}
ENT.StartHealth = 10
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(4,4,2)

ENT.Faction = "FACTION_NONE"

ENT.Bleeds = false
ENT.TurnsOnDamage = false
ENT.IsEssential = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_TINY)
	self:SetMovementType(MOVETYPE_NONE)
	self:SetModelScale(1.5,0)
	self.NextUseT = 0
	self.Possessor_CanMove = false
	self.IsPickedUp = false
	self.Wearer = NULL
	self.NextHealT = 0
	self.NextKillT = CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.IsPickedUp then
		self:SetNoDraw(true)
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		if IsValid(self.Wearer) then
			if !self.Wearer:Alive() then
				self:SetPos(self.Wearer:GetPos())
				self.Wearer = NULL
			end
			if IsValid(self.Wearer) then
				self:SetPos(self.Wearer:GetPos())
				if CurTime() > self.NextHealT then
					self.Wearer:SetHealth(self.Wearer:Health() +5)
					self.NextHealT = CurTime() +0.1
				end
				if CurTime() > self.NextKillT then
					self.Wearer:Kill()
					self.Wearer = NULL
				end
			end
		else
			self:SetClearPos(self:GetPos())
			self.IsPickedUp = false
			self:SetNoDraw(false)
			self:SetCollisionGroup(COLLISION_GROUP_NPC)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInputAccepted(event,activator)
	if CurTime() > self.NextUseT then
		if event == "Use" && IsValid(activator) && activator:IsPlayer() && activator:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 && activator.SCP_Has427 == false && self.IsPickedUp == false then
			activator:ChatPrint("The locket fits perfectly around your neck..")
			activator.SCP_Has427 = true
			self:SetNoDraw(true)
			self.Wearer = activator
			self.IsPickedUp = true
			self.NextKillT = CurTime() +math.Rand(45,125)
		end
		self.NextUseT = CurTime() +0.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	if IsValid(self.Wearer) then
		self.Wearer.SCP_Has427 = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end