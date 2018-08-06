if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/087-1.mdl"}
ENT.StartHealth = 3000
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CollisionBounds = Vector(18,18,70)

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 60
ENT.MeleeAttackDamageDistance = 90
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 60

ENT.Bleeds = false

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["FootStep"] = {"cpthazama/scp/087/loudstep.wav"},
	["Idle"] = {
		"cpthazama/scp/087/ambient1.wav",
		"cpthazama/scp/087/ambient2.wav",
		"cpthazama/scp/087/ambient3.wav",
		"cpthazama/scp/087/ambient4.wav",
		"cpthazama/scp/087/ambient5.wav",
		"cpthazama/scp/087/ambient6.wav",
		"cpthazama/scp/087/ambient7.wav",
		"cpthazama/scp/087/ambient8.wav",
		"cpthazama/scp/087/ambient9.wav",
		"cpthazama/scp/087/no.wav"
	},
	["Teleport"] = {"cpthazama/scp/087/behind.wav"},
	["Death"] = {"cpthazama/scp/087/death.wav"},
	["Horror"] = {"cpthazama/scp/087/horror1.wav","cpthazama/scp/087/horror2.wav","cpthazama/scp/087/horror3.wav"},
	["Strike"] = {"cpthazama/scp/D9341/Damage3.wav"},
}

ENT.tbl_Capabilities = {CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.NextDoorT = 0
	self.WasSeen = false
	self.ThemeSong = CreateSound(self,"cpthazama/scp/087/music.wav")
	self.ThemeSong:SetSoundLevel(110)
	self.IdleLoop = CreateSound(self,"cpthazama/scp/087/breath.wav")
	self.IdleLoop:SetSoundLevel(85)
	self.NextThemeSongT = 0
	self.NextIdleLoopT = 0
	self.NextTeleportT = 0
	self.P_NextTeleportT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSeen()
	self:PlaySound("Horror",100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Teleport(ent)
	self:SetClearPos(ent:GetPos() +ent:GetForward() *math.random(-100,-50))
	if self:IsInWorld() then
		self:EmitSound("cpthazama/scp/087/behind.wav",100,100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Secondary(possessor)
	if CurTime() > self.P_NextTeleportT then
		local tb = {}
		for _,v in ipairs(ents.GetAll()) do
			if v:IsValid() && v:IsNPC() && v != self && v:Disposition(self) != D_LI && v.Faction != "FACTION_SCP" then
				table.insert(tb,v)
			end
		end
		if table.Count(tb) <= 0 then return end
		local ent = self:SelectFromTable(tb)
		self:Teleport(ent)
		self.P_NextTeleportT = CurTime() +15
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Jump(possessor)
	if CurTime() > self.P_NextTeleportT then
		local tb = {}
		for _,v in ipairs(player.GetAll()) do
			if v:Alive() && v != possessor then
				table.insert(tb,v)
			end
		end
		if table.Count(tb) <= 0 then return end
		local ent = self:SelectFromTable(tb)
		self:Teleport(ent)
		self.P_NextTeleportT = CurTime() +15
	end
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
			if !IsValid(self:GetEnemy()) || (IsValid(self:GetEnemy()) && !(self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) && self:GetClosestPoint(self:GetEnemy()) > 800) then
				self:PlaySound("FootStep",90,90,100,true)
			end
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
function ENT:OnThink()
	if GetConVarNumber("cpt_scp_usemusic") == 1 && CurTime() > self.NextThemeSongT then
		self.ThemeSong:Stop()
		self.ThemeSong:Play()
		self.NextThemeSongT = CurTime() +31
	end
	if CurTime() > self.NextIdleLoopT then
		self.IdleLoop:Stop()
		self.IdleLoop:Play()
		self.NextIdleLoopT = CurTime() +10
	end
	if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then
		if self.WasSeen == false then
			self:OnSeen()
			self.WasSeen = true
		end
	else
		self.WasSeen = false
	end
	if !self.IsPossessed then
		if IsValid(self:GetEnemy()) then
			if CurTime() > self.NextTeleportT && !self:GetEnemy():Visible(self) && self:GetClosestPoint(self:GetEnemy()) > 600 && math.random(1,12) == 1 then
				self:Teleport(self:GetEnemy())
				self.NextTeleportT = CurTime() +math.Rand(8,15)
			end
			if !self:IsInWorld() then
				self:Teleport(self:GetEnemy())
			end
		end
	end
	local canwalkthroughsurface = false
	for _,v in ipairs(ents.FindInSphere(self:GetPos(),40)) do
		if v:IsValid() && v != self && (v:GetClass() == "func_brush" || v:GetClass() == "func_door" || v:GetClass() == "func_door_rotating" || v:GetClass() == "prop_door" || v:GetClass() == "prop_door_rotating" || v:GetClass() == "prop_physics" || v:GetClass() == "prop_dynamic") then
			canwalkthroughsurface = true
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
	sound.Play("cpthazama/scp/087/no.wav",self:GetPos(),100,100)
	self.ThemeSong:Stop()
	self.IdleLoop:Stop()
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