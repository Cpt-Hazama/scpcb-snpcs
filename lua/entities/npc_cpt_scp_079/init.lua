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
		self:Possess_DoChat079(possessor,9.821,"LMB - Give the speech")
		self:Possess_DoChat079(possessor,9.822,"RMB - Cycle through doors")
		self:Possess_DoChat079(possessor,9.823,"Reload - Close a door")
		self:Possess_DoChat079(possessor,9.824,"Crouch - Open a door")
		self:Possess_DoChat079(possessor,9.825,"Unlock a door")
		self:Possess_DoChat079(possessor,9.826,"Jump - Lock a door (Unlocks after 10 seconds)")
	else
		self:Possess_DoChat079(possessor,0,"INITIATING CONTROL PANEL -")
		self:Possess_DoChat079(possessor,0.11,"LMB - Give the speech")
		self:Possess_DoChat079(possessor,0.112,"RMB - Cycle through doors")
		self:Possess_DoChat079(possessor,0.113,"Reload - Close a door")
		self:Possess_DoChat079(possessor,0.114,"Crouch - Open a door")
		self:Possess_DoChat079(possessor,0.115,"Unlock a door")
		self:Possess_DoChat079(possessor,0.116,"Jump - Lock a door (Unlocks after 10 seconds)")
	end
	possessor:ConCommand("cpt_scp_togglepcvision")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_DoChat079(ply,time,text)
	timer.Simple(time,function()
		if IsValid(ply) && IsValid(self) then
			ply:ChatPrint(text)
			ply:EmitSound(Sound("buttons/blip1.wav"),25,100)
			if time == 9.826 || time == 0.116 then
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
function ENT:WhenRemoved()
	if IsValid(self.Possessor) && self.Possessor:GetNWBool("CPTBase_IsPossessing") then
		self.Possessor:SetPos(self:GetPos())
		self.Possessor:SpectateEntity(self)
		self.Possessor:ConCommand("cpt_scp_togglepcvision")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Think(possessor,object)
	if self.Possessor_ViewingDoor == true then
		-- object:SetPos(self.Possessor_ViewedDoor:GetPos() +self.Possessor_ViewedDoor:OBBCenter())
		-- object:SetParent(self.Possessor_ViewedDoor)
		possessor:SpectateEntity(self.Possessor_ViewedDoor)
	else
		-- possessor:SpectateEntity(object)
		-- self.Possessor_ViewedDoor = NULL
	end
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
function ENT:Possess_Secondary(possessor)
	if util.IsSCPMap() then
		if self.IsActivated == false then return end
		local tb = {}
		for _,v in ipairs(player.GetAll()) do
			if v:IsValid() && v:Alive() && !v.IsPossessing then
				table.insert(tb,v)
			end
		end
		for _,v in ipairs(ents.GetAll()) do
			if v:IsValid() && v:IsNPC() && v != self then
				table.insert(tb,v)
			end
		end
		if table.Count(tb) <= 0 then return end
		local ply = self:SelectFromTable(tb)
		local tb_doors = {}
		for _,v in ipairs(ents.FindInSphere(ply:GetPos(),500)) do
			if v:IsValid() && v:GetClass() == "func_door" then
				table.insert(tb_doors,v)
			end
		end
		local closestdoor = self:GetClosestDoor_079(tb_doors,ply)
		if IsValid(closestdoor) then
			self.Possessor_ViewingDoor = true
			self.Possessor_ViewedDoor = closestdoor
		end
		table.Empty(tb)
		table.Empty(tb_doors)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Duck(possessor)
	if self.IsActivated == false then return end
	if IsValid(self.Possessor_ViewedDoor) then
		if CurTime() > self.NextDoorT then
			for _,door in ipairs(ents.FindInSphere(self.Possessor_ViewedDoor:GetPos(),30)) do
				if door:IsValid() && door:GetClass() == "func_door" then
					door:Fire("Open")
				end
			end
			self.Possessor_ViewedDoor:EmitSound("cpthazama/scp/079/Broadcast2.mp3",70,100)
			possessor:ChatPrint("You opened a door on " .. ply:Nick() .. ".")
			local nexttime = math.random(4,5)
			possessor:ChatPrint("You can open another door in " .. nexttime .. " seconds.")
			timer.Simple(nexttime,function()
				if self:IsValid() && possessor:IsValid() && possessor.IsPossessing && possessor.CurrentlyPossessedNPC == self then
					possessor:ChatPrint("You can now open another door.")
				end
			end)
			self.NextDoorT = CurTime() +nexttime
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Reload(possessor)
	if self.IsActivated == false then return end
	if IsValid(self.Possessor_ViewedDoor) then
		if CurTime() > self.NextDoorT then
			for _,door in ipairs(ents.FindInSphere(self.Possessor_ViewedDoor:GetPos(),30)) do
				if door:IsValid() && door:GetClass() == "func_door" then
					door:Fire("Close")
				end
			end
			self.Possessor_ViewedDoor:EmitSound("cpthazama/scp/079/Broadcast2.mp3",70,100)
			local nexttime = math.random(4,5)
			possessor:ChatPrint("You can shut another door in " .. nexttime .. " seconds.")
			timer.Simple(nexttime,function()
				if self:IsValid() && possessor:IsValid() && possessor.IsPossessing && possessor.CurrentlyPossessedNPC == self then
					possessor:ChatPrint("You can now shut another door.")
				end
			end)
			self.NextDoorT = CurTime() +nexttime
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Jump(possessor)
	if self.IsActivated == false then return end
	if IsValid(self.Possessor_ViewedDoor) then
		if CurTime() > self.NextDoorT then
			local tbl = {}
			for _,door in ipairs(ents.FindInSphere(self.Possessor_ViewedDoor:GetPos(),30)) do
				if door:IsValid() && door:GetClass() == "func_door" then
					door:Fire("Lock")
					table.insert(tbl,door)
				end
			end
			self.Possessor_ViewedDoor:EmitSound("cpthazama/scp/079/Broadcast2.mp3",70,100)
			timer.Simple(10,function()
				for _,v in ipairs(tbl) do
					if v:IsValid() then
						v:Fire("Unlock")
					end
				end
			end)
			local nexttime = math.random(4,5)
			possessor:ChatPrint("You can lock another door in " .. nexttime .. " seconds.")
			timer.Simple(nexttime,function()
				if self:IsValid() && possessor:IsValid() && possessor.IsPossessing && possessor.CurrentlyPossessedNPC == self then
					possessor:ChatPrint("You can now lock another door.")
				end
			end)
			self.NextDoorT = CurTime() +nexttime
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Walk(possessor)
	if self.IsActivated == false then return end
	if IsValid(self.Possessor_ViewedDoor) then
		if CurTime() > self.NextDoorT then
			local tbl = {}
			for _,door in ipairs(ents.FindInSphere(self.Possessor_ViewedDoor:GetPos(),30)) do
				if door:IsValid() && door:GetClass() == "func_door" then
					door:Fire("Unlock")
					table.insert(tbl,door)
				end
			end
			self.Possessor_ViewedDoor:EmitSound("cpthazama/scp/079/Broadcast2.mp3",70,100)
			local nexttime = math.random(4,5)
			possessor:ChatPrint("You can unlock another door in " .. nexttime .. " seconds.")
			timer.Simple(nexttime,function()
				if self:IsValid() && possessor:IsValid() && possessor.IsPossessing && possessor.CurrentlyPossessedNPC == self then
					possessor:ChatPrint("You can now unlock another door.")
				end
			end)
			self.NextDoorT = CurTime() +nexttime
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if !self.IsPossessed then
		if util.IsSCPMap() then
			local tb = {}
			if CurTime() > self.NextDoorT then
				for _,v in ipairs(player.GetAll()) do
					if v:IsValid() && v:Alive() then
						table.insert(tb,v)
					end
				end
				local ply = self:SelectFromTable(tb)
				for _,v in ipairs(ents.FindInSphere(ply:GetPos(),100)) do
					if v:IsValid() && v:GetClass() == "func_door" then
						for _,door in ipairs(ents.FindInSphere(v:GetPos(),30)) do
							if door:IsValid() && door:GetClass() == "func_door" then
								door:Fire("Close")
							end
						end
						v:EmitSound("cpthazama/scp/079/Broadcast2.mp3",70,100)
						ply:EmitSound("cpthazama/scp/music/Horror7.mp3",70,100)
					end
				end
				table.Empty(tb)
				self.NextDoorT = CurTime() +math.Rand(20,60)
			end
		end
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Primary(possessor)
	if self.IsActivated == false then return end
	if self.IsTalking == false && self.CanBeSpokenTo == true then
		self:PlaySound("Speech",80)
		timer.Simple(4.5,function()
			if self:IsValid() then
				self:SetSkin(1)
			end
		end)
		self.CanBeSpokenTo = false
		self.NextIdleSoundT = CurTime() +999999
		self.NextPainSoundT = CurTime() +999999
		self.IsTalking = true
		timer.Simple(55,function()
			if self:IsValid() then
				self.IsTalking = false
				self:SetSkin(2)
				self.NextIdleSoundT = CurTime() +5
				self.NextPainSoundT = CurTime() +5
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
end