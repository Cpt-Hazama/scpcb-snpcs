if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/173_old.mdl"}
ENT.StartHealth = 4000
ENT.CanMutate = false
-- ENT.CanSeeAllEnemies = true -- DISABLE!
-- ENT.WanderChance = 0
ENT.WanderChance = 25
ENT.DeathRagdollType = "prop_physics"
ENT.Mass = 0
ENT.ViewAngle = 180
ENT.CollisionBounds = Vector(13,13,85)

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 60
ENT.MeleeAttackDamageDistance = 80
ENT.MeleeAttackType = DMG_CRUSH
ENT.MeleeAttackDamage = 200

ENT.Bleeds = false

ENT.tbl_Animations = {
	["Walk"] = {ACT_RUN},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["Horror"] = {
		"cpthazama/scp/music/Horror0.mp3",
		"cpthazama/scp/music/Horror1.mp3",
		"cpthazama/scp/music/Horror2.mp3",
		"cpthazama/scp/music/Horror3.mp3",
		"cpthazama/scp/music/Horror4.mp3",
		"cpthazama/scp/music/Horror5.mp3",
		"cpthazama/scp/music/Horror8.mp3",
		"cpthazama/scp/music/Horror9.mp3",
		"cpthazama/scp/music/Horror10.mp3",
		"cpthazama/scp/music/Horror13.mp3",
		"cpthazama/scp/music/Horror14.mp3",
		"cpthazama/scp/music/Horror0.mp3",
		"cpthazama/scp/music/Horror0.mp3",
	},
	["Strike"] = {"cpthazama/scp/173/NeckSnap1.mp3","cpthazama/scp/173/NeckSnap2.mp3","cpthazama/scp/173/NeckSnap3.mp3"},
	["Idle"] = {"cpthazama/scp/173/Rattle1.mp3","cpthazama/scp/173/Rattle2.mp3","cpthazama/scp/173/Rattle3.mp3"},
	["Alert"] = {"cpthazama/scp/173/Rattle1.mp3","cpthazama/scp/173/Rattle2.mp3","cpthazama/scp/173/Rattle3.mp3"},
	["Strike"] = {"cpthazama/scp/D9341/Damage2.mp3"},
	["Miss"] = {"common/null.wav"},
	["NeckBreak"] = {"cpthazama/scp/173/NeckSnap1.mp3","cpthazama/scp/173/NeckSnap2.mp3","cpthazama/scp/173/NeckSnap3.mp3"}
}
ENT.IdleSoundVolume = 100
ENT.IdleSoundChanceA = 3
ENT.IdleSoundChanceB = 5
ENT.AlertSoundVolume = 100
ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	possessor:ChatPrint("Possessor Controls:")
	possessor:ChatPrint("You can only move/attack when not seen or the player/NPC is blinking")
	possessor:ChatPrint("LMB - Attack")
	possessor:ChatPrint("RMB - Move through vents")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.IdleMoveSound = CreateSound(self,"cpthazama/scp/173/StoneDrag.mp3") // 5
	self.IdleMoveSound:SetSoundLevel(75)
	self.WasSeen = false
	self.IsContained = false
	self.NextDoorT = 0
	self.NextMoveSoundT = 0
	self.P_NextVentT = CurTime() +2
	self.NextAlertSoundShitT = 0
	self.LastVent = Vector(0,0,0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ContainSCP(ntf)
	self.IsContained = true
	if !IsValid(self.Box) then
		self.Box = ents.Create("npc_cpt_scp_173_box")
		self.Box:SetPos(self:GetPos())
		self.Box:SetAngles(self:GetAngles())
		self.Box:SecureBox(self,ntf)
		self.Box:Spawn()
		self.Box:SecureBox(self,ntf)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Teleport(pos)
	if self.IsContained then return end
	self.IdleMoveSound:Stop()
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetNoDraw(true)
	if pos == self.LastVent then
		local tb = {VENTA,VENTB,VENTC,VENTD,VENTE,VENTF,VENTG,VENTH}
		local pos = self:SelectFromTable(tb)
		if util.GetSCPMapData(pos) != nil then
			self:Teleport(util.GetSCPMapData(pos))
		end
		return
	end
	if pos != nil then
		self:SetPos(pos)
	end
	timer.Simple(0.5,function()
		if self:IsValid() then
			self:SetCollisionGroup(COLLISION_GROUP_NPC)
			self:SetNoDraw(false)
			if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then
				local tb = {VENTA,VENTB,VENTC,VENTD,VENTE,VENTF,VENTG,VENTH}
				local pos = self:SelectFromTable(tb)
				if util.GetSCPMapData(pos) != nil then
					self:Teleport(util.GetSCPMapData(pos))
				end
			end
			self.LastVent = pos
		end
	end)
	self:EmitSound("ttt_foundation/ambience/zone1/ambient" .. math.random(7,9) .. ".wav",100,100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Secondary(possessor)
	if util.IsSCPMap() then
		if CurTime() > self.P_NextVentT then
			if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then return end
			local tb = {VENTA,VENTB,VENTC,VENTD,VENTE,VENTF,VENTG,VENTH}
			local pos = self:SelectFromTable(tb)
			if util.GetSCPMapData(pos) != nil then
				self:Teleport(util.GetSCPMapData(pos))
			end
			-- print(pos)
			self.P_NextVentT = CurTime() +7
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "mattack") then
		if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then return true end
		if self.IsContained then return true end
		self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
		return true
	end
end
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.IsContained then
		self.IdleMoveSound:Stop()
		return
	end
	if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then
		if self.WasSeen == false then
			self:OnSeen()
			self.WasSeen = true
		end
		self.Possessor_CanMove = false
		self:SetMaxYawSpeed(0)
		self.IdleMoveSound:Stop()
		self:StopProcessing()
		self:StopProcessing()
		self:StopProcessing()
		self.IsRangeAttacking = true
		self.WanderChance = 0
		self.MeleeAttackDistance = -100
		self.MeleeAttackDamageDistance = -100
	else
		self.WasSeen = false
		self.Possessor_CanMove = true
		self.IsRangeAttacking = false
		self.WanderChance = 25
		self:SetMaxYawSpeed(300)
		if self:IsMoving() then
			if CurTime() > self.NextMoveSoundT then
				self.IdleMoveSound:Stop()
				self.IdleMoveSound:Play()
				self.NextMoveSoundT = CurTime() +5
			end
		else
			self.IdleMoveSound:Stop()
			self.NextMoveSoundT = 0
		end
		self.MeleeAttackDistance = 60
		self.MeleeAttackDamageDistance = 80
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
	if util.IsSCPMap() then
		if !self.IsPossessed then
			if !IsValid(self:GetEnemy()) && math.random(1,50) == 1 && CurTime() > self.P_NextVentT then
				if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then return end
				local tb = {VENTA,VENTB,VENTC,VENTD,VENTE,VENTF,VENTG,VENTH}
				local pos = self:SelectFromTable(tb)
				if util.GetSCPMapData(pos) != nil then
					self:Teleport(util.GetSCPMapData(pos))
				end
				self.P_NextVentT = CurTime() +7
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleMoveSound:Stop()
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
	self:AttackFinish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnHitEntity(hitents,hitpos)
	for _,v in ipairs(hitents) do
		v:EmitSound(self:SelectFromTable(self.tbl_Sounds["NeckBreak"]),90,100)
	end
	self:EmitSound(self:SelectFromTable(self.tbl_Sounds["Strike"]),90,100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if self.IsContained then return end
	-- local IsSeen = (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC())
	-- self:PlayerChat(IsSeen)
	if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then return end
	if(disp == D_HT) then
		if nearest <= self.MeleeAttackDistance && (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == false then
			self:DoAttack()
		end
		if self:CanPerformProcess() && (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) != true then
			self:ChaseEnemy()
		elseif self:CanPerformProcess() && (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then
			self:StopProcessing()
		end
	end
end