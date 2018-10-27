if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/087-1.mdl","models/cpthazama/scp/087-b.mdl"}
ENT.StartHealth = 10
ENT.HasDeathRagdoll = false
ENT.CollisionBounds = Vector(18,18,70)

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 60
ENT.MeleeAttackDamageDistance = 90
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 60

ENT.Bleeds = false

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["Strike"] = {"cpthazama/scp/D9341/Damage3.mp3"},
}

ENT.tbl_Capabilities = {CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.SkyEnt = self
	self:SetMaterial("engine/modulatesinglecolor")
	self:SetNPCRenderMode(RENDERMODE_TRANSADD)
	self:SetRenderFX(kRenderFxHologram)
	self:SetColor(Color(65,65,65,100))
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:DrawShadow(false)
	if SERVER then
		self.Ball = ents.Create("prop_dynamic")
		self.Ball:SetModel("models/cpthazama/ball.mdl")
		self.Ball:SetPos(self:GetPos())
		self.Ball:Spawn()
		self.Ball:SetModelScale(18,0)
		self:DeleteOnRemove(self.Ball)
		self.Ball:SetMaterial("engine/modulatesinglecolor")
		self.Ball:SetRenderMode(RENDERMODE_TRANSADD)
		self.Ball:SetRenderFX(kRenderFxHologram)
		self.Ball:SetColor(Color(65,65,65,1))
		self.Ball:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self.Ball:DrawShadow(false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "mattack") then
		if arg1 == "both" then
			self:DoDamage(self.MeleeAttackDamageDistance *1.5,self.MeleeAttackDamage,self.MeleeAttackType)
		else
			self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
		end
		return true
	end
	if(event == "emit") then
		if arg1 == "step" then
			if !IsValid(self:GetEnemy()) || (IsValid(self:GetEnemy()) && !(self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) && self:GetClosestPoint(self:GetEnemy()) > 800) then
				self:PlaySound("FootStep",90,90,100,true)
			end
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnHitEntity(hitents,hitpos)
	if self.tbl_Sounds["Strike"] == nil then
		self:EmitSound("npc/zombie/claw_strike" .. math.random(1,3) .. ".wav",55,100)
	else
		self:EmitSound(self:SelectFromTable(self.tbl_Sounds["Strike"]),55,100)
	end
	self:SetModelScale(self:GetModelScale() +0.1,0)
	if IsValid(self.Ball) then
		self.Ball:SetModelScale(self.Ball:GetModelScale() +1.2,0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindFlashlights()
	for _,v in ipairs(player.GetAll()) do
		if v:IsValid() && v:Alive() && v:Visible(self) && v:FlashlightIsOn() && v:GetPos():Distance(self:GetPos()) < 550 then
			return true
		else
			return false
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsUnderSky(ent)
	local tr = util.TraceHull({
		start = ent:GetPos(),
		endpos = ent:GetPos() +Vector(0,0,99999999),
		filter = ent,
	})
	if tr.Hit && tr.HitSky /*&& !self:IsNightTexture(tr.HitTexture)*/ then
		self.SkyEnt = tr.Entity
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self:SetMaterial("engine/modulatesinglecolor")
	self:SetNPCRenderMode(RENDERMODE_TRANSADD)
	self:SetColor(Color(65,65,65,1))
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:DrawShadow(false)
	if IsValid(self.Ball) then
		self.Ball:SetPos(LerpVector(0.4,self.Ball:GetPos(),self:GetPos() +self:OBBCenter()))
	end
	if self:IsUnderSky(self) then
		self:TakeDamage(1,self.SkyEnt)
	end
	if (self:SCP_CanBeSeen() && self:FindFlashlights()) then
		self:SetPlaybackRate(0)
		self.CanChaseEnemy = false
		self:SetMaxYawSpeed(0)
		if self:IsMoving() then
			self:StopProcessing()
		end
		-- self:SetRenderFX(kRenderFxNone)
		-- self.Ball:SetRenderFX(kRenderFxNone)
		-- self:SetMovementType(MOVETYPE_NONE)
	else
		self.CanChaseEnemy = true
		self:SetMaxYawSpeed(25)
		-- self:SetRenderFX(kRenderFxHologram)
		-- self.Ball:SetRenderFX(kRenderFxHologram)
		-- self:SetMovementType(MOVETYPE_STEP)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if (self:SCP_CanBeSeen() && self:FindFlashlights()) then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:StopCompletely()
	self:PlayAnimation("Attack",2)
	self.IsAttacking = true
	self:AttackFinish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if(disp == D_HT) then
		if nearest <= self.MeleeAttackDistance && self:FindInCone(enemy,self.MeleeAngle) then
			self:DoAttack()
		end
		if self:CanPerformProcess() then
			if (self:SCP_CanBeSeen() && self:FindFlashlights()) then self:SetPoseParameter("move_yaw",0) return end
			if self:IsUnderSky(enemy) then return end
			self:ChaseEnemy()
		end
	end
end