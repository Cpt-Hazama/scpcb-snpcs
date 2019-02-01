if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scpiso/173.mdl"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSeen()
	if GetConVarNumber("ai_ignoreplayers") == 1 then return end
	if self.IsContained then return end
	if CurTime() > self.NextAlertSoundShitT then
		-- self:PlaySound("Horror",100)
		for _,v in ipairs(self:SCP_CanBeSeenData()) do
			if IsValid(v) then
				v:EmitSound(self:SelectFromTable(self.tbl_Sounds["Horror"]),0.2,100)
			end
		end
		self.NextAlertSoundShitT = CurTime() +5
	end
	local tblIdle = {
		"scare1",
		"scare2",
		"scare3",
		"idle",
	}
	self:SetIdleAnimation(self:SelectFromTable(tblIdle))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self.IsContained then return end
	if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then return end
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:StopCompletely()
	self:PlayAnimation("Attack")
	self.IsAttacking = true
	self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
	self:AttackFinish()
end