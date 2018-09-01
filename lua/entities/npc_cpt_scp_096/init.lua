if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/096.mdl"}
ENT.StartHealth = 5000
ENT.CanMutate = false
ENT.CollisionBounds = Vector(30,18,90)
ENT.CanChaseEnemy = false
ENT.ReactsToSound = false

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 100
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 20

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["Strike"] = {"cpthazama/scp/D9341/Damage4.mp3"},
	["FootStep"] = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav"}
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetMovementType(MOVETYPE_STEP)
	self.CanAttack = false
	self.IsAttacking = false
	self.IdleLoop = CreateSound(self,"cpthazama/scp/music/096.mp3")
	self.IdleLoop:SetSoundLevel(90)
	self.TriggerLoop = CreateSound(self,"cpthazama/scp/music/096Angered.mp3")
	self.TriggerLoop:SetSoundLevel(95)
	self.ChaseLoop = CreateSound(self,"cpthazama/scp/music/096Chase.mp3")
	self.ChaseLoop:SetSoundLevel(110)
	self.NextDoorT = 0
	self.NextCanTriggerT = 0
	self.NextScreamT = 0
	self.NextIdleLT = 0
	self.NextTriggeredLT = 0
	self.NextChaseLT = 0
	self.NextHealT = 0
	self.IsTriggered = false
	self.CanSetEnemy = false
	self.HasReset = true
	self.TriggeredEntity = NULL
	self:SetCollisionBounds(Vector(30,18,90),-(Vector(20,18,0)))
	-- self:SetCollisionBounds(Vector(30,15,60),-(Vector(20,15,0)))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "mattack") then
		if arg1 == "leap" then
			self:DoDamage(self.MeleeAttackDamageDistance,700,self.MeleeAttackType)
		elseif arg1 == "shread" then
			self:DoDamage(self.MeleeAttackDamageDistance,500,self.MeleeAttackType)
		elseif arg1 == "eat" then
			self:DoDamage(self.MeleeAttackDamageDistance,150,self.MeleeAttackType)
		end
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
function ENT:OnHitEntity(hitents,hitpos)
	if self.tbl_Sounds["Strike"] == nil then
		self:EmitSound("npc/zombie/claw_strike" .. math.random(1,3) .. ".wav",55,100)
	else
		self:EmitSound(self:SelectFromTable(self.tbl_Sounds["Strike"]),55,100)
	end
	for _,v in ipairs(hitents) do
		if v:IsValid() && v:IsPlayer() then
			v:Freeze(true)
			timer.Simple(0.5,function() if v:IsValid() then v:Freeze(false) end end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:Health() < self:GetMaxHealth() && CurTime() > self.NextHealT then
		self:SetHealth(self:Health() +50)
		if self:Health() > self:GetMaxHealth() then
			self:SetHealth(self:GetMaxHealth())
		end
		self.NextHealT = CurTime() +5
	end
	if util.IsSCPMap() then
		if CurTime() > self.NextDoorT then
			-- local change = false
			if self.IsTriggered == false then
				for _,v in ipairs(ents.FindInSphere(self:GetPos(),SCP_DoorOpenDistance)) do
					if v:IsValid() && v:GetClass() == "func_door" /*&& v:GetSequenceName(v:GetSequence()) == "idle"*/ then
						v:Fire("Open")
						-- change = true
					end
				end
			elseif self.IsTriggered && self.CanAttack then
				for _,v in ipairs(ents.FindInSphere(self:GetPos(),SCP_DoorOpenDistance +40)) do
					if v:IsValid() && ((v:GetClass() == "prop_dynamic" && v:GetSequenceName(v:GetSequence()) == "idle") || v:GetClass() == "func_door") then
						-- change = true
						-- local finddoors = ents.Create("prop_physics")
						-- finddoors:SetPos(v:GetPos())
						-- finddoors:SetAngles(v:GetAngles())
						-- finddoors:SetModel(v:GetModel())
						-- finddoors:Spawn()
						-- finddoors:Activate()
						-- finddoors:SetModelScale(0.9,0)
						-- if v:GetSkin() != nil then
							-- finddoors:SetSkin(v:GetSkin())
						-- end
						-- finddoors:SetMaterial(v:GetMaterial())
						if v:GetClass() == "prop_dynamic" then
							ParticleEffect("door_pound_core",v:GetPos() +v:OBBCenter(),Angle(0,0,0),nil)
						end
						v:Remove()
						-- if finddoors != nil && finddoors:IsValid() then
							-- finddoors:SetCollisionGroup(COLLISION_GROUP_DEBRIS)	
							-- local finddoors_phys = finddoors:GetPhysicsObject()
							-- finddoors_phys:ApplyForceCenter(((self:GetPos() +self:GetForward() *300) -self:LocalToWorld(Vector(0,-8,20))) *150 +((self:GetPos() +self:GetForward() *300) +self:GetUp() *140))
						-- end
					end
				end
			end
			-- if change == true then
				-- self:SetCollisionBounds(Vector(30,15,60),-(Vector(20,15,0)))
			-- else
				-- self:SetCollisionBounds(Vector(30,20,90),-(Vector(20,20,0)))
			-- end
			self.NextDoorT = CurTime() +math.Rand(1,3)
		end
	end
	if !self.IsPossessed && self.IsAttacking && IsValid(self:GetEnemy()) then
		self:SetAngles(Angle(0,(self:GetEnemy():GetPos() -self:GetPos()):Angle().y,0))
	end
	self:FindFaceLookers()
	self:TriggerConfigure()
	if self.IsPossessed && !self.IsTriggered then
		self.Possessor_CanSprint = false
	elseif self.IsPossessed && self.IsTriggered then
		self.Possessor_CanSprint = true
		self.Possessor_CanMove = false
		if self.CanAttack == false then
			self.Possessor_CanMove = false
		else
			self.Possessor_CanMove = true
		end
	end
	if self.IsTriggered && self.CanAttack == false then
		self.IdleLoop:Stop()
		self.ChaseLoop:Stop()
		if CurTime() > self.NextTriggeredLT then
			self.TriggerLoop:Stop()
			self.TriggerLoop:Play()
			self.NextTriggeredLT = CurTime() +35
		end
	elseif self.IsTriggered && self.CanAttack == true then
		self.IdleLoop:Stop()
		self.TriggerLoop:Stop()
		if CurTime() > self.NextChaseLT then
			self.ChaseLoop:Stop()
			self.ChaseLoop:Play()
			self.NextChaseLT = CurTime() +12
		end
	elseif self.IsTriggered == false then
		self.TriggerLoop:Stop()
		self.ChaseLoop:Stop()
		if CurTime() > self.NextIdleLT then
			self.IdleLoop:Stop()
			self.IdleLoop:Play()
			self.NextIdleLT = CurTime() +34
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TriggerConfigure()
	-- if self.IsTriggered && self.TriggeredEntity == NULL then
		-- self:SetEnemy(NULL)
		-- self.IsTriggered = false
		-- self.TriggeredEntity = NULL
		-- self.CanAttack = false
		-- self.CanChaseEnemy = false
	-- end
	if self.IsTriggered then
		self.tbl_Animations["Run"] = {ACT_RUN}
		self.HasReset = false
		self.CanWander = false
		self:SetIdleAnimation(ACT_RANGE_ATTACK1)
		self.CanSetEnemy = true
		if self.TriggeredEntity != NULL then
			if self.CanAttack then
				self.CanChaseEnemy = true
				self:SetEnemy(self.TriggeredEntity)
				-- if self:GetEnemy() != self.TriggeredEntity then
					-- self:SetEnemy(self.TriggeredEntity)
				-- end
			end
		elseif !IsValid(self.TriggeredEntity) || self.TriggeredEntity == NULL then
			if self.HasReset == false then
				self:ResetTrigger()
			end
		end
		if IsValid(self:GetEnemy()) && self.CanAttack then
			if CurTime() > self.NextScreamT then
				self:EmitSound("cpthazama/scp/096/Scream.mp3",105,100)
				self.NextScreamT = CurTime() +10
			end
		end
	else
		self.tbl_Animations["Run"] = {ACT_WALK}
		self:SetIdleAnimation(ACT_IDLE)
		self.CanWander = true
		if !self.HasReset then
			self:ResetTrigger()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetTrigger()
	self:SetEnemy(NULL)
	self.NextCanTriggerT = CurTime() +10
	self.IsTriggered = false
	self.TriggeredEntity = NULL
	self.CanAttack = false
	self.CanChaseEnemy = false
	self.CanSetEnemy = false
	self.HasReset = true
	self:StopProcessing()
	self:SetIdleAnimation(ACT_IDLE)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakePain(dmg,dmginfo,hitbox)
	if CurTime() <= self.NextCanTriggerT then return end
	if IsValid(dmg:GetInflictor()) && dmg:GetInflictor():IsPlayer() && GetConVarNumber("ai_ignoreplayers") then return end
	if self.IsTriggered == false then
		self.IsTriggered = true
		self.TriggeredEntity = dmg:GetInflictor()
		self:OnTriggered(dmg:GetInflictor(),5.6,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindFaceLookers()
	if self.IsTriggered then return end
	if CurTime() <= self.NextCanTriggerT then return end
	local facepos = self:GetBonePosition(34)
	for _,v in ipairs(ents.GetAll()) do
		if v:IsValid() then
			if v:IsPlayer() then
				local dist = self:FindDistanceToPos(facepos,v:GetEyeTrace().HitPos)
				if self.IsTriggered == false && dist <= 55 && GetConVarNumber("ai_ignoreplayers") == 0 && self:Disposition(v) != D_LI && v:Visible(self) && (self:GetForward():Dot(((v:GetPos() +v:OBBCenter()) -self:GetPos() +self:OBBCenter()):GetNormalized()) > math.cos(math.rad(SCP_SightAngle +20))) then
					self.IsTriggered = true
					self.TriggeredEntity = v
					self:OnTriggered(v,30)
				end
			elseif v:IsNPC() then
				if self.IsTriggered == false && self:Disposition(v) != D_LI && v:Visible(self) && (self:GetForward():Dot(((v:GetPos() +v:OBBCenter()) -self:GetPos() +self:OBBCenter()):GetNormalized()) > math.cos(math.rad(SCP_SightAngle +20))) && (v:GetForward():Dot(((self:GetPos() +self:OBBCenter()) -v:GetPos() +v:OBBCenter()):GetNormalized()) > math.cos(math.rad(SCP_SightAngle))) then
					self.IsTriggered = true
					self.TriggeredEntity = v
					self:OnTriggered(v,15)
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTriggered(v,triggertime,usepanic)
	if usepanic == true then
		self:EmitSound("cpthazama/scp/096/Panic.mp3",100,100)
	else
		self:EmitSound("cpthazama/scp/096/Triggered.mp3",100,100)
	end
	if v:IsPlayer() then
		local hb = 0.5
		for i = 1, 25 do
			hb = hb +0.5
			timer.Simple(hb,function()
				if v:IsValid() && v:Alive() then
					v:SendLua("surface.PlaySound('cpthazama/scp/D9341/Heartbeat.mp3')")
				end
			end)
		end
		v:EmitSound("cpthazama/scp/D9341/breath0.mp3",65,100)
	end
	self:PlayActivity(ACT_SPECIAL_ATTACK1)
	self:SetMaxYawSpeed(0)
	timer.Simple(triggertime,function()
		if self:IsValid() then
			if self.TriggeredEntity != NULL then
				self.CanAttack = true
				self:SetMaxYawSpeed(50)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(v)
	if self.TriggeredEntity != NULL && self.TriggeredEntity == v then
		-- self.IsTriggered = false
		self.TriggeredEntity = NULL
		timer.Simple(8,function()
			if self:IsValid() then
				self:ResetTrigger()
				self:StopCompletely()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleLoop:Stop()
	self.ChaseLoop:Stop()
	self.TriggerLoop:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if self.CanAttack == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:StopCompletely()
	self:PlayAnimation("Attack")
	self.IsAttacking = true
	self:AttackFinish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if self.CanAttack == false then return end
	if(disp == D_HT) then
		if nearest <= self.MeleeAttackDistance && self:FindInCone(enemy,self.MeleeAngle) then
			self:DoAttack()
		end
		if self:CanPerformProcess() then
			-- if IsValid(self.TriggeredEntity) && enemy != self.TriggeredEntity then
				-- self:SetEnemy(self.TriggeredEntity)
				-- return
			-- end
			-- print('go')
			self:ChaseEnemy()
		end
	end
end