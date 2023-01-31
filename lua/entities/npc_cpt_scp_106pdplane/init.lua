if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/106_pdplane.mdl"}
ENT.StartHealth = 500
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(412,1050,5)
ENT.FlyUpOnSpawn = false
ENT.MaxTurnSpeed = 10

ENT.Faction = "FACTION_SCP"

ENT.Bleeds = true
ENT.BloodEffect = {"blood_impact_black"}
ENT.TurnsOnDamage = false
ENT.CheckForwardDistance = 2500
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_LARGE)
	self:SetFlySpeed(200)
	self:SetMovementType(MOVETYPE_FLY)
	self.Possessor_CanMove = false
	-- self.IdleLoop = CreateSound(self,"cpthazama/scp/106/TrenchPlane.mp3") // 27
	self.IdleLoop = CreateSound(self,"cpthazama/scp/106/plane_loop.mp3")
	self.IdleLoop:SetSoundLevel(160)
	self.NextIdleLoopT = 0
	self.NextDamageT = 0
	self.tbl_Drain = {}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanBeSeenByPlane(v)
	if (v:IsNPC() && v != self || (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0)) && self:Disposition(v) != D_LI && self:Visible(v) && (v.Faction != self.Faction && v.Faction != "FACTION_NONE") then
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaneAI()
	if self:DoCustomTrace(self:GetPos() +self:OBBCenter(),self:GetPos() +self:OBBCenter() +self:GetUp() *-1000,{self},true).Hit then
		self:SetLocalVelocity(((Vector(0,0,0) +self:GetUp() *1) +self:GetVelocity():GetNormal()) *self:GetFlySpeed())
	end
	if self:DoCustomTrace(self:GetPos() +self:OBBCenter(),self:GetPos() +self:OBBCenter() +self:GetUp() *400,{self},true).Hit then
		self:SetLocalVelocity(((Vector(0,0,0) +self:GetUp() *-1) +self:GetVelocity():GetNormal()) *self:GetFlySpeed())
	end
	local vel = self:GetForward() *1
	if !self:DoCustomTrace(self:GetPos() +self:OBBCenter(),self:GetPos() +self:OBBCenter() +self:GetForward() *self.CheckForwardDistance,{self},true).Hit then
		vel = self:GetForward() *1
	elseif self:DoCustomTrace(self:GetPos() +self:OBBCenter(),self:GetPos() +self:OBBCenter() +self:GetForward() *self.CheckForwardDistance,{self},true).Hit then
		vel = self:GetForward() *1
		if !self:DoCustomTrace(self:GetPos() +self:OBBCenter(),self:GetPos() +self:OBBCenter() +self:GetRight() *self.CheckForwardDistance,{self},true).Hit then
			-- vel = self:GetRight() *1
			self:CPT_TurnToDegree(self:GetMaxYawSpeed(),self:GetPos() +self:GetRight() *self.CheckForwardDistance,true,42)
		else
			-- vel = self:GetRight() *-1
			self:CPT_TurnToDegree(self:GetMaxYawSpeed(),self:GetPos() +self:GetRight() *-self.CheckForwardDistance,true,42)
		end
	end
	self:SetLocalVelocity(((Vector(0,0,0) +vel) +self:GetVelocity():GetNormal()) *self:GetFlySpeed())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SapHealth()
	for _,v in ipairs(ents.GetAll()) do
		if self:CanBeSeenByPlane(v) then
			self:SetSkin(1)
			if v:IsPlayer() then
				v:SetEyeAngles((self:GetPos() -v:GetShootPos()):Angle())
				if !table.HasValue(self.tbl_Drain,v) then
					table.insert(self.tbl_Drain,v)
				end
				-- if v:GetNWBool("SCP_IsBeingDrained") == false then
					-- v:SetNWBool("SCP_IsBeingDrained",true)
					-- v:ConCommand("cpt_scp_toggleplanevision")
				-- end
			end
			if CurTime() > self.NextDamageT then
				v:TakeDamage(1,self)
				self:SetHealth(self:Health() +1)
				self.NextDamageT = CurTime() +0.01
			end
		else
			-- for _,v in ipairs(self.tbl_Drain) do
				-- if IsValid(v) && !self:CanBeSeenByPlane(v) && v:GetNWBool("SCP_IsBeingDrained") then
					-- v:ConCommand("cpt_scp_toggleplanevision")
				-- end
			-- end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self:RemoveAllDecals()
	if CurTime() > self.NextIdleLoopT then
		self.IdleLoop:Stop()
		self.IdleLoop:Play()
		self.NextIdleLoopT = CurTime() +11.5
		util.ShakeWorld(self:GetPos(),16,26,3000,false)
	end
	if IsValid(self:GetEnemy()) then
		self:SetSkin(1)
	else
		self:SetSkin(0)
	end
	self:SapHealth()
	self:PlaneAI()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleLoop:Stop()
	-- for _,v in ipairs(self.tbl_Drain) do
		-- if IsValid(v) && v:GetNWBool("SCP_IsBeingDrained") then
			-- v:SetNWBool("SCP_IsBeingDrained",false)
			-- v:ConCommand("cpt_scp_toggleplanevision")
		-- end
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleFlying(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end