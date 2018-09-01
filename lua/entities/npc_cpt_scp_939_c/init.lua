if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.StartHealth = 2500
ENT.MonsterType = 2
ENT.MeleeAttackDamage = 160
ENT.AttackFinishTime = 0.9
ENT.HearingDistance = 1300

ENT.tbl_Sounds = {
	["Alert"] = {"cpthazama/scp/939/2Alert1.mp3","cpthazama/scp/939/2Alert2.mp3","cpthazama/scp/939/2Alert3.mp3"},
	["Idle"] = {
		"cpthazama/scp/939/2Lure1.mp3",
		"cpthazama/scp/939/2Lure2.mp3",
		"cpthazama/scp/939/2Lure3.mp3",
		"cpthazama/scp/939/2Lure4.mp3",
		"cpthazama/scp/939/2Lure5.mp3",
		"cpthazama/scp/939/2Lure6.mp3",
		"cpthazama/scp/939/2Lure7.mp3",
		"cpthazama/scp/939/2Lure8.mp3",
		"cpthazama/scp/939/2Lure9.mp3",
	},
	["Voice_Random"] = {"vo/npc/male01/overhere01.wav","vo/npc/male01/onyourside.wav","vo/npc/male01/question06.wav","vo/npc/male01/question09.wav","vo/npc/male01/question11.wav","vo/npc/male01/question23.wav","vo/npc/male01/question25.wav","vo/npc/male01/squad_reinforce_single04.wav","vo/npc/male01/stopitfm.wav","vo/npc/male01/vquestion01.wav"},
	["Strike"] = {"cpthazama/scp/D9341/Damage4.mp3"},
	["Spot"] = {"cpthazama/scp/939/2Attack1.mp3","cpthazama/scp/939/2Attack2.mp3","cpthazama/scp/939/2Attack3.mp3"},
}