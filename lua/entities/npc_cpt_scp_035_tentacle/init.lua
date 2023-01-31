if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/035_tentacle.mdl"}
ENT.StartHealth = 500
ENT.CanMutate = false
ENT.CollisionBounds = Vector(10,10,70)
ENT.CanWander = false
ENT.WanderChance = 0

ENT.BloodEffect = {"blood_impact_black"}

ENT.MeleeAttackDistance = 100
ENT.MeleeAttackDamageDistance = 180
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 20

ENT.Faction = "FACTION_SCP"

ENT.tbl_Animations = {
	["Attack"] = {ACT_MELEE_ATTACK1},
}
// npc_create npc_cpt_scp_035_tentacle
ENT.tbl_Sounds = {
	["Attack"] = {"cpthazama/scp/035_tentacle/TentacleAttack1.mp3","cpthazama/scp/035_tentacle/TentacleAttack2.mp3"},
	["Idle"] = {"cpthazama/scp/035_tentacle/Whispers1.mp3"},
}

ENT.IdleSoundVolume = 50
ENT.IdleSoundChanceA = 14
ENT.IdleSoundChanceB = 14
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_NONE)
	self.IdleLoop = CreateSound(self,"cpthazama/scp/035_tentacle/TentacleIdle.mp3")
	self.IdleLoop:SetSoundLevel(75)
	self.NextIdleLoopT = 0
	self:SetNoDraw(true)
	timer.Simple(0.02,function()
		if IsValid(self) then
			self:SetNoDraw(false)
			self:EmitSound(Sound("cpthazama/scp/035_tentacle/TentacleSpawn.mp3"),75,100)
			self:CPT_PlaySequence("rise",1)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if CurTime() > self.NextIdleLoopT then
		self.IdleLoop:Stop()
		self.IdleLoop:Play()
		self.NextIdleLoopT = CurTime() +6
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmg,dmginfo,hitbox)
	for i = 0,self:GetBoneCount() -1 do
		CPT_ParticleEffect("blood_impact_black",self:GetBonePosition(i),Angle(0,0,0),nil)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleLoop:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:CPT_StopCompletely()
	self:CPT_PlayAnimation("Attack")
	self.IsAttacking = true
	timer.Simple(0.3,function()
		if self:IsValid() then
			self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
		end
	end)
	self:CPT_AttackFinish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if(disp == D_HT) then
		self:SetAngles(Angle(0,(enemy:GetPos() -self:GetPos()):Angle().y,0))
		if nearest <= self.MeleeAttackDistance && self:CPT_FindInCone(enemy,self.MeleeAngle) then
			self:DoAttack()
		end
	end
end