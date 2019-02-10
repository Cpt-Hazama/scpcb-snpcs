if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/dclass.mdl"}
ENT.StartHealth = 60
ENT.CollisionBounds = Vector(18,18,70)
ENT.Faction = "FACTION_PLAYER"
ENT.FriendlyToPlayers = true

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
}

ENT.tbl_Sounds = {
	["Alert"] = {"cpthazama/scp/dclass/DontLikeThis.mp3"},
	["Pain"] = {"cpthazama/scp/D9341/breath0.mp3","cpthazama/scp/D9341/breath1.mp3","cpthazama/scp/D9341/breath2.mp3","cpthazama/scp/D9341/breath3.mp3","cpthazama/scp/D9341/breath4.mp3"},
	["Death"] = {"cpthazama/scp/dclass/Gasp.mp3"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self:SetSkin(math.random(0,2))
	self.NextDoorT = 0
	self.NextUseT = 0
	self.IsOwned = false
	self.FollowingOwner = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFollowAI(owner,dist)
	if IsValid(self:GetEnemy()) then
		if string.find(self:GetEnemy():GetClass(),"173") && dist < 400 && self:GetEnemy():Visible(self) then
			self:SetAngles(Angle(0,(self:GetEnemy():GetPos() -self:GetPos()):Angle().y,0))
		end
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
function ENT:SelectSchedule(bSchedule)
	if self.IsDead == true then return end
	if self.bInSchedule == true then return end
	if self.IsPlayingSequence == true then return end
	if self.IsPossessed == false && !self.IsPlayingSequence && self.CanWander then
		if !IsValid(self:GetEnemy()) then
			if self.WanderChance != 0 && math.random(1,self.WanderChance) == 1 then
				self:TASKFUNC_WANDER()
				self:SetMovementAnimation("Walk")
				self:OnDoIdle()
			end
		else
			if self:GetEnemy():GetClass() == "npc_cpt_scp_scientist" then
				if self.WanderChance != 0 && math.random(1,self.WanderChance) == 1 then
					self:TASKFUNC_WANDER()
					self:SetMovementAnimation("Walk")
					self:OnDoIdle()
				end
			end
		end
	end
	-- self:PlayerChat(tostring(self.EnemyMemoryCount))
	if(self.EnemyMemoryCount == 0) then
		if(self:GetState() == NPC_STATE_ALERT) then
			self:OnAreaCleared()
			self:SetState(NPC_STATE_IDLE)
		end
	end
	self:StartIdleAnimation()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if self.IsOwned then return end
	if(disp == D_HT) then
		if !self.IsFollowingAPlayer && string.find(enemy:GetClass(),"173") then
			self:FaceEnemy()
		else
			if self:CanPerformProcess() then
				if enemy:GetClass() == "npc_cpt_scp_scientist" then return end
				self:Hide()
			end
		end
	end
end