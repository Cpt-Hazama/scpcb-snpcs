if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/scp/049-2_ntf.mdl"}
ENT.StartHealth = 500

ENT.MeleeAttackDamage = 28

ENT.tbl_Sounds = {
	["FootStep"] = {"cpthazama/scp/ntf/Step1.wav","cpthazama/scp/ntf/Step2.wav","cpthazama/scp/ntf/Step3.wav"},
	["Strike"] = {"cpthazama/scp/D9341/Damage3.wav"},
}