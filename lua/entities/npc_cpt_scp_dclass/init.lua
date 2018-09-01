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
function ENT:OnInputAccepted(event,activator)
	if CurTime() > self.NextUseT && self.FriendlyToPlayers then
		if event == "Use" && activator:IsPlayer() && activator:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 then
			if self.FollowingOwner == NULL then
				self.IsOwned = true
				self.FollowingOwner = activator
				activator:ChatPrint("This Class-D Subject will now follow you.")
				self.MinFollowDistance = math.random(120,200)
				self.CanWander = false
			elseif self.FollowingOwner != NULL && activator == self.FollowingOwner then
				self.IsOwned = false
				self.FollowingOwner = NULL
				activator:ChatPrint("This Class-D Subject will no longer follow you.")
				self.CanWander = true
			end
		end
		self.NextUseT = CurTime() +0.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FaceOwner(owner)
	self:SetTarget(owner)
	local facetarget = ai_sched_cpt.New("cptbase_scp_faceowner")
	facetarget:EngTask("TASK_FACE_TARGET",0)
	self:StartSchedule(facetarget)
	self:LookAtPosition(self:FindCenter(owner),self.DefaultPoseParameters,self.DefaultPoseParamaterSpeed)
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
	if self.IsPossessed == false then
		if self.IsOwned && self.FollowingOwner != NULL then
			local dist = self:GetClosestPoint(self.FollowingOwner)
			if self:Disposition(self.FollowingOwner) != D_LI then
				self.IsOwned = false
				self.FollowingOwner = NULL
			end
			if dist > 3000 then
				self.IsOwned = false
				self.FollowingOwner:ChatPrint("You left behind a Class-D Subject.")
				self.FollowingOwner = NULL
			end
			if dist > self.MinFollowDistance && self:CanPerformProcess() then
				self:ChaseTarget(self.FollowingOwner,false)
			end
			if !IsValid(self:GetEnemy()) then
				if dist <= self.MinFollowDistance && self.FollowingOwner:Visible(self) then
					self:StopCompletely()
					self:FaceOwner(self.FollowingOwner)
				end
			else
				if dist <= self.MinFollowDistance && (self:GetEnemy():GetClass() == "npc_cpt_scp_173" || self:GetEnemy():GetClass() == "npc_cpt_scp_087_b") && self:GetEnemy():Visible(self) then
					if self:IsMoving() then
						self:StopCompletely()
					end
					self:FaceEnemy()
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if self.IsOwned then return end
	if(disp == D_HT) then
		if enemy:GetClass() == "npc_cpt_scp_173" then
			self:FaceEnemy()
		else
			if self:CanPerformProcess() then
				self:Hide()
			end
		end
	end
end