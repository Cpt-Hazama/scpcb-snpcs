if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/items/173_box.mdl"}
ENT.StartHealth = 300
ENT.IsEssential = true
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CollisionBounds = Vector(18,18,70)
ENT.ViewDistance = 0
ENT.ViewAngle = 0
ENT.CanWander = false
ENT.CanSetEnemy = false
ENT.ReactsToSound = false
ENT.TurnsOnDamage = false

ENT.Faction = "FACTION_SCP_NTF"
-- ENT.Faction = "FACTION_NONE"

ENT.Bleeds = false

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.SCP = NULL
	self.NTFOwner = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SecureBox(scp173,owner)
	self.SCP = scp173
	self.NTFOwner = owner
	self.NTFOwner.IsTakingSCP_Box = self
	self.NTFOwner.IsTakingSCP = true
	scp173:AddFlags(FL_NOTARGET)
	-- if att then
	-- 	scp173:SetPos(att.Pos)
	-- end
	-- scp173:SetAngles(self:GetAngles())
	-- scp173:SetParent(self)
	-- scp173:Fire("SetParentAttachment","173",0)
	-- scp173:SetLocalAngles(Angle(0,90,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if IsValid(self.NTFOwner) then
		if self.NTFOwner:GetPos():Distance(self:GetPos()) > 125 then
			self:ChaseTarget(self.NTFOwner,true)
		else
			self:CPT_StopCompletely()
		end
	else
		self:CPT_StopCompletely()
	end
	if IsValid(self.SCP) then
		self.SCP.IsContained = true
		self.SCP.Possessor_CanMove = false
		self.SCP:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		-- self.SCP:SetParent(self)
		self.SCP.Faction = "FACTION_SCP_NTF"
		self.SCP.CanWander = false
		self.SCP.CanSetEnemy = false
		self.SCP.CanChaseEnemy = false
		self.SCP:CPT_StopCompletely()
		self.SCP:SetPos(self:GetAttachment(self:LookupAttachment("173")).Pos)
		self.SCP:SetAngles(self:GetAngles())
	else
		self:Remove()
	end

	self:NextThink(CurTime())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	if IsValid(self.SCP) then
		self.SCP.IsContained = false
		-- self.SCP:SetParent(NULL)
		self.SCP.Possessor_CanMove = true
		self.SCP:SetCollisionGroup(COLLISION_GROUP_NPC)
		self.SCP.Faction = "FACTION_SCP"
		self.SCP.CanWander = true
		self.SCP.CanSetEnemy = true
		self.SCP.CanChaseEnemy = true
		self.SCP:UpdateRelations()
	end
	if IsValid(self.NTFOwner) then
		self.NTFOwner.IsTakingSCP_Box = NULL
		self.NTFOwner.IsTakingSCP = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end