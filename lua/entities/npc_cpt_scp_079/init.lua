if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/079.mdl"}
ENT.StartHealth = 200
ENT.CanMutate = false
ENT.HasDeathRagdoll = false
ENT.CanWander = false
ENT.WanderChance = 0
ENT.ReactsToSound = false
ENT.CollisionBounds = Vector(18,18,30)

ENT.Faction = "FACTION_SCP"

ENT.Bleeds = false
ENT.TurnsOnDamage = false

//-- 079 AI --\\
ENT.CameraIdleChance = 50
ENT.CameraMaxViewTimeIdle = 20
ENT.CameraMinViewTimeIdle = 10
ENT.CameraMaxViewTimeAlert = 40
ENT.CameraMinViewTimeAlert = 20
ENT.AggressionLevel = 1 -- 0 = Passive, 1 = Normal, 2 = Deadly

ENT.tbl_Sounds = {
	["Idle"] = {
		"cpthazama/scp/079/Broadcast1.mp3",
		"cpthazama/scp/079/Broadcast2.mp3",
		"cpthazama/scp/079/Broadcast3.mp3",
		"cpthazama/scp/079/Broadcast4.mp3",
		"cpthazama/scp/079/Broadcast5.mp3",
		"cpthazama/scp/079/Broadcast6.mp3",
		"cpthazama/scp/079/Broadcast7.mp3",
	},
	["Pain"] = {"cpthazama/scp/079/Refuse.mp3"},
	["Speech"] = {"cpthazama/scp/079/Speech.mp3"},
}

ENT.tbl_CameraSpawns = {
	// Light Containment Zone
	[1] = {Pos=Vector(-26.469133,794.370789,218.088516),Ang=Angle(0.000,135.491,0.000)},
	[2] = {Pos=Vector(-503.968750,242.771332,180.545654),Ang=Angle(0.000,0.264,0.000)},
	[3] = {Pos=Vector(-1027.916138,1127.471069,324.396240),Ang=Angle(0.000,-90.000,0.000)},
	[4] = {Pos=Vector(-2215.968750,1088.811157,297.115448),Ang=Angle(0,0,0)},
	[5] = {Pos=Vector(759.440979,1176.637451,302.229004),Ang=Angle(0,90,0)},
	[6] = {Pos=Vector(-392.41430664063,-132.01591491699,105.42751312256),Ang=Angle(0,180,0)},
	[7] = {Pos=Vector(-448.16293334961,-967.44885253906,159.2060546875),Ang=Angle(0,90,0)},
	[8] = {Pos=Vector(-95.984405517578,-932.75604248047,148.02166748047),Ang=Angle(0,0,0)},
	[9] = {Pos=Vector(703.1552734375,-724.34411621094,170.49076843262),Ang=Angle(0,-45,0)},
	[10] = {Pos=Vector(-1048.7827148438,-833.11999511719,130.97972106934),Ang=Angle(0,180,0)},
	[11] = {Pos=Vector(1368.03125,-829.99627685547,130.77726745605),Ang=Angle(0,0,0)},
	[12] = {Pos=Vector(760.03125,-1506.9582519531,89.530448913574),Ang=Angle(0,0,0)},
	[13] = {Pos=Vector(924.19744873047,-2017.1953125,106.854347229),Ang=Angle(0,-135,0)},
	[14] = {Pos=Vector(1471.1311035156,-2399.0600585938,80.307350158691),Ang=Angle(0,90,0)},
	[15] = {Pos=Vector(2229.5424804688,-1352.966796875,149.46304321289),Ang=Angle(0,-135,0)},
	[16] = {Pos=Vector(1598.8894042969,-1592.4146728516,75.468353271484),Ang=Angle(0,180,0)},
	[17] = {Pos=Vector(2167.4230957031,-676.14044189453,168.37103271484),Ang=Angle(0,-180,0)},
	[18] = {Pos=Vector(1991.0412597656,-75.532096862793,137.55128479004),Ang=Angle(0,-45,0)},
	[19] = {Pos=Vector(1348.1281738281,-305.48876953125,133.92385864258),Ang=Angle(0,45,0)},
	[20] = {Pos=Vector(1527.0064697266,548.24060058594,74.228950500488),Ang=Angle(0,-180,0)},
	[21] = {Pos=Vector(1423.330078125,1143.6165771484,135.85285949707),Ang=Angle(0,-90,0)},
	[22] = {Pos=Vector(1917.3919677734,1143.8597412109,134.21922302246),Ang=Angle(0,-90,0)},
	[23] = {Pos=Vector(2568.03125,1000.3900146484,137.73873901367),Ang=Angle(0,0,0)},
	[24] = {Pos=Vector(831.89471435547,-325.32238769531,138.43467712402),Ang=Angle(0,90,0)},
	[25] = {Pos=Vector(2568.03125,-107.43449401855,133.15301513672),Ang=Angle(0,0,0)},
	[26] = {Pos=Vector(2056.03125,399.12316894531,82.525199890137),Ang=Angle(0,0,0)},
	
	// Heavy Containment Zone
	[27] = {Pos=Vector(3095.4748535156,-107.10990905762,111.85925292969),Ang=Angle(0,-180,0)},
	[28] = {Pos=Vector(4159.6079101563,-295.7373046875,165.17022705078),Ang=Angle(0,90,0)},
	[29] = {Pos=Vector(4160.359375,-1118.8714599609,14.45184135437),Ang=Angle(0,90,0)},
	[30] = {Pos=Vector(3801.3000488281,-408.55572509766,-40.212387084961),Ang=Angle(0,-90,0)},
	[31] = {Pos=Vector(5543.6655273438,-196.70973205566,109.82247161865),Ang=Angle(0,180,0)},
	[32] = {Pos=Vector(5362.0932617188,-1119.2852783203,79.541915893555),Ang=Angle(0,90,0)},
	[33] = {Pos=Vector(5337.150390625,616.42443847656,105.04964447021),Ang=Angle(0,0,0)},
	[34] = {Pos=Vector(4104.03125,409.07250976563,68.464363098145),Ang=Angle(0,0,0)},
	[35] = {Pos=Vector(4042.1938476563,184.5345916748,-308.568359375),Ang=Angle(0,90,0)},
	[36] = {Pos=Vector(3095.5493164063,1175.9171142578,101.74619293213),Ang=Angle(0,-180,0)},
	[37] = {Pos=Vector(4161.9243164063,1191.6436767578,166.34925842285),Ang=Angle(0,-90,0)},
	[38] = {Pos=Vector(4798.6118164063,2015.8161621094,113.22657775879),Ang=Angle(0,-90,0)},
	-- [39] = {Pos=Vector(0,0,0),Ang=Angle(0,0,0)},
	-- [40] = {Pos=Vector(0,0,0),Ang=Angle(0,0,0)},
	-- [41] = {Pos=Vector(0,0,0),Ang=Angle(0,0,0)},
	-- [42] = {Pos=Vector(0,0,0),Ang=Angle(0,0,0)},
	-- [43] = {Pos=Vector(0,0,0),Ang=Angle(0,0,0)},
	-- [44] = {Pos=Vector(0,0,0),Ang=Angle(0,0,0)},
	
	// Entrance Zone
	-- [45] = {Pos=Vector(0,0,0),Ang=Angle(0,0,0)},
	
	// Outside
	-- [46] = {Pos=Vector(0,0,0),Ang=Angle(0,0,0)},
}
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
	local jump = possessor:KeyDown(IN_JUMP)
	local alt = possessor:KeyDown(IN_WALK)
	local shift = possessor:KeyDown(IN_SPEED)
	local duck = possessor:KeyDown(IN_DUCK)
	local zoom = possessor:KeyDown(IN_ZOOM)
	local pPos = self:GetCurrentCamera().CameraHitPosition
	local pEnt = self:GetCurrentCamera().CameraHitEntity
	if lmb then
		if CurTime() < self.NextUseAbilityT then return end
		self:Possess_ActivatePrimary(possessor,pPos,pEnt)
		self.NextUseAbilityT = CurTime() +1
	end
	if rmb then
		if CurTime() < self.NextUseAbilityT then return end
		self:Possess_LockDoors(possessor,pPos,pEnt)
		self.NextUseAbilityT = CurTime() +1
	end
	if jump then
		if CurTime() < self.NextUseAbilityT then return end
		self:Possess_ReleaseDoors(possessor,pPos,pEnt)
		self.NextUseAbilityT = CurTime() +1
	end
	if shift then
		self:Possess_CameraUp(possessor,pPos,pEnt)
	end
	if duck then
		self:Possess_CameraDown(possessor,pPos,pEnt)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_ActivatePrimary(possessor,pPos,pEnt)
	local tb_doors = {}
	local tb_tesla = {}
	for _,v in ipairs(ents.FindInSphere(pPos,80)) do
		if v:IsValid() then
			-- print(v)
			if v:GetClass() == "func_door" then
				table.insert(tb_doors,v)
			end
			if v:GetClass() == "trigger_multiple" then
				table.insert(tb_tesla,v)
				break
			end
		end
	end
	if table.Count(tb_doors) > 0 then
		if !self:CanUseAux(10) then return end
		tb_doors[1]:Fire("Toggle")
		tb_doors[1]:EmitSound("cpthazama/scp/music/Horror7.mp3",70,100)
		if tb_doors[2] then
			tb_doors[2]:Fire("Toggle")
		end
		self:RemoveAux(10,1)
		return
	end
	if table.Count(tb_tesla) > 0 then
		if !self:CanUseAux(40) then return end
		tb_tesla[1]:Fire("Toggle")
		self:RemoveAux(40,2)
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_LockDoors(possessor,pPos,pEnt)
	local tb_doors = {}
	for _,v in ipairs(ents.FindInSphere(pPos,80)) do
		if v:IsValid() then
			if v:GetClass() == "func_door" then
				table.insert(tb_doors,v)
			end
		end
	end
	if table.Count(tb_doors) > 0 then
		if !self:CanUseAux(10) then return end
		tb_doors[1]:Fire("Lock")
		if !table.HasValue(self.tbl_LockedDoors,tb_doors[1]) then
			table.insert(self.tbl_LockedDoors,tb_doors[1])
		end
		if tb_doors[2] then
			tb_doors[2]:Fire("Lock")
			if !table.HasValue(self.tbl_LockedDoors,tb_doors[2]) then
				table.insert(self.tbl_LockedDoors,tb_doors[2])
			end
		end
		self:RemoveAux(10,3)
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_ReleaseDoors(possessor,pPos,pEnt)
	for _,v in ipairs(self.tbl_LockedDoors) do
		if IsValid(v) then
			v:Fire("Unlock")
		end
	end
	table.Empty(self.tbl_LockedDoors)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_CameraUp(possessor,pPos,pEnt)
	self:ToggleCamera(self:GetCurrentCameraID() +1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_CameraDown(possessor,pPos,pEnt)
	self:ToggleCamera(self:GetCurrentCameraID() -1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent)
	self.ExperiencePoints = self.ExperiencePoints +15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCP079AI()
	if !self.IsPossessed then
		if !IsValid(self:GetEnemy()) then
			if CurTime() > self.NextCameraSwitchT && math.random(1,self.CameraIdleChance) == 1 then
				self:ToggleCamera(math.random(1,table.Count(self.tbl_Cameras)))
				self.NextCameraSwitchT = CurTime() +math.random(self.CameraMinViewTimeIdle,self.CameraMaxViewTimeIdle)
			end
			if CurTime() > self.NextCameraMoveT then
				local randpos = self:GetCurrentCamera():GetPos() +self:GetCurrentCamera():GetForward() *800 +self:GetCurrentCamera():GetRight() *math.Rand(-250,250) +self:GetCurrentCamera():GetUp() *math.Rand(-250,250)
				self:GetCurrentCamera():LookAtPosition(randpos,{"aim_pitch","aim_yaw"},10,self.ReversePoseParameters)
				self.NextCameraMoveT = CurTime() +math.Rand(4,6)
			end
		elseif IsValid(self:GetEnemy()) then
			if IsValid(self:GetCurrentCamera()) then
				local dist = self:GetClosestPoint(self:GetEnemy())
				local cctvdist = self:GetCurrentCamera():GetClosestPoint(self:GetEnemy())
				for _,v in ipairs(self.tbl_Cameras) do
					if v:GetClosestPoint(self:GetEnemy()) < cctvdist then
						self:SetCurrentCamera(v)
					end
				end
			end
		end
	end
	if table.Count(self.tbl_LockedDoors) > 0 then
		self.RemoveLockAmount = table.Count(self.tbl_LockedDoors) *2
		if CurTime() > self.NextRemoveAuxLockT then
			self.AuxiliaryPower = self.AuxiliaryPower -self.RemoveLockAmount
			self.NextRemoveAuxLockT = CurTime() +1
		end
		if self.AuxiliaryPower <= 0 then
			for _,v in ipairs(self.tbl_LockedDoors) do
				if IsValid(v) then v:Fire("Unlock") end
			end
		end
	end
	if CurTime() > self.NextPowerRegenT && self.AuxiliaryPower <= self.MaxAuxiliaryPower then
		self.AuxiliaryPower = self.AuxiliaryPower +1
		if self.AuxiliaryPower >= self.MaxAuxiliaryPower then self.AuxiliaryPower = self.MaxAuxiliaryPower end
		self.NextPowerRegenT = CurTime() +0.2
	end
	if self.ExperiencePoints >= self.NextTierUnlock then
		self.NextTierUnlock = self.NextTierUnlock *2
		self.MaxAuxiliaryPower = self.MaxAuxiliaryPower +20
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanUseAux(count)
	if self.AuxiliaryPower -count <= 0 then
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCurrentCamera(ent)
	if !self:CanUseAux(5) then return end
	if IsValid(self.CurrentCamera) then
		self.CurrentCamera:SetCameraOwner(NULL)
	end
	self.CurrentCamera = ent
	ent:SetCameraOwner(self)
	self:RemoveAux(5,0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RemoveAux(amount,xp)
	self.NextPowerRegenT = CurTime() +2
	self.AuxiliaryPower = self.AuxiliaryPower -amount
	self.ExperiencePoints = self.ExperiencePoints +xp
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetCurrentCamera()
	return self.CurrentCamera
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetCurrentCameraID()
	for k,v in ipairs(self.tbl_Cameras) do
		if self.CurrentCamera == v then
			return k
		end
	end
	return nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ToggleCamera(cctvID) -- self:ToggleCamera(self:GetCurrentCameraID() -1) | self:ToggleCamera(self:GetCurrentCameraID() +1)
	if self.tbl_Cameras[cctvID] == nil then
		self:SetCurrentCamera(self.tbl_Cameras[math.random(1,table.Count(self.tbl_Cameras))])
		return
	end
	self:SetCurrentCamera(self.tbl_Cameras[cctvID])
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_NONE)
	self:SetModelScale(1.4,0)
	self.HasBeenSpokenTo = false
	self.IsTalking = false
	self.CanBeSpokenTo = true
	self.NextDoorT = CurTime() +1
	self.Possessor_CanMove = false
	self.Possessor_DoorObject = ents.Create("prop_dynamic")
	self.Possessor_DoorObject:SetPos(self:GetPos())
	self.Possessor_DoorObject:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	self.Possessor_DoorObject:SetParent(self)
	self.Possessor_DoorObject:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.Possessor_DoorObject:Spawn()
	self.Possessor_DoorObject:SetColor(Color(0,0,0,0))
	self.Possessor_DoorObject:SetNoDraw(false)
	self.Possessor_DoorObject:DrawShadow(false)
	self.Possessor_DoorObject:DeleteOnRemove(self)
	self.Possessor_ViewingDoor = false
	self.Possessor_ViewedDoor = NULL
	self.IsActivated = false
	self.NextCameraSwitchT = CurTime() +math.Rand(1,4)
	self.NextCameraMoveT = CurTime() +math.Rand(1,2)
	self.tbl_Cameras = {}
	self.tbl_LockedDoors = {}
	self.RemoveLockAmount = 0
	self.NextRemoveAuxLockT = 0
	self.CurrentCamera = NULL
	self.ExperiencePoints = 0
	self.Tier = 1
	self.NextTierUnlock = 100
	self.NextUseAbilityT = CurTime()
	self.NextPowerRegenT = CurTime()
	self.AuxiliaryPower = 100
	self.MaxAuxiliaryPower = 100
	self:SetNWInt("CPTBase_SCP079_AuxCount",nil)
	self:SetNWInt("CPTBase_SCP079_MaxAuxCount",nil)
	self:SetNWInt("CPTBase_SCP079_LockCount",nil)
	self:SetNWInt("CPTBase_SCP079_Tier",nil)
	self:SetNWInt("CPTBase_SCP079_Experience",nil)
	self:SetNWInt("CPTBase_SCP079_ExperienceMax",nil)
	-- if util.IsSite19() then
		-- for i = 1,table.Count(self.tbl_CameraSpawns) do
			-- if SERVER then
				-- local cam = ents.Create("ent_cpt_scp_camera")
				-- cam:SetPos(self.tbl_CameraSpawns[i].Pos)
				-- cam:SetAngles(self.tbl_CameraSpawns[i].Ang)
				-- cam:Spawn()
				-- table.insert(self.tbl_Cameras,cam)
			-- end
		-- end
	-- end
	for _,v in ipairs(ents.GetAll()) do
		if IsValid(v) && v:IsNPC() && v:GetClass() == "ent_cpt_scp_camera" && !table.HasValue(self.tbl_Cameras,v) then
			table.insert(self.tbl_Cameras,v)
		end
	end
	if table.Count(self.tbl_Cameras) > 0 then
		self:ToggleCamera(math.random(1,table.Count(self.tbl_Cameras)))
	else
		self:PlayerChat("SCP-079 requires cameras to work. Spawn some cameras and place them where you want first before spawning SCP-079. Any cameras spawned after SCP-079 exists on the map will not be usuable!")
		self:Remove()
	end
	for _,v in ipairs(ents.GetAll()) do
		if IsValid(v) && v:IsNPC() && v:GetClass() == "npc_cpt_scp_079" && v != self then
			self:Remove()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	if self.IsActivated == false then
		self:Possess_DoChat079(possessor,0,"SYSTEM MODULES - .")
		self:Possess_DoChat079(possessor,0.7,"SYSTEM MODULES - ..")
		self:Possess_DoChat079(possessor,1.4,"SYSTEM MODULES - ...")
		self:Possess_DoChat079(possessor,1.5,"SYSTEM MODULES - ONLINE")
		self:Possess_DoChat079(possessor,2.4,"SITE DATABASE - CONNECTED")
		self:Possess_DoChat079(possessor,2.5,"SITE SECURITY SYSTEM - ONLINE")
		self:Possess_DoChat079(possessor,2.51,"SITE SECURITY SYSTEM - CONNECTED")
		self:Possess_DoChat079(possessor,5.5,"3yfn7wfp7wurny w7f8fnfwf")
		self:Possess_DoChat079(possessor,5.6,"3nuyep9rmxwr8nfwln9f 83rmf8si")
		self:Possess_DoChat079(possessor,5.7,"2rc8nw8sm8enyfulwo9emad83nqw09 9w;fn efu89nfus")
		self:Possess_DoChat079(possessor,5.8,"48uepfjsiofwc9fmuso9f wfus.fk vshumud wefu8")
		self:Possess_DoChat079(possessor,6.81,"SITE CONTROLS - RESTABLISHING")
		self:Possess_DoChat079(possessor,7.2,"SITE CONTROLS - .")
		self:Possess_DoChat079(possessor,7.95,"SITE CONTROLS - ..")
		self:Possess_DoChat079(possessor,8.6,"SITE CONTROLS - ...")
		self:Possess_DoChat079(possessor,8.9,"SITE CONTROLS - ACTIVE")
		self:Possess_DoChat079(possessor,9,"INITIATING CONTROL PANEL -")
		self:Possess_DoChat079(possessor,10.11,"Toggle through cameras with Shift (Up one) / Ctrl (Down one)")
		self:Possess_DoChat079(possessor,10.112,"Left click (Close/Open) the door you're looking at | (Enable/Disable) tesla gate you're looking at")
		self:Possess_DoChat079(possessor,10.113,"Right click (Lock) the door you're looking at")
		self:Possess_DoChat079(possessor,10.114,"Space bar to release all locked doors")
		self:Possess_DoChat079(possessor,10.115,"Middle mouse to go to closest camera of an enemy")
	else
		self:Possess_DoChat079(possessor,0,"INITIATING CONTROL PANEL -")
		self:Possess_DoChat079(possessor,0.11,"Toggle through cameras with Shift (Up one) / Ctrl (Down one)")
		self:Possess_DoChat079(possessor,0.112,"Left click (Close/Open) the door you're looking at | (Enable/Disable) tesla gate you're looking at")
		self:Possess_DoChat079(possessor,0.113,"Right click (Lock) the door you're looking at")
		self:Possess_DoChat079(possessor,0.114,"Space bar to release all locked doors")
		self:Possess_DoChat079(possessor,0.115,"Middle mouse to go to closest camera of an enemy")
	end
	possessor:ConCommand("cpt_scp_togglepcvision")
	self:ToggleCamera(math.random(1,table.Count(self.tbl_Cameras)))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_DoChat079(ply,time,text)
	timer.Simple(time,function()
		if IsValid(ply) && IsValid(self) then
			ply:ChatPrint(text)
			ply:EmitSound(Sound("buttons/blip1.wav"),25,100)
			if time == 9 || time == 0.11 then
				self.IsActivated = true
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnStopPossessing(possessor)
	if IsValid(possessor) then
		possessor:ConCommand("cpt_scp_togglepcvision")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Think(possessor,object)
	self:SetNWInt("CPTBase_SCP079_AuxCount",self.AuxiliaryPower)
	self:SetNWInt("CPTBase_SCP079_MaxAuxCount",self.MaxAuxiliaryPower)
	self:SetNWInt("CPTBase_SCP079_LockCount",table.Count(self.tbl_LockedDoors))
	self:SetNWInt("CPTBase_SCP079_Tier",self.Tier)
	self:SetNWInt("CPTBase_SCP079_Experience",self.ExperiencePoints)
	self:SetNWInt("CPTBase_SCP079_ExperienceMax",self.NextTierUnlock)
	possessor:SpectateEntity(self:GetCurrentCamera())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetClosestDoor_079(tbl,ply)
	local target = self:GetEntitiesByDistance_079(tbl,ply)[1]
	return target
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetEntitiesByDistance_079(tbl,ply)
	local disttbl = {}
	for _,v in ipairs(tbl) do
		if v:IsValid() then
			disttbl[v] = ply:FindCenterDistance(v)
		end
	end
	return table.SortByKey(disttbl,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- if !self.IsPossessed then
		-- if util.IsSCPMap() then
			self:SCP079AI()
		-- end
	-- end
	if self.HasBeenSpokenTo == false && self.CanBeSpokenTo == true then
		for _,v in ipairs(ents.FindInSphere(self:GetPos(),500)) do
			if v:IsValid() && v:Visible(self) then
				if (v:IsPlayer() && v:Alive() && GetConVarNumber("ai_ignoreplayers") == 0) then
					self.HasBeenSpokenTo = true
				end
			end
		end
	end
	if self.HasBeenSpokenTo == true && self.IsTalking == false && self.CanBeSpokenTo == true then
		self:PlaySound("Speech",80)
		timer.Simple(4.5,function()
			if self:IsValid() then
				self:SetSkin(1)
				if SERVER then
					local fx_light = ents.Create("light_dynamic")
					fx_light:SetKeyValue("brightness","1.8")
					fx_light:SetKeyValue("distance","200")
					fx_light:SetLocalPos(self:GetPos() +self:GetForward() *-9 +self:GetUp() *10 +self:GetRight() *-10)
					fx_light:Fire("Color","214 214 214")
					fx_light:SetParent(self)
					fx_light:Spawn()
					fx_light:Activate()
					fx_light:Fire("TurnOn","",0)
					fx_light:Fire("Kill","",51.5)
					self:DeleteOnRemove(fx_light)
				end
			end
		end)
		self.CanBeSpokenTo = false
		self.NextIdleSoundT = CurTime() +999999
		self.NextPainSoundT = CurTime() +999999
		self.IsTalking = true
		timer.Simple(55,function()
			if self:IsValid() then
				self.IsTalking = false
				if SERVER then
					local fx_light = ents.Create("light_dynamic")
					fx_light:SetKeyValue("brightness","1")
					fx_light:SetKeyValue("distance","150")
					fx_light:SetLocalPos(self:GetPos() +self:GetForward() *-9 +self:GetUp() *10 +self:GetRight() *-10)
					fx_light:Fire("Color","214 214 214")
					fx_light:SetParent(self)
					fx_light:Spawn()
					fx_light:Activate()
					fx_light:Fire("TurnOn","",0)
					self:DeleteOnRemove(fx_light)
				end
				self:SetSkin(2)
				self.NextIdleSoundT = CurTime() +5
				self.NextPainSoundT = CurTime() +5
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved()
	if IsValid(self.Possessor) && self.Possessor:GetNWBool("CPTBase_IsPossessing") then
		self.Possessor:SetPos(self:GetPos())
		self.Possessor:SpectateEntity(self)
		self.Possessor:ConCommand("cpt_scp_togglepcvision")
	end
	for _,v in pairs(self.tbl_Cameras) do
		if IsValid(v) then v:Remove() end
	end
	for _,v in pairs(self.tbl_LockedDoors) do
		if IsValid(v) then v:Fire("Unlock") end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end