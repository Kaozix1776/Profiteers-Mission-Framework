/*
	This is a mission template brought to you by Guac.
	Please see the GitHub repository for the full README, licensing, support, and new releases:
	https://github.com/Guac0/PROF-Mission-Template 
*/

///////////////////////////////////////////////////
///////////////Mission Maker Options///////////////
///////////////////////////////////////////////////

	/*
	Notes for options/configuration not present in this file:

		The AutoFactionArsenal script helps you make arsenals by generating an arsenal containing all items used by units for a given faction and then letting you edit what is contained in it.
			To view the autoFactionArsenal script helper description and instructions, see the file at \functions\scripts\autoFactionArsenal.sqf

		If you're adding custom hold actions to your mission, you might want to put them in functions\fn_applyHoldActions.sqf, which has support for re-applying the actions if arma eats them.

		To add a custom fortify preset, go to description.ext and follow the instructions there.

		To use the automated reviewer, play the game and execute the following in the debug console:
			[] call PROF_fnc_automatedReviewer;

		Generally speaking, the default options are usually the best for the majority of missions.
	*/





//////////////////////////////////
/////Scripts/Functions Options////
//////////////////////////////////




	/* CH View Distance
		Set the maximum view distance and whether players can disable grass ("LOW" terrain setting).
		Only works if players are running CH View Distance, otherwise no effect (errors will not occur).
		*/
		CHVD_allowNoGrass 	= true; 	//false for disabling client's ability to set 'low' terrain detail (which doesn't render grass). false = force render grass, true = leave it up to player. default true
		CHVD_maxView 		= 10000; 	//max terrain view distance client can set. default 10000 (10k)
		CHVD_maxObj 		= 10000; 	//max object view distance client can set default 10000 (10k)
	
	
	/* Blue Force Tracker
		Initiates Quicksilver's Blue Force Tracking on map/gps
			By default, marks all groups and players (not AI) on side, and colors people in your squad according to their team color
			Customize its settings in scripts/QS_icons if you want to
			Setting PROF_bftOnlyShowOwnGroup to TRUE only shows the units of each individual player's group on their map. Good for when you don't want squads seeing each other on the map.
				This still needs PROF_bftEnabled to be set to TRUE to take effect.
			*/
		PROF_bftEnabled 					= true; //default true
		PROF_bftOnlyShowOwnGroup			= false; //default false


	/* 3d Group Icons
		Adds 3d icons over group leaders' heads for identification purposes, intended to be used during prep time.
			Automatically activates on mission start, zeus can enable/disable it with a zeus module
			It can also automatically disable after a certain time has passed or after players move away from the start zone
			PROF_3dGroupIcons enables/disables the whole system
			PROF_3dGroupIconsTime sets the time to wait from mission start to automatically disable the group icons.
				Set to 0 to disable.
				Do not enable both PROF_3dGroupIconsTime and PROF_3dGroupIconsRange! (enable = both are non-zero numbers)
			PROF_3dGroupIconsRange sets the range from AceHealObject to check for nearby players. If more players are beyond this range than players who are within this range, then the group icons are disabled.
				Set to 0 to disable.
				If enabled, requires AceHealObject to be present!
		*/
		PROF_3dGroupIcons 			= true; //default true
		PROF_3dGroupIconsTime		= 0;	//default 0
		PROF_3dGroupIconsRange		= 150;	//default 150


	/* Resupply Object
		Adds an "Create Resupply Box" action to a whiteboard that spawns the zeus resupply box on the parachute target object.
			Useful for allowing players to run logi without zeus intervention to create resupply box.
			Needs the "Create Resupply Box" whiteboard and "Resupply Spawn Helper" parachute jump target from mission.sqm to work
			PROF_resupplyObjectEnabled enables/disables it
		*/
		PROF_resupplyObjectEnabled 	= true; //default true


	/* Text Briefing
		Creates the standard 4 part briefing in the briefing section of the diary records.
			Functionally identical to creating a text briefing using the Eden modules or toolbars, just via an SQF file if you prefer to write it that way.
			By default it creates it for every player.
			See functions/fn_briefing.sqf to customize.
			*/
		PROF_textBriefing 			= false; //default false

	
	/* Arsenal Curate
		Removes certain problematic items from arsenal boxes that are otherwise hidden and unremoveable
			See functions/fn_arsenalCurate.sqf for full list and to add/remove your own custom items, but this is things like doomsday, hidden brightlights, LAGO superweapons, etc
				They usually get accidentally added by zeus hitting "add all compatible" to a custom arsenal, which adds invisible things too
			Arsenal boxes names must be arsenal_# from 1 to 10, template already gives you 1-3 premade and you can just copy paste those
			Only turn this to "false" if its a meme op and thus players should have extreme yield lights and doomsday and etc
		*/
		PROF_arsenalCurate 		= true; //default true

	
	/* Custom Object Mapper
		Draws black rectangles on all present custom buildings added to the mission. 
			See functions\fn_markCustomObjects for options. 
			Code from FNF.
		*/
		PROF_markCustomObjectsMap = false; //default false


	/* Buddy Blood Drawing
		Adds an action on each (alive) player's arms to draw 250mL of blood from them.
			Action only shows on the radial medical menu, not the advanced menu due to technical reasons.
			Add blood drawing to a custom unit by placing this code in their init:
				if (isServer) then { this remoteExec ["PROF_fnc_drawBlood",0,true]; };
			Customize shown text by going to function/fn_drawBlood.sqf if you want to use this for lore reasons
				If you want only your custom units to have the draw blood action, set PROF_allowBloodDrawing to 'false' and add it manually to the specified units with the above code.
		*/
		PROF_allowBloodDrawing	= true; //default true
	

	/* Punish Civilian Killers
		Adds a counter to players and when they have killed the provided number of protected units, they are locked into a timeout corner at the map origin [0,0,0].
			After their timer is up, they are teleported to their previous position/vehicle/group leader.
			By default, the system is not active unless the zeus modules are used.
				To automatically apply the system to all civilian units, see description.ext and search for "PunishCivKiller"
			To end a player's timeout prematurely, use the "Forgive" module in Zeus on them.

			PROF_punishCivKillsThreshold is the number of civilian kills allowed before punishment (if set to 2, punishment will occur on the 3rd kill).
				Setting this to 0 will cause the "Zeus - Punish Player" module to not work.
			PROF_punishCivKillTimeout is the time in seconds to put the offending player into timeout for.
			PROF_punishCivKillsSpectator puts the offending player into spectator during timeout. This is recommended so that they don't get bored, however, make sure your spectator settings don't allow for seeing enemies/etc.
			PROF_punishCivKillerTpToLeader will attempt to teleport the offender to their group leader (if they have one) or their leader's vehicle after their timeout is over if set to true.
			PROF_punishCivKillerHumiliate displays a message in chat when a player kills a protected unit/is put into timeout
		*/
		PROF_punishCivKillsThreshold 	= 2;	//default 2
		PROF_punishCivKillTimeout 		= 60;	//default 60
		PROF_punishCivKillsSpectator		= true;	//default true
		PROF_punishCivKillerTpToLeader 	= true; //default true
		PROF_punishCivKillerHumiliate 	= true; //default true


	/* PROF Scavenger System
		The Scavenger system auto-populates an AO by placing "objectives" in random houses.
			These objectives have a cache with a certain number of a certain item in it.
			Objectives are guarded by 10 AI scavengers - 4 guarding the building itself, 3 on patrol, and 3 camping nearby.
		
		Additionally, there are a number of AI "roamer" scavenger groups.
			There are a number - default 7 - of large groups of 5-8 scavs that travel between the objectives.
			There are a number - default 7 - of small groups of 1-4 scavs that travel between random houses in the AO.
		
		When players die, they can reinsert as a Player Scavenger.
			Player scavs have a randomized inventory of low quality items.
			They are told to obtain the prize items from caches and extract with them.
			Between runs, they can use a VASS shop (if set up by Zeus) to upgrade their gear.
			They can choose to cooperate or fight other players.
			Only player scavengers get map markers on cache objectives and extractions.

		The Zeus must do the following to set up the system in Eden:
			Make a square area marker covering the AO and put its variable name as the value of PROF_scavAoMarker below
			Place several objects (recommend the data terminal object) where you want extraction points to be and put their names in PROF_scavExtractObjects below
			Optionally, add blacklists for objectives/spawnpoints by placing objects and putting their variable names in PROF_scavBlacklistLocations below.
			Optionally if there are markers normal players can see but you don't want Scav players to see, put their variable names in PROF_scavPmcMarkers below.
			Enable VASS in config.sqf, and set the following to 0 or false or [] depending what's applicable: PROF_vassDefaultBalance, PROF_vassPrebriefing, PROF_vassShop, PROF_rebuyCostPrimary
			Make a safe zone for Scavs for after they extract. I recommend an empty warehouse.
				Place an object to act as a teleport helper and put its variable name in PROF_scavSafeZoneTpHelper below.
				Place an object which will have the reinsert hold action on it and put its variable name in PROF_scavInsertActionObject below.
				Optional but recommended, make a shop using VASS there.
			Optionally but recommended, set PROF_bftOnlyShowOwnGroup to TRUE to avoid BFT shenanigans with seeing other, potentially unfriendly, players.
		
		Advanced options can be configured in the "Advanced" section of config.sqf
		*/
		PROF_scavSystemEnabled 			= false; //default false. Overall off/on switch.
		PROF_scavInsertActionObject		= "scavActionObject"; //default "scavActionObject". Variable name (in quotations) of the object used as a teleporter helper for scavs to be TP'd to after extracting.
		PROF_scavSafeZoneTpHelper		= "scavTpHelper"; //default "scavTpHelper". Variable name (in quotations) of the object used as a teleporter helper for scavs to be TP'd to after extracting.
		PROF_scavAoMarker 				= "PROF_ScavZone_Marker"; //default PROF_ScavZone_Marker. Marker name (in quotes) of the marker covering the AO in which to create objectives/spawn players and roamers in. Must be a square.
		PROF_scavBlacklistLocations 		= ["PROF_ObjectiveBlacklistObject_1","PROF_ObjectiveBlacklistObject_2","PROF_ObjectiveBlacklistObject_3","PROF_ObjectiveBlacklistObject_4","PROF_ObjectiveBlacklistObject_5","PROF_ObjectiveBlacklistObject_6","PROF_ObjectiveBlacklistObject_7","PROF_ObjectiveBlacklistObject_8","PROF_ObjectiveBlacklistObject_9","PROF_ObjectiveBlacklistObject_10","PROF_ObjectiveBlacklistObject_11","PROF_ObjectiveBlacklistObject_12","PROF_ObjectiveBlacklistObject_13","PROF_ObjectiveBlacklistObject_14","PROF_ObjectiveBlacklistObject_15"]; //Variable names (in quotes) of objects where you want to add a objective blacklist for PROF_scavObjectiveDistanceThreshold distance threshold. Excess object names not actually present in mission will be safely ignored.
		PROF_scavExtractObjects 			= ["PROF_extract_1","PROF_extract_2","PROF_extract_3","PROF_extract_4","PROF_extract_5","PROF_extract_6","PROF_extract_7","PROF_extract_8","PROF_extract_9","PROF_extract_10","PROF_extract_11","PROF_extract_12","PROF_extract_13","PROF_extract_14","PROF_extract_15"]; //Variable names (in quotes) of objects you want to make into extraction objects/locations. Excess object names not actually present in mission will be safely ignored.
		PROF_scavPmcMarkers 				= []; 	//default []. Marker variable names of markers to hide once a player becomes a scav (i.e. PMC only markers).
		
	
	/* Unit Marking
		Adds an action to each player's action menu that allows them to mark enemy units and vehicles if they are looking DIRECTLY at them.
		Marking a unit adds a map marker to the unit that updates every second and/or a 3d icon above it.
			Warning: 3d icons are in BETA, they show at infinite distance and are shown even if the unit is behind terrain/a building.
		Marks are removed when the marked unit/vehicle dies.
		Zeuses can mark units via a zeus module with extended options available.
			This is available even if individual players' marking ability is disabled.
		*/
		PROF_addUnitMarkAction 	= false; //default false
		PROF_markTargetOnMap		= true; //default true
		PROF_markTarget3d		= true; //default true





//////////////////////////////////
/////////Inventory Options////////
//////////////////////////////////
	//just a general note, the template only contains ace arsenals for a reason. Usage of any other arsenal type may result in broken scripts/mods.



	/* TFAR Gear Assignment
		Manages TFAR radio assignment. (note: does not assign frequencies, that's handled by the tfar attributes on units in eden)
			PROF_radiosEnabled enables the whole radio giving system and will give all players the PROF_radioPersonal and all leadership players the PROF_radioBackpack in additional to the PROF_radioPersonal
			PROF_NoSquadleadLr enables giving backpack radios to RTOs (role description containing "Radioman" or "RTO") instead of Squad Leads (while still giving backpack radios to GC, vehicle crew, etc)
			PROF_radioAdditionals enables automatically setting up an additional channelon every player's short range radio (and sets main channel to left ear and additional channel to right ear)
			PROF_radioPersonal and PROF_radioBackpack are the classnames of the personal and backpack radios to give to players. Leaving PROF_radioBackpack empty will result in no radio backpacks being assigned.
			Note: leadership backpack radio assignment requires units to be set up according to standard role description naming conventions (done by default in the template)
			*/
		PROF_radiosEnabled 		= true; 				//default true
		PROF_NoSquadleadLr 		= true; 				//default true
		PROF_radioAdditionals 	= false; 				//default false
		PROF_radioPersonal 		= "TFAR_anprc152"; 		//default "TFAR_anprc152"
		PROF_radioBackpack 		= "TFAR_anprc155_coyote"; //default "TFAR_anprc155_coyote"


	/* Loadout from Config
		Assigns player loadouts via config
			It looks at the config files for the given faction and tries to match each player's Role Description with the name of a unit from that faction. If found, it gives them that unit's loadout, if not found, it gives them a Rifleman loadout from that faction
			Note that the actualy inventory items (stuff in uniform and vest and etc) of the player will be overwritten by PROF_populateInventory if that is enabled, but this will still set the clothing, weapons, etc
			To disable loadout assignment on a given unit while keeping the system enabled for other units, place the following in its init box:
				this setVariable ["PROF_disableConfigLoadouPROFsignment",true];
			You can also manually set the loadout names if you don't want it to autodetermine based on the role description. To do this, put the following lines into the init box of the unit (it can have spaces, the underscores are just for easy selection and deletion):
				this setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];

			PROF_useConfigLoadout enables/disables the whole system
			PROF_configLoadoutCustom enables/disables assigning override loadouts via the script menu in initPlayerLocal.sqf instead of via unit init boxes with the above code
			PROF_configFaction sets the target faction for loadout assignment.
				You can find the config name by placing a unit, right click, log, log faction classname to clipboard
			PROF_configUnitPrefix is the unit prefix, including space if necessary.
				Use it when your units are named like 'SF Rifleman', 'SF Team Leader' to avoid retyping, otherwise leave blank (it is NOT the mod prefix)
			PROF_defaultConfigUnit sets it so that if the player's role description doesn't match any unit in the faction, it falls back to this unit name for the loadout assignment
			PROF_configLoadoutNumber is for advanced users only. When multiple loadouts are found, use the # loadout found (zero-based)
			*/
		PROF_useConfigLoadout 	= false; 		//default false
		PROF_configLoadoutCustom	= false;		//default false
		PROF_configFaction 		= "BLU_F"; 		//default "BLU_F" (vanilla NATO)
		PROF_configUnitPrefix	= "";			//default ""
		PROF_defaultConfigUnit 	= "Rifleman"; 	//default "Rifleman"
		PROF_configLoadoutNumber = 0; 			//default 0


	/* Populate Inventory
		Automatically gives appropriate inventory items to players, loosely based on their role. Note: clears eden inventory before assigning the items (but doesn't change clothing or weapons)
			Medical: 16x basic bandages, 8x morphine, 3x TQs, 2x epi, 2x 500ml blood
				If medic, extra 40 basic bandages, 20 morphine, 15 epi, 6 TQs, 10x 500 ml blood, 6x 1000ml blood, 1x PAK
			Ammo: 4x standard primary mags, 4x special mags, 2x pistol mags (if have pistol), 2x launcher mags (if have launcher)
			Misc: 1x entrenching tool
			Grenades: 2x M67s, 2x white smoke, 1x purple smoke
			If engineer, gives 1x toolkit, 1x mine detector
			PROF_populateInventory enables/disables the whole system
			PROF_inventoryAddGps enables automatically putting a vanilla GPS item into each player's terminal slot (requires PROF_populateInventory to be set to true).
				Note that even if set to false players might have a GPS if it was a part of their EDEN inventories.
		Note: see initPlayerLocal.sqf in the custom equipment section if you want to add items for everyone or for only certain roles in addition to the items stated above
		*/
		PROF_populateInventory 	= true; //default true
		PROF_inventoryAddGps		= true;	//default true


	/* Role Based Arsenals
		Adds role-based ace arsenals. See the steps below for configuring.
			1. Make arsenal boxes in your mission for the various roles you want to have a special arsenal
			2. Give the arsenal boxes a variable name (like "arsenalMedic" for example)
			3. Make the boxes invisible and/or hide them someone in the mission
			4. Go to functions/fn_roleBasedArsenal.sqf and follow the steps there to assign each role to an arsenal box
			5. Make some box(es) and place them at the normal arsenal area and give them variable names
				these will be where players will have the action to open the arsenals. don't make these be arsenal boxes in Eden,
				the script will take care of automatically making them be the proper role-based arsenal depending on who opens them
			6. Edit PROF_visibleArsenalBoxes to contain the variable names (with quotation marks) of the boxes you've made at the player arsenal area to have the role-based arsenals
				note: these boxes should not actually have arsenals set for them
		*/
		PROF_roleBasedArsenals	= false; 						//default false
		PROF_visibleArsenalBoxes = ["arsenal_1","arsenal_2"]; 	//default ["arsenal_1","arsenal_2"]





//////////////////////////////////
/////////Respawns Options/////////
//////////////////////////////////



	/* Respawn Gear
		Determines the gear that players get upon respawning.
			Three choices:
				1. Respawning with vanilla config loadout (default in vanilla, not recommended. set both options to false to pick this option)
				2. Respawning with gear you had when you died (PROF_respawnDeathGear)
				3. Respawning with gear that you preset at the arsenal (PROF_respawnArsenalGear)
					For PROF_respawnArsenalGear, loadout is saved whenever the player exits the (ace) arsenal, and there's also an option to manually save your loadout at the AceHealObject
		*/
		PROF_respawnDeathGear 	= false; 	//default false --- DO NOT SET BOTH respawnDeathGear AND respawnArsenalGear to true!!!
		PROF_respawnArsenalGear 	= true; 	//default true


	/* Spectator Options
		Makes players respawn in ACE spectator.
			Recommended to be enabled whenever you're using anything with a timer for reinserts (respawn vehicle, wave respawns, FOB system).
				To clarify, "anything with a timer" does not include the vanilla respawn timer.
				It must be enabled for the various respawn systems included within the template to work correctly.
			Can be edited midgame via the Zeus "Manage ACE Spectator Options" module.
			PROF_respawnSpectator enables/disables respawning in spectator
			PROF_respawnSpectatorForceInterface enables/disables it so that player cannot leave spectator early.
				Disable it to allow them to close spectator and access the arsenal box or whatever while they wait.
			PROF_respawnSpectatorHideBody hides the player's body while they are in spectator.
			PROF_respawnSpectatorTime is the time (in seconds) that the respawn screen lasts before showing the player the appropriate reinsert options.
				If PROF_respawnSpectatorForceInterface is set to false, it will still continue counting when players choose to leave the interface on their own
				When it is set to 0, then spectator time is infinite. Good for one-life ops (combine it with setting "PROF_respawnSpectatorForceInterface = true" to keep dead players in spectator forever).
				Ignored if PROF_waveRespawn is enabled.
		*/
		PROF_respawnSpectator 				= false; 	//default false
		PROF_respawnSpectatorForceInterface 	= false; 	//default false
		PROF_respawnSpectatorHideBody 		= true; 	//default true
		PROF_respawnSpectatorTime 			= 30; 		//default 30


	/* Wave Respawns
		Does wave respawns, aka reinserts all dead players at once every set interval of time instead of them individually reinserting
			PROF_waveRespawn enables/disables the whole system.
			PROF_waveTime sets the time between each respawn wave.
				It can take up to 5-10 seconds for all players to respawn, and respawning is available for a 20 second window as a grace period after each respawn wave.
				It overwrites PROF_respawnSpectatorTime if PROF_waveRespawn is enabled.
		*/
		PROF_waveRespawn		= false;	//default false
		PROF_waveTime		= 300;		//default 300 (5 minutes)


	/* Respawn in Vehicle
		Adds the ability to reinsert through being teleported into the reinsert vehicle.
			Uses a GUI to allow the player which vehicle to reinsert in if multiple are available.
			After respawning, it forces the player to wait the specified duration (while either spectating/editing loadout/chilling in base) before being shown the reinsert menu
				PROF_respawnSpectator is recommended to be enabled with this system, and PROF_respawnSpectatorTime is used for the duration of the wait.
			There are 3 methods for adding a reinsert vehicle:
				1. In eden, place the below code in a vehicle's init box. Change "Respawn Vehicle 1" to whatever you want the vehicle to be named when shown to players.
						if (isServer) then {
							[this,"Respawn Vehicle 1"] spawn PROF_fnc_assignRespawnVicInit;
						};
				2. Using the Zeus module called "Assign As Respawn Vehicle" under the "PROF Mission Template" category by placing it on a vehicle and changing the options shown on it as needed
				3. If no vehicles are configured as being reinsert vehicles within 30 seconds of mission start, then the mission template will automatically add the vehicle with
					a variable name of "logistics_vehicle" as a reinsert vehicle with the name "Default Respawn Vehicle".
			PROF_respawnInVehicle enables/disables the whole system.
		*/
		PROF_respawnInVehicle 	= false; //default false
	

	/* Flagpole Respawn
		Just a simple hook into our custom respawnGUI system that allows flagpoles to be used as respawn locations.
			To add flag poles as respawn locations, add the following code to its object init field and edit "Respawn Flag 1" to be the name to show to players for this respawn location.
				if (isServer) then {
					[this,"Respawn Flag 1"] spawn PROF_fnc_assignRespawnFlagpoleInit;
				};
			You can also add more flagpoles (or other objects) as respawn locations using the Zeus module.
			You may wish to use the Zeus followMarker module on flagpoles if you want them to be tracked on the map for your players.

			PROF_flagpoleRespawn enables/disables flagpoles for respawning.
		*/
		PROF_flagpoleRespawn		= false;		//default false


	/* FOB System
		Manages the FOB system, which give the players the ability to establish FOBs and use them for reinserts.
			The FOB consists of an action on the vehicle in the mission named "logistics_vehicle" which leadership players (GC members, SLs) can use
				The action places a FOB around them, featuring ammo boxes, vehicle RRR crates, and some defensive structures (about 40 meters in diameter)
			PROF_respawnSpectator is recommended to be enabled with this system, and PROF_respawnSpectatorTime is used for the duration of the wait before people are shown the respawn menu.
		*/
		/*
		FOB Basic Settings
			PROF_fobEnabled enables/disables the basic FOB operation.
			PROF_fobPackup enables/disables the ability for players to repack the FOB and place it again elsewhere
			PROF_fobFullArsenals enables/disables the placing of full arsenals at the FOB. If disabled, they instead contain medical supplies and ammo for each player's weapons
			PROF_fobDistance sets the distance from the logistics_vehicle that has to be clear of enemies in order for the FOB to be successfully placed
			PROF_fobRespawn enables/disables adding a vanilla respawn position at the FOB in addition to adding it to the respawn GUI
				You might want to disable this if you want players to spawn at main and then use the respawn GUI to respawn at the FOB

			To change the FOB layout, modify buildfob/fobComposition.sqf
		*/
		PROF_fobEnabled 			= false; 	//default false
		PROF_fobPackup			= false;	//default false
		PROF_fobFullArsenals 	= false; 	//default false
		PROF_fobDistance 		= 300; 		//default 300 meters
		PROF_fobRespawn			= false;	//default false

		/*
		FOB Overrun Settings
			The overrun sequence (if enabled) activates when more enemies than friendlies (adjusted by PROF_fobOverrunFactor) are within PROF_fobDistance of the FOB.
				It gives the players PROF_fobOverrunInterval to kill enough enemies to bring them back under the threshold. If this is not done in time, then the FOB is destroyed.

			PROF_fobOverrun enables/disables the ability for the FOB to be overrun.
			PROF_fobOverrunDestroy enables/disables the destroying all FOB objects when FOB is overrun (may cause mild damage to units nearby)
				does not destroy ammoboxes but does remove arsenals
			PROF_fobOverrunFactor determines how many more enemies than friendlies have to be in PROF_fobDistance of the FOB to begin the overrun sequence.
				i.e. a value of 2 makes it so enemies must outnumber friendlies 2 to 1
			PROF_fobOverrunMinEnemy sets the minimum number of enemies nearby to start/continue the overrun
			PROF_fobOverrunTimer is the time it takes for overrun to complete (friendlies can kill enemies to cancel it midway)
			PROF_fobOverrunInterval determines how often the overrun status is checked and/or broadcast to players. Must be a divisor of PROF_fobOverrunTimer.
				Values larger than 30 will result in the message fading out between updates
		*/
		PROF_fobOverrun			= false;	//default false
		PROF_fobOverrunDestroy	= true;		//default true
		PROF_fobOverrunFactor	= 2;		//default 2
		PROF_fobOverrunMinEnemy	= 8;		//default 8
		PROF_fobOverrunTimer		= 300;		//default 300 (5 min)
		PROF_fobOverrunInterval	= 30;		//default 30 (1 min)


	/* Rallypoint System
		Manages the Rallypoints system, which give the players the ability to establish Rallypoints and use them for reinserts.
			It lets all Squad leaders, GC leader, and Recon leader place Rallypoints via an ace self action, which become reinsert positions for the respawn GUI.
				It also spawns a small campsite at the rallypoint's location and makes a marker appear on map.
			PROF_respawnSpectator is recommended to be enabled with this system, and PROF_respawnSpectatorTime is used for the duration of the wait before people are shown the respawn menu.
			You can change what the rallypoint looks like by modifying buildfob/rallypointComposition.sqf or buildfob/rallypointSmallComposition.sqf
			By default, only players with "Squad Leader" and their squad name in their role description will get the rallypoint. Change this in buildfob/fn_initRallypoints.sqf
				Recon just needs "Leader" and "Recon", and GC accepts several variations on "Leader", "Officer", etc as long as "GC", "Command Element", "Ground Command" is also included.
		*/
		/*
		Rallypoint Basic Settings
			PROF_rallypointsEnabled enables/disables the entire system.
			PROF_useSmallRally enables/disables using the small rally. The small rally is slightly smaller than the regular rally and lacks the supply crate that the regular rally has
			PROF_rallyDistance sets the distance that if enemies are within then rallypoint cannot be created
			PROF_rallyOutnumber enables/disables using outnumbering instead of just any enemies being within PROF_rallyDistance. If enabled, more enemies than friendlies must be within PROF_rallyDistance to fail the rallypoint placement. If false, if any enemies are present then rallypoint creation fails.
		*/
		PROF_rallypointsEnabled	= false;	//default false
		PROF_useSmallRally 		= true; 	//default true
		PROF_rallyDistance 		= 150; 		//default 150 meters
		PROF_rallyOutnumber 		= true; 	//default true

		/*
		Rallypoint Overrun Settings
			The overrun sequence (if enabled) activates when more enemies than friendlies (adjusted by PROF_rallyOutnumberFactor) are within PROF_rallyDistance of a rally.
				It gives the players PROF_rallyOverrunTimer to kill enough enemies to bring them back under the threshold. If this is not done in time, then the rally is destroyed.
			There are several zeus modules available to manage the system ingame.

			PROF_rallypointOverrun enables/disables the overrun system for rallypoints.
			PROF_rallyOutnumberFactor determines how many more enemies than friendlies have to be in PROF_rallyDistance of the rally to begin the overrun sequence
				i.e. a value of 2 makes it so enemies must outnumber friendlies 2 to 1
			PROF_rallyOverrunMinEnemy sets the minimum number of enemies nearby to start/continue the overrun
			PROF_rallyOverrunTimer is the time it takes for overrun to complete (friendlies can kill enemies to cancel it midway)
			PROF_rallyOverrunInterval  determines how often the overrun status is checked and/or broadcast to players. Must be a divisor of PROF_rallyOverrunTimer.
				Values larger than 30 will result in the message fading out between updates
		*/
		PROF_rallypointOverrun 		= false;	//default false
		PROF_rallyOutnumberFactor 	= 2;		//default 2 
		PROF_rallyOverrunMinEnemy	= 4;		//default 4
		PROF_rallyOverrunTimer		= 90;		//default 90 (1.5 min)
		PROF_rallyOverrunInterval 	= 15;		//default 15











//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////Advanced Options/////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
	/*

	Below you can find various options that are not included in the main list for one of three reasons:
		1. It is illogical to change these settings from the defaults
			For example, they manage adding various zeus modules required to manage other systems enabled in the regular template options, or are just handy in general
			Some, like PROF_aceHealObjectEnabled, are intended to be always enabled even if you don't include the relevant objects from the mission.sqm because 
				they are capable to automatically detecting when they are not required (i.e. you delete the object the resupply creator is attached to)
		2. They have either extremely advanced usage cases that only Guac uses, or are settings for developer work on the template/versioning
			For example, PROF_spawnUnitsOnHC and PROF_templateVersion respectively
		3. They are WIP or known to be broken features which default to disabled. Use at your own risk.
			These are rare and are marked as "feature temp removed", "doesn't work", or "probably works but not promises and rare usage case anyways"

		TL;DR: don't scroll down unless you know what you're doing, have been instructed to do so, or are very curious.

	*/


	/* Shortlist of options below that are enabled by default, in (roughly) the order that they appear:
			ace heal object
			ace spectate object
			disabling vanilla stamina
			clean briefing of disabled template systems
			dynamic groups
			global TFAR
			FPS display
			trim group names
			fix team color on death and respawn
			adds various zeus modules
			adds client keys for AFK, music mute, and earplugs
			discord update
			track all clients performance
			does mod log of unallowed mods
		*/





		/* Scavenger System Advanced Settings
			Advanced settings for the Scavenger System. Read the description next to each option.
			*/
			PROF_scavNumberOfObjectives 		= 10;	//default 10. Number of objectives to create.
			PROF_scavSkill 					= [["general",0.8],["courage",0.8],["aimingAccuracy",0.25],["aimingShake",0.25],["aimingSpeed",0.25],["commanding",0.8],["spotDistance",0.25],["spotTime",0.25],["reloadSpeed",0.3]]; //default: [["general",0.8],["courage",0.8],["aimingAccuracy",0.25],["aimingShake",0.25],["aimingSpeed",0.25],["commanding",0.8],["spotDistance",0.25],["spotTime",0.25],["reloadSpeed",0.3]]. The AI skill to give to AI scavs.
			PROF_scavRadioFreq 				= "44";	//default "44". TFAR short range radio freq to set player scavs to when they spawn.
			PROF_scavValuableClassname		= "PROF_RationPizza"; //default "PROF_RationPizza". Classname of the inventory item present in caches/checked for in extract eligibility/rewarded money for extracting with.
			PROF_scavRewardPerItem 			= 100;	//default 100. The amount of money to give extracted player scavs per PROF_scavValuableClassname that they extracted with.
			PROF_scavStartingValuables 		= 10; 	//default 10. Number of PROF_scavValuableClassname to be present in each cache.
			PROF_scavNeededValuables 		= 3; 	//default 3. Minimum number of PROF_scavValuableClassname needed to be present in inventory before extraction is possible.
			PROF_scavSleepInterval 			= 120;	//default 120. Time in seconds to sleep between repawning of roamers and objectives (where needed).
			PROF_scavPlayerDistanceThreshold = 400;	//default 400. Distance in meters between a possible objective location and players (when objectives are first made during system init).
			PROF_scavObjectiveDistanceThreshold = 200; //default 200. Distance in meters between a possible objective location and an already established objective location (when objectives are first made during system init).
			PROF_scavPlayerSide 				= west;	//default west. Side of player scavs. Recommended to be hostile to PROF_scavAiSide and PROF_scavAiRoamerSide.
			PROF_scavAiSide 					= independent; //default independent. Side of scavs guarding caches. Recommended to be hostile to PROF_scavPlayerSide and PROF_scavAiRoamerSide.
			PROF_scavAiRoamerSide 			= east;	//default east. Side of scavs roaming about the map/attacking caches (if enabled). Recommended to be hostile to PROF_scavPlayerSide and PROF_scavAiSide.
			PROF_scavRoamersSmall 			= 7;	//default 7. Number of small roamer AI groups to create and maintain. Each group has 1-4 AI scavs in it.
			PROF_scavRoamersBig 				= 7;	//default 7. Number of large roamer AI groups to create and maintain. Each group has 5-8 AI scavs in it.
			PROF_scavRoamersSmallPatrolChance = 100;	//default 100. Chance for small roamer groups to patrol (move to random buildings in the AO). If a group does not randomly patrol, they will instead move between the various caches.
			PROF_scavRoamersBigPatrolChance 	= 0;	//default 0. Chance for large roamer groups to patrol (move to random buildings in the AO). If a group does not randomly patrol, they will instead move between the various caches.
			PROF_scavRoamersObjectiveDistance = 200;	//default 200. Distance in meters between a possible roamer spawnpoint and an objective location. Continously calculated throughout the mission (i.e. dynamic).
			PROF_scavRoamersPlayerDistance 	= 400;	//default 400. Distance in meters between a possible roamer spawnpoint and the nearest player. Continously calculated throughout the mission (i.e. dynamic).
			PROF_scavRespawnRoamers 			= true; //default true. Whether to respawn roamer groups when all units in a particular roamer group are dead.
			PROF_scavRespawnObjectives 		= true; //default true. Whether to respawn an objective (in the same position) when either all units in one of its guard groups is dead or when its count of pizzas is less than PROF_scavStartingValuables.



	//////////////////////////////////
	////Scripts/Functions Options/////
	//////////////////////////////////



		/* AceHealObject
			Manages actions tied to the 'AceHealObject' in the mission
				PROF_aceHealObjectEnabled adds a hold action to it that gives an Ace Heal to all players within a certain radius when activated
				PROF_aceSpectateObjectEnabled adds a hold action to it that puts the player into acespectator mode
				*/
			PROF_aceHealObjectEnabled 		= true; //default true
			PROF_aceSpectateObjectEnabled 	= true; //default true


		/* Boss Script (WIP)
			Initialize by running the following: [] remoteExec ["PROF_fnc_bossInit",2];
			*/
			PROF_bossEnabled 		= true;		//global on/off switch
			PROF_bossImagePath 		= "media/logo256x256.paa"; //path to image file to use
			PROF_bossParts 			= [[leg1,"LeftLeg",10],[leg2,"RightLeg",10],[torso,"Torso",30],[head,"Head",20]]; //2D array: object variable name, string name to show to players (one word due to limitations), integer of defaultHealth
			PROF_bossInterval 		= 0.5; 		//interval to wait between visible boss health updates
			PROF_bossHealthModifier 	= 1; 		//factor to change the inputted health values by. 1 is no change, 1.5 is 50% more, etc


		/* Virtual Arsenal Shop System (VASS)
			requires special save and exit. execute the following in your debug console/server-only code execution module in zeus
				[] remoteExec ["PROF_fnc_vassEndMission"];
			recommend disable PROF_respawnArsenalGear and PROF_respawDeathGear
			best way to add items to a shop is to use the VASS mod and to edit the attributes of the shop object in Eden
			best way to change money values ingame is to use the zeus module
			*/
			PROF_vassEnabled 			= false; 					//default false
			PROF_vassShopSystemVariable 	= "PROF_exampleVassMoney"; 			//what variable name to store money under. Begin with "PROF_"
			PROF_vassShopSystemLoadoutVariable = "PROF_exampleVassLoadout"; 	//what variable name to store gear under. Begin with "PROF_"
			PROF_vassDefaultBalance 		= 700; 						//default money to start players with
			PROF_vassBonusStartingMoney 	= 0; 						//if you want to give extra money to players when they join this mission (for example, for completing the previous mission well), change this
			PROF_vassPrebriefing 		= [ 						//shows to players when they load into the mission. note how each line except for the last ends with a comma. will not display hint if empty.
				"In this campaign, we have to buy our gear from the black market.",
				"Each player's balance and loadout at mission end will carry over to the next mission.",
				"All free items (cosmetics) are in the red crate's ace arsenal, everything else is in the other box.",
				"Save your loadout at the sign to be able to rebuy it in the future for a small cost."
			];
			PROF_vassShops 				= ["arsenal_1","arsenal_2"]; //variable names of shop objects. note: if doing limited quantities and multiple shops, quantities will probably not be shared between shops
			PROF_vassSigns 				= ["AceHealObject"]; 		//variable names of rebuy sign objects
			PROF_rebuyCostPrimary 		= 35; 						//additive rebuy cost if kit has primary weapon
			PROF_rebuyCostSecondary 		= 50; 						//additive rebuy cost if kit has launcher weapon
			PROF_rebuyCostHandgun 		= 15; 						//additive rebuy cost if kit has handgun weapon





	//////////////////////////////////
	//////////Misc Options////////////
	//////////////////////////////////



		//Disables vanilla stamina at mission start and on player respawn.
		PROF_vanillaStaminaDisabled = true; //defaults to true
		//publicVariable "PROF_vanillaStaminaDisabled";


		//probably works now but no promises
		//Modifies weapon sway (well, aim precison) coefficient and recoil coefficient. 1 is normal, 0 is nothing (but don't use 0, use 0.1)
		PROF_doAimCoefChange 	= false; 	//default false
		PROF_aimCoef 	  		= 0.5;		//default 0.5; no effect if PROF_doCoefChanges is FALSE
		PROF_recoilCoef 	  		= 0.75;		//default 0.75; no effect if PROF_doCoefChanges is FALSE
		//publicVariable "PROF_doAimCoefChange";
		//publicVariable "PROF_aimCoef";
		//publicVariable "PROF_recoilCoef";


		//automatically assign appropriate ctab items, for SL rugged tablet assignment needs preset variable names for SLs (see template)
		//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
		//Required Mods: CTAB
		PROF_ctabEnabled 		= false; //default false (since ctab isnt in scifi modpack)
		//publicVariable "PROF_ctabEnabled";





	//////////////////////////////////
	////////Template Options///////////
	//////////////////////////////////



		PROF_templateVersion 	= 12.0; //if it's a major release (like 10.0), note that arma will truncate the empty decimal to just '10'
		//publicVariable "PROF_templateVersion";


		PROF_doTemplateBriefing 	= true;
		//publicVariable "PROF_doTemplateBriefing";
		PROF_templateBriefing = [
			"1. Added various torture zeus modules for Zeuses to use on the playerbase (set units on fire, spawn attack dog, timeout player, make unit into juggernaut, etc). Fun times ahead!",
			"2. Added Cease Fire Zone, which Zeus may apply to arsenal areas to prevent weapons from being fired near them. Y'know, cause y'all couldn't behave...",
			"3. Added an optional system that punishes players for killing multiple civilians. Disabled by default (which I'm sure that many of you are thankful for).",
			"4. Fixed drawing blood not actually lowering the donator's blood levels, and make the draw blood action faster to complete. Why yes, you can in fact drain enough blood from someone to kill them.",
			"5. Updated the automatic inventory population to use advanced medical items, like specialized bandages. Patch those boo-boos!",
			"Please visit the 'Mission Template' section in the mission notes (in the top left of the map screen) to be aware of the enabled toggleable features present in this mission, and check your custom keybindings for the 'PROF Mission Template' section to access the various custom keybinds we have.",
			"You will only receive this message once every time you join a mission with a new mission template version. Enjoy the mission!"
		];
		//publicVariable "PROF_templateBriefing"; //is probably a problematically-large var to share 


		//Cleans the mission template briefing by removing diary records for options set to FALSE
		PROF_cleanBriefing 			= true; //default true. true to enable, false to disable.
		//publicVariable "PROF_cleanBriefing"; //don't touch the //publicVariable lines





	//////////////////////////////////
	////////Scripts Options///////////
	//////////////////////////////////



		//Special logic in init.sqf for spawning AI directly on HCs. Advanced usage only and requires extensive setup. Do not touch unless Guac tells you to.
		PROF_spawnUnitsOnHC 		= false; //default false
		//publicVariable "PROF_spawnUnitsOnHC";


		//turn PROF_globalTFAR on/off, if on then make sure you have a way to activate it (i recommend a trigger, see template)
		//Required Mods: TFAR
		PROF_globalTfarEnabled 		= true; //default true, no effect if you dont call it using the trigger or a script
		//publicVariable "PROF_globalTfarEnabled";


		//Enables the Dynamic Groups system.
		PROF_dynamicGroupsEnabled 	= true; //default true
		//publicVariable "PROF_dynamicGroupsEnabled";


		//Displays markers in the bottom left of the map that display the server's and HC's FPS and number of local groups/units
		//might be desirable to turn off if you don't want players to see
		PROF_fpsDisplayEnabled 	= true; //default true
		//publicVariable "PROF_fpsDisplayEnabled";


		//attempts to solve people losing their team color after death by reapplying it on respawn
		PROF_fixDeathColor		= true; //default true
		//publicVariable "PROF_fixDeathColor";


		//trims player group names to get rid of the extra spaces added by the template's need for duplicate group names
		PROF_trimGroupNames 		= true;
		//publicVariable "PROF_trimGroupNames";





	//////////////////////////////////
	///////Logistics Options//////////
	//////////////////////////////////



		//FEATURE TEMP REMOVED
		//Enables the KP crate filler script, see "KPCF_config" for options 
		//NOTE: With default settings, it will add custom behavior to ALL "Land Parachute Target" and "Seismic Map (Whiteboard)" objects in your mission. Disable this setting or change the target objects in KPCF_config if you are using those objects in your mission.
		//PROF_kpCratefiller = true;	//default true
		////publicVariable "PROF_kpCratefiller";





	//////////////////////////////////
	//////////Zeus Options////////////
	//////////////////////////////////



		//Adds two custom resupply modules to Zeus
		//Each has 6 magazines of each player's weapon and a bunch of medical
		//One spawns the crate at cursor location, other paradrops it (watch for wind!)
		//Find the modules under the "Resupply" section in Zeus
		//Required Mods: ZEN
		PROF_zeusResupply 		= true; //default true
		//publicVariable "PROF_zeusResupply";


		//Adds zeus module to play info text
		PROF_zeusInfoText 		= true; //default true
		//publicVariable "PROF_zeusInfoText";


		//Adds zeus modules for manually managing group ownership
		PROF_zeusHcTransfer 		= true; //default true
		//publicVariable "PROF_zeusHcTransfer";


		//allows zeus to trigger an automatic debug and cleanup of hold actions available in the mission
			//for example, try placing it when people complain that the heal box doesn't work anymore
		PROF_zeusActionDebug		= true; //default true
		//publicVariable "PROF_zeusActionDebug";


		//adds two modules for zeus to manage spectator settings and to apply spectator to units
		PROF_zeusSpectateManager	= true; //default true
		//publicVariable "PROF_zeusSpectateManager";


		//adds a module for zeus to delete all empty groups and mark occupied groups as eligible for deletion once they are empty
		PROF_zeusGroupDeletion 	= true; //default true
		//publicVariable "PROF_zeusGroupDeletion";


		//adds a module to zeus to run the marker follow script
		PROF_zeusFollowMarker 	= true; //default true
		//publicVariable "PROF_zeusFollowMarker";


		//add module to zeus to enable RRR zone script on placed unit
		PROF_zeusServiceVehicle 	= true; //default true





	//////////////////////////////////
	//Client Hotkeys/Actions Options//
	//////////////////////////////////



		//Script by IndigoFox that adds an ace interact to all windows which breaks them upon use.
		//Source: https://www.reddit.com/r/armadev/comments/sv72xa/let_your_players_break_windows_using_ace/?utm_source=share&utm_medium=ios_app&utm_name=iossmf
		PROF_aceWindowBreak 		= false; //default false
		//publicVariable "PROF_aceWindowBreak";


		//hotkey to turn afk script on/off
		//Required mods: CBA
		PROF_afkEnabled 			= true; //default true
		//publicVariable "PROF_afkEnabled";


		//hotkey to turn earplugs script on/off
		PROF_earplugsEnabled 	= true; //default true
		PROF_earplugVolume 		= 0.25; //volume to reduce to when earplugs are in (0 is no volume, 1 is regular). Applies to fadeSound, fadeRadio, fadeSpeech, fadeMusic, and fadeEnvironment.
		//publicVariable "PROF_earplugsEnabled";
		//publicVariable "PROF_earplugVolume";


		//adds a hotkey to mute/unmute music
		PROF_musicKeyEnabled 	= true; //default true
		//publicVariable "PROF_musicKeyEnabled";





	//////////////////////////////////
	//////////Admin Options///////////
	//////////////////////////////////
		//these options are more geared towards logging or other admin actions and should be left at their defaults unless you know what you're doing 



		//logging information for certain mods, with optional chat messages
		PROF_ModLog 				= true;	//default true
		PROF_ModLogShame 		= true; //default true
		//publicVariable "PROF_ModLog";
		//publicVariable "PROF_ModLogShame";


		//tracks various performance statistics for each client and sends the results to the server
		PROF_trackPerformance 	= true; //default true, customize specific settings in initPlayerLocal.sqf
		//publicVariable "PROF_trackPerformance";


		//adds a custom rich presence for people running the discord rich presence mod
		PROF_doDiscordUpdate		= true; //default true
		PROF_discordUpdateDelay 	= 30; 	//default 30
		//publicVariable "PROF_doDiscordUpdate";
		//publicVariable "PROF_discordUpdateDelay";





//note: player == null in preinit