if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/012.mdl"}
ENT.StartHealth = 200
ENT.CanMutate = false
ENT.CollisionBounds = Vector(8,8,12)
ENT.CanWander = false
ENT.WanderChance = 0

ENT.Faction = "FACTION_SCP"
ENT.Bleeds = false
ENT.ReactsToSound = false
ENT.HasDeathRagdoll = false
ENT.TurnsOnDamage = false

ENT.IdleSoundVolume = 100
ENT.IdleSoundChanceA = 8
ENT.IdleSoundChanceB = 10
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_TINY)
	self:SetMovementType(MOVETYPE_NONE)
	self.NextDamageT = 0
	self.NextSkinT = 0
	self.IdleLoop = CreateSound(self,"cpthazama/scp/music/012Golgotha.mp3")
	self.IdleLoop:SetSoundLevel(80)
	self:SetModelScale(1.5,0)
	self.NextIdleLT = 0
	self.Possessor_CanMove = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if CurTime() > self.NextIdleLT then
		self.IdleLoop:Stop()
		self.IdleLoop:Play()
		self.NextIdleLT = CurTime() +24
	end

	self:NextThink(CurTime() + (0.069696968793869 + FrameTime()))
	
	local tb = {}
	for _,v in pairs(ents.FindInSphere(self:GetPos(),600)) do
		if v:IsValid() && ((v:IsPlayer() && v:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 && v.SCP_Has714 == false) || (v:IsNPC() && v != self && v:Disposition(self) != D_LI)) && v:Visible(self) then
			if v:IsPlayer() then
				local eyeAng = v:EyeAngles()
				v.SCP_012_EyeAng = LerpAngle(FrameTime() *18,v.SCP_012_EyeAng or eyeAng,(self:GetPos() -v:GetShootPos()):Angle())
				v:SetEyeAngles(Angle(v.SCP_012_EyeAng.x,v.SCP_012_EyeAng.y,eyeAng.z))
				if v.SCP_513_CurrentTalk == nil then
					v.SCP_513_CurrentTalk = 1
				end
				if v.SCP_513_NextTalkT == nil then
					v.SCP_513_NextTalkT = 0
				end
				if CurTime() > v.SCP_513_NextTalkT then
					v:EmitSound("cpthazama/scp/012/Speech" .. v.SCP_513_CurrentTalk .. ".mp3",75,100)
					if v.SCP_513_CurrentTalk < 7 then
						v.SCP_513_CurrentTalk = v.SCP_513_CurrentTalk +1
					end
					v:ChatPrint("You dig into your wrist for blood and write on the music sheet..")
					v.SCP_513_NextTalkT = CurTime() +30
				end
				if !table.HasValue(tb,v) then
					table.insert(tb,v)
				end
			else
				v:SetAngles(Angle(0,(self:GetPos() -v:GetPos()):Angle().y,0))
				v:SetLastPosition(self:GetPos())
				v:SetSchedule(SCHED_FORCED_GO)
				if !table.HasValue(tb,v) then
					table.insert(tb,v)
				end
			end
			if CurTime() > self.NextDamageT then
				for _,yesvapitation in ipairs(tb) do
					if yesvapitation == nil then return end
					yesvapitation:TakeDamage(15,self)
					if yesvapitation:GetAttachment(yesvapitation:LookupAttachment("anim_attachment_LH")) != nil then
						CPT_ParticleEffect("blood_impact_red_01",yesvapitation:GetAttachment(yesvapitation:LookupAttachment("anim_attachment_LH")).Pos,angle_0)
					end
				end
				self.NextDamageT = CurTime() +8
			end
			if CurTime() > self.NextSkinT && self:GetSkin(1) < 3 then
				self:SetSkin(self:GetSkin(1) +1)
				self.NextSkinT = CurTime() +20
			end
		end
	end
	for _,yesvapitation in ipairs(tb) do
		if yesvapitation == nil then return end
		if yesvapitation:GetPos():Distance(self:GetPos()) > 600 || !yesvapitation:Visible(self) || (yesvapitation:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 1) then
			tb[yesvapitation] = nil
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleLoop:Stop()
	for _,v in ipairs(player.GetAll()) do
		v.SCP_513_NextTalkT = 0
		v.SCP_513_CurrentTalk = 1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end