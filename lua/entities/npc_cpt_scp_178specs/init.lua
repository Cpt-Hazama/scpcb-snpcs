if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/178specs.mdl"}
ENT.StartHealth = 9999999
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(8,4,5)

ENT.Faction = "FACTION_NONE"
ENT.Possessor_CanBePossessed = false

ENT.Bleeds = false
ENT.TurnsOnDamage = false
ENT.IsEssential = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_TINY)
	self:SetMovementType(MOVETYPE_NONE)
	self.NextUseT = 0
	self.Possessor_CanMove = false
	self.IsPickedUp = false
	self.Wearer = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink_Disabled()
	if self.IsPickedUp then
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		if IsValid(self.Wearer) then
			local pos,ang = self.Wearer:GetBonePosition(7)
			self:SetPos(pos +self.Wearer:GetForward() *-3.5 +Vector(0,0,-2))
			self:SetAngles(ang)
			self:SetNoDraw(true)
			if self.Wearer:GetNWBool("SCP_Has178") == false then
				self:SetNoDraw(false)
				self:SetPos(self.Wearer:GetPos())
				self.Wearer:ConCommand("cpt_scp_toggle178")
				self.Wearer = NULL
			end
		else
			self:SetNoDraw(false)
			self:CPT_SetClearPos(self:GetPos())
			self.IsPickedUp = false
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self:PlayActivity(ACT_JUMP)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInputAccepted(event,activator)
	if CurTime() > self.NextUseT then
		if event == "Use" && IsValid(activator) && activator:IsPlayer() && activator:Alive() && activator:GetNWBool("SCP_Has178") == false && self.IsPickedUp == false then
			activator:ChatPrint("You put on the 3D glasses.")
			activator:SetNWBool("SCP_Has178",true)
			self.Wearer = activator
			activator:ConCommand("cpt_scp_toggle178")
			self.IsPickedUp = true
		end
		self.NextUseT = CurTime() +0.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	if IsValid(self.Wearer) then
		self.Wearer:SetNWBool("SCP_Has178",false)
		self.Wearer:ConCommand("cpt_scp_toggle178")
		self.Wearer:ChatPrint("You take off the 3D glasses.")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end