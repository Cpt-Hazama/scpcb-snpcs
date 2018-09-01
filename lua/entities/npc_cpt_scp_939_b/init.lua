if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.StartHealth = 1000
ENT.MonsterType = 1
ENT.MeleeAttackDamage = 45
ENT.HearingDistance = 1500

ENT.tbl_Sounds = {
	["Alert"] = {"cpthazama/scp/939/1Alert1.mp3","cpthazama/scp/939/1Alert2.mp3","cpthazama/scp/939/1Alert3.mp3"},
	["Idle"] = {
		"cpthazama/scp/939/1Lure1.mp3",
		"cpthazama/scp/939/1Lure2.mp3",
		"cpthazama/scp/939/1Lure3.mp3",
		"cpthazama/scp/939/1Lure4.mp3",
		"cpthazama/scp/939/1Lure5.mp3",
		"cpthazama/scp/939/1Lure6.mp3",
		"cpthazama/scp/939/1Lure7.mp3",
		"cpthazama/scp/939/1Lure8.mp3",
		"cpthazama/scp/939/1Lure9.mp3",
	},
	["Voice_Random"] = {"vo/npc/male01/overhere01.wav","vo/npc/male01/onyourside.wav","vo/npc/male01/question06.wav","vo/npc/male01/question09.wav","vo/npc/male01/question11.wav","vo/npc/male01/question23.wav","vo/npc/male01/question25.wav","vo/npc/male01/squad_reinforce_single04.wav","vo/npc/male01/stopitfm.wav","vo/npc/male01/vquestion01.wav"},
	["Strike"] = {"cpthazama/scp/D9341/Damage4.mp3"},
	["Spot"] = {"cpthazama/scp/939/1Attack1.mp3","cpthazama/scp/939/1Attack2.mp3","cpthazama/scp/939/1Attack3.mp3"},
}