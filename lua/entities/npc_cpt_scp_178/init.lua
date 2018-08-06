if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/178.mdl"}
ENT.StartHealth = 200
ENT.ViewDistance = 80
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CollisionBounds = Vector(18,18,70)

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 60
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 30

ENT.Bleeds = false
ENT.IsEssential = true

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetModelScale(0.9,0)
	self.IsAttacking = false
	self.IsStarter = false
	self.NextThemeT = 0
	local allnpcs = {}
	for _,v in ipairs(ents.GetAll()) do
		if v:IsValid() && v:IsNPC() && v != self && v:GetClass() == self:GetClass() then
			table.insert(allnpcs,v)
		end
	end
	if table.Count(allnpcs) == 0 then
		self.IsStarter = true
	end
	self:DrawShadow(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "mattack") then
		self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
		return true
	end
	if(event == "emit") then
		if arg1 == "step" then
			self:PlaySound("FootStep",90,90,100,true)
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.IsStarter && CurTime() > self.NextThemeT then
		for _,v in ipairs(player.GetAll()) do
			v:SendLua("surface.PlaySound('cpthazama/scp/music/178.wav')")
		end
		self.NextThemeT = CurTime() +17
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
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
			self:ChaseEnemy()
		end
	end
end