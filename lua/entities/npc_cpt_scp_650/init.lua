if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/650.mdl"}
ENT.StartHealth = 1000
ENT.CanWander = false
ENT.WanderChance = 0
ENT.CollisionBounds = Vector(16,16,75)

ENT.Faction = "FACTION_SCP"
ENT.Bleeds = false
ENT.TeleportChance = 30
ENT.Rage = false

ENT.tbl_Animations = {}

ENT.tbl_Sounds = {}

ENT.tbl_Capabilities = {CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	possessor:ChatPrint("Possessor Controls:")
	possessor:ChatPrint("LMB - Teleport to cursor")
	possessor:ChatPrint("RMB - Teleport to random enemy")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Primary(possessor)
	local IsSeen = (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC())
	if IsSeen then return end
	self:Teleport(self:Possess_AimTarget())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Secondary(possessor)
	local IsSeen = (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC())
	if IsSeen then return end
	local tb = {}
	for _,v in ipairs(ents.GetAll()) do
		if IsValid(v) && ((v:IsNPC() && v != self && !self:IsFriendlyToMe(v)) || v:IsPlayer() && v:Alive() && !v:GetNWBool("CPTBase_IsPossessing")) then
			table.insert(tb,v)
		end
	end
	if table.Count(tb) <= 0 then return end
	local ent = self:SelectFromTable(tb)
	self:Teleport(ent:GetPos() +ent:GetForward() *-70)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.WasSeen = false
	self.NextTeleportT = 0
	self.P_NextTeleportT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Teleport(pos)
	self:SetClearPos(pos)
	local tblIdle = {
		"scare1",
		"scare2",
		"scare3",
		"scare4",
		"scare5",
		"scare6",
		"scare7",
		"idle",
	}
	self:SetIdleAnimation(self:SelectFromTable(tblIdle))
	if !self.IsPossessed && IsValid(self:GetEnemy()) then
		self:SetAngles(Angle(0,(self:GetEnemy():GetPos() -self:GetPos()):Angle().y,0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then
		self.Possessor_CanMove = false
		self:SetMaxYawSpeed(0)
		self:StopProcessing()
		self:StopProcessing()
		self:StopProcessing()
		self.IsRangeAttacking = true
	else
		self.Possessor_CanMove = true
		self.IsRangeAttacking = false
		self:SetMaxYawSpeed(300)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	local IsSeen = (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC())
	if(disp == D_HT) then
		if IsSeen then return end
		if IsSeen == false && math.random(1,self.TeleportChance) == 1 then
			self:Teleport(enemy:GetPos() +enemy:GetForward() *-70)
		end
	end
end