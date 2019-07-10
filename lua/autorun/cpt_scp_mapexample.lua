/*--------------------------------------------------
	Copyright (c) 2019 by Cpt. Hazama, All rights reserved.
	Nothing in these files or/and code may be reproduced, adapted, merged or
	modified without prior written consent of the original author, Cpt. Hazama
--------------------------------------------------*/
include('server/cpt_utilities.lua')
include('cpt_scp_map.lua')

/*
	This will show mappers how to add their own Vectors for my SNPCs
	To retrieve coordinates, run this in your console in singleplayer: lua_run for _,v in pairs(player.GetAll()) do print("Vector("..v:GetPos().x..","..v:GetPos().y..","..v:GetPos().z..")") end

	To ensure everything works properly, make sure that you put the vectors in the same order as those listed below. I was having trouble allowing you to give the vectors nick names so for now you'll just have to put them in the same order as those listed.

	Vectors in order:
	POCKETDIMENSION
	FEMURBREAKER
	FEMURBREAKERBUTTON
	THESTATUE
	VENTA
	VENTB
	VENTC
	VENTD
	VENTE
	VENTF
	VENTG
	VENTH
	
	You do not have to put the vents or the statue vectors. Infact the only vector you really need imo is the pocket dimension. However I recommend you add the PD and femur breaker stuff at least
*/

POCKETDIMENSION = 1
FEMURBREAKER = 2
FEMURBREAKERBUTTON = 3
THESTATUE = 4
VENTA = 5
VENTB = 6
VENTC = 7
VENTD = 8
VENTE = 9
VENTF = 10
VENTG = 11
VENTH = 12

hook.Add("Initialize","YOURMAPNAME_CPTBaseSCPVectors",function() -- Please please change the YOURMAPNAME part. If not, it's just gonna break my addon
	util.AddSCPMapData("gm_site19",Vector(2301.208252,4616.074219,512.031250))
	util.AddSCPMapData("gm_site19",Vector(2510.879639,4448.236816,-402.968750))
	util.AddSCPMapData("gm_site19",Vector(2181.582031,5239.628906,-207.408264))
	util.AddSCPMapData("gm_site19",Vector(1156.137695,1669.294189,128.031250))
	util.AddSCPMapData("gm_site19",Vector(3530.062256,1088.677856,0.031250))
	util.AddSCPMapData("gm_site19",Vector(3392.920166,2365.031006,0.186196))
	util.AddSCPMapData("gm_site19",Vector(4162.134277,3011.957764,1.603760))
	util.AddSCPMapData("gm_site19",Vector(4800.398926,1599.382446,0.031250))
	util.AddSCPMapData("gm_site19",Vector(-2420.687988,3691.424805,0.031250))
	util.AddSCPMapData("gm_site19",Vector(2131.408447,-833.008423,2.629341))
	util.AddSCPMapData("gm_site19",Vector(762.196350,1862.844360,128.031250))
	util.AddSCPMapData("gm_site19",Vector(1467.462646,-2335.210938,5.031250))
end)