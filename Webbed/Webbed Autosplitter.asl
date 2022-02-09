/*
		Webbed Autosplitter (08-FEB-2022)

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
	byte	stickerGet:		0x126DB2C, 0x3BC, 0xC, 0x50, 0x0, 0x80, 0x30C; // (0 = no | 10 = Sticker Get!)
	byte	cutscene:		0x1277B48, 0x0, 0xE0C, 0xC, 0x4C;	// Is this a "cutscene"? (0 = no | 1 = yes | 2 = yes yes?)
	float	playerPosX:		0x148A944, 0x0, 0x0;				// Player's X Position (Increases from left to right)
	float	playerPosY:		0x148A944, 0x0, 0x4;				// Player's Y Position (Increases vertically downwards)
	
	float	gameTime:		0x1277B48, 0x0, 0x22C, 0x1C, 0x3C, 0x8, 0x2C, 0x10, 0x444, 0x74;
	// Pauses on Pause, Journal and Main Menu, resets every new save file, and is consistent when you quit to menu and Continue.
	
	// Volatile, require cutscene and room restrictions
	byte	mechWood:		0x148AA34, 0x8,  0x9;				// Mech-Ant breaking the wood				(0 = no | 1 = yes)
	byte	beedungPop:		0x148A944, 0x18, 0x18;				// Dung Ball breaks / Princess breaks out	(0 = no | 1 = yes)
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
				settings.Add("subsplit_LeavingPipes",	false, "Split when leaving Water Pipes.");
				settings.Add("subsplit_Pipeworks",		false, "Split when going from Pipeworks area to Mech hub.");
				settings.Add("subsplit_TopLeg",			false, "Split when entering Bottom-left Leg room.");
				settings.Add("subsplit_BottomLeg",		false, "Split when leaving Bottom-left Leg room.");
				settings.Add("subsplit_LegTransport",	false, "Split when going from Leg hub to Mech hub.");
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
	settings.Add("extra_settings",	false, "Extra Settings");
	settings.CurrentDefaultParent = "extra_settings";
		settings.Add("safety_checks", false, "Safety Checks");
		settings.SetToolTip("safety_checks", "Enable Safety Checks for Pipeworks and Leg Transport");
}

init
{
	/*
		If you want to add a new split on a room transition:

			{Tuple.Create(old.roomID,current.roomID), settingID}

		Also, it won't work unless you add it to the settings.
	*/

	vars.roomSplit = new Dictionary<Tuple<int,int>, string>
	{
        // Bye BF
		{Tuple.Create(20,18), "split_farewellBF"},
		
		// Ants - Subsplits
		{Tuple.Create(18,76), "subsplit_AntILStart"},
		{Tuple.Create(76,86), "subsplit_EnterMech"},
		{Tuple.Create(79,81), "subsplit_Power"},
		{Tuple.Create(80,81), "subsplit_Fuel"},
		{Tuple.Create(93,81), "subsplit_Water"},
		{Tuple.Create(81,86), "subsplit_Pipeworks"},
		{Tuple.Create(89,91), "subsplit_TopLeg"},
		{Tuple.Create(91,89), "subsplit_BottomLeg"},
		{Tuple.Create(89,86), "subsplit_LegTransport"},
		{Tuple.Create(86,88), "subsplit_LegAttach"},

		// Leaving Mudslide
		{Tuple.Create(95,104), "split_mudslide"},

		// Hub to Bees
		{Tuple.Create(18,55), "split_beesStart"},

		// Bower - Subsplits
		{Tuple.Create(18,120), "split_bowerStart"},
		{Tuple.Create(10,132), "split_birdFight"},

		// Individual Levels
		{Tuple.Create(116,18), "IL_beetles"}
    };
}

start
{
	vars.doneSplits = new List<String>();
	
	vars.isChompCutscene = false;
	vars.isBallCutscene = false;
	vars.isBeeholdTime = false;
	
	vars.isPowerDone = false;
	vars.isFuelDone = false;
	vars.isWaterDone = false;
	vars.isBottomLegDone = false;

	return	(!settings["IL_splits"]	&& old.roomID == 13 && current.roomID == 19 && current.gameTime < 2.0) ||
			(settings["IL_ants"]	&& old.roomID == 18 && current.roomID == 76) ||
			(settings["IL_beetles"]	&& old.roomID == 18 && current.roomID == 96) ||
			(settings["IL_bees"]	&& old.roomID == 18 && current.roomID == 55) ||
			(settings["IL_bower"]	&& old.roomID == 18 && current.roomID == 120);
}

split
{
	string transition = old.roomID + " - " + current.roomID;
	vars.transitionSplit = new Tuple<int,int>(old.roomID,current.roomID);
	
	// Safety Checks
	if (settings["safety_checks"])
	{
		if (current.roomID == 79) {
			vars.isPowerDone = true;
		}
		if (current.roomID == 82) {
			vars.isFuelDone = true;
		}
		if (current.roomID == 84) {
			vars.isWaterDone = true;
		}
		if (current.roomID == 91) {
			vars.isBottomLegDone = true;
		}
	}

	// Room Transition Splits
	if (vars.roomSplit.ContainsKey(vars.transitionSplit) && !vars.doneSplits.Contains(transition))
	{
		if (settings[vars.roomSplit[vars.transitionSplit]])
		{
			if (settings["safety_checks"])
			{
				if (!(vars.roomSplit[vars.transitionSplit] == "subsplit_Pipeworks") && !(vars.roomSplit[vars.transitionSplit] == "subsplit_LegTransport"))
				{
					vars.doneSplits.Add(transition);
					print(transition);
					return true;
				}
				if (vars.roomSplit[vars.transitionSplit] == "subsplit_Pipeworks" && vars.isPowerDone && vars.isFuelDone && vars.isWaterDone)
				{
					vars.doneSplits.Add(transition);
					print(transition);
					return true;
				}
				if (vars.roomSplit[vars.transitionSplit] == "subsplit_LegTransport" && vars.isBottomLegDone)
				{
					vars.doneSplits.Add(transition);
					print(transition);
					return true;
				}
			}
			else
			{
				vars.doneSplits.Add(transition);
				print(transition);
				return true;
			}
		}
	}

	// Mech-Ant breaking the wood
	if ((settings["split_mechwood"] || settings["IL_ants"]) && !vars.doneSplits.Contains("isWoodChomp") && current.roomID == 86)
	{
		if (current.cutscene == 1 && !vars.isChompCutscene)
		{
			vars.isChompCutscene = true;
			print("Chomp incoming!");
		}
		if (old.mechWood == 0 && current.mechWood == 1 && vars.isChompCutscene)
		{
			vars.doneSplits.Add("isWoodChomp");
			print("CHOMP");
			return true;
		}
	}

	// Dung Ball breaks
	if (settings["split_dunghit"] && !vars.doneSplits.Contains("isDungHit"))
	{
		if (old.roomID == 116 && current.roomID == 18 && !vars.isBallCutscene)
		{
			vars.isBallCutscene = true;
			print("Dung Split primed and ready!");
		}
		if (current.beedungPop == 1 && vars.isBallCutscene)
		{
			vars.doneSplits.Add("isDungHit");
			print("BOOM! Dung Split!");
			return true;
		}
	}
	
	// Beehold!
	if ((settings["split_beehold"] || settings["IL_bees"]) && !vars.doneSplits.Contains("isBeeholdDone"))
	{
		if (current.roomID == 67 && current.cutscene == 2 && !vars.isBeeholdTime)
		{
			vars.isBeeholdTime = true;
			print("Babe its time for you to split");
		}
		if (current.beedungPop == 1 && vars.isBeeholdTime)
		{
			vars.doneSplits.Add("isBeeholdDone");
			print("BEEHOLD!");
			return true;
		}
	}
	
	// Bower - Subsplits
	if (settings["split_return"] && !vars.doneSplits.Contains("isKingBack") && old.cutscene == 0 && current.cutscene == 1 && current.roomID == 125)
	{
		vars.doneSplits.Add("isKingBack");
		return true;
	}
	
	// Credits
	if ((settings["split_credits"] || settings["IL_bower"]) && old.roomID == 20 && current.roomID == 11) return true;
	
	// 100% Splits
	if (settings["100_sticker"] && old.stickerGet == 0 && current.stickerGet == 10)
	{
		if ((current.roomID == 133 && current.playerPosX > 3100) || current.roomID != 133) return true;
		
		if (current.roomID == 133 && current.playerPosX < 3100 && !vars.doneSplits.Contains("isSkateSticker"))
		{
			vars.doneSplits.Add("isSkateSticker");
			print("Skatebirb Complete!");
			return true;
		}
	}
}
