if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/372.mdl"}
ENT.StartHealth = 300
ENT.CanMutate = false
ENT.CollisionBounds = Vector(18,18,50)
ENT.FlyUpOnSpawn = false
ENT.FlySpeed = 1300
ENT.DeathRagdollType = "prop_physics"

ENT.MeleeAttackDistance = 90
ENT.MeleeAttackDamageDistance = 90
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 10
ENT.MeleeAttackHitTime = 0.1

ENT.Faction = "FACTION_NONE"

ENT.BloodEffect = {"blood_impact_white"}

ENT.tbl_Sounds = {
	["Idle"] = {"cpthazama/scp/372/Rustle0.wav","cpthazama/scp/372/Rustle1.wav","cpthazama/scp/372/Rustle2.wav"},
}

ENT.IdleSoundChanceA = 4
ENT.IdleSoundChanceB = 7
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_FLY)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self:SetLocalVelocity(Vector(math.Rand(-self.FlySpeed,self.FlySpeed),math.Rand(-self.FlySpeed,self.FlySpeed),math.Rand(-self.FlySpeed,self.FlySpeed)))
	self:SetAngles(Angle(math.Rand(-360,360),math.Rand(-360,360),0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if !self.IsPossessed && (IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:StopCompletely()
	self:PlayAnimation("Attack",2)
	self:PlaySound("Attack")
	self.IsAttacking = true
	timer.Simple(self.MeleeAttackHitTime,function()
		if self:IsValid() then
			self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
		end
	end)
	self:AttackFinish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules_Fly(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if disp == D_HT then
		if nearest <= 70 && self:FindInCone(enemy,self.MeleeAngle) then
			self:DoAttack()
		end
	end
end