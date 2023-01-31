if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.StartHealth = 1800
ENT.CanMutate = false
ENT.CollisionBounds = Vector(18,18,90)

ENT.MeleeAttackDamage = 50

ENT.IdleSoundPitch = 130
ENT.AlertSoundPitch = 130
ENT.PainSoundPitch = 130
ENT.DeathSoundPitch = 130
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsAttacking = false
	self.NextDoorT = 0
	self:SetModelScale(0.84,0)
	self:SetSkin(1)
	self.tbl_Followers = {}
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
	if(self:GetState() == NPC_STATE_COMBAT || self:GetState() == NPC_STATE_ALERT) then
		self:SetIdleAnimation(self:CPT_TranslateStringToNumber("idle_panic"))
	else
		self:SetIdleAnimation(ACT_IDLE)
	end
	-- for _,v in ipairs(ents.GetAll()) do
		-- if v:IsValid() && v:IsNPC() && v != self && v:GetClass() == "npc_cpt_scp_1499_1" then
			-- local dist = self:GetClosestPoint(v)
			-- print(v)
			-- if dist > 1500 then
				-- v.IsFollowingKing = false
				-- v.WanderChance = 60
				-- if table.HasValue(self.tbl_Followers,v) then
					-- table.remove(self.tbl_Followers[v])
				-- end
				-- print("TOO FAR")
			-- elseif dist <= 1500 then
				-- v.IsFollowingKing = true
				-- if !table.HasValue(self.tbl_Followers,v) then
					-- table.insert(self.tbl_Followers,v)
				-- end
				-- print("Following")
				-- if dist > 300 then
					-- print("MOVE")
					-- v.WanderChance = 0
					-- v:ChaseTarget(v,false)
				-- else
					-- print("SIT")
					-- v.WanderChance = 60
				-- end
			-- end
		-- end
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	for _,v in ipairs(self.tbl_Followers) do
		if IsValid(v) then
			v.IsFollowingKing = false
		end
	end
end