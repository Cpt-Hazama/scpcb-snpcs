if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/079_camera.mdl"}
ENT.StartHealth = 9999999
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(8,4,5)
ENT.MaxTurnSpeed = 0

ENT.Faction = "FACTION_SCP"

-- ENT.UseNotarget = true
ENT.Bleeds = false
ENT.TurnsOnDamage = false
ENT.IsEssential = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindAllEnemies079()
	for _,v in ipairs(ents.GetAll()) do
		if IsValid(v) && (v:IsNPC() && v != self && v:GetClass() != "npc_cpt_scp_079" || v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 && self.FriendlyToPlayers == false && v.IsPossessing == false) then
			if v.Faction == "FACTION_NOTARGET" then return end
			if v.UseNotarget then return end
			-- if v:GetClass() != "ent_cpt_scp_camera" then return end
			if v:Health() > 0 && self:CheckCanSee(v,90) && v.Faction != self:GetCameraOwner().Faction then
				return v
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCameraOwner(ent)
	self.SCP = ent
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetCameraOwner()
	return self.SCP
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self.UseNotarget = true
	self.StartPos = self:GetPos()
	self.StartAng = self:GetAngles()
	self:SetHullType(HULL_TINY)
	self:SetMovementType(MOVETYPE_NONE)
	self.NextUseT = 0
	self.Possessor_CanMove = false
	self.IsBeingControlled = false
	self.CameraHitPosition = nil
	self.CameraHitEntity = NULL
	self.UseNotarget = true
	self:SetCollisionBounds(Vector(14,4,20),Vector(-24,-4,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink_Disabled()
	-- self:SetPos(self.StartPos)
	-- self:SetAngles(self.StartAng)
	-- PrintEntityPlacement(self)
	self.UseNotarget = true
	if IsValid(self:GetCameraOwner()) && self:GetCameraOwner():GetCurrentCamera() == self then
		self:SetSkin(1)
		local enemy = self:FindAllEnemies079()
		if !IsValid(self:GetCameraOwner():GetEnemy()) && IsValid(enemy) then
			self:GetCameraOwner():SetRelationship(enemy,D_HT)
			self:GetCameraOwner():SetEnemy(enemy)
			if !table.HasValue(self:GetCameraOwner().tbl_EnemyMemory,enemy) then
				table.insert(self:GetCameraOwner().tbl_EnemyMemory,enemy)
			end
		end
		if self:GetCameraOwner().IsPossessed then
			local pPos = self:Possess_EyeTrace(self:GetCameraOwner().Possessor).HitPos
			local pEnt = self:Possess_EyeTrace(self:GetCameraOwner().Possessor).Entity
			self.CameraHitPosition = pPos
			self.CameraHitEntity = pEnt
		end
	else
		self:SetSkin(0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PoseParameters()
	if !IsValid(self:GetCameraOwner()) then return end
	local pp = self.DefaultPoseParameters
	local pp_speed = self.DefaultPoseParamaterSpeed
	if self:GetCameraOwner().IsPossessed then
		self:LookAtPosition(self:Possess_EyeTrace(self:GetCameraOwner().Possessor).HitPos,self.DefaultPoseParameters,pp_speed,self.ReversePoseParameters)
	else
		if IsValid(self:GetCameraOwner()) && IsValid(self:GetCameraOwner():GetEnemy()) then
			self:LookAtPosition(self:FindCenter(self:GetCameraOwner():GetEnemy()),pp,3,self.ReversePoseParameters)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end