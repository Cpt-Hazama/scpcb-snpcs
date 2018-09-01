if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/008-1.mdl"}
ENT.StartHealth = 200
ENT.CanMutate = false
ENT.CollisionBounds = Vector(18,18,70)

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 60
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 10

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1},
}

ENT.tbl_Sounds = {
	["FootStep"] = {"cpthazama/scp/Step1.mp3","cpthazama/scp/Step2.mp3","cpthazama/scp/Step3.mp3"},
	["Idle"] = {
		"cpthazama/scp/008/Voices0.mp3",
		"cpthazama/scp/008/Voices1.mp3",
		"cpthazama/scp/008/Voices2.mp3",
		"cpthazama/scp/008/Voices3.mp3",
		"cpthazama/scp/008/Voices4.mp3",
		"cpthazama/scp/008/Voices5.mp3",
		"cpthazama/scp/008/Voices6.mp3",
	},
	["Alert"] = {
		"cpthazama/scp/008/Voices0.mp3",
		"cpthazama/scp/008/Voices1.mp3",
		"cpthazama/scp/008/Voices2.mp3",
		"cpthazama/scp/008/Voices3.mp3",
		"cpthazama/scp/008/Voices4.mp3",
		"cpthazama/scp/008/Voices5.mp3",
		"cpthazama/scp/008/Voices6.mp3",
	},
	["Strike"] = {"cpthazama/scp/D9341/Damage3.mp3"},
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.NextDoorT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(...)
	local event = select(1,...)
	local arg1 = select(2,...)
	if(event == "mattack") then
		if arg1 == "both" then
			self:DoDamage(self.MeleeAttackDamageDistance *1.5,self.MeleeAttackDamage,self.MeleeAttackType)
		else
			self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
		end
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
function ENT:OnHitEntity(hitents,hitpos)
	if self.tbl_Sounds["Strike"] == nil then
		self:EmitSound("npc/zombie/claw_strike" .. math.random(1,3) .. ".wav",55,100)
	else
		self:EmitSound(self:SelectFromTable(self.tbl_Sounds["Strike"]),55,100)
	end
	for _,v in ipairs(hitents) do
		if v:IsValid() && v:IsPlayer() && v:Alive() && v.SCP_Has714 == false && v.SCP_Infected_008 == false then
			v.SCP_Infected_008 = true
			v:EmitSound("cpthazama/scp/008/Voices0.mp3",50,100)
			v:ChatPrint("You feel like something is wrong..")
			local deaths = v:Deaths()
			local time = GetConVarNumber("cpt_scp_008infectiontime")
			timer.Simple(time /3,function()
				if v:IsValid() && v.SCP_Infected_008 then
					if v:Deaths() > deaths then return end
					v:EmitSound("cpthazama/scp/008/Voices5.mp3",50,100)
					v:ChatPrint("You start to feel dizzy..")
				end
			end)
			timer.Simple(time /2,function()
				if v:IsValid() && v.SCP_Infected_008 then
					if v:Deaths() > deaths then return end
					v:EmitSound("cpthazama/scp/008/Voices1.mp3",50,100)
					v:ChatPrint("You have an unsationable urge to eat flesh..")
				end
			end)
			timer.Simple(time,function()
				if v:IsValid() && v.SCP_Infected_008 then
					if v:Deaths() > deaths then return end
					local zombie = ents.Create("npc_cpt_scp_008_1")
					zombie:SetPos(v:GetPos())
					zombie:SetAngles(v:GetAngles())
					zombie:Spawn()
					zombie:SetColor(v:GetColor())
					zombie:SetMaterial(v:GetMaterial())
					zombie:SetModelScale(v:GetModelScale(),0)
					CreateUndo(zombie,v:Nick() .. " (008 Infected)",v)
					v:Kill()
					v.CPTBase_SCP_Zombie = zombie
					v:GetRagdollEntity():Remove()
				end
			end)
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
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:StopCompletely()
	self:PlayAnimation("Attack")
	self.IsAttacking = true
	self:AttackFinish()
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