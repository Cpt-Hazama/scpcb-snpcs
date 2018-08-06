if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/lambda.mdl"}
ENT.StartHealth = 100
ENT.CanMutate = false
ENT.CollisionBounds = Vector(18,15,70)

ENT.Faction = "FACTION_SCP_NTF"

ENT.GrenadeDistance = 1000
ENT.GrenadeMinDistance = 450
ENT.GrenadeChance = 30

ENT.RangeAttackDistance = 800
ENT.FireRate = 0.1

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Fire"] = {ACT_IDLE_ANGRY}
}

ENT.tbl_Sounds = {
	["FootStep"] = {"cpthazama/scp/ntf/Step1.wav","cpthazama/scp/ntf/Step2.wav","cpthazama/scp/ntf/Step3.wav"},
	["Spot"] = {"cpthazama/scp/ntf/Stop1.wav","cpthazama/scp/ntf/Stop3.wav","cpthazama/scp/ntf/Stop4.wav","cpthazama/scp/ntf/Stop5.wav","cpthazama/scp/ntf/Stop6.wav"},
	["Termination"] = {"cpthazama/scp/ntf/TargetTerminated2.wav","cpthazama/scp/ntf/TargetTerminated4.wav","cpthazama/scp/ntf/Targetterminated1.wav"},
	["CombatToLost"] = {"cpthazama/scp/ntf/Searching1.wav","cpthazama/scp/ntf/Searching3.wav","cpthazama/scp/ntf/Searching4.wav","cpthazama/scp/ntf/Searching5.wav","cpthazama/scp/ntf/Searching6.wav"},
	["LostToNormal"] = {"cpthazama/scp/ntf/TargetLost1.wav","cpthazama/scp/ntf/TargetLost3.wav",},
	["Fire"] = {"cpthazama/scp/Gunshot.wav"},
	["Blinking"] = {"cpthazama/scp/ntf/173blinking.wav"},
	-- ["Idle"] = {
		-- "cpthazama/scp/ntf/Random1.wav",
		-- "cpthazama/scp/ntf/Random2.wav",
		-- "cpthazama/scp/ntf/Random3.wav",
		-- "cpthazama/scp/ntf/Random4.wav",
		-- "cpthazama/scp/ntf/Random5.wav",
		-- "cpthazama/scp/ntf/Random6.wav",
		-- "cpthazama/scp/ntf/Random7.wav",
	-- },
	["Spot_Scientist"] = {"cpthazama/scp/ntf/ThereHeIs3.wav"},
	["Spot_DClass"] = {"cpthazama/scp/ntf/ClassD1.wav","cpthazama/scp/ntf/ClassD2.wav","cpthazama/scp/ntf/ClassD3.wav","cpthazama/scp/ntf/ClassD4.wav"},
	["Spot_049"] = {"cpthazama/scp/ntf/049/Spotted1.wav","cpthazama/scp/ntf/049/Spotted2.wav","cpthazama/scp/ntf/049/Spotted3.wav","cpthazama/scp/ntf/049/Spotted4.wav","cpthazama/scp/ntf/049/Spotted5.wav"},
	["Spot_0492"] = {"cpthazama/scp/ntf/049/Player0492_1.wav","cpthazama/scp/ntf/049/Player0492_2.wav"},
	["Spot_096"] = {"cpthazama/scp/ntf/GateB3.wav","cpthazama/scp/ntf/096/Spotted1.wav","cpthazama/scp/ntf/096/Spotted2.wav"},
	["Spot_106"] = {"cpthazama/scp/ntf/106/Spotted1.wav","cpthazama/scp/ntf/106/Spotted2.wav","cpthazama/scp/ntf/106/Spotted3.wav","cpthazama/scp/ntf/106/Spotted4.wav"},
	["Spot_173"] = {"cpthazama/scp/ntf/173/Spotted1.wav","cpthazama/scp/ntf/173/Spotted2.wav","cpthazama/scp/ntf/173/Spotted3.wav"},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCP_BeforeBlinking()
	if CurTime() > self.NextBlinkingSoundT then
		for _,v in ipairs(ents.GetAll()) do
			if v:IsNPC() && (v:GetClass() == "npc_cpt_scp_173" || v:GetClass() == "npc_cpt_scp_087_b") && v:Visible(self) then
				self:PlaySound("Blinking",72)
				self.NextBlinkingSoundT = CurTime() +4
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnScientistFollowed(ent)
	if CurTime() > self.NextSciT then
		self:PlaySound("Spot_Scientist",80)
		self.NextSciT = CurTime() +10
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlaySound(sound,tbl)
	if tbl != "FootStep" then
		self:EmitSound("cpthazama/scp/ntf/Beep.wav",60,100)
		timer.Simple(SoundDuration(sound),function() if self:IsValid() then self:EmitSound("cpthazama/scp/ntf/Beep.wav",60,100) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	possessor:ChatPrint("Possessor Controls:")
	possessor:ChatPrint("LMB - Command Lambda Units")
	possessor:ChatPrint("RMB - Fire Project 90")
	possessor:ChatPrint("Jump - Throw Grenade (You Have " .. self.GrenadeCount .. " Grenades)")
	possessor:ChatPrint("Reload - Contain SCP-173")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	-- self:SetModelScale(0.8)
	self.NextDoorT = 0
	self.tbl_OpenedDoors = {}
	self.IsLeader = false
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
	local allnpcs = {}
	for _,v in ipairs(ents.GetAll()) do
		if v:IsValid() && v:IsNPC() && v != self && v:GetClass() == self:GetClass() then
			table.insert(allnpcs,v)
		end
	end
	if table.Count(allnpcs) == 0 then
		self.IsLeader = true
		self.WanderChance = 2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnEnemyChanged(ent)
	if ent:Health() <= 0 then return end
	if self.NextSpotT == nil then self.NextSpotT = CurTime() end
	if CurTime() > self.NextSpotT then
		self:PlayActivity(ACT_SIGNAL_HALT,2)
		if ent:IsNPC() then
			local class = ent:GetClass()
			if class == "npc_cpt_scp_dclass" then
				self:PlaySound("Spot_DClass",80)
			elseif class == "npc_cpt_scp_049" then
				self:PlaySound("Spot_049",80)
			elseif class == "npc_cpt_scp_0492" then
				self:PlaySound("Spot_0492",80)
			elseif class == "npc_cpt_scp_096" then
				self:PlaySound("Spot_096",80)
			elseif class == "npc_cpt_scp_106" then
				self:PlaySound("Spot_106",80)
			elseif class == "npc_cpt_scp_173" then
				self:PlaySound("Spot_173",80)
			end
		elseif ent:IsPlayer() then
			self:PlaySound("Spot",80)
		end
		self.NextSpotT = CurTime() +8
	end
	for _,v in ipairs(ents.GetAll()) do
		if v:IsValid() && v:IsNPC() && v != self && v:GetClass() == self:GetClass() then
			if !table.HasValue(v.tbl_EnemyMemory,ent) then
				table.insert(v.tbl_EnemyMemory,ent)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(v)
	if GetConVarNumber("cpt_scp_ntfannouncer") == 1 && util.IsSCPMap() then
		if v:IsNPC() then
			if v:GetClass() == "npc_cpt_scp_173" then
				for _,v in ipairs(player.GetAll()) do
					v:SendLua("surface.PlaySound('cpthazama/scp/ntf/Announc173Contain.wav')")
				end
			end
		end
	end
	self:PlaySound("Termination",80)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "rattack") then
		if arg1 == "grenade_spawn" then
			self.IsThrowingGrenade = false
			if IsValid(self) then
				local grenent = ents.Create("obj_cpt_grenade")
				grenent:SetPos(self:GetAttachment(self:LookupAttachment("grenade")).Pos)
				grenent:SetAngles(self:GetAttachment(self:LookupAttachment("grenade")).Ang)
				grenent:SetParent(self)
				grenent:Fire("SetParentAttachment","grenade")
				grenent:SetTimer(4)
				grenent:Spawn()
				grenent:Activate()
				local phys = grenent:GetPhysicsObject()
				if IsValid(phys) then
					grenent:SetParent(NULL)
					phys:SetVelocity(self:SetUpRangeAttackTarget() *math.Rand(1,2) +self:GetUp() *200)
				end
				self.GrenadeCount = self.GrenadeCount -1
			end
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
ENT.P_NextContainT = 0
function ENT:Possess_Reload(possessor)
	if CurTime() > self.P_NextContainT then
		local tr = self:Possess_EyeTrace(possessor)
		if tr.Hit && IsValid(tr.Entity) && tr.Entity:GetClass() == "npc_cpt_scp_173" then
			local scp = tr.Entity
			if self:GetClosestPoint(scp) <= 130 && scp:GetPos():Distance(THESTATUE) > 400 then
				scp:ContainSCP(self)
				for _,v in ipairs(player.GetAll()) do
					v:SendLua("surface.PlaySound('cpthazama/scp/ntf/Announc173Contain.wav')")
				end
			end
		end
		self.P_NextContainT = CurTime() +10
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Jump(possessor)
	self:ThrowGrenade()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ThrowGrenade()
	if self.GrenadeCount <= 0 then return end
	if CurTime() > self.NextGrenadeT then
		if self:CanPerformProcess() == false then return end
		self:StopCompletely()
		self:PlayActivity("throw_grenade",2)
		self.IsThrowingGrenade = true
		self:AttackFinish()
		self.NextGrenadeT = CurTime() +math.random(5,8)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.P_NextDirectT = 0
function ENT:Possess_Primary(possessor)
	if CurTime() > self.P_NextDirectT then
		local tb = {}
		for _,v in ipairs(ents.GetAll()) do
			if v:IsValid() && v:IsNPC() && v != self && v:GetClass() == "npc_cpt_scp_lambda" && !v.IsLeader then
				table.insert(tb,v)
			end
		end
		if table.Count(tb) <= 0 then return end
		for i = 1, table.Count(tb) do
			if tb[i].P_IsBeingCommanded == true then return end
			tb[i].P_IsBeingCommanded = true
			tb[i]:StopCompletely()
			tb[i]:SetLastPosition(self:Possess_AimTarget())
			tb[i]:TASKFUNC_LASTPOSITION()
			tb[i]:PlaySound("CombatToLost",70)
			timer.Simple(7,function()
				if IsValid(tb[i]) then
					tb[i].P_IsBeingCommanded = false
				end
			end)
		end
		self:PlayActivity(ACT_SIGNAL_GROUP,2)
		possessor:ChatPrint("Commanded " .. table.Count(tb) .. " troops to position.")
		self.P_NextDirectT = CurTime() +8
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if IsValid(self:GetEnemy()) then
		self:SetIdleAnimation(ACT_IDLE_ANGRY)
	else
		if !self.IsPossessed then
			self:SetIdleAnimation(ACT_IDLE)
			if self.P_IsBeingCommanded then
				self.WanderChance = 0
			else
				self.WanderChance = 60
			end
			if self.IsLeader == false then
				if self.P_IsBeingCommanded == false then
					for _,v in ipairs(ents.GetAll()) do
						if v:IsValid() && v:IsNPC() && v != self && v:GetClass() == self:GetClass() && v.IsLeader then
							local dist = self:GetClosestPoint(v)
							if dist > 600 then
								self.WanderChance = 0
								self:ChaseTarget(v,false)
								if dist < 200 then
									self.WanderChance = 60
								end
							else
								self.WanderChance = 60
							end
						end
					end
				end
			end
		else
			self:SetIdleAnimation(ACT_IDLE_ANGRY)
		end
	end
	if util.IsSCPMap() then
		if !self.IsPossessed then
			if self.IsTakingSCP == true then
				if IsValid(self.IsTakingSCP_Box) && self.IsTakingSCP_Box:GetPos():Distance(THESTATUE) <= 250 then
					self.IsTakingSCP_Box.NTFOwner = NULL
					self.IsTakingSCP = false
				end
			end
			if IsValid(self:GetEnemy()) && self:GetEnemy():GetClass() == "npc_cpt_scp_173" && !self:GetEnemy().IsContained then
				local ent = self:GetEnemy()
				local dist = ent:GetPos():Distance(self:GetPos())
				if dist <= 350 then
					if !self.IsContainingSCP then
						for _,v in ipairs(ents.FindInSphere(self:GetPos(),350)) do
							if v:IsValid() && v:IsNPC() && v != self && v:GetClass() == self:GetClass() then
								self:SetEnemy(NULL)
								v:FaceTarget(ent)
								self.IsContainingSCP = true
								self.CanShoot = false
							end
						end
					end
					if self.IsContainingSCP == true then
						self:ChaseTarget(ent,false)
						if dist <= 80 && !self.IsContained then
							ent:ContainSCP(self)
							self:StopProcessing()
							self:CheckPoseParameters()
							self.CanShoot = true
							self.IsContainingSCP = false
						end
					end
				end
			end
		end
		if CurTime() > self.NextDoorT then
			for _,v in ipairs(ents.FindInSphere(self:GetPos(),SCP_DoorOpenDistance *1.35)) do
				if v:IsValid() && v:GetClass() == "func_door" /*&& v:GetSequenceName(v:GetSequence()) == "idle"*/ then
					v:Fire("Open")
					if v.SCP_LAMBDA_FORCED == nil then v.SCP_LAMBDA_FORCED = false end
					if v.SCP_LAMBDA_FORCED == false then
						v.SCP_LAMBDA_FORCED = true
						timer.Simple(5.5,function()
							if v:IsValid() then
								sound.Play("ttt_foundation/misc/timed_alarm_01.wav",v:GetPos(),75,100)
							end
						end)
						timer.Simple(7,function()
							if v:IsValid() then
								v:Fire("Close")
								if self:IsValid() then
									v.SCP_LAMBDA_FORCED = false
								end
							end
						end)
					end
				end
			end
			if self.IsLeader == true then
				local didremove = false
				for _,v in ipairs(ents.FindInSphere(self:GetPos(),100)) do
					if v:IsValid() && (v:GetClass() == "trigger_multiple") then
						v:Remove()
						didremove = true
					end
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
function ENT:Possess_Secondary(possessor)
	if self.DoRangeAttack then
		-- if !IsValid(self:GetEnemy()) then possessor:ChatPrint("No Valid Enemy To Target") return end
		if self.IsThrowingGrenade then return end
		self:DoRangeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoRangeAttack()
	if self:CanPerformProcess() == false then return end
	if self.CanShoot == false then return end
	if self.IsThrowingGrenade == true then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	local spread = 20
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
		if nearest <= self.GrenadeDistance && nearest > self.GrenadeMinDistance && math.random(1,self.GrenadeChance) == 1 then
			self:ThrowGrenade()
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