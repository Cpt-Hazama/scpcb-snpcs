if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.StartHealth = 2500
ENT.MonsterType = 2
ENT.MeleeAttackDamage = 160
ENT.AttackFinishTime = 0.9
ENT.HearingDistance = 1300

ENT.tbl_Sounds = {
	["Alert"] = {"cpthazama/scp/939/2Alert1.wav","cpthazama/scp/939/2Alert2.wav","cpthazama/scp/939/2Alert3.wav"},
	["Idle"] = {
		"cpthazama/scp/939/2Lure1.wav",
		"cpthazama/scp/939/2Lure2.wav",
		"cpthazama/scp/939/2Lure3.wav",
		"cpthazama/scp/939/2Lure4.wav",
		"cpthazama/scp/939/2Lure5.wav",
		"cpthazama/scp/939/2Lure6.wav",
		"cpthazama/scp/939/2Lure7.wav",
		"cpthazama/scp/939/2Lure8.wav",
		"cpthazama/scp/939/2Lure9.wav",
	},
	["Voice_Random"] = {"vo/npc/male01/overhere01.wav","vo/npc/male01/onyourside.wav","vo/npc/male01/question06.wav","vo/npc/male01/question09.wav","vo/npc/male01/question11.wav","vo/npc/male01/question23.wav","vo/npc/male01/question25.wav","vo/npc/male01/squad_reinforce_single04.wav","vo/npc/male01/stopitfm.wav","vo/npc/male01/vquestion01.wav"},
	["Strike"] = {"cpthazama/scp/D9341/Damage4.wav"},
	["Spot"] = {"cpthazama/scp/939/2Attack1.wav","cpthazama/scp/939/2Attack2.wav","cpthazama/scp/939/2Attack3.wav"},
}