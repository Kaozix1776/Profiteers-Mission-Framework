// [] call fn_automatedReviewer.sqf
//4 spaces to count as a tab

private _outputArray = [];

//mission, map, and template version
_outputArray pushBack format ["Mission name: %1, Map: %2, Mission Template Version: %3",missionName,worldName,PROF_templateVersion];


//time
private _time = [dayTime, "HH:MM"] call BIS_fnc_timeToString;
_outputArray pushBack format ["Mission time: %1. Time acceleration: %2",_time,timeMultiplier];

//todo weather 


//check number of groups and if the majority (75%+ have automated group deletion on)
private _numberOfGroups = count allGroups;
private _numberOfGroupsAutodelete = count (allGroups select {isGroupDeletedWhenEmpty _x});
_outputArray pushBack format ["Total number of groups: %1, wherein %2 will be automatically deleted when empty.",_numberOfGroups,_numberOfGroupsAutodelete]; // Remember that there can only be 288 groups per side at the same time!
//todo group breakdown per side


//check for DLC restrictions?


//check for number of units and if any are dead on mission start
private _numberOfUnits = count allUnits; //does not include agents or vehicles
private _numberOfAgents = count agents;
private _numberOfUnitsWest = count units West;
private _numberOfUnitsEast = count units East;
private _numberOfUnitsIndependent = count units Independent;
private _numberOfUnitsCiv = count units Civilian;
private _numberOfDeadUnits	= count allDeadMen; //includes agents
_outputArray pushBack format ["Total number of units: %1, wherein %2 are dead on mission start and %3 are agents.",_numberOfUnits,_numberOfDeadUnits,_numberOfAgents];
_outputArray pushBack format ["    Unit breakdown per side: West - %1, East - %2, Independent - %3, Civilian - %4.",_numberOfUnitsWest,_numberOfUnitsEast,_numberOfUnitsIndependent,_numberOfUnitsCiv];

//check for number of objects
private _numberOfObjects = count allMissionObjects "all"; //does not count (most) ambient animals, does not track mines, might track some unintended game-created items
private _numberOfObjectsNoSim = count ((allMissionObjects "all") select {!(simulationEnabled _x)});
private _numberOfSimpleObjects = count allSimpleObjects [];
_outputArray pushBack format ["Total number of objects: %1, wherein %2 have their simulation disabled. There are also an additional %3 simple objects.",_numberOfObjects,_numberOfObjectsNoSim,_numberOfSimpleObjects];

//player units
private _numberOfPlayersWest = playableSlotsNumber west;
private _numberOfPlayersEast = playableSlotsNumber east;
private _numberOfPlayersIndependent = playableSlotsNumber independent;
private _numberOfPlayersCiv = playableSlotsNumber civilian;
private _numberOfPlayers = _numberOfPlayersWest + _numberOfPlayersEast + _numberOfPlayersIndependent + _numberOfPlayersCiv;
_outputArray pushBack format ["Total number of playable units: %1 (not counting logic entities like headless clients or spectators).",_numberOfPlayers];
_outputArray pushBack format ["    Player slots breakdown per side: West - %1, East - %2, Independent - %3, Civilian - %4.",_numberOfPlayersWest,_numberOfPlayersEast,_numberOfPlayersIndependent,_numberOfPlayersCiv];

//check for map markers
private _numberOfMapMarkers = count allMapMarkers;
_outputArray pushBack format ["Total number of map markers: %1.",_numberOfMapMarkers];

//check for mines 
private _numberOfMines = count allMines;
_outputArray pushBack format ["Total number of mines: %1.",_numberOfMines];

//count zeuses. TODO check what they're attached to
private _numberOfZeusLogics = count allCurators;
_outputArray pushBack format ["Total number of zeus logics: %1.",_numberOfZeusLogics];

//count HCs - TODO check if theyre set up properly?
private _headlessClients = entities "HeadlessClient_F";
private _numberOfHeadlessClients = count _headlessClients;
_outputArray pushBack format ["Total number of headless clients: %1.",_numberOfHeadlessClients];

//maybe check if heal box is enabled but nonfunctional? and other template features


//get number and type of respawns?
//https://community.bistudio.com/wiki/BIS_fnc_getRespawnPositions
private _numberOfRespawnsWest = count (west call BIS_fnc_getRespawnPositions);
private _numberOfRespawnsEast = count (east call BIS_fnc_getRespawnPositions);
private _numberOfRespawnsIndependent = count (independent call BIS_fnc_getRespawnPositions);
private _numberOfRespawnsCiv = count (civilian call BIS_fnc_getRespawnPositions);
private _numberOfRespawns = _numberOfRespawnsWest + _numberOfRespawnsEast + _numberOfRespawnsIndependent + _numberOfRespawnsCiv;
private _respawnTime = getMissionConfigValue ["respawnDelay",0];
_outputArray pushBack format ["Total number of respawns: %1. Vanilla respawn delay: %2",_numberOfRespawns,_respawnTime];
_outputArray pushBack format ["    Respawn breakdown per side: West - %1, East - %2, Independent - %3, Civilian - %4.",_numberOfRespawnsWest,_numberOfRespawnsEast,_numberOfRespawnsIndependent,_numberOfRespawnsCiv];


//dysim
if (dynamicSimulationSystemEnabled) then {
	_outputArray pushBack format ["Dynamic simulation enabled. Unit simulation range: %1, vehicle simulation range: %2, empty vehicle simulation range: %3, object simulation range: %4, moving multiplier: %5",dynamicSimulationDistance "Group",dynamicSimulationDistance "Vehicle",dynamicSimulationDistance "EmptyVehicle",dynamicSimulationDistance "Prop", dynamicSimulationDistanceCoef "IsMoving"];
} else {
	_outputArray pushBack format ["Dynamic simulation disabled!"];
};


//todo init field checks


//todo triggers


//check if template settings are customized from the defaults
_outputArray pushBack format ["Mission Template Settings Check:"];
{
    private _settingName = _x select 0;
    private _settingValue = _x select 1;
    private _defaultValue = _x select 2;
    if (_settingValue isNotEqualTo _defaultValue) then {
        _outputArray pushBack format ["%1 has been set to %2!",_settingName,_settingValue];
    };
} forEach [
	//CHVD CH View
	["CHVD_allowNoGrass",CHVD_allowNoGrass,true],
	["CHVD_maxView",CHVD_maxView,10000],
	["CHVD_maxObj",CHVD_maxObj,10000],
	//bft
    ["PROF_bftEnabled",PROF_bftEnabled,true],
	["PROF_bftOnlyShowOwnGroup",PROF_bftOnlyShowOwnGroup,false],
	//group icons
    ["PROF_3dGroupIcons",PROF_3dGroupIcons,true],
    ["PROF_3dGroupIconsTime",PROF_3dGroupIconsTime,0],
    ["PROF_3dGroupIconsRange",PROF_3dGroupIconsRange,150],
	//resupply
    ["PROF_resupplyObjectEnabled",PROF_resupplyObjectEnabled,true],
	//briefing
	["PROF_textBriefing",PROF_textBriefing,false],
	//arsenal curate
	["PROF_arsenalCurate",PROF_arsenalCurate,true],
	//custom object mapper
	["PROF_markCustomObjectsMap",PROF_markCustomObjectsMap,false],
	//buddy blood drawing
	["PROF_allowBloodDrawing",PROF_allowBloodDrawing,true],
	//punish civ killers
	["PROF_punishCivKillsThreshold",PROF_punishCivKillsThreshold,2],
	["PROF_punishCivKillTimeout",PROF_punishCivKillTimeout,60],
	["PROF_punishCivKillsSpectator",PROF_punishCivKillsSpectator,true],
	["PROF_punishCivKillerTpToLeader",PROF_punishCivKillerTpToLeader,true],
	["PROF_punishCivKillerHumiliate",PROF_punishCivKillerHumiliate,true],
	//Scav Basic
	["PROF_scavSystemEnabled",PROF_scavSystemEnabled,false],
	["PROF_scavInsertActionObject",PROF_scavInsertActionObject,"scavActionObject"],
	["PROF_scavSafeZoneTpHelper",PROF_scavSafeZoneTpHelper,"scavTpHelper"],
	["PROF_scavAoMarker",PROF_scavAoMarker,"PROF_ScavZone_Marker"],
	["PROF_scavBlacklistLocations",PROF_scavBlacklistLocations,["PROF_ObjectiveBlacklistObject_1","PROF_ObjectiveBlacklistObject_2","PROF_ObjectiveBlacklistObject_3","PROF_ObjectiveBlacklistObject_4","PROF_ObjectiveBlacklistObject_5","PROF_ObjectiveBlacklistObject_6","PROF_ObjectiveBlacklistObject_7","PROF_ObjectiveBlacklistObject_8","PROF_ObjectiveBlacklistObject_9","PROF_ObjectiveBlacklistObject_10","PROF_ObjectiveBlacklistObject_11","PROF_ObjectiveBlacklistObject_12","PROF_ObjectiveBlacklistObject_13","PROF_ObjectiveBlacklistObject_14","PROF_ObjectiveBlacklistObject_15"]],
	["PROF_scavExtractObjects",PROF_scavExtractObjects,["PROF_extract_1","PROF_extract_2","PROF_extract_3","PROF_extract_4","PROF_extract_5","PROF_extract_6","PROF_extract_7","PROF_extract_8","PROF_extract_9","PROF_extract_10","PROF_extract_11","PROF_extract_12","PROF_extract_13","PROF_extract_14","PROF_extract_15"]],
	["PROF_scavPmcMarkers",PROF_scavPmcMarkers,[]],
	//Scav Advanced
	["PROF_scavNumberOfObjectives",PROF_scavNumberOfObjectives,10],
	["PROF_scavSkill",PROF_scavSkill,[["general",0.8],["courage",0.8],["aimingAccuracy",0.25],["aimingShake",0.25],["aimingSpeed",0.25],["commanding",0.8],["spotDistance",0.25],["spotTime",0.25],["reloadSpeed",0.3]]],
	["PROF_scavRadioFreq",PROF_scavRadioFreq,"44"],
	["PROF_scavValuableClassname",PROF_scavValuableClassname,"PROF_RationPizza"],
	["PROF_scavRewardPerItem",PROF_scavRewardPerItem,100],
	["PROF_scavStartingValuables",PROF_scavStartingValuables,10],
	["PROF_scavNeededValuables",PROF_scavNeededValuables,3],
	["PROF_scavSleepInterval",PROF_scavSleepInterval,120],
	["PROF_scavPlayerDistanceThreshold",PROF_scavPlayerDistanceThreshold,400],
	["PROF_scavObjectiveDistanceThreshold",PROF_scavObjectiveDistanceThreshold,200],
	["PROF_scavPlayerSide",PROF_scavPlayerSide,west],
	["PROF_scavAiSide",PROF_scavAiSide,independent],
	["PROF_scavAiRoamerSide",PROF_scavAiRoamerSide,east],
	["PROF_scavRoamersSmall",PROF_scavRoamersSmall,7],
	["PROF_scavRoamersBig",PROF_scavRoamersBig,7],
	["PROF_scavRoamersSmallPatrolChance",PROF_scavRoamersSmallPatrolChance,100],
	["PROF_scavRoamersBigPatrolChance",PROF_scavRoamersBigPatrolChance,0],
	["PROF_scavRoamersObjectiveDistance",PROF_scavRoamersObjectiveDistance,200],
	["PROF_scavRoamersPlayerDistance",PROF_scavRoamersPlayerDistance,400],
	["PROF_scavRespawnRoamers",PROF_scavRespawnRoamers,true],
	["PROF_scavRespawnObjectives",PROF_scavRespawnObjectives,true],
	//Spotting system/marking units
	["PROF_addUnitMarkAction",PROF_addUnitMarkAction,false],
	["PROF_markTargetOnMap",PROF_markTargetOnMap,true],
	["PROF_markTarget3d",PROF_markTarget3d,true],
	//////////////////////////////////
	/////////Inventory Options////////
	//////////////////////////////////
	//radio assignment
	["PROF_radiosEnabled",PROF_radiosEnabled,true],
	["PROF_NoSquadleadLr",PROF_NoSquadleadLr,true],
	["PROF_radioAdditionals",PROF_radioAdditionals,false],
	["PROF_radioPersonal",PROF_radioPersonal,"TFAR_anprc152"],
	["PROF_radioBackpack",PROF_radioBackpack,"TFAR_anprc155_coyote"],
	//config loadouts
	["PROF_useConfigLoadout",PROF_useConfigLoadout,false],
	["PROF_configLoadoutCustom",PROF_configLoadoutCustom,false],
	["PROF_configFaction",PROF_configFaction,"BLU_F"],
	["PROF_configUnitPrefix",PROF_configUnitPrefix,""],
	["PROF_defaultConfigUnit",PROF_defaultConfigUnit,"Rifleman"],
	["PROF_configLoadoutNumber",PROF_configLoadoutNumber,0],
	//populate inventory
	["PROF_populateInventory",PROF_populateInventory,true],
	["PROF_inventoryAddGps",PROF_inventoryAddGps,true],
	//role based arsenals
	["PROF_roleBasedArsenals",PROF_roleBasedArsenals,false],
	["PROF_visibleArsenalBoxes",PROF_visibleArsenalBoxes,["arsenal_1","arsenal_2"]],
	//////////////////////////////////
	/////////Respawns Options/////////
	//////////////////////////////////
	//respawn gear
	["PROF_respawnDeathGear",PROF_respawnDeathGear,false],
	["PROF_respawnArsenalGear",PROF_respawnArsenalGear,true],
	//respawn spectator
	["PROF_respawnSpectator",PROF_respawnSpectator,false],
	["PROF_respawnSpectatorForceInterface",PROF_respawnSpectatorForceInterface,false],
	["PROF_respawnSpectatorHideBody",PROF_respawnSpectatorHideBody,true],
	["PROF_respawnSpectatorTime",PROF_respawnSpectatorTime,30],
	//wave respawns
	["PROF_waveRespawn",PROF_waveRespawn,false],
	["PROF_waveTime",PROF_waveTime,300],
	//respawn in vehicle
	["PROF_respawnInVehicle",PROF_respawnInVehicle,false],
	//flagpole respawn
	["PROF_flagpoleRespawn",PROF_flagpoleRespawn,false],
	//fob system main
	["PROF_fobEnabled",PROF_fobEnabled,false],
	["PROF_fobPackup",PROF_fobPackup,false],
	["PROF_fobFullArsenals",PROF_fobFullArsenals,false],
	["PROF_fobDistance",300],
	["PROF_fobRespawn",PROF_fobRespawn,false],
	//fob overrun
	["PROF_fobOverrun",PROF_fobOverrun,false],
	["PROF_fobOverrunDestroy",PROF_fobOverrunDestroy,true],
	["PROF_fobOVerrunFactor",PROF_fobOVerrunFactor,2],
	["PROF_fobOverrunMinEnemy",PROF_fobOverrunMinEnemy,8],
	["PROF_fobOverrunTimer",PROF_fobOverrunTimer,300],
	["PROF_fobOverrunInterval",PROF_fobOverrunInterval,30],
	//rallypoints main
	["PROF_rallypointsEnabled",PROF_rallypointsEnabled,false],
	["PROF_useSmallRally",PROF_useSmallRally,true],
	["PROF_rallyDistance",PROF_rallyDistance,150],
	["PROF_rallyOutnumber",PROF_rallyOutnumber,true],
	//rallypoint overrun
	["PROF_rallypointOverrun",PROF_rallypointOverrun,false],
	["PROF_rallyOutnumberFactor",PROF_rallyOutnumberFactor,2],
	["PROF_rallyOverrunMinEnemy",PROF_rallyOverrunMinEnemy,4],
	["PROF_rallyOverrunTimer",PROF_rallyOverrunTimer,90],
	["PROF_rallyOverrunInterval",PROF_rallyOverrunInterval,15],
	//////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////Advanced Options///////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////
	////Scripts/Functions Options/////
	//////////////////////////////////
	["PROF_aceHealObjectEnabled",PROF_aceHealObjectEnabled,true],
	["PROF_aceSpectateObjectEnabled",PROF_aceSpectateObjectEnabled,true],
	//////////////////////////////////
	//////////Misc Options////////////
	//////////////////////////////////
	//boss options
	["PROF_bossEnabled",PROF_bossEnabled,true],
	["PROF_bossImagePath",PROF_bossImagePath,"media/logo256x256.paa"],
	//["PROF_bossParts",PROF_bossParts,[[leg1,"LeftLeg",10],[leg2,"RightLeg",10],[torso,"Torso",30],[head,"Head",20]]], //not checked due to 'leg1' and etc being ANY if not defined and thus not matching
	["PROF_bossInterval",PROF_bossInterval,0.5],
	["PROF_bossHealthModifier",PROF_bossHealthModifier,1],
	//VASS options
	["PROF_vassEnabled",PROF_vassEnabled,false],
	["PROF_vassShopSystemVariable",PROF_vassShopSystemVariable,"PROF_exampleVassMoney"],
	["PROF_vassShopSystemLoadoutVariable",PROF_vassShopSystemLoadoutVariable,"PROF_exampleVassLoadout"],
	["PROF_vassDefaultBalance",PROF_vassDefaultBalance,700],
	["PROF_vassBonusStartingMoney",PROF_vassBonusStartingMoney,0],
	["PROF_vassPrebriefing",PROF_vassPrebriefing,["In this campaign, we have to buy our gear from the black market.","Each player's balance and loadout at mission end will carry over to the next mission.","All free items (cosmetics) are in the red crate's ace arsenal, everything else is in the other box.","Save your loadout at the sign to be able to rebuy it in the future for a small cost."]],
	["PROF_vassShops",PROF_vassShops,["arsenal_1","arsenal_2"]],
	["PROF_vassSigns",PROF_vassSigns,["AceHealObject"]],
	["PROF_rebuyCostPrimary",PROF_rebuyCostPrimary,35],
	["PROF_rebuyCostSecondary",PROF_rebuyCostSecondary,50],
	["PROF_rebuyCostHandgun",PROF_rebuyCostHandgun,15],
	//other assorted stuff 
	["PROF_vanillaStaminaDisabled",PROF_vanillaStaminaDisabled,true],
	["PROF_doAimCoefChange",PROF_doAimCoefChange,false],
	["PROF_aimCoef",PROF_aimCoef,0.5],
	["PROF_recoilCoef",PROF_recoilCoef,0.75],
	["PROF_ctabEnabled",PROF_ctabEnabled,false],
	//////////////////////////////////
	////////Template Options//////////
	//////////////////////////////////
	//skip version and briefing
	["PROF_cleanBriefing",PROF_cleanBriefing,true],
	//////////////////////////////////
	////////Scripts Options///////////
	//////////////////////////////////
	["PROF_spawnUnitsOnHC",PROF_spawnUnitsOnHC,false],
	["PROF_globalTfarEnabled",PROF_globalTfarEnabled,true],
	["PROF_dynamicGroupsEnabled",PROF_dynamicGroupsEnabled,true],
	["PROF_fpsDisplayEnabled",PROF_fpsDisplayEnabled,true],
	["PROF_fixDeathColor",PROF_fixDeathColor,true],
	["PROF_trimGroupNames",PROF_trimGroupNames,true],
	//////////////////////////////////
	///////Logistics Options//////////
	//////////////////////////////////
	//["PROF_kpCratefiller",PROF_kpCratefiller,true],
	//////////////////////////////////
	//////////Zeus Options////////////
	//////////////////////////////////
	["PROF_zeusResupply",PROF_zeusResupply,true],
	["PROF_zeusInfoText",PROF_zeusInfoText,true],
	["PROF_zeusHcTransfer",PROF_zeusHcTransfer,true],
	["PROF_zeusActionDebug",PROF_zeusActionDebug,true],
	["PROF_zeusSpectateManager",PROF_zeusSpectateManager,true],
	["PROF_zeusGroupDeletion",PROF_zeusGroupDeletion,true],
	["PROF_zeusFollowMarker",PROF_zeusFollowMarker,true],
	["PROF_zeusServiceVehicle",PROF_zeusServiceVehicle,true],
	//////////////////////////////////
	//Client Hotkeys/Actions Options//
	//////////////////////////////////
	["PROF_aceWindowBreak",PROF_aceWindowBreak,false],
	["PROF_afkEnabled",PROF_afkEnabled,true],
	["PROF_earplugsEnabled",PROF_earplugsEnabled,true],
	["PROF_earplugVolume",PROF_earplugVolume,0.25],
	["PROF_musicKeyEnabled",PROF_musicKeyEnabled,true],
	//////////////////////////////////
	//////////Admin Options///////////
	//////////////////////////////////
	["PROF_ModLog",PROF_ModLog,true],
	["PROF_ModLogShame",PROF_ModLogShame,true],
	["PROF_trackPeformance",PROF_trackPeformance,true],
	["PROF_doDiscordUpdate",PROF_doDiscordUpdate,true],
	["PROF_discordUpdateDelay",PROF_discordUpdateDelay,30]
]; //2D array of ALL config parameters and their default values



/////////////////////////////
//////////output/////////////
/////////////////////////////
private _br = toString [13,10];//(carriage return & line feed)
//_string = "Line 1" + _br + "Line 2";
//copyToClipboard _string;
private _finalOutput = "";
{
 _finalOutput = _finalOutput + _x + _br;
} forEach _outputArray;
copyToClipboard _finalOutput;
diag_log _finalOutput;
hint "Results of automated reviewer copied to clipboard!";
systemChat "Results of automated reviewer copied to clipboard!";

/* example results for template
Mission name: PROF_missiontemplate_8mansquads, Map: vr, Mission Template Version: 10.1
Mission time: 13:37. Time acceleration: 1
Total number of groups: 35, wherein 0 will be automatically deleted when empty.
Total number of units: 13, wherein 0 are dead on mission start and 0 are agents.
    Unit breakdown per side: West - 1, East - 1, Independent - 0, Civilian - 12.
Total number of objects: 43, wherein 5 have their simulation disabled. There are also an additional 7 simple objects.
Total number of playable units: 153 (not counting logic entities like headless clients or spectators).
    Player slots breakdown per side: West - 50, East - 50, Independent - 50, Civilian - 3.
Total number of map markers: 15.
Total number of mines: 0.
Total number of zeus logics: 5.
Total number of headless clients: 0.
Total number of respawns: 4. Vanilla respawn delay: 
    Respawn breakdown per side: West - 1, East - 1, Independent - 1, Civilian - 1.
Dynamic simulation enabled. Unit simulation range: 700, vehicle simulation range: 700, empty vehicle simulation range: 700, object simulation range: 50, moving multiplier: 1

*/