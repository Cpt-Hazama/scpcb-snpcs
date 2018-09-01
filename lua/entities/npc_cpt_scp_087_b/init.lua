if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/087-B.mdl"}
ENT.StartHealth = 5000
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.SightAngle = 180
ENT.CollisionBounds = Vector(18,18,70)

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 60
ENT.MeleeAttackDamageDistance = 80
ENT.MeleeAttackType = DMG_CRUSH
ENT.MeleeAttackDamage = 300

ENT.Bleeds = false

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["FootStep"] = {"cpthazama/scp/087/step.mp3"},
	["Horror"] = {"cpthazama/scp/087/horror1.mp3","cpthazama/scp/087/horror2.mp3","cpthazama/scp/087/horror3.mp3"},
	["Strike"] = {"cpthazama/scp/D9341/Damage3.mp3"},
}

ENT.tbl_Capabilities = {CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	possessor:ChatPrint("Possessor Controls:")
	possessor:ChatPrint("You can only move/attack when not seen or the player/NPC is blinking")
	possessor:ChatPrint("LMB - Attack")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.IdleLoop = CreateSound(self,"cpthazama/scp/087/dontlook.mp3")
	self.IdleLoop:SetSoundLevel(90)
	-- self.IdleMoveSound = CreateSound(self,"cpthazama/scp/173/StoneDrag.mp3") // 5
	self.IdleMoveSound = CreateSound(self,"cpthazama/scp/087/stone.mp3") // 1.5
	self.IdleMoveSound:SetSoundLevel(75)
	self.NextIdleLoopT = 0
	self.NextMoveSoundT = 0
	self.WasSeen = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "mattack") then
		if arg1 == "both" then
			self:DoDamage(self.MeleeAttackDamageDistance *1.5,self.MeleeAttackDamage,self.MeleeAttackType)
		else
			self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSeen()
	if IsValid(self:GetEnemy()) && self:GetClosestPoint(self:GetEnemy()) < 130 then
		self:PlaySound("Horror",100)
		util.ShakeWorld(self:GetEnemy():GetPos(),14,2,60)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then
		if self.WasSeen == false then
			self:OnSeen()
			self.WasSeen = true
		end
		self:StopProcessing()
		self:StopProcessing()
		self:StopProcessing()
		if CurTime() > self.NextIdleLoopT then
			self.IdleLoop:Stop()
			self.IdleLoop:Play()
			self.NextIdleLoopT = CurTime() +10
		end
		self.IdleMoveSound:Stop()
		self.MeleeAttackDistance = 0
		self.MeleeAttackDamageDistance = 0
		self.Possessor_CanMove = false
	else
		self.WasSeen = false
		self.Possessor_CanMove = true
		self.IdleLoop:Stop()
		self.NextIdleLoopT = CurTime()
		self.MeleeAttackDistance = 60
		self.MeleeAttackDamageDistance = 80
		-- if self:IsMoving() then
			-- if CurTime() > self.NextMoveSoundT then
				-- self.IdleMoveSound:Stop()
				-- self.IdleMoveSound:Play()
				-- self.NextMoveSoundT = CurTime() +1
			-- end
		-- else
			-- self.IdleMoveSound:Stop()
			-- self.NextMoveSoundT = 0
		-- end
	end
	local canwalkthroughsurface = false
	for _,v in ipairs(ents.FindInSphere(self:GetPos(),45)) do
	if v:IsValid() && v != self && (v:GetClass() == "func_brush" || v:GetClass() == "func_door" || v:GetClass() == "func_door_rotating" || v:GetClass() == "prop_door" || v:GetClass() == "prop_door_rotating" || v:GetClass() == "prop_physics" || v:GetClass() == "prop_dynamic") then			canwalkthroughsurface = true
		end
	end
	if canwalkthroughsurface == true then
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	else
		self:SetCollisionGroup(COLLISION_GROUP_NPC)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	sound.Play("cpthazama/scp/087/no.mp3",self:GetPos(),100,100)
	self.IdleLoop:Stop()
	self.IdleMoveSound:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then return end
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:StopCompletely()
	self:PlayAnimation("Attack")
	self.IsAttacking = true
	self:AttackFinish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then return end
	if self.IsPossessed then return end
	if(disp == D_HT) then
		if nearest <= self.MeleeAttackDistance && self:FindInCone(enemy,self.MeleeAngle) && (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) != true then
			self:DoAttack()
		end
		if self:CanPerformProcess() && (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) != true then
			self:ChaseEnemy()
		end
	end
end