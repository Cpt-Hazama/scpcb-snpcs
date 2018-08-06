if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/895.mdl"}
ENT.StartHealth = 3000
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(25,25,125)

ENT.Faction = "FACTION_NONE"

ENT.Bleeds = false
ENT.TurnsOnDamage = false
ENT.IsEssental = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_LARGE)
	self:SetMovementType(MOVETYPE_NONE)
	self.NextUseT = 0
	self.NextScareT = 0
	self.Possessor_CanMove = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetRandomImage()
	local pic
	local horror = math.random(1,3)
	if horror == 1 then
		pic = "models/cpthazama/scp/895/895_imageA"
	elseif horror == 2 then
		pic = "models/cpthazama/scp/895/895_imageB"
	else
		pic = "models/cpthazama/scp/895/895_imageC"
	end
	return pic
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateGrossImage(v)
	if IsValid(v) then
		local dmgpos = v:NearestPoint(self:GetPos() +self:OBBCenter())
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(20)
		dmginfo:SetAttacker(self)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamageType(DMG_GENERIC)
		dmginfo:SetDamagePosition(dmgpos)
		v:TakeDamageInfo(dmginfo)
		v:SetDSP(32,false)
		if math.random(1,3) == 1 then
			v:EmitSound("cpthazama/scp/music/Horror16.wav",45,100)
		elseif math.random(1,3) == 2 then
			v:EmitSound("cpthazama/scp/music/Horror1.wav",45,100)
		else
			v:EmitSound("cpthazama/scp/music/Horror6.wav",45,100)
		end
		v:SetNWBool("SCP_895Horror",true)
		v:SetNWString("SCP_895HorrorID",self:SetRandomImage())
		timer.Simple(math.Rand(0.05,0.79),function() if IsValid(v) then v:SetNWString("SCP_895HorrorID",self:SetRandomImage()) end end)
		timer.Simple(math.Rand(0.05,0.79),function() if IsValid(v) then v:SetNWString("SCP_895HorrorID",self:SetRandomImage()) end end)
		timer.Simple(math.Rand(0.05,0.79),function() if IsValid(v) then v:SetNWString("SCP_895HorrorID",self:SetRandomImage()) end end)
		timer.Simple(0.8,function()
			if IsValid(v) then
				v:SetNWBool("SCP_895Horror",false)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if CurTime() > self.NextScareT then
		for _,v in ipairs(player.GetAll()) do
			if v:IsValid() && v:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 && v:GetNWBool("SCP_895Horror") == false then
				if v:GetNWBool("SCP_HasNightvision") == true || (GetConVarNumber("cpt_scp_895attack") == 1) then
					if self:GetClosestPoint(v) <= 895 then
						self:CreateGrossImage(v)
					end
				end
			end
		end
		self.NextScareT = CurTime() +math.Rand(2,4)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInputAccepted(event,activator)
	if CurTime() > self.NextUseT then
		if event == "Use" && IsValid(activator) && activator:IsPlayer() && activator:Alive() && GetConVarNumber("ai_ignoreplayers") == 0 then
			activator:ChatPrint("You place your hand on the coffin and feel a very cold sensation go down your back. Maybe it's best if you leave..")
			if math.random(1,50) == 1 then
				self:CreateGrossImage(activator)
			end
		end
		self.NextUseT = CurTime() +2.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end