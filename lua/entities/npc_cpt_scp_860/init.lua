if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/860.mdl"}
ENT.StartHealth = 2500
ENT.CanMutate = false
ENT.CollisionBounds = Vector(35,58,70)

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 30
ENT.MeleeAttackDamageDistance = 120
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 34

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["Alert"] = {
		"cpthazama/scp/860/Cancer0.wav",
		"cpthazama/scp/860/Cancer1.wav",
		"cpthazama/scp/860/Cancer2.wav",
		"cpthazama/scp/860/Cancer3.wav",
		"cpthazama/scp/860/Cancer4.wav",
		"cpthazama/scp/860/Cancer5.wav",
	},
	["Horror"] = {"cpthazama/scp/860/Chase1.wav","cpthazama/scp/860/Chase2.wav"},
	["Strike"] = {"cpthazama/scp/D9341/Damage4.wav"},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.WasSeen = false
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSeen()
	self:PlaySound("Horror",100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then
		if self.WasSeen == false then
			self:OnSeen()
			self.WasSeen = true
		end
	else
		self.WasSeen = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:StopCompletely()
	self:PlayAnimation("Attack")
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