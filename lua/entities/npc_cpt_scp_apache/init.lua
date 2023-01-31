if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/apache.mdl"}
ENT.StartHealth = 400
ENT.CollisionBounds = Vector(75,75,350)

ENT.Faction = "FACTION_SCP_NTF"

ENT.HasDeathRagdoll = false
ENT.Possessor_CanBePossessed = false

ENT.GunAttackDistance = 4000
ENT.RangeAttackDistance = 5000
ENT.RangeAttackDamageDistance = 60
ENT.RangeAttackDamage = 15

ENT.Bleeds = false
ENT.HasDeathAnimation = true

ENT.tbl_Animations = {
	["Death"] = {"death"},
}

ENT.tbl_Sounds = {
	["Idle"] = {"common/null.wav"},
	["Fire"] = {"cpthazama/scp/Gunshot2.mp3"},
	["Rocket"] = {"weapons/rpg/rocketfire1.wav"},
	["Pain"] = {"npc/attack_helicopter/aheli_crash_alert2.wav"},
	["Death"] = {"npc/attack_helicopter/aheli_damaged_alarm1.wav"},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HoverAI_Stop()
	self:SetLocalVelocity(LerpVector(0.1,self:GetVelocity(),Vector(0,0,0)))
	self:SetPoseParameter("move_yaw",Lerp(0.2,self:GetPoseParameter("move_yaw"),0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HoverAI_DoFlightPath(pos,reverse)
	local GoToPos = self:GetPos()
	local selectedpos = pos
	if reverse then
		GoToPos = (selectedpos):GetNormal() *self:GetFlySpeed()
		self:SetPoseParameter("move_yaw",Lerp(0.2,self:GetPoseParameter("move_yaw"),-180))
	else
		GoToPos = (selectedpos -self:GetPos()):GetNormal() *self:GetFlySpeed()
		self:SetPoseParameter("move_yaw",Lerp(0.2,self:GetPoseParameter("move_yaw"),0))
	end
	self:SetLocalVelocity(GoToPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleFlying_HoverAI(enemy,dist,nearest)
	-- local pos = self:GetPos() +self:OBBCenter()
	-- local tr = util.TraceHull({
		-- start = pos,
		-- endpos = enemy:GetPos() +enemy:OBBCenter() +enemy:GetUp() *20,
		-- filter = self,
		-- mins = self:OBBMins(),
		-- maxs = self:OBBMaxs()
	-- })
	-- if (tr.Hit) then
		-- local fly = (util.RandomVectorAroundPos(tr.HitPos,self.FlyRandomDistance) -self:GetPos() +self:GetVelocity() *30):GetNormal() *self:GetFlySpeed()
		-- self:SetAngles(LerpAngle(0.5,self:GetAngles(),Angle(0,(self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().y,0)))
		-- self:SetLocalVelocity(fly)
	-- end
	-- self:SetAngles(LerpAngle(0.5,self:GetAngles(),Angle(0,(self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().y,(self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().r)))
	local xang = (self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().x
	if xang > 34 then
		self:SetAngles(LerpAngle(0.5,self:GetAngles(),Angle(0,(self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().y,(self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().r)))
	else
		self:SetAngles(LerpAngle(0.5,self:GetAngles(),Angle((self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().x,(self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().y,(self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().r)))
	end
	-- print((self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().x)
	local movecloserDist = 2500
	local movefartherDist = 760
	local GoToPos = self:GetPos()
	if nearest > movecloserDist && enemy:Visible(self) then
		self:HoverAI_DoFlightPath(enemy:GetPos() +enemy:GetUp() *(self.Height),false)
	elseif nearest <= movecloserDist && nearest > movefartherDist then
		if CurTime() < self.NextMoveAroundT then
			self:HoverAI_Stop()
		end
		if CurTime() > self.NextMoveAroundT && math.random(1,50) == 1 then
			self:HoverAI_DoFlightPath(self:GetPos() +self:GetRight() *math.Rand(-1500,1500) +self:GetUp() *(self.Height),false)
			self.NextMoveAroundT = CurTime() +3
		end
	elseif nearest <= movefartherDist then
		self:HoverAI_DoFlightPath(self:GetPos() -enemy:GetPos(),true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_LARGE)
	self:SetFlySpeed(800)
	self:SetMovementType(MOVETYPE_FLY,true)
	self.IsGunAttacking = false
	self.IsRangeAttacking = false
	self.IdleLoop = CreateSound(self,"cpthazama/scp/apache_idle.mp3")
	self.IdleLoop:SetSoundLevel(110)
	self.NextMoveAroundT = 0
	self.NextIdleLoopT = 0
	self.NextFireT = 0
	self.LastMissile = 1
	self.Height = 500
	self.NextHeightT = CurTime() +math.Rand(5,10)
	self.NextMissileT = CurTime() +math.Rand(1,2)
	self:SetCollisionBounds(Vector(33,33,26),Vector(-33,-33,-30))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink_Disabled()
	if CurTime() > self.NextIdleLoopT then
		self.IdleLoop:Stop()
		self.IdleLoop:Play()
		-- self.NextIdleLoopT = CurTime() +SoundDuration("npc/attack_helicopter/aheli_rotor_loop1.wav")
		self.NextIdleLoopT = CurTime() +2.8
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleLoop:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.IsPossessed == false && !IsValid(self:GetEnemy()) && (self.IsStartingUp == false or self:GetVelocity():Length() < 10) then
		self:HoverAI_Stop()
	end
	if !self.IsPossessed then
		local tr = util.TraceHull({
			start = self:GetPos(),
			endpos = self:GetPos() +self:GetUp() *-self.Height /5,
			filter = self,
			mins = self:OBBMins(),
			maxs = self:OBBMaxs()
		})
		if tr.Hit && !self.IsStartingUp then
			self:HoverAI_DoFlightPath(self:GetPos() +self:GetUp() *(self.Height /7 +50),false)
		end
	end
	if CurTime() > self.NextHeightT then
		self.Height = math.random(300,700)
		self.NextHeightT = CurTime() +math.Rand(5,10)
	end
	self:SetIdleAnimation(ACT_FLY)
	self:SetPlaybackRate(4)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Jump(possessor)
	self:HoverAI_Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if CurTime() > self.NextMissileT then
		self:CPT_PlaySound("Rocket",95)
		self.IsRangeAttacking = true
		local pos
		if self.LastMissile == 1 then
			pos = "Hydra70_A"
			self.LastMissile = 2
		else
			pos = "Hydra70_B"
			self.LastMissile = 1
		end
		local rattack = ents.Create("obj_cpt_rocket")
		rattack:SetPos(self:GetAttachment(self:LookupAttachment(pos)).Pos)
		rattack:SetAngles(Angle((self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().x,(self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().y,(self:CPT_FindCenter(self:GetEnemy()) -self:CPT_FindCenter(self)):Angle().r))
		rattack:SetOwner(self)
		rattack:Spawn()
		rattack:Activate()
		local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetOrigin(rattack:GetPos())
		effectdata:SetNormal(rattack:GetForward())
		effectdata:SetAttachment(self:LookupAttachment(pos))
		util.Effect("cpt_muzzle",effectdata)
		
		local phys = rattack:GetPhysicsObject()
		if IsValid(phys) then
			-- phys:SetVelocity(self:SetUpRangeAttackTarget() *1 +self:GetForward() *1500 +self:GetUp() *-450 +self:GetRight() *math.Rand(-40,40))
			phys:SetVelocity(self:SetUpRangeAttackTarget() *50 +self:GetRight() *math.Rand(-40,40))
		end
		timer.Simple(0.5,function()
			if IsValid(self) then
				self.IsRangeAttacking = false
			end
		end)
		self.NextMissileT = CurTime() +math.Rand(0.5,5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoRangeAttack()
	if self:CanPerformProcess() == false then return end
	local spread = 10
	if CurTime() > self.NextFireT then
		local muzzle = self:GetAttachment(self:LookupAttachment("M230E1"))
		local bullet = {}
		bullet.Num = 1
		bullet.Src = muzzle.Pos
		if self.IsPossessed then
			bullet.Dir = self:Possess_AimTarget() -muzzle.Pos +Vector(math.Rand(-spread,spread),math.Rand(-spread,spread),math.Rand(-spread,spread))
		else
			if !IsValid(self:GetEnemy()) then return true end
			bullet.Dir = (self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()) -muzzle.Pos +Vector(math.Rand(-spread,spread),math.Rand(-spread,spread),math.Rand(-spread,spread))
		end
		bullet.Spread = spread
		bullet.Tracer = 1
		bullet.TracerName = "cpt_tracer"
		bullet.Force = 7
		bullet.Damage = 13
		bullet.AmmoType = "SMG"
		self:FireBullets(bullet)
		self:CPT_SoundCreate(self:SelectFromTable(self.tbl_Sounds["Fire"]),95)
		local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetOrigin(muzzle.Pos)
		effectdata:SetNormal(bullet.Dir)
		effectdata:SetAttachment(self:LookupAttachment("M230E1"))
		util.Effect("cpt_muzzle",effectdata)
		self.NextFireT = CurTime() +0.001
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakePain(dmg,dmginfo,hitbox)
	if !dmg:IsBulletDamage() then
		if CurTime() > self.NextMoveAroundT && math.random(1,2) == 1 then
			self:HoverAI_DoFlightPath(self:GetPos() +self:GetRight() *math.Rand(-1500,1500) +self:GetUp() *(self.Height),false)
			self.NextMoveAroundT = CurTime() +3
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChangeDamageOnHit(dmg,hitbox)
	if dmg:IsBulletDamage() then
		return math.random(1,3)
	else
		return dmg:GetDamage()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmg,dmginfo,hitbox)
	util.CreateCustomExplosion(self:GetPos(),150,300,self)
	timer.Simple(0.4,function()
		if IsValid(self) then
			util.CreateCustomExplosion(self:GetPos(),150,300,self)
			if SERVER then
				local mdl = ents.Create("prop_ragdoll")
				mdl:SetModel("models/cpthazama/scp/ntf.mdl")
				mdl:SetPos(self:GetPos())
				mdl:SetAngles(self:GetAngles())
				mdl:Spawn()
				mdl:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				mdl:SetBodygroup(1,1)
				mdl:Ignite(8,2)
				local phys = mdl:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(mdl:GetVelocity() *30 +mdl:GetUp() *math.Rand(500,1200) +mdl:GetForward() *math.Rand(-400,400))
				end
			end
			self:WhenRemoved()
			self:Remove()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules_Fly(enemy,dist,nearest,disp)
	if self.IsPossessed == true then return end
	if self.IsStartingUp == true then
		self.IsStartingUp = false
		self:HoverAI_Stop()
	end
	if(disp == D_HT) then
		self:HandleFlying_HoverAI(enemy,dist,nearest)
		if nearest <= self.RangeAttackDistance && enemy:Visible(self) then
			self:DoAttack()
		end
		if nearest <= self.GunAttackDistance && enemy:Visible(self) then
			self:DoRangeAttack()
		end
	end
end