if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/682.mdl"}
ENT.StartHealth = 5000000
ENT.CollisionBounds = Vector(150,150,120)

ENT.Faction = "FACTION_SCP_682"

ENT.MeleeAttackDistance = 120
ENT.MeleeAttackDamageDistance = 270
ENT.MeleeAttackType = DMG_CRUSH
ENT.MeleeAttackDamage = 250
ENT.MutationAttackChance = 10

ENT.BloodEffect = {"blood_impact_red"}
ENT.BloodDecal = {"Blood"}
ENT.HasFlinchAnimation = true
ENT.FlinchChance = 30

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Pain"] = {ACT_BIG_FLINCH},
	["Attack"] = {ACT_MELEE_ATTACK1},
	["Roar"] = {ACT_RANGE_ATTACK1},
}

ENT.tbl_Sounds = {
	["FootStep"] = {"cpthazama/scp/682/682 Footstep.mp3"},
	["Attack"] = {
		"cpthazama/scp/682/Roar 1.mp3",
		"cpthazama/scp/682/Roar 2.mp3",
		"cpthazama/scp/682/Roar 3.mp3",
		"cpthazama/scp/682/Roar.mp3",
	},
	["Pain"] = {"cpthazama/scp/682/Roar 4.mp3"},
	["Roar"] = {"cpthazama/scp/682/Louad Roar.mp3"},
	["Idle"] = {
		"cpthazama/scp/682/Sniffs (1).mp3",
		"cpthazama/scp/682/Sniffs (2).mp3",
		"cpthazama/scp/682/Sniffs (3).mp3",
		"cpthazama/scp/682/Sniffs (4).mp3",
		"cpthazama/scp/682/Sniffs (5).mp3",
		"cpthazama/scp/682/Sniffs (6).mp3",
		"cpthazama/scp/682/Sniffs (7).mp3",
	},
	["Strike"] = {"cpthazama/scp/D9341/Damage3.mp3"},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_LARGE)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.NextAlarmT = 0
	self.NextDoorT = 0
	if GetConVarNumber("cpt_scp_682audio") == 1 then
		for _,v in ipairs(player.GetAll()) do
			v:SendLua("surface.PlaySound('cpthazama/scp/682/anoucement.mp3')")
		end
	end
	-- self:SetCollisionBounds(Vector(250,40,120),-(Vector(220,40,0)))
	self.NextHealT = 0
	self.tbl_Reduce = {
		[DMG_GENERIC] = 0,
		[DMG_CRUSH] = 0,
		[DMG_BULLET] = 0,
		[DMG_SLASH] = 0,
		[DMG_BURN] = 0,
		[DMG_VEHICLE] = 0,
		[DMG_FALL] = 0,
		[DMG_BLAST] = 0,
		[DMG_CLUB] = 0,
		[DMG_SHOCK] = 0,
		[DMG_SONIC] = 0,
		[DMG_ENERGYBEAM] = 0,
		[DMG_PREVENT_PHYSICS_FORCE] = 0,
		[DMG_NEVERGIB] = 0,
		[DMG_ALWAYSGIB] = 0,
		[DMG_DROWN] = 0,
		[DMG_PARALYZE] = 0,
		[DMG_NERVEGAS] = 0,
		[DMG_POISON] = 0,
		[DMG_RADIATION] = 0,
		[DMG_DROWNRECOVER] = 0,
		[DMG_ACID] = 0,
		[DMG_SLOWBURN] = 0,
		[DMG_REMOVENORAGDOLL] = 0,
		[DMG_PHYSGUN] = 0,
		[DMG_PLASMA] = 0,
		[DMG_AIRBOAT] = 0,
		[DMG_DISSOLVE] = 0,
		[DMG_BLAST_SURFACE] = 0,
		[DMG_DIRECT] = 0,
		[DMG_BUCKSHOT] = 0,
		[DMG_SNIPER] = 0,
		[DMG_MISSILEDEFENSE] = 0,
	}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "roar") then
		self:CPT_PlaySound("Roar",125,100,140)
		util.ShakeWorld(self:GetPos(),16,4,4000,false)
		return true
	end
	if(event == "rattack") then
		for i=1,math.random(8,14) do
			local spit = ents.Create(self.MutationAttack)
			spit:SetPos(self:GetPos() +self:OBBCenter() +self:GetForward() *230 +self:GetUp() *20)
			spit:SetAngles(Angle(math.random(0,360),math.random(0,360),math.random(0,360)))
			spit:SetOwner(self)
			spit:Spawn()
			spit:Activate()
			local phys = spit:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(Vector(math.Rand(-350,350),math.Rand(-350,350),math.Rand(-350,350)) *2 +self:GetUp() *800)
			end
		end
		return true
	end
	if(event == "mattack") then
		self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
		return true
	end
	if(event == "emit") then
		if arg1 == "step" then
			self:CPT_PlaySound("FootStep",90,90,100,true)
			util.ShakeWorld(self:GetPos(),12,1,800,false)
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink_Disabled()
	-- self:PlayerChat(self:Health())
	if self:Health() < self:GetMaxHealth() && CurTime() > self.NextHealT then
		self:SetHealth(self:Health() +1)
		if self:Health() > self:GetMaxHealth() then
			self:SetHealth(self:GetMaxHealth())
		end
		self.NextHealT = CurTime() +0.1
	end
	if GetConVarNumber("cpt_scp_682audio") == 1 && CurTime() > self.NextAlarmT then
		for _,v in ipairs(player.GetAll()) do
			v:SendLua("surface.PlaySound('cpthazama/scp/682/Alarm verb.mp3')")
		end
		self.NextAlarmT = CurTime() +2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if util.IsSCPMap() then
		if CurTime() > self.NextDoorT then
			for _,v in ipairs(ents.FindInSphere(self:GetPos(),SCP_DoorOpenDistance)) do
				if v:IsValid() && v:GetClass() == "func_door" /*&& v:GetSequenceName(v:GetSequence()) == "idle"*/ then
					CPT_ParticleEffect("door_pound_core",v:GetPos() +v:OBBCenter(),Angle(0,0,0),nil)
					v:Remove()
				end
			end
			self.NextDoorT = CurTime() +math.Rand(1,3)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakePain(dmg,dmginfo,hitbox)
	local damage = dmg:GetDamage()
	local dtype = dmg:GetDamageType()
	local tb = self.tbl_Reduce[dtype]
	if tb == nil then return end
	self.tbl_Reduce[dtype] = self.tbl_Reduce[dtype] +0.05
	if tb >= 20 && math.random(1,self.MutationAttackChance) == 1 then
		if dtype == DMG_BURN || dtype == DMG_BLAST then
			self:CPT_PlayAnimation("Roar")
			self.MutationAttack = "obj_cpt_scp_flame"
		end
		if dtype == DMG_POISON || dtype == DMG_RADIATION || dtype == DMG_NERVEGAS || dtype == DMG_ACID then
			self:CPT_PlayAnimation("Roar")
			self.MutationAttack = "obj_cpt_scp_poisongas"
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmg,dmginfo,hitbox)
	self:SetModelScale(self:GetModelScale() +0.01,0)
	self.MeleeAttackDistance = self.MeleeAttackDistance +0.01
	self.MeleeAttackDamageDistance = self.MeleeAttackDamageDistance +0.01
	self.MeleeAttackDamage = self.MeleeAttackDamage +5
	-- if math.random(1,2) == 1 then self.FlinchChance = self.FlinchChance +1 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChangeDamageOnHit(dmg,hitbox)
	local damage = dmg:GetDamage()
	local dtype = dmg:GetDamageType()
	local tb = self.tbl_Reduce[dtype]
	if tb == nil then return dmg:GetDamage() end
	local rnd = math.Round(damage -self.tbl_Reduce[dtype])
	if rnd <= 0 then rnd = 1 end
	return rnd
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:CPT_StopCompletely()
	self:CPT_PlaySound("Attack",90)
	self:CPT_PlayAnimation("Attack")
	self.IsAttacking = true
	self:CPT_AttackFinish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if(disp == D_HT) then
		if nearest <= self.MeleeAttackDistance && self:CPT_FindInCone(enemy,self.MeleeAngle) then
			self:DoAttack()
		end
		if self:CanPerformProcess() then
			self:ChaseEnemy()
		end
	end
end