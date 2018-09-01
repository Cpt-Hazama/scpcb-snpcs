if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/939.mdl"}
ENT.StartHealth = 1500
ENT.CanMutate = false

ENT.Faction = "FACTION_SCP"
ENT.ViewAngle = 160
ENT.MonsterType = 0

ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 110
ENT.MeleeAttackType = DMG_CRUSH
ENT.MeleeAttackDamage = 90
ENT.AttackFinishTime = 0.4

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {"cptges_attack"},
}

ENT.tbl_Sounds = {
	["FootStep"] = {"cpthazama/scp/049/Step1.mp3","cpthazama/scp/049/Step2.mp3","cpthazama/scp/049/Step3.mp3"},
	["HearSound"] = {"cpthazama/scp/939/0Alert1.mp3","cpthazama/scp/939/0Alert2.mp3","cpthazama/scp/939/0Alert3.mp3"},
	["Idle"] = {
		"cpthazama/scp/939/0Lure1.mp3",
		"cpthazama/scp/939/0Lure2.mp3",
		"cpthazama/scp/939/0Lure3.mp3",
		"cpthazama/scp/939/0Lure4.mp3",
		"cpthazama/scp/939/0Lure5.mp3",
		"cpthazama/scp/939/0Lure6.mp3",
		"cpthazama/scp/939/0Lure7.mp3",
		"cpthazama/scp/939/0Lure8.mp3",
		"cpthazama/scp/939/0Lure9.mp3",
	},
	["Voice_Random"] = {"vo/npc/male01/overhere01.wav","vo/npc/male01/onyourside.wav","vo/npc/male01/question06.wav","vo/npc/male01/question09.wav","vo/npc/male01/question11.wav","vo/npc/male01/question23.wav","vo/npc/male01/question25.wav","vo/npc/male01/squad_reinforce_single04.wav","vo/npc/male01/stopitfm.wav","vo/npc/male01/vquestion01.wav"},
	["Strike"] = {"cpthazama/scp/D9341/Damage4.mp3"},
	["Crunch"] = {"physics/body/body_medium_break2.wav"},
	["Spot"] = {"cpthazama/scp/939/0Attack1.mp3","cpthazama/scp/939/0Attack2.mp3","cpthazama/scp/939/0Attack3.mp3"},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.NextDoorT = 0
	self.ViewDistance = GetConVarNumber("cpt_scp_939viewdistance")
	if GetConVarNumber("cpt_scp_939smallcollision") == 1 then
		self.CollisionBounds = Vector(0,0,0)
	else
		self:SetCollisionBounds(Vector(65,48,55),-(Vector(65,48,0))) // Should fix getting stuck
	end
	self.NextHearSoundT = CurTime()
	self.NextSpotSoundT = CurTime() +0.5
	self.NextVoiceSoundT = CurTime()
	if GetConVarNumber("cpt_scp_939slsounds") == 1 then
		self.tbl_Sounds["Attack"] = {"cpthazama/scp/939/SL_Attack1.mp3","cpthazama/scp/939/SL_Attack2.mp3","cpthazama/scp/939/SL_Attack3.mp3"}
	else
		self.tbl_Sounds["Attack"] = {}
	end
	self:SetSkin(self.MonsterType)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	possessor:ChatPrint("Possessor Controls:")
	possessor:ChatPrint("LMB - Attack")
	possessor:ChatPrint("RMB - Emit a default voice")
	possessor:ChatPrint("Reload - Emit a random Half-Life 2 voice")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Secondary(possessor)
	if CurTime() > self.NextHearSoundT then
		self:PlaySound("Idle",75)
		self.NextHearSoundT = CurTime() +5
		if self.CurrentSound != nil then
			self.NextHearSoundT = CurTime() +SoundDuration(self.CurrentPlayingSound)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Reload(possessor)
	if CurTime() > self.NextHearSoundT then
		self:PlaySound("Voice_Random",75)
		self.NextHearSoundT = CurTime() +5
		if self.CurrentSound != nil then
			self.NextHearSoundT = CurTime() +SoundDuration(self.CurrentPlayingSound)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnHitEntity(hitents,hitpos)
	for _,v in ipairs(hitents) do
		v:EmitSound(self:SelectFromTable(self.tbl_Sounds["Crunch"]),90,100)
		if v:IsPlayer() then
			v:SetDSP(32,false)
			v:Freeze(true)
			timer.Simple(0.6,function() if IsValid(v) then v:Freeze(false) end end)
			ParticleEffect("blood_impact_red_01",v:GetAttachment(v:LookupAttachment("eyes")).Pos,Angle(math.random(0,360),math.random(0,360),math.random(0,360)),false)
		end
	end
	self:EmitSound(self:SelectFromTable(self.tbl_Sounds["Strike"]),90,100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LocateEnemies()
	if self.Faction == "FACTION_NONE" || self.CanSetEnemy == false then return end
	for _,v in ipairs(ents.FindInSphere(self:GetPos(),self.FindEntitiesDistance)) do
		if v:IsNPC() && v != self && v:Health() > 0 then
			if (v:IsMoving() && self:CanSeeEntities(v) && self:FindInCone(v,self.ViewAngle)) && v.Faction != "FACTION_NONE" && self:CanSetAsEnemy(v) then
				if ((v:GetFaction() == nil or v:GetFaction() != nil) && v.Faction != self:GetFaction()) && self:Disposition(v) != D_LI && !table.HasValue(self.tblBlackList,v) then
					return v
				end
			end
		elseif self.FriendlyToPlayers == false && GetConVarNumber("ai_ignoreplayers") == 0 && v:IsPlayer() && v:Alive() && !v.IsPossessing && v != self.Possessor then
			if ((v:GetVelocity():Length() > 5 && v:GetVelocity().z <= 0) && self:CanSeeEntities(v) && self:FindInCone(v,self.ViewAngle)) && v.IsPossessing != true && v.Faction != "FACTION_NONE" then
				if self:GetFaction() != "FACTION_PLAYER" && self.Faction != v.Faction && self:Disposition(v) != D_LI && !table.HasValue(self.tblBlackList,v) then
					return v
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnHearSound(ent)
	if !self.IsPossessed then
		self:SetLastPosition(ent:GetPos())
		self:TASKFUNC_WALKLASTPOSITION()
	end
	if CurTime() > self.NextHearSoundT then
		self:PlaySound("HearSound",78)
		self.NextHearSoundT = CurTime() +5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnEnemyChanged(ent)
	if IsValid(ent) then
		if ent:Health() <= 0 then return end
		if !ent:Visible(self) then return end
		if self.NextSpotSoundT == nil then
			self.NextSpotSoundT = CurTime() +1
		end
		if CurTime() > self.NextSpotSoundT then
			if ent:IsPlayer() then ent:SendLua("surface.PlaySound('cpthazama/scp/939/attack.mp3')") end
			self:PlaySound("Spot",80)
			self.NextSpotSoundT = CurTime() +5
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.IsPossessed then
		self.NextIdleSoundT = CurTime() +15
	end
	if self.NextSpotSoundT == nil then
		self.NextSpotSoundT = CurTime() +1
	end
	if self.NextDoorT == nil then
		self.NextDoorT = CurTime() +1
	end
	if self.NextHearSoundT == nil then
		self.NextHearSoundT = CurTime() +1
	end
	if self.NextVoiceSoundT == nil then
		self.NextVoiceSoundT = CurTime() +1
	end
	for _,v in ipairs(player.GetAll()) do
		if (GetConVarNumber("ai_ignoreplayers") == 0 && v.IsPossessing == false && v != self.Possessor) && !v:Visible(self) then
			if self:GetClosestPoint(v) < 1000 then
				if v.CPTBase_SCP939_ChatT == nil then v.CPTBase_SCP939_ChatT = 0 end
				local rand = math.random(1,3)
				if CurTime() > v.CPTBase_SCP939_ChatT then
					if rand == 1 then
						v:ChatPrint("You feel an odd feeling..almost like..nostalgia..")
					elseif rand == 2 then
						v:ChatPrint("This strange feeling..you feel like you should go towards the source..")
					else
						v:ChatPrint('"Have I been here before?"')
					end
					v.CPTBase_SCP939_ChatT = CurTime() +math.Rand(12,20)
				end
			end
		end
	end
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
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "mattack") then
		self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
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
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	if GetConVarNumber("cpt_scp_939slsounds") == 1 then
		self:PlaySound("Attack",75)
	end
	self:PlayNPCGesture("attack",2,1)
	self.IsAttacking = true
	timer.Simple(self.AttackFinishTime,function()
		if self:IsValid() then
			self.IsAttacking = false
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if(disp == D_HT) then
		if nearest <= self.MeleeAttackDistance && self:FindInCone(enemy,self.MeleeAngle) then
			self:DoAttack()
		end
		if self:CanPerformProcess() then
			self:ChaseEnemy()
		end
	end
end