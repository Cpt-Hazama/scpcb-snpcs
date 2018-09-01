if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/513-1.mdl"}
ENT.StartHealth = 300
ENT.CanMutate = false
ENT.CollisionBounds = Vector(13,13,70)
ENT.CanWander = false
ENT.WanderChance = 0

ENT.Faction = "FACTION_NONE"
ENT.IsEssential = true
ENT.Bleeds = false
ENT.TurnsOnDamage = false

ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 60
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 20

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["Idle"] = {"cpthazama/scp/513/Bell1.mp3","cpthazama/scp/513/Bell2.mp3","cpthazama/scp/513/Bell3.mp3"},
	["Alert"] = {"cpthazama/scp/513/Bell1.mp3","cpthazama/scp/513/Bell2.mp3","cpthazama/scp/513/Bell3.mp3"},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}

ENT.IdleSoundVolume = 100
ENT.IdleSoundChanceA = 8
ENT.IdleSoundChanceB = 10
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self:DrawShadow(false)
	-- if self.BellToucher == nil then
		-- local tbl = {}
		-- for _,v in ipairs(player.GetAll()) do
			-- if v:IsValid() && self.BellToucher == nil && v.SCP_Has714 == false then
				-- table.insert(tbl,v)
				-- self.WanderChance = 0
			-- end
		-- end
		-- self.BellToucher = self:SelectFromTable(tbl)
	-- end
	self.NextDamageT = 0
	self.NextTeleportT = 0
	timer.Simple(GetConVarNumber("cpt_scp_513effectstime"),function()
		if self:IsValid() then
			self:Remove()
		end
	end)
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
function ENT:Teleport(ent)
	self:SetClearPos(ent:GetPos() +ent:GetForward() *70)
	-- self:PlaySound("Alert",100)
	sound.Play("cpthazama/scp/513/Bell" .. math.random(1,3) .. ".mp3",ent:GetPos(),180,100)
	ent:TakeDamage(15,self)
	util.ShakeWorld(ent:GetPos(),16,3,100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	if self.BellToucher != nil && self.BellToucher != NULL then
		if CurTime() > self.NextDamageT then
			self.BellToucher:TakeDamage(1,self)
			self.NextDamageT = CurTime() +5
		end
		local dist = self:GetClosestPoint(self.BellToucher)
		if dist >= 150 && dist <= 1000 then
			self:ChaseTarget(self.BellToucher,false)
		elseif dist > 1000 then
			self:Teleport(self.BellToucher)
		elseif dist < 150 then
			self:StopMoving()
			self:FaceTarget(self.BellToucher)
		end
		if CurTime() > self.NextTeleportT then
			self:Teleport(self.BellToucher)
			self.NextTeleportT = CurTime() +math.Rand(8,15)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end