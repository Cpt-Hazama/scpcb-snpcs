if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/1123.mdl"}
ENT.StartHealth = 500
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(2,2,4)

ENT.Faction = "FACTION_NONE"

ENT.Bleeds = false
ENT.TurnsOnDamage = false
ENT.IsEssental = false
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
		if event == "Use" && IsValid(activator) && activator:IsPlayer() && activator:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 && activator.SCP_Has714 == false && CurTime() > activator.SCP_NextUse1123T then
			activator.SCP_NextUse1123T = CurTime() +10
			activator:TakeDamage(15)
			-- if math.random(1,4) == 1 then
				-- self:EmitSound("cpthazama/scp/1123/Horror.wav",70,100)
				-- activator:SetNWBool("SCP_Touched1123",true)
				-- activator:SetNWBool("SCP_Touched1123_Horror",true)
			-- else
				self:EmitSound("cpthazama/scp/1123/Touch.wav",70,100)
				activator:SetNWBool("SCP_Touched1123",true)
				activator:ChatPrint("You touch the skull and feel as though you've been through the holocaust..")
			-- end
			if math.random(1,15) == 1 then
				timer.Simple(0.5,function()
					if IsValid(activator) && activator:Alive() then
						activator:EmitSound("cpthazama/scp/1123/Gunshot.wav",90,100)
						if activator:GetAttachment(activator:LookupAttachment("eyes")) != nil then
							ParticleEffect("blood_impact_red_01",activator:GetAttachment(activator:LookupAttachment("eyes")).Pos,Angle(math.random(0,360),math.random(0,360),math.random(0,360)),false)
						end
						activator:ChatPrint("The events that happened forced you to kill yourself..")
						activator:Kill()
					end
				end)
			end
			timer.Simple(0.1,function()
				if IsValid(activator) && activator:Alive() then
					activator:EmitSound("cpthazama/scp/D9341/breath1.wav",60,100)
				end
			end)
			timer.Simple(1.2,function()
				if IsValid(activator) && activator:Alive() then
					activator:EmitSound("cpthazama/scp/D9341/breath1.wav",60,100)
				end
			end)
			timer.Simple(2.4,function()
				if IsValid(activator) && activator:Alive() && !ply:GetNWBool("SCP_Touched1123") then
					activator:EmitSound("cpthazama/scp/D9341/breath1.wav",60,100)
				end
			end)
			timer.Simple(3.5,function()
				if IsValid(activator) && activator:Alive() && !ply:GetNWBool("SCP_Touched1123") then
					activator:EmitSound("cpthazama/scp/D9341/breath0.wav",60,100)
				end
			end)
			timer.Simple(3,function()
				if IsValid(activator) then
					activator:SetNWBool("SCP_Touched1123",false)
					activator:SetNWBool("SCP_Touched1123_Horror",false)
				end
			end)
		end
		self.NextUseT = CurTime() +3.2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end