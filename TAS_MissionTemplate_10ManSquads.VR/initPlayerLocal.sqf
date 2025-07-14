////////////////////////////////////////////////////////////////////////////////
//////////////////////////////Variable Setup////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//note that player object is fully available at the start of this script, but radios are not 



//setup diary subject
player createDiarySubject ["PROFMissionTemplate","Mission Template","media\logo256x256.paa"];
player createDiaryRecord ["PROFMissionTemplate", ["Mission Template Version", format ["v%1",PROF_templateVersion]]];

//setup leadership trait for later usage
private _leadershipVariableNames = ["Z1","Z2","Z3","CMD_Actual","CMD_JTAC","RECON_Actual","AIR_1_Actual","AIR_2_Actual","GROUND_1_Actual","GROUND_2_Actual","ALPHA_Actual","BRAVO_Actual","CHARLIE_Actual","DELTA_Actual","ECHO_Actual","FOXTROT_Actual"];
private _leadershipRoleDescriptions = ["Zeus","Ground Command","Officer","JTAC","TACP","Pilot","Commander","Squad Leader","Recon Team Leader","Radioman","RTO"]; //Case sensitive (so don't worry about copilot showing up). Team leader is explicitly not on this due to it might be being used for fireteam stuff under the SL
private _leadershipRoleDescriptionSimple = "@";	//group leaders have an @ sign in their role description to name their squads in role select
private _playerClass = vehicleVarName player;
private _roleDescription = roleDescription player;
private _roleDescriptionSimple = roleDescription player; //we'll use this in a sec

if ((_roleDescription find "@") != -1) then { //-1 indicates no @ sign. If unit has @ sign, parse it and only count text before it (remove group info)
	private _roleDescriptionArray = _roleDescription splitString "@"; //splits string into array with values separated by @ sign, so "AAA@BBB" becomes "[AAA,BBB]"
	_roleDescriptionSimple = _roleDescriptionArray select 0;
};
if ((_roleDescription find "[") != -1) then { //remove info about assigned color team if player has it
	private _indexOfBracket = _roleDescription find "[";
	_roleDescriptionSimple = _roleDescription select [0,(_indexOfBracket - 1)]; //-1 to remove the space before it
};
//at this point, _roleDescriptionSimple should be just "Squad Leader", while _roleDescription is "Squad Leader [Blue Team]@Alpha"

//leadership marking
if (_leadershipRoleDescriptionSimple in _roleDescription) then { //STRING in STRING
	player setVariable ["PROF_PlayerisLeadership",true];
};
//if (_playerClass in _leadershipVariableNames) then {
//	player setVariable ["PROF_PlayerisLeadership",true];
//};



////////////////////////////////////////////////////////////////////////////////
/////////////////////////////Editable Scripts///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//scripts below this point are intended to be editable by zeuses who want to customize the equipment given to their players (assuming the appropriate settings are enabled in the options)
	//read the comments carefully!



if (PROF_useConfigLoadout) then {

	if (PROF_configLoadoutCustom) then {

		/*Change 'Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player' to the role name that you want players named accordingly to have that unit's gear
			note that PROF_configUnitPrefix is still applied to these units
			Also, very rarely, a mod might decide to use invisible characters instead of spaces between words in a unit's display name
				For example, CUP's ION has names like "FieldÂ Medic" (the whitespace is unicode U+00a0)
				If you have issues with normal names not working, spawn the unit in zeus and execute this code in its ZEN code box to get its real display name:
					private _name = getText (configFile >> "cfgVehicles" >> typeOf _this >> "displayName"); copyToClipboard _name; systemChat _name;
			*/

		switch (true) do
		{
			//cmd
			case ("Officer" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("JTAC" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case (("Combat Life Saver" in _roleDescriptionSimple) || ("Medic" in _roleDescriptionSimple) || ("medic" in _roleDescriptionSimple)): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Engineer" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};

			//recon
			case ("Recon Team Leader" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Recon Paramedic" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Recon Demo Specialist" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Recon Sharpshooter" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};

			//air
			case ("Pilot" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Copilot" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};

			//armor
			case ("Commander" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Gunner" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Driver" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};

			//squad (medic is in cmd section)
			case ("Squad Leader" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case (("Radioman" in _roleDescriptionSimple) || ("RTO" in _roleDescriptionSimple)): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Machinegunner" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Team Leader" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Autorifleman" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			case ("Rifleman (AT)" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};

			//other, feel free to add more if you have custom names
			case ("Zeus" in _roleDescriptionSimple): {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};
			default {
				player setVariable ["PROF_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
			};

		};
		
	};

	[player,PROF_configFaction,PROF_defaultConfigUnit,PROF_configUnitPrefix] call PROF_fnc_assignLoadoutFromConfig;

	player createDiaryRecord ["PROFMissionTemplate", ["Loadout Assignment From Config", "Your loadout has been set accordingly to the given faction and your role description. See your chat messages for more information in the case of the script resorting to fallback loadouts or a notficiation that Zeus has chosen to skip your loadout assignment in particular."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Loadout Assignment From Config", "Disabled."]]; };
};

//radio setup, needs to be before custom equipment due to backpack replacement
if (PROF_radiosEnabled) then {
	player linkItem PROF_radioPersonal;
	//LR radio possession marking
	if (PROF_NoSquadleadLr) then {
		//give radio if player is RTO
		if (("Radioman" in _roleDescription) || ("RTO" in _roleDescription)) then {
			player setVariable ["PROF_PlayerHasLr",true];
		};
		//give radio if player is a normal leadership guy (if they aren't an SL)
		if ((player getVariable ["PROF_PlayerisLeadership",false]) && !("Squad Leader" in _roleDescription)) then {
			player setVariable ["PROF_PlayerHasLr",true];
		};
	} else {
		//if player is leadership, then give radio
		if (player getVariable ["PROF_PlayerIsLeadership",false]) then {
			player setVariable ["PROF_PlayerHasLr",true];
		};
	};
	//give player LR radio if approved to do so
	if (player getVariable ["PROF_PlayerHasLr",false]) then {
		player addBackpack PROF_radioBackpack;
		[] spawn { //spawn to avoid errors in TFAR radios not being inited at mission start
			waitUntil {(call TFAR_fnc_haveSWRadio)};
			[(call TFAR_fnc_activeLrRadio), 1, "50"] call TFAR_fnc_SetChannelFrequency; //set 50 as active radio channel on channel 1
			[(call TFAR_fnc_activeLrRadio), 2, "55"] call TFAR_fnc_SetChannelFrequency; //set 55 (fire support) as radio channel two (not active and not additional)
		};
	};
	player createDiaryRecord ["PROFMissionTemplate", ["Radio Assignment", "Enabled.<br/><br/>It may take a second for Teamspeak to initialize your radios. If your radio freq shows up as blank, do not panic as this happens when it is set via script. All SRs are set on squad freq and LRs on 50 (channel 1) and 55 (channel 2)."]];
	//systemChat "Radio loadout init finished. It may take a second for Teamspeak to initialize your radio fully.";
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Radio Assignment", "Disabled."]]; };
	//systemChat "TFAR automatic radio assignment disabled."
};

if (PROF_populateInventory) then {
	//clear items (should remove everything in cargo of uniform/vest/backpack, wont remove radios and gps and etc)
	removeAllItems player; //does not remove radio and gps items
	{player removeMagazine _x} forEach magazines player;
	//for "_i" from 1 to 10 do { player addItem " " };

	//basic medical
	for "_i" from 1 to 8 do { player addItem "ACE_elasticBandage" }; //ACE_fieldDressing ACE_elasticBandage ACE_packingBandage ACE_quikclot
	for "_i" from 1 to 8 do { player addItem "ACE_quikclot" };
	for "_i" from 1 to 8 do { player addItem "ACE_morphine" };
	for "_i" from 1 to 2 do { player addItem "ACE_epinephrine" };
	for "_i" from 1 to 3 do { player addItem "ACE_tourniquet"};
	for "_i" from 1 to 2 do { player addItem "ACE_bloodIV_500" };
	for "_i" from 1 to 2 do { player addItem "ACE_splint" };
	
	//misc
	for "_i" from 1 to 2 do { player addItem "ACE_CableTie" };
	player addItem "ACE_Earplugs";
	player addItem "ACE_EntrenchingTool";

	if (PROF_inventoryAddGps) then {
		player linkItem "ItemGPS";
	};
	//player linkItem "ItemMap";
	//player linkItem "ItemWatch";
	//player linkItem "ItemCompass";
	//player linkItem "TFAR_anprc152";
	
	//grenades
	for "_i" from 1 to 2 do { player addItem "HandGrenade" }; //vanilla m67, v40 is MiniGrenade
	for "_i" from 1 to 2 do { player addItem "SmokeShell" }; //white smoke
	for "_i" from 1 to 1 do { player addItem "SmokeShellPurple" }; //purple smoke

	//medic special stuff
	//https://github.com/acemod/ACE3/blob/master/addons/medical_treatment/functions/fnc_isMedic.sqf
	private _bisMedic = player getUnitTrait "Medic";
	private _aceMedic = [player,1] call ace_medical_treatment_fnc_isMedic;
	private _aceDoctor = [player,2] call ace_medical_treatment_fnc_isMedic;
	if ( _bisMedic == true || _aceMedic == true || _aceDoctor == true ) then {
		for "_i" from 1 to 20 do { player addItem "ACE_elasticBandage" }; //ACE_fieldDressing ACE_elasticBandage ACE_packingBandage ACE_quikclot
		for "_i" from 1 to 20 do { player addItem "ACE_quikclot" };
		for "_i" from 1 to 20 do { player addItem "ACE_morphine" };
		for "_i" from 1 to 15 do { player addItem "ACE_epinephrine" };
		for "_i" from 1 to 6 do { player addItem "ACE_tourniquet"};
		for "_i" from 1 to 10 do { player addItem "ACE_bloodIV_500" };
		for "_i" from 1 to 6 do { player addItem "ACE_bloodIV" };
		for "_i" from 1 to 8 do { player addItem "ACE_splint" };
		player addItem "ACE_personalAidKit";
		player addItem "ACE_surgicalKit";
		player addItem "adv_aceCPR_AED";
		//player addItem "ROOK_SutureGun";
		//for "_i" from 1 to 4 do { player addMagazine "ROOK_SutureMag" };
	};

	//https://github.com/acemod/ACE3/blob/e4be783f80db5730ad5c351d611206a245b35a0f/addons/repair/functions/fnc_isEngineer.sqf
	//engineer gaming
	private _bisEngineer = player getUnitTrait "engineer";
	private _bisEOD = player getUnitTrait "explosiveSpecialist";
	private _aceEngineer = [player, 1] call ace_repair_fnc_isEngineer;
	if ( _bisEngineer == true || _bisEOD == true || _aceEngineer == true ) then {
		player addItem "ToolKit";
		player addItem "MineDetector";
		player addItem "ACE_DefusalKit";
	};

	////////////////////////////////////////
	///////////Custom Equipment/////////////
	////////////////////////////////////////
	//add any custom equipment here
	//setups for default units are provided
	//to enable, set _doCustoMEquipment to TRUE. disabled by default to save performance.
	private _doCustomEquipment = false;

	if (_doCustomEquipment) then {
		//add any misc equipment for all roles here

		

		//add equipment specific to a role to the appropriate switch statement
		switch (true) do
		{
			//cmd
			case ("Officer" in _roleDescriptionSimple): {

			};
			case ("JTAC" in _roleDescriptionSimple): {
				
			};
			case (("Combat Life Saver" in _roleDescriptionSimple) || ("Medic" in _roleDescriptionSimple) || ("medic" in _roleDescriptionSimple)): {
				
			};
			case ("Engineer" in _roleDescriptionSimple): {
				
			};

			//recon
			case ("Recon Team Leader" in _roleDescriptionSimple): {

			};
			case ("Recon Paramedic" in _roleDescriptionSimple): {
				
			};
			case ("Recon Demo Specialist" in _roleDescriptionSimple): {
				
			};
			case ("Recon Sharpshooter" in _roleDescriptionSimple): {
				
			};

			//air
			case ("Pilot" in _roleDescriptionSimple): {

			};
			case ("Copilot" in _roleDescriptionSimple): {
				
			};

			//armor
			case ("Commander" in _roleDescriptionSimple): {

			};
			case ("Gunner" in _roleDescriptionSimple): {
				
			};
			case ("Driver" in _roleDescriptionSimple): {
				
			};

			//squad (medic is in cmd section)
			case ("Squad Leader" in _roleDescriptionSimple): {

			};
			case (("Radioman" in _roleDescriptionSimple) || ("RTO" in _roleDescriptionSimple)): {
				
			};
			case ("Machinegunner" in _roleDescriptionSimple): {
				
			};
			case ("Team Leader" in _roleDescriptionSimple): {
				
			};
			case ("Autorifleman" in _roleDescriptionSimple): {
				
			};
			case ("Rifleman (AT)" in _roleDescriptionSimple): {
				
			};

			//other, feel free to add more if you have custom names
			case ("Zeus" in _roleDescriptionSimple): {
				
			};
			default {

			};
		};
	};

	////////////////////////////////////////
	/////////End Custom Equipment///////////
	////////////////////////////////////////

	//ammo
	if (primaryWeapon player != "") then {
		//for "_i" from 1 to 8 do { player addItem ([primaryWeapon player] call CBA_fnc_compatibleMagazines select 0) }; //standard ammo
		if (count ([primaryWeapon player] call CBA_fnc_compatibleMagazines) > 0) then {									
			for "_i" from 1 to 6 do { player addItem ([primaryWeapon player] call CBA_fnc_compatibleMagazines select 0) };
			if (count ([primaryWeapon player] call CBA_fnc_compatibleMagazines) > 1) then {  								
				for "_i" from 1 to 4 do { player addItem ([primaryWeapon player] call CBA_fnc_compatibleMagazines select 1) }; 
			};
		};
		{
			if (_x != "this") then {
				if (count ([configFile >> "CfgWeapons" >> primaryWeapon player >> _x] call CBA_fnc_compatibleMagazines) > 0) then {									//checks if weapon actually has compatible ammo
					for "_i" from 1 to 6 do { player addItem ([configFile >> "CfgWeapons" >> primaryWeapon player >> _x] call CBA_fnc_compatibleMagazines select 0) }; //standard ammo
					if (count ([configFile >> "CfgWeapons" >> primaryWeapon player >> _x] call CBA_fnc_compatibleMagazines) > 1) then {  								//adds CBA's second best guess for ammo (for tracer rounds for rifles, HE rounds for launchers, and the like) if any exists
						for "_i" from 1 to 4 do { player addItem ([configFile >> "CfgWeapons" >> primaryWeapon player >> _x] call CBA_fnc_compatibleMagazines select 1) }; //standard ammo
					};
				};
			};
		} forEach (getArray (configFile >> "CfgWeapons" >> (primaryWeapon player) >> "muzzles"));				//check for each muzzle so that UGL has ammo
	};
	//for "_i" from 1 to 4 do { player addItem ([primaryWeapon player] call CBA_fnc_compatibleMagazines select 1) }; //special ammo, usually but not always tracers. Buggy so just double the amount of standard mags
	if (handgunWeapon player != "") then {
		//for "_i" from 1 to 1 do { player addItem ([handgunWeapon player] call CBA_fnc_compatibleMagazines select 0) };
		if (count ([handgunWeapon player] call CBA_fnc_compatibleMagazines) > 0) then {									
			for "_i" from 1 to 1 do { player addItem ([handgunWeapon player] call CBA_fnc_compatibleMagazines select 0) };
		};
		{
			if (_x != "this") then {
				if (count ([configFile >> "CfgWeapons" >> handgunWeapon player >> _x] call CBA_fnc_compatibleMagazines) > 0) then {									//checks if weapon actually has compatible ammo
					for "_i" from 1 to 1 do { player addItem ([configFile >> "CfgWeapons" >> handgunWeapon player >> _x] call CBA_fnc_compatibleMagazines select 0) }; //standard ammo
				};
			};
		} forEach (getArray (configFile >> "CfgWeapons" >> (handgunWeapon player) >> "muzzles"));
	};
	if (secondaryWeapon player != "") then {
		//for "_i" from 1 to 2 do { player addItem ([secondaryWeapon player] call CBA_fnc_compatibleMagazines select 0) }; //add launcher ammo if player has launcher
		if (count ([secondaryWeapon player] call CBA_fnc_compatibleMagazines) > 0) then {									
			for "_i" from 1 to 2 do { player addItem ([secondaryWeapon player] call CBA_fnc_compatibleMagazines select 0) };
			if (count ([secondaryWeapon player] call CBA_fnc_compatibleMagazines) > 1) then {  								
				for "_i" from 1 to 2 do { player addItem ([secondaryWeapon player] call CBA_fnc_compatibleMagazines select 1) }; 
			};
		};
		{
			if (_x != "this") then {
				if (count ([configFile >> "CfgWeapons" >> secondaryWeapon player >> _x] call CBA_fnc_compatibleMagazines) > 0) then {									//checks if weapon actually has compatible ammo
					for "_i" from 1 to 2 do { player addItem ([configFile >> "CfgWeapons" >> secondaryWeapon player >> _x] call CBA_fnc_compatibleMagazines select 0) }; //standard ammo
					if (count ([configFile >> "CfgWeapons" >> secondaryWeapon player >> _x] call CBA_fnc_compatibleMagazines) > 1) then {  								//adds CBA's second best guess for ammo (for tracer rounds for rifles, HE rounds for launchers, and the like) if any exists
						for "_i" from 1 to 2 do { player addItem ([configFile >> "CfgWeapons" >> secondaryWeapon player >> _x] call CBA_fnc_compatibleMagazines select 1) }; //standard ammo
					};
				};
			};
		} forEach (getArray (configFile >> "CfgWeapons" >> (secondaryWeapon player) >> "muzzles"));
	};

	player createDiaryRecord ["PROFMissionTemplate", ["Inventory Population", "Enabled.<br/><br/>You have been given basic medical, grenade, ammo, and loadout-specific supplies."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Inventory Population", "Disabled"]]; };
};



////////////////////////////////////////////////////////////////////////////////
////////////////////////////Non-Editable Scripts////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//scripts below this point are not intended to be editable by most zeuses



//arsenal GUI handling for respawnGUI. added even if respawninvehicle or etc are enabled as its useful for various scripts
["ace_arsenal_displayOpened", {player setVariable ["PROF_aceArsenalOpen",true]}] call CBA_fnc_addEventHandler;
["ace_arsenal_displayClosed", {player setVariable ["PROF_aceArsenalOpen",false]}] call CBA_fnc_addEventHandler;

if (PROF_roleBasedArsenals) then {

	_openRoleArsenalAceAction = [
		"roleArsenalAceAction",
		"Open Role-Based Arsenal",
		"",
		{
			player call PROF_fnc_roleBasedArsenal;
		},
		{
			PROF_roleBasedArsenals
		},
		{},
		{},
		{},
		10
	] call ace_interact_menu_fnc_createAction;
	/*
	* Argument:
	* 0: Action name <STRING>
	* 1: Name of the action shown in the menu <STRING>
	* 2: Icon <STRING>
	* 3: Statement <CODE>
	* 4: Condition <CODE>
	* 5: Insert children code <CODE> (Optional)
	* 6: Action parameters <ANY> (Optional)
	* 7: Position (Position array, Position code or Selection Name) <ARRAY>, <CODE> or <STRING> (Optional)
	* 8: Distance <NUMBER> (Optional)
	* 9: Other parameters [showDisabled,enableInside,canCollapse,runOnHover,doNotCheckLOS] <ARRAY> (Optional)
	* 10: Modifier function <CODE> (Optional)
	*/
	{
		private _arsenal = _x;
		_arsenal = missionNamespace getVariable [_arsenal, objNull]; //convert from string to object, otherwise we get errors
		if (!isNull _arsenal) then {
			//ace
			[_arsenal, 0, ["ACE_MainActions"], _openRoleArsenalAceAction] call ace_interact_menu_fnc_addActionToObject;

			//vanilla too ig
			_arsenal addAction [
				"Open Role-Based Arsenal",	// title
				{
					params ["_target", "_caller", "_actionId", "_arguments"]; // script
					_caller call PROF_fnc_roleBasedArsenal;
				},
				nil,		// arguments
				99,		// priority
				true,		// showWindow
				false,		// hideOnUse
				"",			// shortcut
				"PROF_roleBasedArsenals", 	// condition
				10,			// radius
				false,		// unconscious
				"",			// selection
				""			// memoryPoint
			];
		} else {
			systemChat "PROF-MISSION-TEMPLATE Error: arsenal in PROF_visibleArsenalBoxes does not exist in the mission!";
		};
	} forEach PROF_visibleArsenalBoxes;

	player createDiaryRecord ["PROFMissionTemplate", ["Role-Based Arsenals", "Enabled.<br/><br/>Use the action on the arsenals to access the role-based arsenals."]];

} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Role-Based Arsenals", "Disabled."]]; };
};

if (PROF_radioAdditionals) then {
	private _standardRadioAssignment = [] spawn {
		waitUntil {(call TFAR_fnc_haveSWRadio)}; //wait until have radio
		[(call TFAR_fnc_activeSwRadio), 1] call TFAR_fnc_setAdditionalSwChannel; //set Channel 2 to additional (0-based index)
		[(call TFAR_fnc_ActiveSWRadio), 2] call TFAR_fnc_setAdditionalSwStereo; //set additional channel to right ear only
		[(call TFAR_fnc_ActiveSWRadio), 1] call TFAR_fnc_setSwStereo; //set main channel to left ear
	};
	player createDiaryRecord ["PROFMissionTemplate", ["Radio Additional Channels Assignment", "Enabled.<br/><br/>Your left ear is your main channel (capslock to transmit and by default is the squad-wide net), while your right ear is your additional channel (T to transmit, usually the fireteam net). Your Long Range radio remains unchanged."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Radio Additional Channels Assignment", "Disabled."]]; };
};

//ctab setup
if (PROF_ctabEnabled) then {
	player addItem "ItemcTabHCam"; //give all players a helmetcam, will auto delete hcam if inventory is full
	player linkItem "itemAndroid"; //give everyone an android in their gps slot, will be overwriten if they are leadership
	if (player getVariable ["PROF_PlayerIsLeadership",false]) then {player linkItem "itemcTab"; player addItem "itemAndroid";}; //give leadership an android in their inventories and a tablet in their gps slot (will delete existing item), will auto delete android if inventory is full
	//systemChat "cTab loadout init finished.";
	player createDiaryRecord ["PROFMissionTemplate", ["cTab Assignment", "Enabled.<br/><br/>All units have recieved an Android and helmet cam, while leadership have also recieved a rugged tablet."]];
} else {
	//systemChat "cTab automatic item assignment disabled."
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["cTab Assignment", "Disabled."]]; };
};

//dynamic groups code
if (PROF_dynamicGroupsEnabled) then {
	["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups; // Initializes the player/client side Dynamic Groups framework and registers the player group
	player createDiaryRecord ["PROFMissionTemplate", ["Dynamic Groups", "Enabled.<br/><br/>Press 'U' to open the Dynamic Groups menu."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Dynamic Groups", "Disabled."]]; };
};

//disableStamina, simple way since the more complicated way with addMPEventhandler bugged out recently. Must be here and in onPlayerRespawn
if (PROF_vanillaStaminaDisabled) then {
	player enableFatigue false;
	player createDiaryRecord ["PROFMissionTemplate", ["Vanilla Stamina", "Disabled.<br/><br/>Vanilla Stamina is Disabled."]];
} else {
	player createDiaryRecord ["PROFMissionTemplate", ["Vanilla Stamina", "Enabled.<br/><br/>Vanilla Stamina is Enabled."]];
};

//Sets custom aim coefficient (precision and/or weapon sway) and recoil coefficient. Must be here and in onPlayerRespawn
if (PROF_doAimCoefChange) then {
	player setCustomAimCoef PROF_aimCoef;
	player setUnitRecoilCoefficient PROF_recoilCoef;
	player createDiaryRecord ["PROFMissionTemplate", ["Sway/Recoil Coefficient Changes", format ["Sway coefficient: %1. Recoil Coefficient: %2",PROF_aimCoef,PROF_recoilCoef]]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Sway/Recoil Coefficient Changes", "Vanilla coefficients are enabled."]]; };
};

//Add PROF Afk Script
if (PROF_afkEnabled) then {
	// Register a simple keypress to an action
	//#include "\a3\ui_f\hpp\defineDIKCodes.inc" //these two lines can be removed if wanted, rn script uses the number codes instead
	//#define USER_19 0x10C
	//25 for P, 0x10C for User Action 19
	//[24, [false, true, true]] is "O + lctrl + lalt", can change in cba keybindings if wanted
	["PROF Keybindings","afk_script_key_v2","Run PROF Afk Script", {[] spawn PROF_fnc_AfkScript}, "", [24, [false, true, true]]] call CBA_fnc_addKeybind;

	//make a diary record tutorial
	player createDiaryRecord ["PROFMissionTemplate", ["Afk Script", "Enabled.<br/><br/>To start/stop the AFK script, input the keybinding you added under Controls\Addon Controls\PROF Keybindings\Run AFK Script. By default, it will be Left Control + Left Alt + O."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Afk Script", "Disabled."]]; };
	//systemChat "Afk System disabled.";
};

//Add PROF Earplugs Script
if (PROF_earplugsEnabled) then {
	// Register a simple keypress to an action
	//#include "\a3\ui_f\hpp\defineDIKCodes.inc" //these two lines can be removed if wanted, rn script uses the number codes instead
	//#define USER_19 0x10C
	//25 for P, 0x10C for User Action 19
	//[18, [false, true, true]] is "E + lctrl + lalt", can change in cba keybindings if wanted
	["PROF Keybindings","earplugs_key","Toggle Earplugs", {[] spawn PROF_fnc_earplugs}, "", [18, [false, true, true]]] call CBA_fnc_addKeybind;

	//make a diary record tutorial
	player createDiaryRecord ["PROFMissionTemplate", ["Earplugs Script", "Enabled.<br/><br/>To enable/disable the earplugs, input the keybinding you added under Controls\Addon Controls\PROF Keybindings\Toggle Earplugs. By default, it will be Left Control + Left Alt + E."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Earplugs Script", "Disabled."]]; };
	//systemChat "Afk System disabled.";
};

//Add PROF Music Hotkey Script
if (PROF_musicKeyEnabled) then {
	["PROF Keybindings","music_key","Toggle Music", {[] spawn PROF_fnc_toggleMusic}, "", [13, [false, true, true]]] call CBA_fnc_addKeybind; //13 is =

	//make a diary record tutorial
	player createDiaryRecord ["PROFMissionTemplate", ["Music Hotkey Script", "Enabled.<br/><br/>To enable/disable music audio, input the keybinding you added under Controls\Addon Controls\PROF Keybindings\Toggle Music. By default, it will be Left Control + Left Alt + =."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Music Hotkey Script", "Disabled."]]; };
	//systemChat "Afk System disabled.";
};

//Add FOB Script
if (PROF_fobEnabled) then {
	[] spawn PROF_fnc_initFOB;
} else {
	//systemChat "FOB/Rallypoint building disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["FOB System", "Disabled."]]; };
};

//Add Rallypoints Script
if (PROF_rallypointsEnabled) then {
	[] spawn PROF_fnc_initRallypoints;
} else {
	//systemChat "FOB/Rallypoint building disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Rallypoints System", "Disabled."]]; };
};


//global tfar diary entry
if (PROF_globalTfarEnabled) then { 
	//function handled in description.ext
	player createDiaryRecord ["PROFMissionTemplate", ["Global TFAR Script", "Enabled.<br/><br/>Sets all Short Range radios to a single channel for Zeus/Lore events. Restores radios to prior channel when run a second time. Can be executed from either debug console or via trigger by using remoteExecCall on PROF_fnc_globalTFAR."]];
} else {
	//systemChat "PROF Global TFAR System disabled."
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Global TFAR Script", "Disabled."]]; };
};

if (PROF_bftEnabled) then {
	if !(PROF_bftOnlyShowOwnGroup) then {
		[] execVM "functions\scripts\QS_icons.sqf";
	} else {
		[] execVM "functions\scripts\QS_icons_onlyOwnGroup.sqf";
	};
	//systemChat "QS BFT initiated.";
	player createDiaryRecord ["PROFMissionTemplate", ["Quicksilver BFT", "Enabled.<br/><br/>Open your map or GPS to activate it."]];
} else {
	//systemChat "QS BFT disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Quicksilver BFT", "Disabled."]]; };
};

if (PROF_aceHealObjectEnabled) then {
	player createDiaryRecord ["PROFMissionTemplate", ["Ace Heal Object", "Enabled.<br/><br/>Interact with the heal object in order to see and activate the heal action."]];
} else {
	//systemChat "Ace Heal Object disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Ace Heal Object", "Disabled."]]; };
};

if (PROF_aceSpectateObjectEnabled) then {
	player createDiaryRecord ["PROFMissionTemplate", ["Ace Spectate Object", "Enabled.<br/><br/>Interact with the heal/spectate object in order to see and activate the spectate action. Press the 'Escape' key to exit spectator."]];
} else {
	//systemChat "Ace Spectate Object disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Ace Spectate Object", "Disabled."]]; };
};

//respawn with death gear
if (PROF_respawnDeathGear) then {
	player createDiaryRecord ["PROFMissionTemplate", ["Respawn With Death Loadout", "Enabled.<br/><br/>You will respawn with the gear you had equipped when you died."]];
} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Respawn With Death Loadout", "Disabled."]]; };
};

//respawn with saved gear
if (PROF_respawnArsenalGear) then {
	private _loadout = [player] call CBA_fnc_getLoadout;
	player setVariable ["PROF_arsenalLoadout",_loadout]; //setup initial loadout so doesnt use config loadout if not done by player. Use CBA method.

	//setup automatic saving of loadout when exitting the arsenal. Player can also set loadout at the heal box manually.
	["ace_arsenal_displayClosed", {
		private _loadout = [player] call CBA_fnc_getLoadout;
		player setVariable ["PROF_arsenalLoadout",_loadout];
	}] call CBA_fnc_addEventHandler;

	player createDiaryRecord ["PROFMissionTemplate", ["Respawn With Saved Loadout", "Enabled.<br/><br/>Interact with the heal/spectate object in order to save your loadout."]];
} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Respawn With Saved Loadout", "Disabled."]]; };
};

//respawn in vehicle
if (PROF_respawnInVehicle) then {
	player createDiaryRecord ["PROFMissionTemplate", ["Respawn in Vehicle (Custom)", "Enabled.<br/><br/>After a waiting period specified by the mission maker, respawning players will be teleported into the logistics vehicle. During this waiting time, respawning players can spectate, edit their loadout, or hang out at base. Zeus has access to a module to add additional respawn vehicles. You can find it under 'PROF Mission Template' in the module list."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Respawn in Vehicle (Custom)", "Disabled."]]; };
};

if (PROF_fpsDisplayEnabled) then {
	player createDiaryRecord ["PROFMissionTemplate", ["FPS Counter (by MildlyInterested)", "Enabled.<br/><br/>In the bottom left of the map you will see markers for the server and any HCs with various debug information."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["FPS Counter (by MildlyInterested)", "Disabled."]]; };
};

if (PROF_resupplyObjectEnabled) then {
	player createDiaryRecord ["PROFMissionTemplate", ["Resupply Object Spawner", "Enabled.<br/><br/>At base, players will be able to spawn a supply crate with ammo and medical for all the players."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Resupply Object Spawner", "Disabled."]]; };
};

//JIP compat for globalTFAR
//if player has not had radio set to global most recently then cache current additional data and set additional to global
private _playerRadiosAreGlobal = missionNamespace getVariable ["playersRadioGlobal", false];
if (_playerRadiosAreGlobal == true) then {
	[] spawn { //spawn to avoid errors in TFAR radios not being inited at mission start
		waitUntil {(call TFAR_fnc_haveSWRadio)};
		private _activeSwRadio = call TFAR_fnc_ActiveSwRadio;
		private _originalAdditionalChannel = _activeSwRadio call TFAR_fnc_getAdditionalSwChannel;
		private _originalAdditionalStereo = _activeSwRadio call TFAR_fnc_getAdditionalSwStereo;
		player setVariable ["originalAdditionalChannel", _originalAdditionalChannel];
		player setVariable ["originalAdditionalStereo", _originalAdditionalStereo];
		[_activeSwRadio, 8, "87"] call TFAR_fnc_SetChannelFrequency; //these two lines determine global channel and frequency, freq is the max freq LRs can go to
		[_activeSwRadio, 7] call TFAR_fnc_setAdditionalSwChannel; //lower by 1 cause internally this fnc is zero-based
		[_activeSwRadio, 0] call TFAR_fnc_setAdditionalSwStereo;
		player setVariable ["playersRadioGlobal", true];
		
		diag_log format ["PROF_fnc_globalTFAR applied successfully during JIP."];
	};
};

//diary record for repair zone. Figuring out the logic for detecting if repair zone exists hurts my mind, so don't bother with it.
player createDiaryRecord ["PROFMissionTemplate", ["Automatic RRR Zone", "If placed in the mission by the Zeus, the repair zone(s) usually are located at a square helipad. Move your vehicle onto this helipad, reduce its speed to 0, and turn your engine off to begin the automatic repair, refuel, and rearm."]];

//window break setup
if (PROF_aceWindowBreak) then {
	[] execVM "functions\scripts\ifx_windowBreak.sqf";
	player createDiaryRecord ["PROFMissionTemplate", ["Ace Window Break by IndigoFox", "Enabled.<br/><br/>Walk up to any window and you will see an ace interaction somewhere near it in order to break it."]];
} else {
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Ace Window Break by IndigoFox", "Disabled."]]; };
};

//TODO check if we need to delay until curator is registered? and/or just set it as postInit in description.ext and remove it from here
[] call PROF_fnc_zenCustomModulesRegister;

//apply hold actions
[] call PROF_fnc_applyHoldActions;

if (PROF_arsenalCurate) then {
	["arsenal_1","arsenal_2","arsenal_3","arsenal_4","arsenal_5","arsenal_6","arsenal_7","arsenal_8","arsenal_9","arsenal_10"] spawn PROF_fnc_arsenalCurate;
		//template only provides 3 arsenals, but more are provided in case mission maker copy pastes them (they'll automatically be named arsenal_X)
};

if (PROF_doTemplateBriefing) then {
	private _lastBriefed = profileNamespace getVariable ["PROF_lastTemplateBriefNumber",0];	//new name as old one used string
	if (_lastBriefed < PROF_templateVersion) then {
		[] spawn {
			sleep 1; //to wait until after map screen
			(format ["PROF Mission Template v%1 — What's New",PROF_templateVersion]) hintC PROF_templateBriefing;
			profileNamespace setVariable ["PROF_lastTemplateBriefNumber",PROF_templateVersion];
			//note: if client does a non-graceful game exit, this variable will not be saved. Not going to bother forcing a save here as it's not worth the time it takes.
		};
	};
};

if (PROF_scavSystemEnabled) then {
	player createDiarySubject ["scavDiaryEntries","Tarkov Op Meta Info","media\logo256x256.paa"];
	player createDiaryRecord [
		"scavDiaryEntries",
		[
			"Scav Info",
			"After you die, you will respawn as a Scavenger. Scavengers are inhabitants of the area and scavenge for materials to survive, often working for local power brokers called Traders.<br /><br />A Trader has told you that they recently had a convoy carrying vital food supplies get hijacked. The attackers have hidden the food supplies in a number of caches and are guarding them. Acquire at least 3 of the Pizza items and bring them to an extraction point. You get $100 per pizza item that you extract with.<br /><br />Traders have a shop in the safe zone where you can buy better weapons and gear. You get $100 for every pizza item you extract with.<br /><br />You may choose to either cooperate with other scavenger players, or fight them for any pizzas they may have. Zeus may give bonus money for good cooperation, ping them. All AI is hostile to you. You can contact other player scavengers on the default radio frequency 44.<br /><br />There is no dynamic loot script running, so don't search houses looking for gear. Feel free to loot dead bodies though.<br /><br />Unless specially instructed by Zeus, there is no reward to hunting PMCs. If you believe you have a good idea for a special PROFk, contact Zeus."
		]
	];
	player createDiaryRecord [
		"scavDiaryEntries",
		[
			"PMC Info",
			"You are members of USEC, a PMC group working for the Terragroup Labs corporation. About a week ago, all Terragroup employees were told to shelter at various Terragroup facilities due to a widespread state of unrest breaking out in the region. However, now that the unrest seems like it'll continue for quite some time, USEC operatives are venturing out to recover some personel and assets that didn't successfully evacuate earlier.<br /><br />You have various PROFks to do. These are all marked on the map, and will be explained by Zeus in the briefing.<br /><br />When you are told you must 'Extract', you can either return to the start position or make it anywhere outside the play zone (marked on map). You can also exit the play zone and ask Zeus for a fast travel to another boundary location of the play zone."
		]
	];
};

if (PROF_trackPerformance) then {
	[true,300,2,true] spawn PROF_fnc_debugPerfRpt;	//duration, delay between debugs, target for output, copy to local machine
};

if (PROF_doDiscordUpdate) then {
	if (isClass(configFile >> "CfgPatches" >> "CAU_DiscordRichPresence")) then { 
		(format ["%1 is running Discord Rich Presence",player]) remoteExec ["diag_log",2];
		PROF_discordUpdateDelay spawn PROF_fnc_updateDiscordRichPresence;
	};
};

if (PROF_3dGroupIcons) then { //intentionally the "do" variant for performance reasons
	[] spawn PROF_fnc_3dGroupIcons;
};

if (PROF_trimGroupNames) then {
	[group player,false] spawn PROF_fnc_trimGroupName;
};

if (PROF_textBriefing) then {
	[] spawn PROF_fnc_briefing;
	/*
	switch (side player) do {
		case west: {};
		case east: {};
		case independent: {};
		case civilian: {};
		default {};
	};
	*/
};

if (PROF_allowBloodDrawing) then {
	player remoteExec ["PROF_fnc_drawBlood",0,true];
};

if (PROF_vassEnabled) then {
	[] spawn PROF_fnc_vassPlayerInit;
};

if (PROF_addUnitMarkAction) then {
	[] spawn PROF_fnc_addMarkingAction;
};

if (PROF_ModLog) then {
	//TOOD chat not working?
	private _logMessage = "";

	if (isClass(configFile >> "CfgPatches" >> "Revo_NoWeaponSway")) then {
		_shameMessage = format ["%1 is running No Weapon Sway",name player];
		_shameMessage remoteExec ["diag_log",2];
		if (PROF_ModLogShame) then {
			//[player,"I am running No Weapon Sway!"] remoteExec ["globalChat"];
		};
	};
	if (isClass(configFile >> "CfgPatches" >> "cTab")) then { 
		_shameMessage = format ["%1 is running cTab",name player];
		_shameMessage remoteExec ["diag_log",2];
		if (PROF_ModLogShame) then {
			[player,"I am running cTab!"] remoteExec ["globalChat"];
		};
	};
	if (isClass(configFile >> "CfgPatches" >> "Ronon_gun_Pat")) then { 
		_shameMessage = format ["%1 is running Stargate",name player];
		_shameMessage remoteExec ["diag_log",2];
		if (PROF_ModLogShame) then {
			[player,"I am running Stargate!"] remoteExec ["globalChat"];
		};
	};
	if ((isClass(configFile >> "CfgPatches" >> "BRIDGE_PunchMod")) || (isClass(configFile >> "CfgPatches" >> "BRIDGE_punch"))) then { 
		_shameMessage = format ["%1 is running Knock People Unconscious",name player];
		_shameMessage remoteExec ["diag_log",2];
		if (PROF_ModLogShame) then {
			[player,"I am running Knock People Unconscious!"] remoteExec ["globalChat"];
		};
	};
	if !(isClass(configFile >> "CfgPatches" >> "L_Suppress_Suppress_main")) then { 
		_shameMessage = format ["%1 is not running Suppress",name player];
		_shameMessage remoteExec ["diag_log",2];
		if (PROF_ModLogShame) then {
			[player,"I am not running Suppress!"] remoteExec ["globalChat"];
		};
	};
	if (isClass(configFile >> "CfgPatches" >> "Alternative_Running")) then { 
		_shameMessage = format ["%1 is running Alternative Running",name player];
		_shameMessage remoteExec ["diag_log",2];
		if (PROF_ModLogShame) then {
			[player,"I am running Alternative Running!"] remoteExec ["globalChat"];
		};
	};

	/*if (isClass(configFile >> "CfgPatches" >> "rhsusf_weapons")) then { 
		//[player,"I am running AAA! Shame on me!"] remoteExec ["globalChat"];
		_shameMessage = format ["%1 is running AAA",name player];
		_shameMessage remoteExec ["diag_log"];
	};*/
};