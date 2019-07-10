if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/106.mdl"}
ENT.StartHealth = 5000
ENT.CanMutate = false
ENT.CollisionBounds = Vector(16,16,75)

ENT.CorrosionCheckDistance = 50

ENT.Faction = "FACTION_SCP"

ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 60
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 40

ENT.BloodEffect = {"blood_impact_black"}
-- ENT.BloodDecal = {"CPTBase_BlackBlood"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_WALK},
	["Attack"] = {ACT_MELEE_ATTACK1},
	["AttackGround"] = {ACT_MELEE_ATTACK2},
	["Teleport"] = {ACT_JUMP},
	["TeleportWall"] = {ACT_SPRINT},
}

ENT.tbl_Sounds = {
	["FootStep"] = {"cpthazama/scp/StepPD1.mp3","cpthazama/scp/StepPD2.mp3","cpthazama/scp/StepPD3.mp3"},
	["Alert"] = {"cpthazama/scp/106/Laugh.mp3"},
	["Kneel"] = {"cpthazama/scp/106/Kneel.mp3"},
	["Strike"] = {"cpthazama/scp/D9341/Damage3.mp3"},
	["Corrosion"] = {"cpthazama/scp/106/Corrosion1.mp3","cpthazama/scp/106/Corrosion2.mp3","cpthazama/scp/106/Corrosion3.mp3"},
	["Decay"] = {"cpthazama/scp/106/Decay0.mp3"}
}

ENT.RootBone = "Dummy001"

ENT.tbl_Capabilities = {CAP_USE}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	possessor:ChatPrint("Possessor Controls:")
	possessor:ChatPrint("LMB - Attack/Pocket Dimension")
	possessor:ChatPrint("RMB - Teleport to Pocket Hole")
	possessor:ChatPrint("Reload - Set Pocket Hole")
	possessor:ChatPrint("Jump - Teleport to random player")
	possessor:ChatPrint("Crouch - Teleport to random NPC")
	possessor:ChatPrint("Suit Zoom - Wall teleport to random enemy")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BeforeTakeDamage(dmg,hitbox)
	if GetConVarNumber("cpt_scp_106damage") == 0 then
		if dmg:GetDamageType() == DMG_SHOCK || dmg:GetDamageType() == DMG_DISSOLVE || ((dmg:GetAttacker():GetClass() == "trigger_hurt" || dmg:GetAttacker():GetClass() == "func_movelinear") && util.IsSCPMap()) then
			return true
		else
			return false
		end
	else
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	PrintTable(CPTBASE_TBL_SCPMAPVECTORS)
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self.IsContained = false
	self.IsAttacking = false
	self.WasSeen = false
	self.GrabbedVictim = NULL
	self.NextTeleportT = 0
	self.NextThemeSongT = 0
	self.NextIdleLoopT = 0
	self.ThemeSong = CreateSound(self,"cpthazama/scp/music/106.mp3")
	self.ThemeSong:SetSoundLevel(110)
	self.IdleLoop = CreateSound(self,"cpthazama/scp/106/Breathing.mp3")
	self.IdleLoop:SetSoundLevel(68)
	self.NextCorrosionEffectT = 0
	self.NextDoorT = 0
	self.NextTeleportToPointT = 0
	self.P_TeleportSpot = Vector(0,0,0)
	self.P_NextSetTeleportSpotT = 0
	self.P_NextTeleportT = 0
	self.P_NextTeleportParticleT = 0
	self.NextRandomTeleportT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Teleport(pos,grab)
	if self.IsContained then return end
	self:StopCompletely()
	if grab then
		self:PlayAnimation("AttackGround",2)
		timer.Simple(self:AnimationLength(ACT_MELEE_ATTACK2) +0.01,function()
			if IsValid(self) then
				self:PlayAnimation("Teleport",2)
			end
		end)
	else
		self:PlayAnimation("Teleport",2)
	end
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() -Vector(0,0,10),
		filter = self,
		mask = MASK_NPCWORLDSTATIC
	})
	ParticleEffect("scp_decay",tr.HitPos,Angle(0,0,0),nil)
	for i = 0,self:GetBoneCount() -1 do
		ParticleEffect("blood_impact_black",self:GetBonePosition(i),Angle(0,0,0),nil)
	end
	-- self:SetClearPos(pos)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetPos(pos)
	timer.Simple(0.5,function()
		if self:IsValid() then
			self:SetCollisionGroup(COLLISION_GROUP_NPC)
		end
	end)
	self:EmitSound("cpthazama/scp/106/Laugh.mp3",110,100)
	self:EmitSound("cpthazama/scp/106/Corrosion" .. math.random(1,3) .. ".mp3",70,100)
	self:PlaySound("Decay",100)
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() -Vector(0,0,10),
		filter = self,
		mask = MASK_NPCWORLDSTATIC
	})
	ParticleEffect("scp_decay",tr.HitPos,Angle(0,0,0),nil)
	if !grab then
		for i = 1,math.random(60,70) do
			timer.Simple(i *0.1,function()
				if self:IsValid() then
					for i = 0,self:GetBoneCount() -1 do
						ParticleEffect("blood_impact_black",self:GetPos() +Vector(math.Rand(-20,20),math.Rand(-20,20),-8),Angle(0,0,0),nil)
					end
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BeContained()
	self:PlayAnimation("Teleport",2)
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() -Vector(0,0,10),
		filter = self,
		mask = MASK_NPCWORLDSTATIC
	})
	ParticleEffect("scp_decay",tr.HitPos,Angle(0,0,0),nil)
	for i = 0,self:GetBoneCount() -1 do
		ParticleEffect("blood_impact_black",self:GetBonePosition(i),Angle(0,0,0),nil)
	end
	if util.GetSCPMapData(FEMURBREAKER) != nil then
		self:SetPos(util.GetSCPMapData(FEMURBREAKER) +self:GetUp() *15)
	end
	self:EmitSound("cpthazama/scp/106/Corrosion" .. math.random(1,3) .. ".mp3",70,100)
	self:PlaySound("Decay",100)
	ParticleEffect("scp_decay",self:GetPos(),Angle(0,0,0),nil)
	for i = 1,math.random(60,70) do
		timer.Simple(i *0.1,function()
			if self:IsValid() then
				for i = 0,self:GetBoneCount() -1 do
					ParticleEffect("blood_impact_black",self:GetPos() +Vector(math.Rand(-20,20),math.Rand(-20,20),-8),Angle(0,0,0),nil)
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Secondary(possessor)
	if self.IsContained then return end
	if self.P_TeleportSpot != Vector(0,0,0) then
		if CurTime() > self.P_NextTeleportT then
			self:PlayAnimation("Teleport",2)
			local tr = util.TraceLine({
				start = self:GetPos(),
				endpos = self:GetPos() -Vector(0,0,10),
				filter = self,
				mask = MASK_NPCWORLDSTATIC
			})
			ParticleEffect("scp_decay",tr.HitPos,Angle(0,0,0),nil)
			for i = 0,self:GetBoneCount() -1 do
				ParticleEffect("blood_impact_black",self:GetBonePosition(i),Angle(0,0,0),nil)
			end
			self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			self:SetPos(self.P_TeleportSpot)
			timer.Simple(0.5,function()
				if self:IsValid() then
					self:SetCollisionGroup(COLLISION_GROUP_NPC)
				end
			end)
			self:EmitSound("cpthazama/scp/106/Laugh.mp3",110,100)
			self:EmitSound("cpthazama/scp/106/Corrosion" .. math.random(1,3) .. ".mp3",70,100)
			self:PlaySound("Decay",100)
			if CurTime() > self.P_NextTeleportParticleT then
				ParticleEffect("scp_decay",self:GetPos(),Angle(0,0,0),nil)
				self.P_NextTeleportParticleT = CurTime() +140
			end
			for i = 1,math.random(60,70) do
				timer.Simple(i *0.1,function()
					if self:IsValid() then
						for i = 0,self:GetBoneCount() -1 do
							ParticleEffect("blood_impact_black",self:GetPos() +Vector(math.Rand(-20,20),math.Rand(-20,20),-8),Angle(0,0,0),nil)
						end
					end
				end)
			end
			self.P_NextTeleportT = CurTime() +10
		end
	else
		possessor:ChatPrint("You have to set a teleport spot first! Press +reload to do so.")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Reload(possessor)
	if self.IsContained then return end
	if CurTime() > self.P_NextSetTeleportSpotT then
		self:PlaySound("Decay",100)
		possessor:ChatPrint("Teleport spot set.")
		local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() -Vector(0,0,10),
			filter = self,
			mask = MASK_NPCWORLDSTATIC
		})
		ParticleEffect("scp_decay",tr.HitPos,Angle(0,0,0),nil)
		if self.point != nil then self.point:Remove() end
		self.point = ents.Create("prop_physics")
		self.point:SetModel("models/hunter/tubes/circle2x2.mdl")
		self.point:SetPos(self:GetPos() +Vector(0,0,-1))
		self.point:Spawn()
		self.point:SetMaterial("Models/effects/vol_light001.vmt")
		self.point:DrawShadow(false)
		self.point:SetModelScale(0.1,0)
		self.point:SetModelScale(0.7,6)
		self.point.SCP106_Point = true
		self.point:SetNWBool("SCP106_Point",true)
		if self.point:GetPhysicsObject():IsValid() then
			self.point:GetPhysicsObject():EnableMotion(false)
		end
		self.point:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self.P_TeleportSpot = (self:GetPos() +Vector(0,0,1))
		self.P_NextTeleportParticleT = CurTime() +140
		self.P_NextSetTeleportSpotT = CurTime() +15
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Duck(possessor)
	if self.IsContained then return end
	if CurTime() > self.P_NextTeleportT then
		local tb = {}
		for _,v in ipairs(ents.GetAll()) do
			if v:IsValid() && v:IsNPC() && v != self && v:Disposition(self) != D_LI && v.Faction != "FACTION_SCP" then
				table.insert(tb,v)
			end
		end
		if table.Count(tb) <= 0 then return end
		local ent = self:SelectFromTable(tb)
		if math.random(1,2) == 1 then
			self:Teleport(ent:GetPos() +Vector(math.random(-50,50),math.random(-50,50),0))
		else
			self:Teleport(ent:GetPos(),true)
		end
		self.P_NextTeleportT = CurTime() +15
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Jump(possessor)
	if self.IsContained then return end
	if CurTime() > self.P_NextTeleportT then
		local tb = {}
		for _,v in ipairs(player.GetAll()) do
			if v:Alive() && v != possessor then
				table.insert(tb,v)
			end
		end
		if table.Count(tb) <= 0 then return end
		local ent = self:SelectFromTable(tb)
		if math.random(1,2) == 1 then
			self:Teleport(ent:GetPos() +Vector(math.random(-50,50),math.random(-50,50),0))
		else
			self:Teleport(ent:GetPos(),true)
		end
		self.P_NextTeleportT = CurTime() +15
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_CustomCommands(possessor)
	local w = possessor:KeyDown(IN_FORWARD)
	local e = possessor:KeyDown(IN_USE)
	local r = possessor:KeyDown(IN_RELOAD)
	local a = possessor:KeyDown(IN_MOVELEFT)
	local s = possessor:KeyDown(IN_BACK)
	local d = possessor:KeyDown(IN_MOVERIGHT)
	local lmb = possessor:KeyDown(IN_ATTACK)
	local rmb = possessor:KeyDown(IN_ATTACK2)
	local alt = possessor:KeyDown(IN_ALT1)
	local shift = possessor:KeyDown(IN_RUN)
	local zoom = possessor:KeyDown(IN_ZOOM)
	if zoom then
		return self:Possess_Zoom(possessor)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Zoom(possessor)
	if self.IsContained then return end
	if CurTime() > self.P_NextTeleportT then
		local tb = {}
		for _,v in ipairs(player.GetAll()) do
			if v:Alive() && v != possessor then
				table.insert(tb,v)
			end
		end
		for _,v in ipairs(ents.GetAll()) do
			if v:IsValid() && v:IsNPC() && v != self && v:Disposition(self) != D_LI && v.Faction != "FACTION_SCP" then
				table.insert(tb,v)
			end
		end
		if table.Count(tb) <= 0 then return end
		local ent = self:SelectFromTable(tb)
		self:DoWallTeleport(ent)
		self.P_NextTeleportT = CurTime() +7
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
	if(event == "grab") then
		if(arg1 == "pull") then
			if IsValid(self:GetEnemy()) && self:GetEnemy():GetPos():Distance(self:GetPos()) <= 50 then
				self.GrabbedVictim = self:GetEnemy()
				self.GrabbedVictim:EmitSound("physics/body/body_medium_impact_soft7.wav",65,100)
				if self.GrabbedVictim:IsPlayer() then
					self.GrabbedVictim:EmitSound("cpthazama/scp/D9341/breath4.mp3",65,100)
					self.GrabbedVictim:ChatPrint("SCP-106 grabs you by your legs and yanks you into the ground!")
				end
				self:PlaySound("Kneel",75)
				self.GrabbedVictim:SetPos(LerpVector(0.2,self.GrabbedVictim:GetPos(),self.GrabbedVictim:GetPos() +Vector(0,0,-120)))
			end
		end
		if(arg1 == "kill") then
			if self.GrabbedVictim:IsValid() then
				if math.random(1,3) == 1 then
					for i = 0,self.GrabbedVictim:GetBoneCount() -1 do
						ParticleEffect("blood_impact_black",self.GrabbedVictim:GetBonePosition(i),Angle(0,0,0),nil)
					end
					if self.GrabbedVictim:IsNPC() then
						self.GrabbedVictim.HasDeathRagdoll = false
					end
					self.GrabbedVictim:Kill()
					if self.GrabbedVictim:IsNPC() then
						self.GrabbedVictim:Remove()
					else
						self.GrabbedVictim:EmitSound("cpthazama/scp/D9341/Damage5.mp3",78,100)
						if self.GrabbedVictim:GetRagdollEntity():IsValid() then
							self.GrabbedVictim:GetRagdollEntity():Remove()
						end
					end
					sound.Play("cpthazama/scp/_oldscp/106horror.mp3",self:GetPos(),78,100)
				else
					if util.IsSCPMap() && self.GrabbedVictim:IsValid() && self.GrabbedVictim:Alive() then
						for i = 0,self.GrabbedVictim:GetBoneCount() -1 do
							ParticleEffect("blood_impact_black",self.GrabbedVictim:GetBonePosition(i),Angle(0,0,0),nil)
						end
						if util.GetSCPMapData(POCKETDIMENSION) != nil then
							self.GrabbedVictim:SetPos(util.GetSCPMapData(POCKETDIMENSION))
						end
						self.GrabbedVictim:EmitSound("cpthazama/scp/106/Enter.mp3",40,100)
						local tr = util.TraceLine({
							start = self.GrabbedVictim:GetPos(),
							endpos = self.GrabbedVictim:GetPos() -Vector(0,0,10),
							filter = {self,self.GrabbedVictim},
							mask = MASK_NPCWORLDSTATIC
						})
						ParticleEffect("scp_decay",tr.HitPos,Angle(0,0,0),nil)
						for i = 0,self.GrabbedVictim:GetBoneCount() -1 do
							ParticleEffect("blood_impact_black",self.GrabbedVictim:GetBonePosition(i),Angle(0,0,0),nil)
						end
					end
				end
			end
		end
		return true
	end
	if(event == "emit") then
		if(arg1 == "step_left") then
			if self:IsOnGround() then
				self:PlaySound("FootStep",75,90,100,true)
				local tr = util.TraceLine({
					start = self:GetBonePosition(11),
					endpos = self:GetBonePosition(11) -Vector(0,0,10),
					filter = self,
					mask = MASK_NPCWORLDSTATIC
				})
				ParticleEffect("scp_decay_step",tr.HitPos,Angle(0,0,0),nil)
				ParticleEffect("blood_impact_black",self:GetBonePosition(11) +Vector(0,0,-5),Angle(0,0,0),nil)
			end
		elseif(arg1 == "step_right") then
			if self:IsOnGround() then
				self:PlaySound("FootStep",75,90,100,true)
				local tr = util.TraceLine({
					start = self:GetBonePosition(7),
					endpos = self:GetBonePosition(7) -Vector(0,0,10),
					filter = self,
					mask = MASK_NPCWORLDSTATIC
				})
				ParticleEffect("scp_decay_step",tr.HitPos,Angle(0,0,0),nil)
				ParticleEffect("blood_impact_black",self:GetBonePosition(7) +Vector(0,0,-5),Angle(0,0,0),nil)
			end
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
		if v:IsValid() then
			for i = 0,v:GetBoneCount() -1 do
				if math.random(1,3) == 1 then
					ParticleEffect("blood_impact_black",v:GetBonePosition(i),Angle(0,0,0),nil)
					v:EmitSound("cpthazama/scp/106/Decay" .. math.random(0,3) .. ".mp3",35,200)
				end
			end
			if util.IsSCPMap() && v:IsValid() && v:Alive() then
				if util.GetSCPMapData(POCKETDIMENSION) != nil then
					v:SetPos(util.GetSCPMapData(POCKETDIMENSION))
				end
				v:EmitSound("cpthazama/scp/106/Enter.mp3",40,100)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.WasContained = false
function ENT:OnThink()
	if self:GetCollisionGroup() == COLLISION_GROUP_IN_VEHICLE then
		self.OverrideWalkAnimation = ACT_WALK_STIMULATED
		self.OverrideRunAnimation = ACT_WALK_STIMULATED
	else
		self.OverrideWalkAnimation = ACT_WALK
		self.OverrideRunAnimation = ACT_WALK
	end
		-- Containment --
	if util.IsSCPMap() && util.GetSCPMapData(FEMURBREAKER) != nil then
		if MN_FEMUR == false && self:GetPos():Distance(util.GetSCPMapData(FEMURBREAKER)) <= 250 then
			self.IsContained = true
			if self.WasContained == false then
				self.WasContained = true
				for _,v in ipairs(player.GetAll()) do
					v:SendLua("surface.PlaySound('cpthazama/scp/106Contain.mp3')")
				end
			end
		else
			self.IsContained = false
			if self.WasContained == true then
				self.WasContained = false
			end
		end
	end
		-- Random Teleportation --
	if !IsValid(self:GetEnemy()) then
		if !self.IsPossessed && self:CanPerformProcess() && CurTime() > self.NextRandomTeleportT && math.random(1,80) == 1 then
			local tb = {}
			for _,v in ipairs(ents.GetAll()) do
				if IsValid(v) && ((v:IsNPC() && v != self && self:Disposition(v) != D_LI) || (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 && v:Alive() && !v:GetNWBool("CPTBase_IsPossessing"))) then
					table.insert(tb,v)
				end
			end
			if table.Count(tb) <= 0 then return end
			local ent = self:SelectFromTable(tb)
			self:Teleport(ent:GetPos() +Vector(math.Rand(-60,60),math.Rand(-60,60),0))
			self.NextRandomTeleportT = CurTime() +math.Rand(30,40)
		end
	end
	if GetConVarNumber("cpt_scp_usemusic") == 1 && CurTime() > self.NextThemeSongT then
		self.ThemeSong:Stop()
		self.ThemeSong:Play()
		self.NextThemeSongT = CurTime() +30
	end
	if CurTime() > self.NextIdleLoopT then
		self.IdleLoop:Stop()
		self.IdleLoop:Play()
		self.NextIdleLoopT = CurTime() +2.8
	end
		-- Stupid Code --
	local cantpp = false
	if self.point != nil && self.point:IsValid() && self.point:GetPos():Distance(self:GetPos()) > 800 && !self.point:Visible(self) then
		for _,v in ipairs(ents.FindInSphere(self.point:GetPos(),250)) do
			if (v:IsNPC() && v != self && v:GetClass() != self:GetClass() && v:Disposition(self) != D_LI) || (v:IsPlayer() && v:Alive() && GetConVarNumber("ai_ignoreplayers") == 0) && CurTime() > self.NextTeleportToPointT then
				v:SetNWBool("CPTBase_SCP106_Highlight",true)
				cantpp = true
			end
		end
	end
	if !self.IsPossessed && !IsValid(self:GetEnemy()) then
		if !self.IsContained && cantpp == true && CurTime() > self.NextTeleportToPointT then
			self:Teleport(self.point:GetPos())
			self.NextTeleportToPointT = CurTime() +30
		end
	end
	if (self:SCP_CanBeSeen() || self:SCP_CanBeSeen_NPC()) == true then
		if self.WasSeen == false then
			-- self:OnSeen()
			self.WasSeen = true
		end
	else
		self.WasSeen = false
	end
		-- Walk Through Stuff --
	local canwalkthroughsurface = false
	if self.IsContained == false then
		for _,v in ipairs(ents.FindInSphere(self:GetPos(),self.CorrosionCheckDistance)) do
			if v:IsValid() && v != self && (v:GetClass() == "func_brush" || v:GetClass() == "func_door" || v:GetClass() == "func_door_rotating" || v:GetClass() == "prop_door" || v:GetClass() == "prop_door_rotating" || v:GetClass() == "prop_physics" || v:GetClass() == "prop_dynamic") then
				canwalkthroughsurface = true
			end
		end
		if canwalkthroughsurface == true && self.IsContained == false then
			self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			local direction = ((self:GetPos() +self:GetForward() *10) -self:GetPos()):GetNormal()
			-- local direction = ((self:GetEnemy():GetPos() +vector_up) -self:GetPos()):GetNormal()
			-- local speed = self:GetPos() +direction *1.8
			-- self:SetAngles(Angle(0,direction:Angle().y,direction:Angle().r))
			-- self:SetPos(speed)
			-- self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"),ACT_WALK)
			-- self:MaintainActivity()
			if CurTime() > self.NextCorrosionEffectT then
				for i = 1,2 do
					local tr = {}
					tr.start = self:GetPos() +vector_up *30 *i -direction *30
					tr.endpos = self:GetPos() +vector_up *30 *i -direction *50
					tr.filter = self
					local trace = util.TraceLine(tr)
					if trace.Hit then
						-- util.Decal("SCP_PDCorrosion",trace.HitPos +trace.HitNormal,trace.HitPos -trace.HitNormal)
						util.Decal("MetalStain3",trace.HitPos +trace.HitNormal,trace.HitPos -trace.HitNormal)
					end
				end
				sound.Play("cpthazama/scp/106/Corrosion" .. math.random(1,3) .. ".mp3",self:GetPos(),70,130)
				for i = 0,self:GetBoneCount() -1 do
					if math.random(1,8) == 1 then
						ParticleEffect("blood_impact_black",self:GetBonePosition(i),Angle(0,0,0),nil)
					end
				end
				self.NextCorrosionEffectT = CurTime() +0.18
			end
		else
			self:SetCollisionGroup(COLLISION_GROUP_NPC)
		end
	else
		self:SetCollisionGroup(COLLISION_GROUP_NPC)
	end
		-- Enemy Teleportation --
	if !self.IsPossessed then
		if !self.IsContained && IsValid(self:GetEnemy()) then
			if CurTime() > self.NextTeleportT && !self:GetEnemy():Visible(self) && self:GetClosestPoint(self:GetEnemy()) > 500 && math.random(1,20) == 1 then
				if math.random(1,2) == 1 then
					self:Teleport(self:GetEnemy():GetPos(),true)
				else
					self:Teleport(self:GetEnemy():GetPos() +Vector(math.random(-50,50),math.random(-50,50),0))
				end
				self.NextTeleportT = CurTime() +math.Rand(28,35)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	self.ThemeSong:Stop()
	self.IdleLoop:Stop()
	if self.point != nil then
		self.point:Remove()
	end
	if util.IsSCPMap() then
		for _,v in ipairs(player.GetAll()) do
			v:SendLua("surface.PlaySound('cpthazama/scp/106Contain.mp3')")
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
function ENT:DoWallTeleport(enemy)
	local tPos = enemy:GetPos() +enemy:GetUp() *8
	local trR = self:DoCustomTrace(tPos,tPos +self:GetRight() *400,{self,enemy},true)
	local trL = self:DoCustomTrace(tPos,tPos +self:GetRight() *-400,{self,enemy},true)
	local time = 0.04
	if trR.HitWorld then
		local opos = enemy:GetPos()
		ParticleEffect("scp_decay",self:GetPos(),Angle(0,0,0),nil)
		for i = 0,self:GetBoneCount() -1 do
			ParticleEffect("blood_impact_black",self:GetBonePosition(i),Angle(0,0,0),nil)
		end
		self:SetClearPos(trR.HitPos)
		self:SetAngles(Angle(0,(trR.HitNormal):Angle().y,0))
		-- self:SetPos(self:GetPos() +self:GetForward() *20)
		self:PlayAnimation("TeleportWall")
		util.Decal("MetalStain3",trR.HitPos +trR.HitNormal,trR.HitPos -trR.HitNormal)
		self:EmitSound("cpthazama/scp/106/Decay2.mp3",80,100)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		timer.Simple(2,function()
			if self:IsValid() then
				self:SetCollisionGroup(COLLISION_GROUP_NPC)
			end
		end)
		timer.Simple(self:AnimationLength(ACT_SPRINT) +time,function()
			if self:IsValid() then
				-- self:PlayerChat("Ran")
				local pos,ang = self:GetBonePosition(0)
				self:SetPos(pos)
			end
		end)
	elseif trL.HitWorld then
		local opos = enemy:GetPos()
		ParticleEffect("scp_decay",self:GetPos(),Angle(0,0,0),nil)
		for i = 0,self:GetBoneCount() -1 do
			ParticleEffect("blood_impact_black",self:GetBonePosition(i),Angle(0,0,0),nil)
		end
		self:SetClearPos(trL.HitPos)
		self:SetAngles(Angle(0,(trL.HitNormal):Angle().y,0))
		-- self:SetPos(self:GetPos() +self:GetForward() *20)
		self:PlayAnimation("TeleportWall")
		util.Decal("MetalStain3",trL.HitPos +trL.HitNormal,trL.HitPos -trL.HitNormal)
		self:EmitSound("cpthazama/scp/106/Decay2.mp3",80,100)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		timer.Simple(2,function()
			if self:IsValid() then
				self:SetCollisionGroup(COLLISION_GROUP_NPC)
			end
		end)
		timer.Simple(self:AnimationLength(ACT_SPRINT) +time,function()
			if self:IsValid() then
				-- self:PlayerChat("Ran")
				local pos,ang = self:GetBonePosition(0)
				self:SetPos(pos)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if(disp == D_HT) then
		if (!enemy:Visible(self) || nearest > 900) && math.random(1,20) == 1 && self:CanPerformProcess() then
			self:DoWallTeleport(enemy)
		end
		if nearest <= self.MeleeAttackDistance && self:FindInCone(enemy,self.MeleeAngle) then
			self:DoAttack()
		end
		if self:CanPerformProcess() then
			self:ChaseEnemy()
		end
	end
end