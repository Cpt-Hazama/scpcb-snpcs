if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/420.mdl"}
ENT.StartHealth = 10
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(2,2,4)

ENT.Faction = "FACTION_NONE"

ENT.Bleeds = false
ENT.TurnsOnDamage = false
ENT.IsEssential = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_TINY)
	self:SetMovementType(MOVETYPE_NONE)
	self.NextUseT = 0
	self.Possessor_CanMove = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInputAccepted(event,activator)
	if CurTime() > self.NextUseT then
		if event == "Use" && activator:IsPlayer() && activator:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 && activator.SCP_Using420 == false then
			activator.SCP_Using420 = true
			activator:ChatPrint("MAN DATS SOM GOOD ASS SHIT")
			activator:SetHealth(activator:Health() +25)
			local oldspeed = activator:GetWalkSpeed()
			local oldspeedrun = activator:GetRunSpeed()
			activator:SetWalkSpeed(activator:GetWalkSpeed() +100)
			activator:SetRunSpeed(activator:GetRunSpeed() +100)
			activator:EmitSound("cpthazama/scp/music/420J.wav",50,100)
			self:Remove()
			timer.Simple(GetConVarNumber("cpt_scp_420effectstime"),function()
				if IsValid(activator) then
					activator.SCP_Using420 = false
					activator:SetWalkSpeed(oldspeed)
					activator:SetRunSpeed(oldspeedrun)
				end
			end)
		end
		self.NextUseT = CurTime() +0.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end