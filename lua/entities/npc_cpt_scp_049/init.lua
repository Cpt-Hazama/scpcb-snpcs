if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/049.mdl"}
ENT.StartHealth = 2000
ENT.CanMutate = false
ENT.CollisionBounds = Vector(13,13,70)

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 30
ENT.MeleeAttackDamageDistance = 60
ENT.MeleeAttackType = DMG_DIRECT
ENT.MeleeAttackDamage = 300

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Infect"] = {ACT_SPECIAL_ATTACK1},
}

ENT.tbl_Sounds = {
	["Idle"] = {"cpthazama/scp/049/Detected1.mp3","cpthazama/scp/049/Detected2.mp3","cpthazama/scp/049/Detected3.mp3","cpthazama/scp/049/Detected4.mp3"},
	["Strike"] = {"cpthazama/scp/D9341/Damage1.mp3"},
	["Miss"] = {"common/null.wav"},
	["HearSound"] = {"cpthazama/scp/049/Room2SL1.mp3","cpthazama/scp/049/Room2SL2.mp3"},
	["714"] = {"cpthazama/scp/049/714Equipped.mp3"},
	["Hazmat"] = {"cpthazama/scp/049/TakeOffHazmat.mp3"},
	["Infect"] = {"cpthazama/scp/049/Kidnap1.mp3","cpthazama/scp/049/Kidnap2.mp3"},
	["Alert"] = {
		"cpthazama/scp/049/Greeting1.mp3",
		"cpthazama/scp/049/Greeting2.mp3",
		"cpthazama/scp/049/Spotted1.mp3",
		"cpthazama/scp/049/Spotted2.mp3",
		"cpthazama/scp/049/Spotted3.mp3",
		"cpthazama/scp/049/Spotted4.mp3",
		"cpthazama/scp/049/Spotted5.mp3",
		"cpthazama/scp/049/Spotted6.mp3",
		"cpthazama/scp/049/Spotted7.mp3",
		"cpthazama/scp/049/DetectedInChamber.mp3"
	},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	possessor:ChatPrint("Possessor Controls:")
	possessor:ChatPrint("LMB - Cure the plague")
	possessor:ChatPrint("RMB - Remove SCP-714")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.IdleLoop = CreateSound(self,"cpthazama/scp/049/0492Breath.mp3")
	self.IdleLoop:SetSoundLevel(60)
	-- self.ThemeSong = CreateSound(self,"cpthazama/scp/music/Room049.mp3")
	self.ThemeSong = CreateSound(self,"cpthazama/scp/music/SaveMeFrom.mp3")
	self.ThemeSong:SetSoundLevel(130)
	-- self.ChaseSong = CreateSound(self,"cpthazama/scp/music/049Chase.mp3")
	self.ChaseSong = CreateSound(self,"cpthazama/scp/music/HaveMercyOnMe(NoChoir).mp3")
	self.ChaseSong:SetSoundLevel(140)
	self.TotalInfections = 0
	self.NextIdleLoopT = 0
	self.NextThemeSongT = 0
	self.NextChaseSongT = 0
	self.NextDoorT = 0
	if GetConVarNumber("cpt_scp_049slsounds") == 1 then
		self.tbl_Sounds["FootStep"] = {"cpthazama/scp/049/SCPSL_Footstep01.mp3","cpthazama/scp/049/SCPSL_Footstep02.mp3"}
	else
		self.tbl_Sounds["FootStep"] = {"cpthazama/scp/049/Step1.mp3","cpthazama/scp/049/Step2.mp3","cpthazama/scp/049/Step3.mp3"}
	end
	self.NextHearSoundT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnHearSound(ent)
	if !self.IsPossessed then
		self:SetLastPosition(ent:GetPos())
		self:TASKFUNC_WALKLASTPOSITION()
	end
	if CurTime() > self.NextHearSoundT then
		self:CPT_PlaySound("HearSound",78)
		self.NextHearSoundT = CurTime() +16
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
	if(event == "sattack") then
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
function ENT:CustomChecksBeforeDamage(ent)
	if ent.SCP_Has714 != true then
		return true
	else
		return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self.IsAttacking = true
	timer.Simple(0.1,function()
		if self:IsValid() then
			self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
		end
	end)
	timer.Simple(0.5,function()
		if self:IsValid() then
			self.IsAttacking = false
			self.IsRangeAttacking = false
			-- self.IsLeapAttacking = false
			self.HasStoppedMovingToAttack = false
			self:CustomOnAttackFinish()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnHitEntity(hitents,hitpos)
	if self.tbl_Sounds["Strike"] == nil then
		self:EmitSound("npc/zombie/claw_strike" .. math.random(1,3) .. ".wav",55,100)
	else
		self:EmitSound(self:SelectFromTable(self.tbl_Sounds["Strike"]),55,100)
	end
	for _,v in ipairs(hitents) do
		if v:IsValid() && v:IsPlayer() && v:Alive() && v.SCP_Has714 == false then
			if v.CPTBase_SCP_InfectionOverlayT == nil then v.CPTBase_SCP_InfectionOverlayT = 0 end
			if CurTime() > v.CPTBase_SCP_InfectionOverlayT then
				v:ConCommand("r_screenoverlay models/props_lab/Tank_Glass001.vmt")
				v:ChatPrint("SCP-049 grabs you by the throat..")
				-- v:SendLua("surface.PlaySound('cptbase/fx_poison_stinger.wav')")
				v.CPTBase_SCP_InfectionOverlayT = CurTime() +4.9
				timer.Simple(5,function()
					if v:IsValid() then
						v:ConCommand("r_screenoverlay 0")
					end
				end)
			end
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
	if GetConVarNumber("cpt_scp_usemusic") == 1 then
		if !IsValid(self:GetEnemy()) then
			self.ChaseSong:Stop()
			self.NextChaseSongT = CurTime()
			if CurTime() > self.NextThemeSongT then
				self.ThemeSong:Stop()
				self.ThemeSong:Play()
				self.NextThemeSongT = CurTime() +39
			end
		else
			self.ThemeSong:Stop()
			self.NextThemeSongT = CurTime()
			if CurTime() > self.NextChaseSongT then
				self.ChaseSong:Stop()
				self.ChaseSong:Play()
				self.NextChaseSongT = CurTime() +179
			end
		end
	end
	if CurTime() > self.NextIdleLoopT then
		self.IdleLoop:Stop()
		self.IdleLoop:Play()
		self.NextIdleLoopT = CurTime() +8
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.IdleLoop:Stop()
	self.ThemeSong:Stop()
	self.ChaseSong:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(v)
	local function SCPSounds()
		timer.Simple(0.4,function()
			if IsValid(self) then
				self:EmitSound(Sound("npc/zombie/foot_slide3.wav"),72,100)
			end
		end)
		timer.Simple(2.8,function()
			if IsValid(self) then
				self:EmitSound(Sound("npc/zombie/foot_slide2.wav"),72,100)
			end
		end)
		timer.Simple(1.2,function()
			if IsValid(self) then
				self:EmitSound(Sound("physics/flesh/flesh_squishy_impact_hard1.wav"),72,130)
			end
		end)
	end
	self:CPT_PlaySound("Infect",75)
	if v:IsNPC() then
		local zombie
		local setskin = false
		if !file.Exists("lua/autorun/cpt_scp_zombies_autorun.lua","GAME") then
			if v:GetClass() == "npc_cpt_scp_ntf" then
				zombie = ents.Create("npc_cpt_scp_049_2_ntf")
				setskin = true
			elseif v:GetClass() == "npc_cpt_scp_lambda" then
				zombie = ents.Create("npc_cpt_scp_049_2_ntf")
				setskin = 2
			elseif v:GetClass() == "npc_cpt_scp_nu" then
				zombie = ents.Create("npc_cpt_scp_049_2_ntf")
				setskin = 3
			else
				zombie = ents.Create("npc_cpt_scp_049_2")
			end
		else
			if v:GetClass() == "npc_cpt_scp_dclass" then
				zombie = ents.Create("npc_cpt_scp_049-2d")
			elseif v:GetClass() == "npc_cpt_scp_ntf" then
				zombie = ents.Create("npc_cpt_scp_049_2_ntf")
				setskin = v:GetSkin()
			elseif v:GetClass() == "npc_cpt_scp_lambda" then
				zombie = ents.Create("npc_cpt_scp_049_2_ntf")
				setskin = 2
			elseif v:GetClass() == "npc_cpt_scp_nu" then
				zombie = ents.Create("npc_cpt_scp_049_2_ntf")
				setskin = 3
			elseif file.Exists("lua/autorun/cpt_scp_chaos_autorun.lua","GAME") && (v:GetClass() == "npc_cpt_scp_chaos" || v:GetClass() == "npc_cpt_scp_p90chaos") then
				zombie = ents.Create("npc_cpt_scp_0492chaos")
			elseif file.Exists("lua/autorun/cpt_scp_sne_autorun.lua","GAME") && v:GetClass() == "npc_cpt_scp_snemtf" then
				zombie = ents.Create("npc_cpt_scp_sne0492")
			else
				zombie = ents.Create("npc_cpt_scp_049_2")
			end
		end
		zombie:SetPos(v:GetPos())
		zombie:SetAngles(v:GetAngles())
		zombie.WasInfected = true
		zombie:Spawn()
		if setskin != false then
			if setskin == true then
				zombie:SetSkin(v:GetSkin())
			else
				zombie:SetSkin(setskin)
			end
		end
		zombie:SetColor(v:GetColor())
		zombie:SetMaterial(v:GetMaterial())
		zombie:SetModelScale(v:GetModelScale(),0)
		undo.ReplaceEntity(v,zombie)
		v.HasDeathRagdoll = false
		v.HasDeathCorpse = false
		self:CPT_PlaySequence("infect",1)
		v:Remove()
	elseif v:IsPlayer() && v.SCP_Has714 == false then
		v:ChatPrint("You lose consciousness and your body is turned into a walking corpse..")
		local zombie = ents.Create("npc_cpt_scp_049_2")
		zombie:SetPos(v:GetPos())
		zombie:SetAngles(v:GetAngles())
		zombie.WasInfected = true
		zombie:Spawn()
		zombie:SetColor(v:GetColor())
		zombie:SetMaterial(v:GetMaterial())
		zombie:SetModelScale(v:GetModelScale(),0)
		CreateUndo(zombie,v:Nick() .. " (Infected)",v)
		v.CPTBase_SCP_Zombie = zombie
		v:SetPos(zombie:GetPos() +zombie:OBBCenter())
		v:GetRagdollEntity():Remove()
		zombie:CPT_PlaySequence("resurrect",1)
		SCPSounds()
	end
	self.TotalInfections = self.TotalInfections +1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Secondary(possessor)
	if IsValid(self:GetEnemy()) then
		local enemy = self:GetEnemy()
		local nearest = self:GetClosestPoint(enemy)
		if nearest <= self.MeleeAttackDistance then
			if enemy.SCP_Has714 == true then
				enemy.SCP_Has714 = false
				self:CPT_PlaySound("714",75)
				enemy:ChatPrint("SCP-714 is removed from your finger by SCP-049..")
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if(disp == D_HT) then
		if nearest <= self.MeleeAttackDistance then
			if enemy.SCP_Has714 == true then
				if math.random(1,160) == 1 then
					enemy.SCP_Has714 = false
					self:CPT_PlaySound("714",75)
					enemy:ChatPrint("SCP-714 is removed from your finger by SCP-049..")
				end
			end
		end
		if nearest <= self.MeleeAttackDistance && self:CPT_FindInCone(enemy,self.MeleeAngle) then
			self:DoAttack()
		end
		-- if self:CanPerformProcess() then
			self:ChaseEnemy()
		-- end
	end
end