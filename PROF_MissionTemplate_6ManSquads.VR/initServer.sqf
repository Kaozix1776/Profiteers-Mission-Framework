//dynamic groups code
if (PROF_dynamicGroupsEnabled) then {
	["Initialize", [true]] call BIS_fnc_dynamicGroups; // Initializes the Dynamic Groups framework and groups led by a player at mission start will be registered
};

//If AceHealObject does not exist but options that require it are turned on, then display a warning that those options will be disabled
if ((isNil "AceHealObject") && (PROF_respawnArsenalGear || PROF_aceHealObjectEnabled || PROF_aceSpectateObjectEnabled)) then {
	systemchat "WARNING: You have turned on mission template options that require the AceHealObject to be present in your mission, but it does not exist! Disabling functions that require the heal object to be present...";
	diag_log text "PROF-Mission-Template WARNING: You have turned on mission template options that require the AceHealObject to be present in your mission, but it does not exist! Disabling functions that require the heal object to be present...";
};

//debug info for presence of the resupply object if it is enabled
if (PROF_resupplyObjectEnabled) then {
	if ((isNil "CreateResupplyObject") || (isNil "ResupplySpawnHelper")) then {
		systemChat "WARNING: Resupply Creator enabled, but missing the relevant spawner object(s) in mission! Disabling resupply creator...";
		diag_log text "PROF-Mission-Template WARNING: Resupply Creator enabled, but missing the relevant spawner object(s) in mission! Disabling resupply creator...";
	};
};

//hold actions are locally applied in fn_applyHoldActions (executed from initPlayerLocal.sqf)

//several systems use PROF_respawnLocations so for simplicity let's just always have it be declared
if (isNil "PROF_respawnLocations") then { //mightve already been set up elsewhere
	PROF_respawnLocations = [];
	publicVariable "PROF_respawnLocations";
};

//setup fob variables if fob system is enabled
if (PROF_fobEnabled) then {
	//{ 
	//	_x = createMarkerLocal [_x, [0,0,0]]; _x setMarkerTypeLocal "Flag"; _x setMarkerColorLocal "ColorCIV";
	//} forEach ["fobMarker","rallypointCmdMarker","rallypointAlphaMarker"]; //create the markers via script (unused, placed in editor instead)
	PROF_fobBuilt = false;
	publicVariable "PROF_fobBuilt";
	PROF_fobDestroyed = false;
	publicVariable "PROF_fobDestroyed";

	if !(isNil "logistics_vehicle") then {	//do not do marker follow if fob vehicle is missing
		[logistics_vehicle,"hd_flag","ColorUNKNOWN","FOB Vehicle",true,5] spawn PROF_fnc_markerFollow; //TODO make this turn greyed out after FOB has been placed
	};
};

if (PROF_rallypointsEnabled) then {
	PROF_rallyCmdUsed = false;
	publicVariable "PROF_rallyCmdUsed";
	PROF_rallyAlphaUsed = false;
	publicVariable "PROF_rallyAlphaUsed";
	PROF_rallyBravoUsed = false;
	publicVariable "PROF_rallyBravoUsed";
	PROF_rallyCharlieUsed = false;
	publicVariable "PROF_rallyCharlieUsed";
	PROF_rallyDeltaUsed = false;
	publicVariable "PROF_rallyDeltaUsed";
	PROF_rallyEchoUsed = false;
	publicVariable "PROF_rallyEchoUsed";
	PROF_rallyFoxtrotUsed = false;
	publicVariable "PROF_rallyFoxtrotUsed";
	PROF_rallyGolfUsed = false;
	publicVariable "PROF_rallyGolfUsed";
	PROF_rallyHotelUsed = false;
	publicVariable "PROF_rallyHotelUsed";
	PROF_rallyReconUsed = false;
	publicVariable "PROF_rallyReconUsed";
	if (isNil "PROF_respawnLocations") then { //mightve already been set up elsewhere
		PROF_respawnLocations = [];
		publicVariable "PROF_respawnLocations";
	};
};

//show fps script by Mildly Interested/Bassbeard
//Code here is for main server, headless client is in init.sqf
if (PROF_fpsDisplayEnabled) then {
	[] spawn PROF_fnc_showFps;
	diag_log text "PROF-Mission-Template --------------------[Executed show_fps on Server]--------------------"; //will show in server logs
};

//handle radio settings broadcast
/*PROF_radioSettings = [];
{
	private _addToArray = _x;
	if (_x == true) then {_addToArray = 1};
	if (_x == false) then {_addToArray = 0};
	PROF_radioSettings pushBack _x;
} forEach [PROF_radiosEnabled,PROF_NoSquadleadLr,PROF_radioAdditionals,PROF_radioPersonal,PROF_radioBackpack];
publicVariable PROF_radioSettings;

//handle fob settings broadcast
PROF_fobSettings = [];
{
	private _addToArray = _x;
	if (_x == true) then {_addToArray = 1};
	if (_x == false) then {_addToArray = 0};
	PROF_fobSettings pushBack _x;
} forEach [PROF_fobEnabled,PROF_fobFullArsenals,PROF_fobDistance,PROF_useSmallRally,PROF_rallyDistance];
publicVariable PROF_fobSettings;*/

if (PROF_waveRespawn) then {
	[] spawn PROF_fnc_waveRespawn;
};

if (PROF_3dGroupIcons) then {
	[] spawn PROF_fnc_autoDisableGroupIcons;
};

if (PROF_markCustomObjectsMap) then {
	[] spawn PROF_fnc_markCustomObjects;
};

if (PROF_scavSystemEnabled) then {
	[] spawn {
		sleep 1; //wait after map screen
		[] spawn PROF_fnc_scavServerInit;
	};
};

//at bottom because has sleep. NOTE: no longer needs to be at the bottom due to 'spawn' being added
if (PROF_respawnInVehicle) then {
	[] spawn { //spawn due to sleep. if not spawned, then the sleep will hold this up.
		PROF_respawnLocations = [];
		sleep 30; //should be enough time for waitUntil in object init fields to activate, plus extra time for zeus to manually configure a vic (not really enough time but didnt want to do too long so that testing it doesnt take too long)
		if (count PROF_respawnLocations == 0) then { //add fallback respawn vehicle if no other respawn vehicles are made
			if (isNil "logistics_vehicle") then {
				systemchat "WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, and the fallback 'logistics vehicle' does not exist either!";
				diag_log text "PROF-Mission-Template WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, and the fallback 'logistics vehicle' does not exist either!";
			} else {
				
				[logistics_vehicle,"Default Respawn Vehicle"] spawn PROF_fnc_assignRespawnVicInit;
				
				systemChat "WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, adding 'logistics_vehicle' as a respawn vehicle as a fallback!";
				diag_log text "PROF-Mission-Template WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, adding 'logistics_vehicle' as a respawn vehicle as a fallback!";
			};
		};
		publicVariable "PROF_respawnLocations";
	};
};