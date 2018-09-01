if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/008.mdl"}
ENT.StartHealth = 10000
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(28,33,45)

ENT.Faction = "FACTION_NONE"
ENT.MaxInfectionDistance = 948

ENT.Bleeds = false
ENT.TurnsOnDamage = false
ENT.IsEssential = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_LARGE)
	self:SetMovementType(MOVETYPE_NONE)
	-- self:SetModelScale(1.8,0)
	self.Possessor_CanMove = false
	self.IdleLoop = CreateSound(self,"ambient/gas/steam2.wav")
	self.IdleLoop:SetSoundLevel(60)
	self.MachineLoop = CreateSound(self,"ambient/machines/machine3.wav")
	self.MachineLoop:SetSoundLevel(70)
	self.NextIdleLoopT = 0
	self.IsActivated = false
	self.InfectionDistance = 100
	self.InfectionIncrease = 100
	self.NextChangeDistT = 0
	self.NextUseT = CurTime() +3
	self.Particle = NULL
	self:UseLids("close")
	self:StartMachine()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseLids(act)
	if act == "open" then
		self:SetBodygroup(1,0)
	elseif act == "close" then
		self:SetBodygroup(1,1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMachine()
	self.MachineLoop:Stop()
	self.MachineLoop:Play()
	timer.Simple(2,function()
		if IsValid(self) then
			self.IsActivated = true
			self:EmitSound(Sound("physics/metal/soda_can_impact_soft2.wav",70,100))
			if IsValid(self.particle_whitesmoke) then
				self.particle_whitesmoke:Fire("Start","",0)
			else
				self.particle_whitesmoke = ents.Create("info_particle_system")
				self.particle_whitesmoke:SetKeyValue("effect_name","Advisor_Pod_Steam_Continuous")
				self.particle_whitesmoke:SetPos(self:GetAttachment(self:LookupAttachment("008")).Pos)
				self.particle_whitesmoke:SetAngles(self:GetAttachment(self:LookupAttachment("008")).Ang)
				self.particle_whitesmoke:SetParent(self)
				self.particle_whitesmoke:Spawn()
				self.particle_whitesmoke:Activate()
				self.particle_whitesmoke:Fire("Start","",0)
				self.particle_whitesmoke:DeleteOnRemove(self)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInputAccepted(event,activator)
	if CurTime() > self.NextUseT then
		if event == "Use" && IsValid(activator) && activator:IsPlayer() && activator:Alive() then
			if self.IsActivated then
				activator:ChatPrint("You close the lids on the machine.")
				self:EmitSound(Sound("ambient/machines/spindown.wav",70,100))
				self:EmitSound(Sound("physics/metal/soda_can_impact_soft2.wav",70,100))
				self.MachineLoop:Stop()
				self.IsActivated = false
			else
				activator:ChatPrint("You open the lids on the machine.")
				self:StartMachine()
			end
		end
		self.NextUseT = CurTime() +2.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.IsActivated then
		self:UseLids("open")
		if CurTime() > self.NextIdleLoopT then
			self.IdleLoop:Stop()
			self.IdleLoop:Play()
			self.InfectionIncrease = math.Rand(85,115)
			self.IdleLoop:ChangePitch(self.InfectionIncrease)
			self.NextIdleLoopT = CurTime() +math.Rand(5,8)
		end
		if self.InfectionDistance <= self.MaxInfectionDistance && CurTime() > self.NextChangeDistT then
			self.InfectionDistance = self.InfectionDistance +math.Round(self.InfectionIncrease *0.03)
			self.NextChangeDistT = CurTime() +0.5
		end
		for _,v in ipairs(ents.FindInSphere(self:GetPos(),self.InfectionDistance)) do
			if IsValid(v) && v != self && v:GetClass() != self:GetClass() && (v:IsNPC() || (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0)) then
				if v:IsNPC() && v.Faction != "FACTION_SCP" then
					self:Infect(v)
				end
				if v:IsPlayer() && self:Disposition(v) != D_LI && v.Faction != "FACTION_SCP" then
					self:Infect(v)
				end
			end
		end
	else
		self:UseLids("close")
		self.IdleLoop:Stop()
		if IsValid(self.particle_whitesmoke) then
			self.particle_whitesmoke:Fire("Stop","",0)
		end
		self.InfectionDistance = 100
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Infect(v)
	if v.SCP_Infected_008 != true then
		v.SCP_Infected_008 = true
		v:EmitSound("cpthazama/scp/008/Voices0.mp3",50,100)
		if v:IsPlayer() then
			v:ChatPrint("You notice the air feels a bit strange..")
		end
		local deaths
		if v:IsPlayer() then
			deaths = v:Deaths()
		end
		local time = GetConVarNumber("cpt_scp_008infectiontime")
		timer.Simple(time /3,function()
			if v:IsValid() && v.SCP_Infected_008 then
				if v:IsPlayer() && v:Deaths() > deaths then return end
				v:EmitSound("cpthazama/scp/008/Voices5.mp3",50,100)
				if v:IsPlayer() then
					v:ChatPrint("You start to feel dizzy..")
				end
			end
		end)
		timer.Simple(time /2,function()
			if v:IsValid() && v.SCP_Infected_008 then
				if v:IsPlayer() && v:Deaths() > deaths then return end
				v:EmitSound("cpthazama/scp/008/Voices1.mp3",50,100)
				if v:IsPlayer() then
					v:ChatPrint("You have an unsationable urge to eat flesh..")
				end
			end
		end)
		timer.Simple(time,function()
			if v:IsValid() && v.SCP_Infected_008 then
				if v:IsPlayer() && v:Deaths() > deaths then return end
				local zombie = ents.Create("npc_cpt_scp_008_1")
				zombie:SetPos(v:GetPos())
				zombie:SetAngles(v:GetAngles())
				zombie:Spawn()
				zombie:SetColor(v:GetColor())
				zombie:SetMaterial(v:GetMaterial())
				zombie:SetModelScale(v:GetModelScale(),0)
				if v:IsPlayer() then
					CreateUndo(zombie,v:Nick() .. " (008 Instance)",v)
				else
					undo.ReplaceEntity(v,zombie)
				end
				if v:IsPlayer() then
					v:Kill()
					v.CPTBase_SCP_Zombie = zombie
				else
					gamemode.Call("OnNPCKilled",v,self,self)
					v:Remove()
				end
				if v:IsPlayer() then
					v:GetRagdollEntity():Remove()
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleLoop:Stop()
	self.MachineLoop:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end