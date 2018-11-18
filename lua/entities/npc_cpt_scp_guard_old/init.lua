if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/guard_old.mdl"}
ENT.StartHealth = 90
ENT.CanMutate = false
ENT.CollisionBounds = Vector(18,15,70)

ENT.Faction = "FACTION_SCP_NTF"

ENT.SpeakDistance = 130

ENT.RangeAttackDistance = 800
ENT.FireRate = 0.1

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Fire"] = {ACT_IDLE_ANGRY}
}

ENT.tbl_Sounds = {
	["FootStep"] = {
		"cpthazama/scp/_oldscp/RunMetal1.mp3",
		"cpthazama/scp/_oldscp/RunMetal2.mp3",
		"cpthazama/scp/_oldscp/RunMetal3.mp3",
		"cpthazama/scp/_oldscp/RunMetal4.mp3",
		"cpthazama/scp/_oldscp/RunMetal5.mp3",
		"cpthazama/scp/_oldscp/RunMetal6.mp3",
		"cpthazama/scp/_oldscp/RunMetal7.mp3",
		"cpthazama/scp/_oldscp/RunMetal8.mp3",
	},
	["CombatToLost"] = {"cpthazama/scp/mtf/PlayerEscape.mp3"},
	["Fire"] = {"cpthazama/scp/Gunshot.mp3"},
	["Conversation1_Start"] = {
		"cpthazama/scp/mtf/Conversation1a.mp3",
	},
	["Conversation1_Partner"] = {
		"cpthazama/scp/mtf/Conversation1b.mp3",
	},
	["Conversation2_Start"] = {
		"cpthazama/scp/mtf/Conversation2a.mp3",
	},
	["Conversation2_Partner"] = {
		"cpthazama/scp/mtf/Conversation2b.mp3",
	},
	["Conversation3_Start"] = {
		"cpthazama/scp/mtf/Conversation3a.mp3",
	},
	["Conversation3_Partner"] = {
		"cpthazama/scp/mtf/Conversation3b.mp3",
	},
	["Conversation4_Start"] = {
		"cpthazama/scp/mtf/Conversation4a.mp3",
	},
	["Conversation4_Partner"] = {
		"cpthazama/scp/mtf/Conversation4b.mp3",
	},
	["Conversation5_Start"] = {
		"cpthazama/scp/mtf/Conversation5a.mp3",
	},
	["Conversation5_Partner"] = {
		"cpthazama/scp/mtf/Conversation5b.mp3",
	},
	["Spot_DClass"] = {"cpthazama/scp/mtf/EscortKill1.mp3","cpthazama/scp/mtf/EscortKill2.mp3"},
	["Spot_Player"] = {
		"cpthazama/scp/mtf/Escort1.mp3",
		"cpthazama/scp/mtf/Escort2.mp3",
	},
	["BecomeEnemy"] = {
		"cpthazama/scp/mtf/EscortKill1.mp3",
		"cpthazama/scp/mtf/EscortKill2.mp3",
		"cpthazama/scp/mtf/PlayerEscape.mp3",
	},
	["PissOff"] = {
		"cpthazama/scp/mtf/EscortPissedOff1.mp3",
		"cpthazama/scp/mtf/EscortPissedOff2.mp3",
		"cpthazama/scp/mtf/EscortRefuse1.mp3",
		"cpthazama/scp/mtf/EscortRefuse2.mp3",
		"cpthazama/scp/mtf/ExitCellRefuse1.mp3",
		"cpthazama/scp/mtf/ExitCellRefuse2.mp3",
	},
	["EndEscort"] = {
		"cpthazama/scp/mtf/EscortDone1.mp3",
		"cpthazama/scp/mtf/EscortDone2.mp3",
		"cpthazama/scp/mtf/EscortDone3.mp3",
		"cpthazama/scp/mtf/EscortDone4.mp3",
		"cpthazama/scp/mtf/EscortDone5.mp3",
	},
	["MoveTooFar"] = {"cpthazama/scp/mtf/EscortRun.mp3"},
	["ExitCell"] = {"cpthazama/scp/mtf/ExitCell.mp3"},
	["Spot_SCP"] = {"cpthazama/scp/mtf/OhSh.mp3","cpthazama/scp/mtf/WTF1.mp3","cpthazama/scp/mtf/WTF2.mp3"},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	possessor:ChatPrint("Possessor Controls:")
	possessor:ChatPrint("LMB - Fire Project 90")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.NextDoorT = 0
	self.tbl_OpenedDoors = {}
	self.CanShoot = true
	self.IsTakingSCP_Box = NULL
	self.IsTakingSCP = false
	self.GrenadeCount = math.random(2,4)
	self.NextFireT = 0
	self.NextSpotT = 0
	self.NextSciT = 0
	self.NextBlinkingSoundT = 0
	self.ThrowEnemyPos = Vector(0,0,0)
	self.NextGrenadeT = CurTime() +1
	self.IsThrowingGrenade = false
	self.P_IsBeingCommanded = false
	self.MTF_Partner = NULL
	self.MTF_PartnerStarter = false
	self.IsSpeaking = false
	self.Bossed = NULL
	self.IsBossing = false
	self.FindBossedT = CurTime() +2
	self.Threshold = 0
	self.NextThresholdT = 0
	self.NextEndEscort = CurTime() +500
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanTalk()
	if !self.IsSpeaking && !IsValid(self.MTF_Partner) && !self.MTF_PartnerStarter && CurTime() > self.NextIdleSoundT then
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindPartner()
	for _,v in ipairs(ents.FindInSphere(self:GetPos(),self.SpeakDistance)) do
		-- print(v:IsNPC(),v:Visible(self),(v:GetClass() == self:GetClass()),(v != self),!IsValid(v.MTF_Partner),self.MTF_PartnerStarter)
		if IsValid(v) && v:IsNPC() then
			if v:Visible(self) && v:GetClass() == self:GetClass() && v != self && v:CanTalk() then
				return v
			end
		end
		-- break
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindPlayer()
	for _,v in ipairs(ents.FindInSphere(self:GetPos(),300)) do
		if IsValid(v) && v:IsPlayer() then
			if v:Visible(self) && !v.IsBeingBossed && v.Faction == "FACTION_SCP_NTF" then
				return v
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSounds()
	if self.IsPossessed == false then
		if !IsValid(self:GetEnemy()) then
			if self:CanTalk() && math.random(1,3) == 1 then
				self.MTF_Partner = self:FindPartner()
				if IsValid(self.MTF_Partner) then
					self.MTF_PartnerStarter = true
					self.MTF_Partner.MTF_Partner = self
					if self.MTF_Partner.MTF_Partner != self then
						self.MTF_Partner = NULL
						return
					end
					self.IsSpeaking = true
					self.MTF_Partner.IsSpeaking = true
					local time = math.random(24,26)
					timer.Simple(time,function()
						if IsValid(self) then
							self.IsSpeaking = false
							if IsValid(self.MTF_Partner) then
								self.MTF_Partner.IsSpeaking = false
								self.MTF_Partner.MTF_Partner = NULL
								self.MTF_Partner.MTF_PartnerStarter = false
								self.MTF_Partner:ClearPoseParameters()
							end
							self.MTF_Partner = NULL
							self.MTF_PartnerStarter = false
							self:ClearPoseParameters()
						end
					end)
					self.MTF_Partner.MTF_PartnerStarter = false
					local conv = math.random(1,5)
					self:PlaySound("Conversation" .. conv .. "_Start",self.IdleSoundVolume,90,self.IdleSoundPitch)
					self.MTF_Partner:PlaySound("Conversation" .. conv .. "_Partner",self.MTF_Partner.IdleSoundVolume,90,self.MTF_Partner.IdleSoundPitch)
					self:DoPlaySound("Conversation" .. conv .. "_Start")
					self.MTF_Partner:DoPlaySound("Conversation" .. conv .. "_Partner")
					-- if self.CurrentSound != nil then
						self.NextIdleSoundT = CurTime() +time +math.random(20,30)
					-- end
				end
			end
		end
	else
		if !IsValid(self:GetEnemy()) && self:CanTalk() && math.random(1,3) == 1 then
			self.MTF_Partner = self:FindPartner()
			if IsValid(self.MTF_Partner) then
				self.MTF_PartnerStarter = true
				self.MTF_Partner.MTF_Partner = self
				if self.MTF_Partner.MTF_Partner != self then
					self.MTF_Partner = NULL
					return
				end
				self.IsSpeaking = true
				self.MTF_Partner.IsSpeaking = true
				local time = math.random(24,26)
				timer.Simple(time,function()
					if IsValid(self) then
						self.IsSpeaking = false
						if IsValid(self.MTF_Partner) then
							self.MTF_Partner.IsSpeaking = false
							self.MTF_Partner.MTF_Partner = NULL
							self.MTF_Partner.MTF_PartnerStarter = false
							self.MTF_Partner:ClearPoseParameters()
						end
						self.MTF_Partner = NULL
						self.MTF_PartnerStarter = false
						self:ClearPoseParameters()
					end
				end)
				self.MTF_Partner.MTF_PartnerStarter = false
				local conv = math.random(1,5)
				self:PlaySound("Conversation" .. conv .. "_Start",self.IdleSoundVolume,90,self.IdleSoundPitch)
				self.MTF_Partner:PlaySound("Conversation" .. conv .. "_Partner",self.MTF_Partner.IdleSoundVolume,90,self.MTF_Partner.IdleSoundPitch)
				self:DoPlaySound("Conversation" .. conv .. "_Start")
				self.MTF_Partner:DoPlaySound("Conversation" .. conv .. "_Partner")
				-- if self.CurrentSound != nil then
					self.NextIdleSoundT = CurTime() +time +math.random(20,30)
				-- end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoPlaySound(tbl)
	if string.find(tbl,"Conversation") then
		timer.Simple(5,function()
			if IsValid(self) then
				self.MTF_PartnerStarter = false
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnEnemyChanged(ent)
	if ent:Health() <= 0 then return end
	if self.NextSpotT == nil then self.NextSpotT = CurTime() end
	if CurTime() > self.NextSpotT then
		if ent:IsNPC() then
			local class = ent:GetClass()
			if class == "npc_cpt_scp_dclass" then
				self:PlaySound("Spot_DClass",80)
			end
			if string.find(class,"scp") && (class != "npc_cpt_scp_dclass" || class != "npc_cpt_scp_ntf" || class != "npc_cpt_scp_lambda" || class != "npc_cpt_scp_nu" || class != "npc_cpt_scp_scientist") then
				self:PlaySound("Spot_SCP",80)
			end
		elseif ent:IsPlayer() && self:Disposition(ent) == D_LI then
			self:PlaySound("Spot_Player",80)
		end
		self.NextSpotT = CurTime() +8
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "emit") then
		if arg1 == "step" then
			self:PlaySound("FootStep",75,90,100,true)
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Boss(ent)
	if self.Threshold >= 3 then
		ent.IsBeingBossed = false
		self.IsBossing = false
		self.Bossed.Faction = "FACTION_PLAYER"
		self.Bossed:SetNWString("CPTBase_NPCFaction","FACTION_PLAYER")
		self.Bossed = NULL
		self:PlaySound("BecomeEnemy",78)
		self.WanderChance = 60
		self.FindBossedT = CurTime() +30
	end
	if IsValid(ent) then
		if CurTime() > self.NextEndEscort then
			ent.IsBeingBossed = false
			self.IsBossing = false
			self.Bossed = NULL
			self:PlaySound("EndEscort",78)
			self.WanderChance = 60
			self.FindBossedT = CurTime() +30
		end
		local dist = self:GetClosestPoint(ent)
		if CurTime() > self.NextThresholdT && dist > 300 then // too far
			self.Threshold = self.Threshold +1
			if self.Threshold <= 1 then
				self:PlaySound("MoveTooFar",78)
			else
				self:PlaySound("PissOff",78)
			end
			self:LookAtPosition(self:FindCenter(ent),pp,pp_speed,self.ReversePoseParameters)
			self:SetAngles(Angle(0,(ent:GetPos() -self:GetPos()):Angle().y,0))
			self:StopCompletely()
			self.NextThresholdT = CurTime() +8
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- print(self,self.IsSpeaking)
	-- if self.IsSpeaking then
		-- self:SetColor(Color(255,0,0))
	-- else
		-- self:SetColor(Color(0,0,255))
	-- end
	if IsValid(self:GetEnemy()) then
		self:SetIdleAnimation(ACT_IDLE_ANGRY)
		self.MTF_PartnerStarter = false
		if IsValid(self.MTF_Partner) then
			self.MTF_Partner.MTF_PartnerStarter = false
			self.MTF_Partner.MTF_Partner = NULL
		end
		if IsValid(self.Bossed) then
			self.Bossed.IsBeingBossed = false
			self.Threshold = 0
			self.Bossed = NULL
			self.IsBossing = false
		end
		self.MTF_Partner = NULL
		self.NextIdleSoundT = CurTime() +math.random(5,10)
		self.WanderChance = 60
	else
		if !self.IsPossessed then
			self:SetIdleAnimation(ACT_IDLE)
			if GetConVarNumber("cpt_scp_guardduty") == 1 && !self.IsBossing && CurTime() > self.FindBossedT then
				local v = self:FindPlayer()
				if IsValid(v) then
					self.Bossed = v
					v.IsBeingBossed = true
					self.IsBossing = true
					self.NextEndEscort = CurTime() +60
					v:ChatPrint("Follow the MTF Guard for the next 60 seconds or you will be terminated.")
					self:PlaySound("ExitCell",78)
					self:LookAtPosition(self:FindCenter(v),pp,pp_speed,self.ReversePoseParameters)
					self:SetAngles(Angle(0,(v:GetPos() -self:GetPos()):Angle().y,0))
					self:StopCompletely()
					self.WanderChance = 1
				end
				self.FindBossedT = CurTime() +5
			end
			if self.IsBossing && IsValid(self.Bossed) then
				self:Boss(self.Bossed)
			end
			if IsValid(self.MTF_Partner) then
				if self.IsSpeaking && !self.IsBossing then
					local pp = self.DefaultPoseParameters
					local pp_speed = self.DefaultPoseParamaterSpeed
					self:LookAtPosition(self:FindCenter(self.MTF_Partner),pp,pp_speed,self.ReversePoseParameters)
					self.WanderChance = 0
					self:SetAngles(Angle(0,(self.MTF_Partner:GetPos() -self:GetPos()):Angle().y,0))
					self:StopCompletely()
				end
			else
				self.WanderChance = 60
			end
		else
			self:SetIdleAnimation(ACT_IDLE_ANGRY)
		end
	end
	if util.IsSCPMap() then
		if CurTime() > self.NextDoorT then
			for _,v in ipairs(ents.FindInSphere(self:GetPos(),SCP_DoorOpenDistance *1.35)) do
				if v:IsValid() && v:GetClass() == "func_door" /*&& v:GetSequenceName(v:GetSequence()) == "idle"*/ then
					v:Fire("Open")
				end
			end
			self.NextDoorT = CurTime() +math.Rand(1,3)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanSetAsEnemy(ent)
	if ent:GetClass() == "npc_cpt_scp_173" && ent.IsContained then
		return false
	else
		return true
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Primary(possessor)
	self:DoRangeAttack()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoRangeAttack()
	if self:CanPerformProcess() == false then return end
	if self.CanShoot == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	local spread = 18
	if CurTime() > self.NextFireT then
		local muzzle = self:GetAttachment(self:LookupAttachment("muzzle"))
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
		self:SoundCreate(self:SelectFromTable(self.tbl_Sounds["Fire"]),95)
		local effectdata = EffectData()
		effectdata:SetStart(muzzle.Pos)
		effectdata:SetOrigin(muzzle.Pos)
		effectdata:SetScale(1)
		effectdata:SetAngles(muzzle.Ang)
		util.Effect("MuzzleEffect",effectdata)
		if !self.IsPossessed then
			self.IsRangeAttacking = true
			self:StopCompletely()
		end
		timer.Simple(self.FireRate -0.01,function() if self:IsValid() then self.IsRangeAttacking = false end end)
		self.NextFireT = CurTime() +self.FireRate
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanShootEnemy()
	if self.IsThrowingGrenade then return false end
	local tracedata = {}
	tracedata.start = self:GetAttachment(self:LookupAttachment("muzzle")).Pos
	tracedata.endpos = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter()
	tracedata.filter = {self}
	return util.TraceLine(tracedata).Hit
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp,time)
	if self.IsPossessed then return end
	if(disp == D_HT) then
		if GetConVarNumber("cpt_scp_mtfhiding") == 1 then
			if enemy:GetClass() == "npc_cpt_scp_096" && !enemy.IsTriggered then self:Hide("Walk") return end
			if enemy:GetClass() == "npc_cpt_scp_106" then self:Hide("Run") return end
			if enemy:GetClass() == "npc_cpt_scp_049" then self:Hide("Run") return end
		end
		if nearest <= self.RangeAttackDistance && self.CanShoot == true then
			if self:FindInCone(enemy,30) && self:Visible(enemy) then
				if self:CanShootEnemy() then
					self:SetAngles(Angle(0,(enemy:GetPos() -self:GetPos()):Angle().y,0))
					self:DoRangeAttack()
					if self:GetSequence() != ACT_IDLE_ANGRY then
						self:StopProcessing()
						self:SetIdleAnimation(ACT_IDLE_ANGRY)
					end
				end
			elseif !self:FindInCone(enemy,30) && self:Visible(enemy) then
				self:SetAngles(Angle(0,(enemy:GetPos() -self:GetPos()):Angle().y,0))
				self:StopCompletely()
				self:SetIdleAnimation(ACT_IDLE_ANGRY)
			end
		end
		if self:CanPerformProcess() then
			if !self:Visible(enemy) || (nearest > self.RangeAttackDistance && self:Visible(enemy)) then
				if self.IsRangeAttacking == true then self:StopCompletely() return end
				self:ChaseEnemy()
			-- else
				-- self:FaceEnemy()
			end
		end
	end
end