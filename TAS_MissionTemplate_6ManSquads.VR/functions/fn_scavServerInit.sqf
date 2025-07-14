sleep 1;

private _debug = false;
private _markers = [];

/////////////////////////
/////// EXTRACTS ////////
/////////////////////////
private _extracts = [];
{
	private _object = _x;
	_object = missionNamespace getVariable [_object, objNull]; //convert from string to object, otherwise we get errors
	
	if (!isNull _object) then {
		_marker = createMarkerLocal [format ["%1_Marker",_x],getPos _object];
		_marker setMarkerColorLocal "ColorGreen";
		_marker setMarkerTextLocal "Extraction Point";
		_marker SetMarkerTypeLocal "mil_start";
		_marker setMarkerAlpha 0; //broadcast
		_markers pushback _marker;

		_extracts pushBack _object;
	} else {
		//["fn_scavServerInit: missing at least one extraction point!",true] call PROF_fnc_error;
	};
} forEach PROF_scavExtractObjects;

private _blacklistObjects = [];
{
	private _object = _x;
	_object = missionNamespace getVariable [_object, objNull]; //convert from string to object, otherwise we get errors
	
	if (!isNull _object) then {
		

		_blacklistObjects pushBack _object;
	} else {
		//["fn_scavServerInit: missing at least one extraction point!",true] call PROF_fnc_error;
	};
} forEach PROF_scavBlacklistLocations;

/////////////////////////
///// OBJECTIVES ////////
/////////////////////////
//spawn objectives and make markers
//private _scavZone = triggerArea PROF_scavAoMarker;
private _centerZone = getMarkerPos PROF_scavAoMarker;
private _zoneSize = getMarkerSize PROF_scavAoMarker;
private _buildings = _centerZone nearObjects ["Building",_zoneSize select 0];
private _enterableBuildings = _buildings select {count ([_x] call BIS_fnc_buildingPositions) > 6};
private _objectivesToMake = PROF_scavNumberOfObjectives;
private _scavObjectives = [];
private _blacklistLocations = _blacklistObjects + _extracts;
private _attemptsRemaining = _objectivesToMake * 10;
private _guardSide = PROF_scavAiSide;
private ["_guardClass"];
switch (_guardSide) do //need to spawn classnames from the corressponding side
{
	case west: { _guardClass = "B_Survivor_F" };
	case independent: { _guardClass = "I_Survivor_F" };
	case east: { _guardClass = "O_Survivor_F" };
	case civilian: { _guardClass = "C_man_1" }; //todo find classname of looters
	default { _guardClass = "I_Survivor_F" };
};

if (_debug) then {
	[format ["fn_scavServerInit enterable buildings: %1",_enterableBuildings],true] call PROF_fnc_error;
};

/*
{
	private _markerNum = missionNamespace getVariable ["PROF_debug_markerNum",0];
	_markerNum = _markerNum + 1;
	missionNamespace setVariable ["PROF_debug_markerNum",_markerNum];
	private _marker = createMarker [format ["PROF_debug_Marker%1",_markerNum], getPos _x];
	_marker setMarkerType "mil_dot";
	_marker setMarkerColor "ColorBlack";
} forEach _buildings;
{
	private _markerNum = missionNamespace getVariable ["PROF_debug_markerNum",0];
	_markerNum = _markerNum + 1;
	missionNamespace setVariable ["PROF_debug_markerNum",_markerNum];
	private _marker = createMarker [format ["PROF_debug_Marker%1",_markerNum], getPos _x];
	_marker setMarkerType "mil_dot";
	_marker setMarkerColor "ColorPink";
} forEach _enterableBuildings;
*/

//need to do this early because spawnRoamers and PROF_fnc_scavFindSuitableBuilding depends on it
missionNamespace setVariable ["PROF_scavBuildingsInAO",_buildings,false]; //dont broadcast, lots of info
missionNamespace setVariable ["PROF_scavEnterableBuildingsInAO",_enterableBuildings,false]; //dont broadcast, lots of info
missionNamespace setVariable ["PROF_scavObjectives",_scavObjectives,true];
missionNamespace setVariable ["PROF_scavPROFkMarkers",_markers,true];
missionNamespace setVariable ["PROF_scavExtracts",_extracts,true];
missionNamespace setVariable ["PROF_scavAllBlacklists",_blacklistLocations];

while {_objectivesToMake > 0} do { //dont get caught in a forever loop

	private _potentialObjective = [] call PROF_fnc_scavFindSuitableBuilding;

	private _objectiveBox = createVehicle ["VirtualReammoBox_camonet_F",(_potentialObjective buildingPos 0),[],0,"CAN_COLLIDE"]; //empty cache
	_objectiveBox addItemCargoGlobal [PROF_scavValuableClassname, PROF_scavStartingValuables];
	_objectiveBox allowDamage false;

	private _objectiveGroupGuard = createGroup _guardSide;
	private _objectiveGroupCamp = createGroup _guardSide;
	private _objectiveGroupPatrol = createGroup _guardSide;
	private _groups = [_objectiveGroupGuard,_objectiveGroupCamp,_objectiveGroupPatrol];
	private _campLocation = [_objectiveBox, 5, 30, 3, 0, 0, 0, [], [getPos _objectiveBox, getPos _objectiveBox]] call BIS_fnc_findSafePos;
	for "_i" from 1 to 4 do {
		private _unit = _objectiveGroupGuard createUnit [_guardClass, getPos _objectiveBox,[],0,"NONE"];
		_unit allowDamage false;
		[_unit] call PROF_fnc_scavLoadout;
	};
	for "_i" from 1 to 3 do {
		private _unit = _objectiveGroupCamp createUnit [_guardClass, _campLocation,[],0,"NONE"];
		_unit allowDamage false;
		[_unit] call PROF_fnc_scavLoadout;
	};
	for "_i" from 1 to 3 do {
		private _unit = _objectiveGroupPatrol createUnit [_guardClass, _campLocation,[],0,"NONE"];
		_unit allowDamage false;
		[_unit] call PROF_fnc_scavLoadout;
	};
	[_objectiveGroupGuard, _objectiveBox, 10,[],true,false,2,false] call lambs_wp_fnc_PROFkGarrison;
	[_objectiveGroupCamp, _campLocation, 5, [], true, false] call lambs_wp_fnc_PROFkCamp;
	[_objectiveGroupPatrol, _objectiveBox, 50] call lambs_wp_fnc_PROFkPatrol;
	[_groups] spawn { //heal units in case lambs teleport hurts them
		params ["_groups"];
		sleep 5;
		{
			private _group = _x;
			{
				_x allowDamage true;
				[objNull, _x] call ace_medical_treatment_fnc_fullHeal;
			} forEach (units _group);
			_x enableDynamicSimulation true; //wait to enable so that they can fall into place

			private _groupID = groupID _x;
			_x setGroupIdGlobal [format ["%1 [Cache Guard]",_groupID]];
		} forEach _groups;
	};

	_marker = createMarkerLocal [format ["ScavObj_%1_Marker",_objectivesToMake],_objectiveBox];
	_marker setMarkerColorLocal "ColorPink";
	_marker setMarkerTextLocal "Cache Location";
	_marker SetMarkerTypeLocal "mil_destroy";
	_marker setMarkerAlpha 0; //broadcast
	_markers pushback _marker;
	
	_scavObjectives pushBack [_objectiveBox,_groups,_marker];
	_blacklistLocations pushBack _objectiveBox;
	//update vars before next run due to PROF_fnc_scavFindSuitableBuilding needing them
	missionNamespace setVariable ["PROF_scavObjectives",_scavObjectives,true];
	missionNamespace setVariable ["PROF_scavAllBlacklists",_blacklistLocations];

	_objectivesToMake = _objectivesToMake - 1;
	
};

if (_debug) then {
	[format ["fn_scavServerInit found objectives: %1",_scavObjectives],true] call PROF_fnc_error;
};

//need to do this early because spawnRoamers depends on it
missionNamespace setVariable ["PROF_scavBuildingsInAO",_buildings,false]; //dont broadcast, lots of info
missionNamespace setVariable ["PROF_scavEnterableBuildingsInAO",_enterableBuildings,false]; //dont broadcast, lots of info
missionNamespace setVariable ["PROF_scavObjectives",_scavObjectives,true];
missionNamespace setVariable ["PROF_scavPROFkMarkers",_markers,true];
missionNamespace setVariable ["PROF_scavExtracts",_extracts,true];
missionNamespace setVariable ["PROF_scavAllBlacklists",_blacklistLocations];



/////////////////////////
/////// ROAMERS /////////
/////////////////////////
private _numberRoamersSmall = PROF_scavRoamersSmall;
private _numberRoamersBig = PROF_scavRoamersBig;

private _roamerGroupsSmall = [];
private _roamerGroupsBig = [];

while {_numberRoamersSmall > 0} do {
	private _group = [true] call PROF_fnc_scavSpawnRoamers; //can be "dummy" if doesnt find an acceptable spawnpoint
	if (_group isNotEqualTo "dummy") then {
		_roamerGroupsSmall pushBack _group;
		_numberRoamersSmall = _numberRoamersSmall - 1;
	};
};
while {_numberRoamersBig > 0} do {
	private _group = [false] call PROF_fnc_scavSpawnRoamers; //can be null if doesnt find an acceptable spawnpoint
	if (_group isNotEqualTo "dummy") then {
		_roamerGroupsBig pushBack _group;
		_numberRoamersBig = _numberRoamersBig - 1;
	};
};

/////////////////////////
/////// CLEANUP /////////
/////////////////////////
missionNamespace setVariable ["PROF_scavRoamerGroupsSmall",_roamerGroupsSmall,true];
missionNamespace setVariable ["PROF_scavRoamerGroupsBig",_roamerGroupsBig,true];

if (PROF_scavRespawnRoamers) then {
	[] spawn PROF_fnc_scavRespawnRoamers;
};
if (PROF_scavRespawnObjectives) then {
	[] spawn PROF_fnc_scavRespawnObjectives;
};