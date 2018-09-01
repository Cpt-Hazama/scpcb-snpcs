if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/1025.mdl"}
ENT.StartHealth = 150
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(6,6,4)

ENT.Faction = "FACTION_NONE"

ENT.Bleeds = false
ENT.TurnsOnDamage = false
ENT.IsEssential = false

ENT.tbl_Diseases = {
	"Asthma", // Slow speed
	"Lung Cancer", // Cough + Die
	"Cardiac Arrest", // Heart attack
	"Chickenpox", // Cough
	"Appendicitis", // Cough + Die
	"Common Cold" // Cough
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_TINY)
	self:SetMovementType(MOVETYPE_NONE)
	self.NextUseT = 0
	self:SetModelScale(1.2,0)
	self.Possessor_CanMove = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInputAccepted(event,activator)
	if CurTime() > self.NextUseT then
		if event == "Use" && IsValid(activator) && activator:IsPlayer() && activator:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 && activator.SCP_Has714 == false then
			local disease = self:SelectFromTable(self.tbl_Diseases)
			if disease == "Lung Cancer" then activator.SCP_Disease_LungCancer = true end
			if disease == "Appendicitis" then activator.SCP_Disease_Appendicitis = true end
			if disease == "Chickenpox" then activator.SCP_Disease_CommonCold = true end
			if disease == "Common Cold" then activator.SCP_Disease_Chickenpox = true end
			if disease == "Asthma" then activator.SCP_Disease_Asthma = true end
			if disease == "Cardiac Arrest" then activator.SCP_Disease_CardiacArrest = true end

			if disease == "Lung Cancer" or disease == "Appendicitis" then
				if disease == "Lung Cancer" then
					self:SetupCough(true,activator,disease)
				elseif disease == "Appendicitis" then
					self:SetupCough(true,activator,disease)
				end
			elseif disease == "Chickenpox" or disease == "Common Cold" then
				if disease == "Chickenpox" then
					self:SetupCough(false,activator,disease)
				elseif disease == "Common Cold" then
					self:SetupCough(false,activator,disease)
				end
			elseif disease == "Asthma" then
				-- if activator.SCP_Disease_Asthma == false then
					activator:SetWalkSpeed(activator:GetWalkSpeed() -80)
					activator:SetRunSpeed(activator:GetRunSpeed() -80)
				-- end
			elseif disease == "Cardiac Arrest" then
				-- if activator.SCP_Disease_CardiacArrest == false then
					self:SetupHeartAttack()
				-- end
			end
			activator:ChatPrint("You pick a random page and you get " .. disease .. "..")
			activator:SendLua("surface.PlaySound('cpthazama/scp/1162/NostalgiaCancer" .. math.random(1,10) .. ".mp3')")
		end
		self.NextUseT = CurTime() +5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupCough(dodie,ply,disease)
	local deaths = ply:Deaths()
	ply:EmitSound("cpthazama/scp/D9341/Cough3.mp3",75,100)
	timer.Simple(4,function()
		if ply:IsValid() && ply.SCP_Has714 == false  then
			if ply:Deaths() > deaths then return end
			ply:EmitSound("cpthazama/scp/D9341/Cough3.mp3",75,100)
		end
	end)
	timer.Simple(7,function()
		if ply:IsValid() && ply.SCP_Has714 == false  then
			if ply:Deaths() > deaths then return end
			ply:EmitSound("cpthazama/scp/D9341/Cough1.mp3",75,100)
		end
	end)
	timer.Simple(14,function()
		if ply:IsValid() && ply.SCP_Has714 == false  then
			if ply:Deaths() > deaths then return end
			ply:EmitSound("cpthazama/scp/D9341/Cough2.mp3",75,100)
		end
	end)
	timer.Simple(20,function()
		if ply:IsValid() && ply.SCP_Has714 == false  then
			if ply:Deaths() > deaths then return end
			ply:EmitSound("cpthazama/scp/D9341/Cough1.mp3",75,100)
			if dodie == true then
				ply:Kill()
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupHeartAttack()
	if IsValid(ply) then
		local deaths = ply:Deaths()
		ply:EmitSound("cpthazama/scp/D9341/breath0.mp3",75,100)
		timer.Simple(8,function()
			if ply:IsValid() && ply.SCP_Has714 == false then
				if ply:Deaths() > deaths then return end
				ply:EmitSound("cpthazama/scp/D9341/Cough1.mp3",75,100)
				ply:Kill()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end