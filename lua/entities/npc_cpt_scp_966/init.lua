if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/966.mdl"}
ENT.StartHealth = 1500
ENT.CanMutate = false
ENT.CollisionBounds = Vector(13,13,70)

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 60
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 20

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["Idle"] = {"cpthazama/scp/966/Idle1.mp3","cpthazama/scp/966/Idle2.mp3","cpthazama/scp/966/Idle3.mp3"},
	["Echo"] = {"cpthazama/scp/966/Echo1.mp3","cpthazama/scp/966/Echo2.mp3","cpthazama/scp/966/Echo3.mp3"},
	["Strike"] = {"cpthazama/scp/D9341/Damage4.mp3"},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.NextEchoT = 0
	self:DrawShadow(false)
	self.IdleLoop = CreateSound(self,self:SelectFromTable(self.tbl_Sounds["Echo"]))
	self.IdleLoop:SetSoundLevel(90)
	self.NextDoorT = 0
	self:SetNoDraw(true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "mattack") then
		self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
		return true
	end
	if(event == "emit") then
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
	self:RemoveAllDecals()
	for _,v in ipairs(ents.GetAll()) do
		if ((v:IsNPC() && v != self && self:Disposition(v) != D_LI) || (GetConVarNumber("ai_ignoreplayers") == 0 && v:IsPlayer() && v.IsPossessing == false && v != self.Possessor)) && v:Visible(self) then
			if self:GetClosestPoint(v) < 500 then
				if v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 then
					if v.CPTBase_SCP966_ChatT == nil then v.CPTBase_SCP966_ChatT = 0 end
					local rand = math.random(1,3)
					if CurTime() > v.CPTBase_SCP966_ChatT then
						if rand == 1 then
							v:ChatPrint("You feel like something is in the room with you.")
						elseif rand == 2 then
							v:ChatPrint("You feel something breathing on you.")
						else
							v:ChatPrint("You feel something is watching you.")
						end
						v.CPTBase_SCP966_ChatT = CurTime() +math.Rand(12,20)
					end
				end
				if GetConVarNumber("cpt_scp_realistic966") == 0 then
					self:SetNoDraw(false)
				end
			else
				self:SetNoDraw(true)
			end
		end
	end
	local selectedecho = nil
	if CurTime() > self.NextEchoT then
		selectedecho = self:SelectFromTable(self.tbl_Sounds["Echo"])
		self.IdleLoop = CreateSound(self,selectedecho)
		self.IdleLoop:SetSoundLevel(95)
		self.IdleLoop:Stop()
		self.IdleLoop:Play()
		self.NextEchoT = CurTime() +SoundDuration(selectedecho) +0.1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleLoop:Stop()
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