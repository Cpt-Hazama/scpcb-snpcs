if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scpiso/303.mdl"}
ENT.StartHealth = 350
ENT.Possessor_CanBePossessed = false
ENT.CollisionBounds = Vector(18,18,70)

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 45
ENT.MeleeAttackDamageDistance = 65
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 200

ENT.BloodEffect = {"blood_impact_red_01"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_WALK},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["FootStep"] = {"npc/zombie/foot_slide1.wav","npc/zombie/foot_slide2.wav","npc/zombie/foot_slide3.wav"},
	["Strike"] = {"cpthazama/scp/D9341/Damage4.mp3"},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IdleLoop = CreateSound(self,"cpthazama/scpisolation/303loop.mp3")
	self.IdleLoop:SetSoundLevel(75)
	self.BreathLoop = CreateSound(self,"cpthazama/scpisolation/Breath.mp3")
	self.BreathLoop:SetSoundLevel(85)
	self.IsAttacking = false
	self.NextIdleLoopT = 0
	self.NextBreathLoopT = 0
	self.NextDoorT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "mattack") then
		if arg1 == "tear" then
			self:DoDamage(math.Round(self.MeleeAttackDamageDistance *0.4),self.MeleeAttackDamage,self.MeleeAttackType)
		else
			self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
		end
		return true
	end
	if(event == "emit") then
		if arg1 == "step" then
			self:CPT_PlaySound("FootStep",75,90,100,true)
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self:StopMoving()
	if !self.IsPossessed && IsValid(self:GetEnemy()) then
		self:SetAngles(Angle(0,(self:GetEnemy():GetPos() -self:GetPos()):Angle().y,0))
	end
	if util.IsSCPMap() then
		local tb = {}
		local tbp = {}
		local ent = self:GetEnemy()
		if !IsValid(ent) then
			ent = self
		end
		if CurTime() > self.NextDoorT then
			for _,v in ipairs(ents.GetAll()) do
				if v:IsValid() && v:GetClass() == "func_door" /*&& v:GetSequenceName(v:GetSequence()) == "idle"*/ then
					table.insert(tb,v)
				end
			end
			local fv = self:GetClosestEntity(tb,ent)
			if ent == self then
				fv = self:SelectFromTable(tb)
			end
			for _,v in ipairs(ents.FindInSphere(fv:GetPos(),50)) do
				if v:IsValid() && v:GetClass() == "prop_dynamic" && string.find(v:GetModel(),"door") then
					table.insert(tbp,v)
				end
			end
			local v = self:GetClosestEntity(tbp,ent)
			if !IsValid(v) then return end
			fv:Fire("Close")
			if ent:VisibleVec(v:GetPos() +v:GetRight() *40) then
				self:SetPos(v:GetPos() +v:GetRight() *-40 +v:GetUp() *-55)
			else
				self:SetPos(v:GetPos() +v:GetRight() *40 +v:GetUp() *-55)
			end
			local t = math.Rand(1,3)
			local ti = math.Rand(0.5,2)
			if self:Visible(ent) then
				if ent:IsPlayer() then
					util.ShakeWorld(ent:GetPos(),16,ti,40,false)
					ent:CPT_Freeze(true)
					ent:SetNWBool("CPTBase_SCP303",true)
					timer.Simple(ti,function() if IsValid(ent) then ent:SetNWBool("CPTBase_SCP303",false); ent:EmitSound("cpthazama/scp/D9341/breath1.mp3",55,100) ent:CPT_Freeze(false) end end)
					ent:EmitSound("cpthazama/scp/D9341/Heartbeat.mp3",30,110)
					ent:EmitSound("cpthazama/scp/music/Horror15.mp3",0.2,105)
					ent:ChatPrint("SCP-303's presence sends your whole body into complete shock")
				else
					ent:CPT_Freeze(ti)
				end
			end
			-- self:SetPos(v:GetPos() +v:GetRight() *40)
			-- if self:Visible(ent) then
				-- self:SetPos(v:GetPos() +v:GetRight() *-40)
			-- end
			table.Empty(tb)
			self.NextDoorT = CurTime() +t
		end
	else
		local tbp = {}
		local ent = self:GetEnemy()
		if !IsValid(ent) then
			ent = self
		end
		if CurTime() > self.NextDoorT then
			for _,v in ipairs(ents.GetAll()) do
				if v:IsValid() && string.find(v:GetClass(),"door") then
					table.insert(tbp,v)
				end
			end
			local v = self:GetClosestEntity(tbp,ent)
			if !IsValid(v) then return end
			v:Fire("Close")
			if ent:VisibleVec(v:GetPos() +v:GetForward() *40) then
				self:SetPos(v:GetPos() +v:GetForward() *-40 +v:GetUp() *-55)
			else
				self:SetPos(v:GetPos() +v:GetForward() *40 +v:GetUp() *-55)
			end
			local t = math.Rand(1,3)
			local ti = math.Rand(0.5,2)
			if self:Visible(ent) then
				if ent:IsPlayer() then
					util.ShakeWorld(ent:GetPos(),16,ti,40,false)
					ent:CPT_Freeze(true)
					ent:SetNWBool("CPTBase_SCP303",true)
					timer.Simple(ti,function() if IsValid(ent) then ent:SetNWBool("CPTBase_SCP303",false); ent:EmitSound("cpthazama/scp/D9341/breath1.mp3",55,100) ent:CPT_Freeze(false) end end)
					ent:EmitSound("cpthazama/scp/D9341/Heartbeat.mp3",30,110)
					ent:EmitSound("cpthazama/scp/music/Horror15.mp3",0.2,105)
					ent:ChatPrint("SCP-303's presence sends your whole body into complete shock")
				else
					ent:CPT_Freeze(ti)
				end
			end
			-- self:SetPos(v:GetPos() +v:GetRight() *40)
			-- if self:Visible(ent) then
				-- self:SetPos(v:GetPos() +v:GetRight() *-40)
			-- end
			table.Empty(tbp)
			self.NextDoorT = CurTime() +t
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink_Disabled()
	if CurTime() > self.NextIdleLoopT then
		self.IdleLoop:Stop()
		self.IdleLoop:Play()
		self.NextIdleLoopT = CurTime() +3
	end
	if CurTime() > self.NextBreathLoopT then
		self.BreathLoop:Stop()
		self.BreathLoop:Play()
		self.NextBreathLoopT = CurTime() +3.85
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleLoop:Stop()
	self.BreathLoop:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakePain(dmg,dmginfo,hitbox)
	local ent
	if dmg:GetAttacker():IsValid() then
		ent = dmg:GetAttacker()
		if ent:IsNPC() || ent:IsPlayer() then
			if math.random(1,5) == 1 then
				ent:Kill()
				if ent:IsPlayer() then
					ent:EmitSound("cpthazama/scp/music/Horror14.mp3",0.2,105)
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:CPT_StopCompletely()
	self:CPT_PlayAnimation("Attack",2)
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