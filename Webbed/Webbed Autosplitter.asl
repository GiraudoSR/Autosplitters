/*
		Webbed Autosplitter (01-FEB-2022)

		Made by Giraudo (@Giraudo#8245 on Discord)
	
		Special thanks to ShadowthePast (@Past#9621) for the Ants Subsplits,
	torqqes (@torqqes#5650) and SteelOsprei (@SteelOsprei#5720) for split ideas,
	and CashMunkey (@CashMunkey#6541) for helping me with small, yet very helpful
	stuff when I started this.

		A huge thanks to the Webbed speedrunning community, the devs and everyone
	who helped me along the way, through feedback and/or just support in general.
		
		Currently only works on Steam v. 1.04
*/
 
state("webbed")
{
	byte	roomID:			0x1279C90;
	byte	stickerGet:		0x126DB2C, 0x3BC, 0xC, 0x50, 0x0, 0x80, 0x30C; 	// (0 = no | 10 = Sticker Get!)
	byte	cutscene:		0x1277B48, 0x0, 0xE0C, 0xC, 0x4C;		// Is this a "cutscene"? (0 = no | 1 = yes | 2 = yes yes?)
	byte	playerDance:		0x148AA2C, 0x8,	0x1B4, 0x507;			// Player's Dancing Animation (0 = no | 63 = yes)
	float	playerPosX:		0x148A944, 0x0, 0x0;				// Player's X Position (Increases from left to right)
	float	playerPosY:		0x148A944, 0x0, 0x4;				// Player's Y Position (Increases vertically downwards)
	
	float	gameTime:		0x1277B48, 0x0, 0x22C, 0x1C, 0x3C, 0x8, 0x2C, 0x10, 0x444, 0x74;
	// Pauses on Pause, Journal and Main Menu, resets every new save file, and is consistent when you quit to menu and Continue.
	
	// Volatile, require cutscene and room restrictions
	byte	mechWood:		0x148AA34, 0x8,  0x9;				// Mech-Ant breaking the wood			(0 = no | 1 = yes)
	byte	beedungPop:		0x148A944, 0x18, 0x18;				// Dung Ball breaks / Princess breaks out	(0 = no | 1 = yes)
	
	// Bug Dancers, require room restrictions
	
		// "Tap Dance" Proof (0 = no | 63 = yes)
		byte	mothDance:		0x11DD72C,	0x190,	0x4,	0xC,	0x2C,	0x10,	0x1C8,	0x7;				// Moth			- Room 18
		byte	flyDance:		0x1279C20,	0x108,	0x74,	0x0,	0x70,	0xA4,	0x14C,	0x2C,	0x10,	0x1C8,	0x7;	// Fly Lord		- Room 18
		byte	redbackDance:	0x1279C20,	0x60,	0x14C,	0x148,	0x2C,	0x10,	0x7BC,	0x7;					// Redback Spider	- Room 133
		byte	orbDance1:		0x1279C68,	0x4,	0xB4,	0x10,	0x44,	0xA4,	0x2C,	0x10,	0x7BC,	0x7;		// Orb Weaver		- Room 72/74
		byte	orbDance2:		0x1279C68,	0xB4,	0x0,	0x1AC,	0x2C,	0x10,	0x7BC,	0x7;				// Orb Weaver		- Room 73/75
	
		// Not "Tap Dance" Proof (255 = no | 0 = yes)
		
		byte	wolfDance:		0x11DD72C,	0x1B0,	0x4,	0xC,	0x125;		// Wolf Spider - Room 18
		byte	ogreDance:		0x11DD72C,	0x0,	0xC,	0x14C,	0x14C,	0x125;	// Ogre Spider - Room 110

		// > Ants
		byte	antDance1:		0x11DD72C,	0x198,	0x4,	0xC,	0x121;		// Ant - Room 18

		// > Bees
		byte	beeDance1:		0x1279C68,	0xF4,	0x264,	0x48,	0x20,	0x121;	// Bee - Room 57 (refuses to change while talking)
		byte	beeDance2:		0x1279CF4,	0xEC,	0x108,	0x108,	0x20,	0x121;	// Bee - Room 59

		// > Beetles
		byte	beetleDance1:	0x11DD72C,	0xD8,	0xC,	0x121;				// Beetle 1		- Room 105
		byte	beetleDance2:	0x11DD72C,	0x590,	0xC,	0x121;				// Beetle 2 (can't fly)	- Room 106
		byte	beetleDance3:	0x11DD72C,	0xA0,	0xC,	0x121;				// Beetle 3		- Room 116
		byte	beetleDance4:	0x1279C68,	0xB4,	0x0,	0x618,	0x148,	0x121;		// Beetle 4		- Room 105
		byte	beetleDance5:	0x1279C68,	0xB4,	0x0,	0x34C,	0x121;			// Beetle 5 (Horned)	- Room 105/106/116
}

startup
{
	settings.Add("any_splits", true, "Any%");
	settings.CurrentDefaultParent = "any_splits";

		settings.Add("default_splits", true, "Default Splits");
		settings.SetToolTip("default_splits", "Based on ShadowthePast's splits. \nStarts on New Game.");
		settings.CurrentDefaultParent = "default_splits";
			settings.Add("split_farewellBF",	true, "Split when leaving BF behind.");
			settings.Add("split_mechwood",		true, "Split when Mech-Ant breaks the wood.");
			settings.Add("split_dunghit",		true, "Split when Dung Ball breaks.");
			settings.Add("split_beehold",		true, "Split when Princess breaks out of her cell.");
			settings.Add("split_return",		true, "Split when you reunite with BF.");
			settings.Add("split_credits",		true, "Split when Credits start.");
			settings.CurrentDefaultParent = "any_splits";

		settings.Add("sub_splits", false, "Subsplits");
		settings.SetToolTip("sub_splits", "Splits inside splits. \nHappen on Room Transitions.");
		settings.CurrentDefaultParent = "sub_splits";
			settings.Add("subsplits_ants", false, "Ants");
			settings.CurrentDefaultParent = "subsplits_ants";
				settings.Add("subsplit_AntILStart",		false, "Split when going from Hub to Elevator room.");
				settings.Add("subsplit_EnterMech",		false, "Split when going from Elevator to Mech room.");
				settings.Add("subsplit_Power",			false, "Split when leaving Power room.");
				settings.Add("subsplit_Fuel",			false, "Split when leaving Fuel area.");
				settings.Add("subsplit_Water",			false, "Split when leaving Water area.");
				settings.Add("subsplit_Pipeworks",		false, "Split when going from Pipeworks area to Mech hub.");
				settings.Add("subsplit_TopLeg",			false, "Split when entering Bottom-left Leg room.");
				settings.Add("subsplit_BottomLeg",		false, "Split when leaving Bottom-left Leg room.");
				settings.Add("subsplit_LegTransport",		false, "Split when going from Leg hub to Mech hub.");
				settings.Add("subsplit_LegAttach", 		false, "Split when going from Mech room to Mandible area.");
				settings.CurrentDefaultParent = "sub_splits";
		
			settings.Add("subsplits_beetles", false, "Beetles");
			settings.CurrentDefaultParent = "subsplits_beetles";
				settings.Add("split_mudslide",			false, "Split when entering the next room after Mudslide.");
				settings.CurrentDefaultParent = "sub_splits";
			
			settings.Add("subsplits_bees", false, "Bees");
			settings.CurrentDefaultParent = "subsplits_bees";
				settings.Add("split_beesStart",			false, "Split when going from Hub to Bees.");
				settings.CurrentDefaultParent = "sub_splits";
			
			settings.Add("subsplits_bower", false, "Sky Bower");
			settings.CurrentDefaultParent = "subsplits_bower";
				settings.Add("split_bowerStart",		false, "Split when going from Hub to the 1st Sky Bower Room.");
				settings.Add("split_birdFight",			false, "Split when entering the Bird Fight room.");
	
	settings.CurrentDefaultParent = null;
	settings.Add("100_splits", false, "100%");
	settings.CurrentDefaultParent = "100_splits";
		settings.Add("100_sticker", false, "Split when you get a new Sticker");
		settings.SetToolTip("100_sticker", "Ends when you get all 12 Stickers");
	
	settings.CurrentDefaultParent = null;
	settings.Add("IL_splits", false, "Individual Levels (Turns off \"Start on New Game\")");
	settings.SetToolTip("IL_splits", "Start and End Splits for ILs");
	settings.CurrentDefaultParent = "IL_splits";
		settings.Add("IL_ants",		false, "Start on Hub to Ants, splits when Mech-Ant breaks the wood.");
		settings.Add("IL_beetles",	false, "Start on Hub to Beetles, splits on Dung Hill to Hub.");
		settings.Add("IL_bees",		false, "Start on Hub to Bees, splits when Princess breaks out of her cell.");
		settings.Add("IL_bower",	false, "Start on Hub to Bower, splits when Credits start.");
			
	settings.CurrentDefaultParent = null;
	settings.Add("extra_splits", false, "> > > Unfinished, may not work properly < < <");
	settings.CurrentDefaultParent = "extra_splits";
		settings.Add("dance_splits", false, "Dance%");
		settings.SetToolTip("dance_splits", "Dance with every species of bug");
		settings.CurrentDefaultParent = "dance_splits";
			settings.Add("dance_moth",	false, "Split when Moth dances.");
			settings.Add("dance_fly",	false, "Split when Fly Lord dances.");
			settings.Add("dance_wolf",	false, "Split when Wolf Spider dances.");
			settings.Add("dance_orb",	false, "Split when Golden Orb Weaver dances.");
			settings.Add("dance_ogre",	false, "Split when Ogre Face Spider dances.");
			settings.Add("dance_redback",	false, "Split when Redback Spider dances.");
			settings.Add("dance_ants",	false, "Split when any ant dances.");
			settings.Add("dance_beetles",	false, "Split when any beetle dances.");
			settings.Add("dance_bees",	false, "Split when any bee dances.");
}

start
{	
	vars.doneSplits = new List<String>();
	vars.isChompCutscene = false;
	vars.isBallCutscene = false;
	vars.isBeeholdTime = false;
	
	/* 
		Start when IGT resets, but also check if we're going from Main Menu to the 1st room.
		Done this way because sometimes gameTime likes to go back to zero while going to Main Menu.
	*/

	if (!settings["IL_splits"] && current.gameTime < 2.0 && old.roomID == 13 && current.roomID == 19) {
		print("Here we go again!");
		return true;
	}
	
	if (settings["IL_ants"] && old.roomID == 18 && current.roomID == 76) {
		print("why");
		return true;
	}
	
	if (settings["IL_beetles"] && old.roomID == 18 && current.roomID == 96) {
		print("ok");
		return true;
	}
	
	if (settings["IL_bees"] && old.roomID == 18 && current.roomID == 55) {
		print("sure");
		return true;
	}
	
	if (settings["IL_bower"] && old.roomID == 18 && current.roomID == 120) {
		print("whatever");
		return true;
	}
}

split
{	
	// For most of these (except some visual splits, like Beehold and Dung Hit), the split occurs on a room transition.
	// Check if setting is enabled, add it to the list so it doesn't repeat, and define old and current room IDs.
	
	if (settings["split_farewellBF"] && !vars.doneSplits.Contains("isBFGone") && old.roomID == 20 && current.roomID == 18) {
		vars.doneSplits.Add("isBFGone");
		print("I'll be back in a sec, BF!");
		return true;
	}
	
	// Ants - Subsplits
	if (settings["subsplit_AntILStart"] && !settings["IL_ants"] && !vars.doneSplits.Contains("isAntILStart") && old.roomID == 18 && current.roomID == 76) {
		vars.doneSplits.Add("isAntILStart");
		return true;
	}
	
	if (settings["subsplit_EnterMech"] && !vars.doneSplits.Contains("isElevator") && old.roomID == 76 && current.roomID == 86) {
		vars.doneSplits.Add("isElevator");
		return true;
	}
	
	if (settings["subsplit_Power"] && !vars.doneSplits.Contains("isPower") && old.roomID == 79 && current.roomID == 81) {
		vars.doneSplits.Add("isPower");
		return true;
	}
	
	if (settings["subsplit_Fuel"] && !vars.doneSplits.Contains("isFuel") && old.roomID == 80 && current.roomID == 81) {
		vars.doneSplits.Add("isFuel");
		return true;
	}
	
	if (settings["subsplit_Water"] && !vars.doneSplits.Contains("isWater") && old.roomID == 93 && current.roomID == 81) {
		vars.doneSplits.Add("isWater");
		return true;
	}
	
	/* if (settings["subsplit_LeavingPipes"] && !vars.doneSplits.Contains("isLeavingPipes") && old.roomID == 82 && current.roomID == 80) {
		vars.doneSplits.Add("isLeavingPipes");
		return true;
	} */
	
	if (settings["subsplit_Pipeworks"] && !vars.doneSplits.Contains("isPipeworks") && old.roomID == 81 && current.roomID == 86) {
		vars.doneSplits.Add("isPipeworks");
		return true;
	}
	
	if (settings["subsplit_TopLeg"] && !vars.doneSplits.Contains("isTopLeg") && old.roomID == 89 && current.roomID == 91) {
		vars.doneSplits.Add("isTopLeg");
		return true;
	}
	
	if (settings["subsplit_BottomLeg"] && !vars.doneSplits.Contains("isBottomLeg") && old.roomID == 91 && current.roomID == 89) {
		vars.doneSplits.Add("isBottomLeg");
		return true;
	}
	
	if (settings["subsplit_LegTransport"] && !vars.doneSplits.Contains("isLegTransport") && old.roomID == 89 && current.roomID == 86) {
		vars.doneSplits.Add("isLegTransport");
		return true;
	}
	
	if (settings["subsplit_LegAttach"] && !vars.doneSplits.Contains("isLegAttach") && old.roomID == 86 && current.roomID == 88) {
		vars.doneSplits.Add("isLegAttach");
		return true;
	}
	// End of Ants - Subsplits
	
	if ((settings["split_mechwood"] || settings["IL_ants"]) && !vars.doneSplits.Contains("isWoodChomp") && current.roomID == 86) {
		
		if (current.cutscene == 1 && !vars.isChompCutscene) {
			vars.isChompCutscene = true;
			print("Chomp incoming!");
		}
		
		if (old.mechWood == 0 && current.mechWood == 1 && vars.isChompCutscene) {
			vars.doneSplits.Add("isWoodChomp");
			print("CHOMP");
			return true;
		}
	}

	// Leaving Mudslide
	if (settings["split_mudslide"] && !vars.doneSplits.Contains("isMudslideDone") && old.roomID == 95 && current.roomID == 104) {
		vars.doneSplits.Add("isMudslideDone");
		print("Mudslide Done!");
		return true;
	}
	
	if (settings["split_dunghit"] && !vars.doneSplits.Contains("isDungHit")) {
		
		if (old.roomID == 116 && current.roomID == 18 && !vars.isBallCutscene) {
			vars.isBallCutscene = true;
			print("Dung Split primed and ready!");
		}
		
		if (current.beedungPop == 1 && vars.isBallCutscene) {
			vars.doneSplits.Add("isDungHit");
			print("BOOM! Dung Split!");
			return true;
		}
	}
	
	// Hub to Bees
	if ((settings["split_beesStart"] || !settings["IL_bees"]) && !vars.doneSplits.Contains("isBeesStart") && old.roomID == 18 && current.roomID == 55) {
		vars.doneSplits.Add("isBeesStart");
		print("Bees Time!");
		return true;
	}
	
	if ((settings["split_beehold"] || settings["IL_bees"]) && !vars.doneSplits.Contains("isBeeholdDone")) {
		
		if (current.roomID == 67 && current.cutscene == 2 && !vars.isBeeholdTime) {
			vars.isBeeholdTime = true;
			print("Babe its time for you to split");
		}
		
		if (current.beedungPop == 1 && vars.isBeeholdTime) {
			vars.doneSplits.Add("isBeeholdDone");
			print("BEEHOLD!");
			return true;
		}
	}
	
	// Hub to Bower
	if (settings["split_bowerStart"] && !vars.doneSplits.Contains("isBowerStart") && old.roomID == 18 && current.roomID == 120) {
		vars.doneSplits.Add("isBowerStart");
		print("Bower Time!");
		return true;
	}
	
	if (settings["split_return"] && !vars.doneSplits.Contains("isKingBack") && old.cutscene == 0 && current.cutscene == 1 && current.roomID == 125) {
		vars.doneSplits.Add("isKingBack");
		print("Return of the King!");
		return true;
	}
	
	// Entering Bird Fight Room
	if (settings["split_birdFight"] && !vars.doneSplits.Contains("isBirdFight") && old.roomID == 10 && current.roomID == 132) {
		vars.doneSplits.Add("isBirdFight");
		print("Not again!");
		return true;
	}
	
	if ((settings["split_credits"] || settings["IL_bower"]) && old.roomID == 20 && current.roomID == 11) {
		print("The End");
		return true;
	}
	
	// 100% Splits
	if (settings["100_sticker"] && old.stickerGet == 0 && current.stickerGet == 10 &&
		current.roomID == 133 && current.playerPosX < 3100 && !vars.doneSplits.Contains("isSkateSticker")) { // THIS IS NOT A GOOD SOLUTION, COME UP WITH A BETTER ONE
		
		vars.doneSplits.Add("isSkateSticker");
		print("Skatebirb Complete!");
		return true;
	}	
	if (settings["100_sticker"] && old.stickerGet == 0 && current.stickerGet == 10 &&
		((current.roomID == 133 && current.playerPosX > 3100) || current.roomID != 133)) {
		print("Sticker Get!");
		return true;
	}
	
	// Individual Levels
	if (settings["IL_beetles"] && !vars.doneSplits.Contains("isBeetlesILEnd") && old.roomID == 116 && current.roomID == 18) {
		vars.doneSplits.Add("isBeetlesILEnd");
		print("beetles OVER");
		return true;
	}
	
	// Bug Dancers
	if (settings["dance_moth"] && !vars.doneSplits.Contains("isMothDance") && current.roomID == 18 &&
		current.playerPosY > 12315 && current.playerPosY < 16000 &&
		old.mothDance == 0 && current.mothDance == 63) {
			
		vars.doneSplits.Add("isMothDance");
		print("moth dance");
		return true;
	}
	
	if (settings["dance_fly"] && !vars.doneSplits.Contains("isFlyDance") && current.roomID == 18 &&
		current.playerPosX > 605 && current.playerPosX < 865 &&
		old.flyDance == 0 && current.flyDance == 63) {
			
		vars.doneSplits.Add("isFlyDance");
		print("fly dance");
		return true;
	}
	
	if (settings["dance_wolf"] && !vars.doneSplits.Contains("isWolfDance") && current.roomID == 18 &&
		current.playerPosY > 12315 && current.playerPosY < 16000 &&
		old.wolfDance == 255 && current.wolfDance == 0) {
		
		vars.doneSplits.Add("isWolfDance");
		print("wolf dance");
		return true;
	}
	
	if (settings["dance_orb"] && !vars.doneSplits.Contains("isOrbDance") && current.playerDance == 63 && (
		(current.roomID == 72 && old.orbDance1 == 0 && current.orbDance1 == 63) ||
		(current.roomID == 73 && old.orbDance2 == 0 && current.orbDance2 == 63) ||
		(current.roomID == 74 && old.orbDance1 == 0 && current.orbDance1 == 63) ||
		(current.roomID == 75 && old.orbDance2 == 0 && current.orbDance2 == 63) )) {
			
		vars.doneSplits.Add("isOrbDance");
		print("orb dance");
		return true;
	}
	
	if (settings["dance_redback"] && !vars.doneSplits.Contains("isRedbackDance") && current.roomID == 133 &&
		current.playerPosY > 45 && current.playerPosY < 1720 &&
		old.redbackDance == 0 && current.redbackDance == 63) {

		vars.doneSplits.Add("isRedbackDance" + current.metasave);
		print("redback dance");
		return true;
	}
	
	if (settings["dance_ogre"] && current.roomID == 110 && old.ogreDance == 255 && current.ogreDance == 0 && current.playerDance == 63 && !vars.doneSplits.Contains("isOgreDance")) {
		vars.doneSplits.Add("isOgreDance");
		print("ogre dance");
		return true;
	}
	
	if (settings["dance_ants"] && !vars.doneSplits.Contains("isAntsDance") && (
		(current.playerPosY > 12315 && current.playerPosY < 16000 && current.roomID == 18 && old.antDance1 == 255 && current.antDance1 == 0) )) {
		
		vars.doneSplits.Add("isAntsDance");
		print("ants dance");
		return true;
	}
	
	if (settings["dance_beetles"] && !vars.doneSplits.Contains("isBeetlesDance") && current.playerDance == 63 && (
		(current.roomID == 105 && (
			(old.beetleDance1 == 255 && current.beetleDance1 == 0) ||
			(old.beetleDance4 == 255 && current.beetleDance4 == 0) ||
			(old.beetleDance5 == 255 && current.beetleDance5 == 0))) ||
		(current.roomID == 106 && (
			(old.beetleDance2 == 255 && current.beetleDance2 == 0) ||
			(old.beetleDance5 == 255 && current.beetleDance5 == 0))) ||
		(current.roomID == 116 && (
			(old.beetleDance3 == 255 && current.beetleDance3 == 0) ||
			(old.beetleDance5 == 255 && current.beetleDance5 == 0))) )) {
				
		vars.doneSplits.Add("isBeetlesDance");
		print("beetles dance");
		return true;
	}
	
	if (settings["dance_bees"] && !vars.doneSplits.Contains("isBeesDance") && current.playerDance == 63 && (
		(current.roomID == 57 && old.beeDance1 == 255 && current.beeDance1 == 0) ||
		(current.roomID == 59 && old.beeDance2 == 255 && current.beeDance2 == 0) )) {

		vars.doneSplits.Add("isBeesDance");
		print("bees dance");
		return true;
	}
}
