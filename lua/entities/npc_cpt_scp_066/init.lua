if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/066.mdl"}
ENT.StartHealth = 300
ENT.CanMutate = false
ENT.CollisionBounds = Vector(8,8,15)
ENT.DeathRagdollType = "prop_physics"

ENT.Faction = "FACTION_NONE"

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
}

ENT.tbl_Sounds = {
	["Idle"] = {"cpthazama/scp/066/Eric1.wav","cpthazama/scp/066/Eric2.wav","cpthazama/scp/066/Eric3.wav"},
	["OnIdle"] = {"cpthazama/scp/066/Notes1.wav","cpthazama/scp/066/Notes2.wav","cpthazama/scp/066/Notes3.wav","cpthazama/scp/066/Notes4.wav","cpthazama/scp/066/Notes5.wav","cpthazama/scp/066/Notes6.wav"},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_TINY)
	self:SetMovementType(MOVETYPE_STEP)
	self:SetModelScale(1.5,0)
	self.IdleMoveSound = CreateSound(self,"cpthazama/scp/066/Rolling.wav")
	self.IdleMoveSound:SetSoundLevel(75)
	self.NextIdleLoopT = 0
	self.SelectedTarget = NULL
	self.LastSelectedTarget = NULL
	self.NextEarRapeT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDoIdle() self:PlaySound("OnIdle",75) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if !self.IsPossessed then
		if CurTime() > self.NextEarRapeT && math.random(1,10) == 1 then
			local tb = {}
			for _,v in ipairs(ents.FindInSphere(self:GetPos(),500)) do
				if v:IsValid() && ((v:IsNPC() && v != self && v:GetClass() != self:GetClass()) || (v:IsPlayer() && v:Alive() && GetConVarNumber("ai_ignoreplayers") == 0)) then
					table.insert(tb,v)
				end
			end
			for _,v in ipairs(tb) do
				self.SelectedTarget = self:GetClosestEntity(tb)
			end
			self.NextEarRapeT = CurTime() +math.Rand(25,40)
		end
		if self.SelectedTarget != NULL && self.LastSelectedTarget != self.SelectedTarget then
			self:ChaseTarget(self.SelectedTarget)
			self.CanWander = false
			-- self.LastSelectedTarget = self.SelectedTarget
			if self:GetClosestPoint(self.SelectedTarget) <= 50 then
				sound.Play("cpthazama/scp/066/Beethoven.wav",self:GetPos(),160,100)
				util.ShakeWorld(self:GetPos(),16,23,1500)
				self.SelectedTarget = NULL
				for _,v in ipairs(ents.FindInSphere(self:GetPos(),500)) do
					if v:IsValid() && ((v:IsNPC() && v != self && v:GetClass() != self:GetClass()) || (v:IsPlayer() && v:Alive() && GetConVarNumber("ai_ignoreplayers") == 0)) then
						v:SetLocalVelocity(Vector(0,0,350))
					end
				end
				self.CanWander = true
			end
		end
	end
	if CurTime() > self.NextIdleLoopT && self:IsMoving() then
		self.IdleMoveSound:Stop()
		self.IdleMoveSound:Play()
		self.NextIdleLoopT = CurTime() +4
	elseif !self:IsMoving() then
		self.IdleMoveSound:Stop()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Primary(possessor)
	if CurTime() > self.NextEarRapeT then
		sound.Play("cpthazama/scp/066/Beethoven.wav",self:GetPos(),160,100)
		util.ShakeWorld(self:GetPos(),16,23,1500)
		self.SelectedTarget = NULL
		for _,v in ipairs(ents.FindInSphere(self:GetPos(),500)) do
			if v:IsValid() && ((v:IsNPC() && v != self && v:GetClass() != self:GetClass()) || (v:IsPlayer() && v:Alive() && GetConVarNumber("ai_ignoreplayers") == 0)) then
				v:SetLocalVelocity(Vector(0,0,350))
			end
		end
		self.NextEarRapeT = CurTime() +math.Rand(25,30)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end