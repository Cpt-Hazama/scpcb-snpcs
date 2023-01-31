if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/035.mdl"}
ENT.StartHealth = 500
ENT.CanMutate = false
ENT.CollisionBounds = Vector(18,18,70)
ENT.Faction = "FACTION_SCP"

ENT.SummonAttackDistance = 400

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Summon"] = {ACT_SPECIAL_ATTACK1},
}

ENT.tbl_Sounds = {
	["Idle"] = {"cpthazama/scp/035/Idle3.mp3","cpthazama/scp/035/Idle4.mp3","cpthazama/scp/035/Idle5.mp3","cpthazama/scp/035/Idle6.mp3","cpthazama/scp/035/Idle7.mp3"},
	["Alert"] = {"cpthazama/scp/035/GasedKilled1.mp3"},
	["Pain"] = {"cpthazama/scp/D9341/breath0.mp3","cpthazama/scp/D9341/breath1.mp3","cpthazama/scp/D9341/breath2.mp3","cpthazama/scp/D9341/breath3.mp3","cpthazama/scp/D9341/breath4.mp3"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.TentacleAmount = 0
	self.NextSummonT = 0
	self.tbl_Tentacles = {}
	self.NextDoorT = 0
	self:EmitSound("cpthazama/scp/035/GetUp.mp3",85,100)
	timer.Simple(0.02,function()
		if IsValid(self) then
			self:CPT_PlaySequence("standup",1)
		end
	end)
	if SERVER then
		local fx_light = ents.Create("light_dynamic")
		fx_light:SetKeyValue("brightness","1")
		fx_light:SetKeyValue("distance","200")
		fx_light:SetLocalPos(self:GetPos() +self:GetUp() *20)
		fx_light:Fire("Color","220 0 255")
		fx_light:SetParent(self)
		fx_light:Spawn()
		fx_light:Activate()
		fx_light:Fire("TurnOn","",0)
		fx_light:Fire("Kill","",1.8)
		self:DeleteOnRemove(fx_light)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanSummon()
	if self.TentacleAmount < 9 then
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "sattack") then
		if arg1 == "summon" then
			for i = 1,3 do
				if self.TentacleAmount >= 9 then return true end
				local tentacle = ents.Create("npc_cpt_scp_035_tentacle")
				tentacle:CPT_SetClearPos(self:GetPos() +self:GetRight() *math.random(-150,150) +self:GetForward() *math.random(-150,150))
				tentacle.TentacleOwner = self
				tentacle:Spawn()
				tentacle:Activate()
				self.TentacleAmount = self.TentacleAmount +1
				table.insert(self.tbl_Tentacles,tentacle)
				timer.Simple(60,function()
					if tentacle:IsValid() then
						tentacle:Remove()
					end
				end)
				function tentacle:OnDeath(dmg,dmginfo,hitbox)
					if self.TentacleOwner != nil && IsValid(self.TentacleOwner) then
						self.TentacleOwner.TentacleAmount = self.TentacleOwner.TentacleAmount -1
					end
				end
			end
		end
		return true
	end
	if(event == "emit") then
		if arg1 == "step" then
			self:CPT_PlaySound("FootStep",45,90,250,true)
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	for _,v in ipairs(self.tbl_Tentacles) do
		if IsValid(v) then
			v:Remove()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if CurTime() > self.NextSummonT then
		if self:CanPerformProcess() == false then return end
		if !self.IsPossessed && (IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
		if !self:CanSummon() then return end
		self:CPT_StopCompletely()
		self:CPT_PlayAnimation("Summon",2)
		self.NextSummonT = CurTime() +math.Rand(15,30)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if(disp == D_HT) then
		if nearest <= self.SummonAttackDistance && self:CPT_FindInCone(enemy,self.MeleeAngle) then
			self:DoAttack()
		end
		if self:CanPerformProcess() then
			self:Hide()
		end
	end
end