SWEP.PrintName		= "Project 90"
SWEP.HUDSlot = 3
SWEP.HUDImportance = 1
SWEP.Author 		= "Cpt. Hazama"
SWEP.Category		= "CPTBase - SCP:CB"
SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cpthazama/scp/v_p90.mdl"
SWEP.WorldModel		= "models/cpthazama/scp/w_p90.mdl"
SWEP.HoldType		= "smg"
SWEP.Base = "weapon_cpt_base"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.DrawTime = false
SWEP.ReloadTime = false
SWEP.WeaponWeight = 7

SWEP.Primary.TotalShots = 1
SWEP.Primary.Spread = 0.022
SWEP.Primary.Tracer = 1
SWEP.Primary.Force = 1
SWEP.Primary.Damage = 13
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize		= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.NPCFireRate = 0.1

SWEP.DrawAnimation = ACT_VM_DRAW
SWEP.IdleAnimation = ACT_VM_IDLE
SWEP.FireAnimation = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnimation = ACT_VM_RELOAD

SWEP.AdjustWorldModel = true
SWEP.WorldModelAttachmentBone = "ValveBiped.Bip01_R_Hand"
SWEP.WorldModelAdjust = {
	Pos = {Right = 0,Forward = 5,Up = -1},
	Ang = {Right = 170,Up = 185,Forward = 0}
}

SWEP.tbl_Sounds = {
	["DryFire"] = {"weapons/clipempty_rifle.wav"},
	["Fire"] = {"cpthazama/scp/Gunshot.wav"},
	["ReloadA"] = {"weapons/p90/p90_cliprelease.wav"},
	["ReloadB"] = {"weapons/p90/p90_clipout.wav"},
	["ReloadC"] = {"weapons/p90/p90_clipin.wav"},
	["ReloadD"] = {"weapons/p90/p90_boltpull.wav"}
}

function SWEP:ReloadSounds()
	self:PlayWeaponSoundTimed("ReloadA",75,0.8)
	self:PlayWeaponSoundTimed("ReloadB",75,1.6)
	self:PlayWeaponSoundTimed("ReloadC",75,3.6)
	self:PlayWeaponSoundTimed("ReloadD",75,4.9)
end