if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/457.mdl"}
ENT.StartHealth = 1000
ENT.CollisionBounds = Vector(16,16,75)
ENT.IsEssential = true
ENT.CanGrow = false

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 60
ENT.MeleeAttackType = DMG_BURN
ENT.MeleeAttackDamage = 15

ENT.Bleeds = false

ENT.tbl_ImmuneTypes = {DMG_BURN,DMG_PARALYZE,DMG_NERVEGAS,DMG_POISON,DMG_DIRECT}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_WALK},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["FootStep"] = {"ambient/fire/mtov_flame2.wav"},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.NextDoorT = 0
	self.NextTeleportT = 0
	self.P_NextTeleportT = 0
	self.NextFireTrailT = 0
	self.tbl_FireTrails = {}
	self.IdleLoop = CreateSound(self,"ambient/fire/firebig.wav")
	self.IdleLoop:SetSoundLevel(68)
	self.NextIdleLoopT = 0
	self.IdleSpeakLoop = CreateSound(self,"cpthazama/scp/457/speakloop.mp3")
	self.IdleSpeakLoop:SetSoundLevel(75)
	self.NextIdleSpeakLoopT = 0
	self.HasFinishedGrowing = false
	self.IsMaxSize = false
	for i = 1,5 do
		local ent = ents.Create("env_fire")
		ent:SetPos(self:GetPos())
		ent:SetKeyValue("health",0)
		ent:SetKeyValue("size",40)
		ent:SetKeyValue("spawnflags",142)
		ent:Spawn()
		ent:Activate()
		self:DeleteOnRemove(ent)
		self.tbl_FireTrails[i] = ent
	end
	self:SetModelScale(0.3,0)
	self:SetModelScale(1,15)
	self.GlowLight = ents.Create("light_dynamic")
	self.GlowLight:SetKeyValue("_light","255 93 0 200")
	self.GlowLight:SetKeyValue("brightness","2")
	self.GlowLight:SetKeyValue("distance","400")
	self.GlowLight:SetKeyValue("style","0")
	self.GlowLight:SetPos(self:GetPos() +self:OBBCenter() +Vector(0,0,15))
	self.GlowLight:SetParent(self)
	self.GlowLight:Spawn()
	self.GlowLight:Activate()
	self.GlowLight:Fire("TurnOn","",0)
	self.GlowLight:DeleteOnRemove(self)
	timer.Simple(8.5,function()
		if IsValid(self) then
			for i = 1,math.random(2,3) do
				ParticleEffectAttach("env_fire_medium",PATTACH_ABSORIGIN_FOLLOW,self,0)
			end
			if IsValid(self.GlowLight) then
				self.GlowLight:SetKeyValue("brightness","4")
				self.GlowLight:SetKeyValue("distance","600")
				self:EmitSound("ambient/fire/gascan_ignite1.wav",80,100)
			end
		end
	end)
	timer.Simple(15,function()
		if IsValid(self) then
			self.HasFinishedGrowing = true
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BeforeTakeDamage(dmg,hitbox)
	if dmg:GetAttacker():GetClass() == "env_fire" then
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "mattack") then
		self:DoDamage(self.MeleeAttackDamageDistance *self:GetModelScale(),self.MeleeAttackDamage *self:GetModelScale(),self.MeleeAttackType)
		return true
	end
	if(event == "emit") then
		if(arg1 == "step_left") then
			if self:IsOnGround() then
				self:CPT_PlaySound("FootStep",75,90,100,true)
				local tr = util.TraceLine({
					start = self:GetBonePosition(11),
					endpos = self:GetBonePosition(11) -Vector(0,0,10),
					filter = self,
					mask = MASK_NPCWORLDSTATIC
				})
				if tr.Hit then
					local ent = ents.Create("env_fire")
					ent:SetPos(tr.HitPos)
					ent:SetKeyValue("health",0)
					ent:SetKeyValue("size",5)
					ent:SetKeyValue("spawnflags",142)
					ent:Spawn()
					ent:Activate()
					timer.Simple(12,function()
						if IsValid(ent) then
							ent:Remove()
						end
					end)
				end
			end
		elseif(arg1 == "step_right") then
			if self:IsOnGround() then
				self:CPT_PlaySound("FootStep",75,90,100,true)
				local tr = util.TraceLine({
					start = self:GetBonePosition(7),
					endpos = self:GetBonePosition(7) -Vector(0,0,10),
					filter = self,
					mask = MASK_NPCWORLDSTATIC
				})
				if tr.Hit then
					local ent = ents.Create("env_fire")
					ent:SetPos(tr.HitPos)
					ent:SetKeyValue("health",0)
					ent:SetKeyValue("size",5)
					ent:SetKeyValue("spawnflags",142)
					ent:Spawn()
					ent:Activate()
					timer.Simple(12,function()
						if IsValid(ent) then
							ent:Remove()
						end
					end)
				end
			end
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.CanGrow then
		if self:GetModelScale() >= 2 && self.IsMaxSize == false then
			for i = 1,2 do
				ParticleEffectAttach("env_fire_large",PATTACH_ABSORIGIN_FOLLOW,self,1)
			end
			self.IsMaxSize = true
		end
		if self:GetModelScale() <= 2 then
			self:SetCollisionBounds(Vector(16 *self:GetModelScale(),16 *self:GetModelScale(),75 *self:GetModelScale()),-(Vector(16 *self:GetModelScale(),16 *self:GetModelScale(),0)))
		end
	end
	if CurTime() > self.NextIdleLoopT then
		self.IdleLoop:Stop()
		self.IdleLoop:Play()
		self.NextIdleLoopT = CurTime() +6
	end
	if CurTime() > self.NextIdleSpeakLoopT then
		self.IdleSpeakLoop:Stop()
		self.IdleSpeakLoop:Play()
		self.NextIdleSpeakLoopT = CurTime() +76
	end
	if util.IsSCPMap() then
		if CurTime() > self.NextDoorT then
			for _,v in ipairs(ents.FindInSphere(self:GetPos(),SCP_DoorOpenDistance)) do
				if v:IsValid() && v:GetClass() == "func_door" /*&& v:GetSequenceName(v:GetSequence()) == "idle"*/ then
					v:Fire("Open")
				end
			end
			self.NextDoorT = CurTime() +math.Rand(1,3)
		end
	end
	if CurTime() > self.NextFireTrailT && self:OnGround() then
		self.NextFireTrailT = CurTime() +0.1
		local pos = self:GetPos()
		local tr = util.TraceLine({
			start = pos,
			endpos = pos -Vector(0,0,5),
			filter = self,
			mask = MASK_NPCWORLDSTATIC
		})
		for i = 5, 2, -1 do
			if(self.tbl_FireTrails[i]:IsValid() && self.tbl_FireTrails[i -1]:IsValid()) then
				self.tbl_FireTrails[i]:SetPos(self.tbl_FireTrails[i -1]:GetPos())
			end
		end
		self.tbl_FireTrails[1]:SetPos(tr.HitPos)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnHitEntity(hitents,hitpos)
	if self.tbl_Sounds["Strike"] == nil then
		self:EmitSound("npc/zombie/claw_strike" .. math.random(1,3) .. ".wav",55,100)
	else
		self:EmitSound(self:SelectFromTable(self.tbl_Sounds["Strike"]),55,100)
	end
	for _,v in ipairs(hitents) do
		if v:IsValid() then
			v:Ignite(4,30)
		end
	end
	if self.CanGrow then
		if self.HasFinishedGrowing == true then
			if self:GetModelScale() <= 2 then
				self:SetModelScale(self:GetModelScale() +0.1,0.2)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleLoop:Stop()
	self.IdleSpeakLoop:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:CPT_StopCompletely()
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