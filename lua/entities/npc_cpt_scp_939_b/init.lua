if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.StartHealth = 1000
ENT.MonsterType = 1
ENT.MeleeAttackDamage = 45
ENT.HearingDistance = 1500

ENT.tbl_Sounds = {
	["Alert"] = {"cpthazama/scp/939/1Alert1.wav","cpthazama/scp/939/1Alert2.wav","cpthazama/scp/939/1Alert3.wav"},
	["Idle"] = {
		"cpthazama/scp/939/1Lure1.wav",
		"cpthazama/scp/939/1Lure2.wav",
		"cpthazama/scp/939/1Lure3.wav",
		"cpthazama/scp/939/1Lure4.wav",
		"cpthazama/scp/939/1Lure5.wav",
		"cpthazama/scp/939/1Lure6.wav",
		"cpthazama/scp/939/1Lure7.wav",
		"cpthazama/scp/939/1Lure8.wav",
		"cpthazama/scp/939/1Lure9.wav",
	},
	["Voice_Random"] = {"vo/npc/male01/overhere01.wav","vo/npc/male01/onyourside.wav","vo/npc/male01/question06.wav","vo/npc/male01/question09.wav","vo/npc/male01/question11.wav","vo/npc/male01/question23.wav","vo/npc/male01/question25.wav","vo/npc/male01/squad_reinforce_single04.wav","vo/npc/male01/stopitfm.wav","vo/npc/male01/vquestion01.wav"},
	["Strike"] = {"cpthazama/scp/D9341/Damage4.wav"},
	["Spot"] = {"cpthazama/scp/939/1Attack1.wav","cpthazama/scp/939/1Attack2.wav","cpthazama/scp/939/1Attack3.wav"},
}