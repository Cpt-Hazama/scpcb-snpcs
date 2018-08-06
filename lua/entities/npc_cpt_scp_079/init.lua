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
		"cpthazama/scp/079/Broadcast1.wav",
		"cpthazama/scp/079/Broadcast2.wav",
		"cpthazama/scp/079/Broadcast3.wav",
		"cpthazama/scp/079/Broadcast4.wav",
		"cpthazama/scp/079/Broadcast5.wav",
		"cpthazama/scp/079/Broadcast6.wav",
		"cpthazama/scp/079/Broadcast7.wav",
	},
	["Pain"] = {"cpthazama/scp/079/Refuse.wav"},
	["Speech"] = {"cpthazama/scp/079/Speech.wav"},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_NONE)
	self:SetModelScale(1.4,0)
	self.HasBeenSpokenTo = false
	self.IsTalking = false
	self.CanBeSpokenTo = true
	self.NextDoorT = CurTime() +5
	self.Possessor_CanMove = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	possessor:ChatPrint("Possessor Controls:")
	possessor:ChatPrint("LMB - Give a speech")
	possessor:ChatPrint("RMB - Close a random door around the map")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_Secondary(possessor)
	if util.IsSCPMap() then
		local tb = {}
		if CurTime() > self.NextDoorT then
			for _,v in ipairs(player.GetAll()) do
				if v:IsValid() && v:Alive() && !v.IsPossessing then
					table.insert(tb,v)
				end
			end
			if table.Count(tb) <= 0 then return end
			local ply = self:SelectFromTable(tb)
			for _,v in ipairs(ents.FindInSphere(ply:GetPos(),100)) do
				if v:IsValid() && v:GetClass() == "func_door" then
					for _,door in ipairs(ents.FindInSphere(v:GetPos(),30)) do
						if door:IsValid() && door:GetClass() == "func_door" then
							door:Fire("Close")
						end
					end
					v:EmitSound("cpthazama/scp/079/Broadcast2.wav",70,100)
					possessor:ChatPrint("You shut a door on " .. ply:Nick() .. ".")
				end
			end
			table.Empty(tb)
			local nexttime = math.Rand(8,12)
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
						v:EmitSound("cpthazama/scp/079/Broadcast2.wav",70,100)
						ply:EmitSound("cpthazama/scp/music/Horror7.wav",70,100)
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