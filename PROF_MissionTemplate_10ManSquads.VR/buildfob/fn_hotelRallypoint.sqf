//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//15 instances of first letter uppercase

//if (rallyHotelUsed == nil) then {rallyHotelUsed = false; publicVariable "rallyHotelUsed";}; //if variable is nonexistant, create it (first time setup)

//_nearEntities = player nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = player countEnemy _nearEntities;
private _friendlySide 			= side group player;
private _enemySides 			= [_friendlySide] call BIS_fnc_enemySides;
private _radius 				= PROF_rallyDistance; //parameter from initServer.sqf, default 150
private _nearUnits = allUnits select { _x distance player < _radius };
private _nearEnemies = _nearUnits select {alive _x && { side _x in _enemySides && { !(_x getVariable ["ACE_isUnconscious",false]) } } };
private _nearEnemiesNumber = count _nearEnemies;
private _nearFriendlies = _nearUnits select {alive _x && { side _x == _friendlySide && { !(_x getVariable ["ACE_isUnconscious",false]) } } }; //limitation: does not account for multiple friendly sides
private _nearFriendliesNumber = count _nearFriendlies;
private _rallypointPosATL 		= getPosAtl player;

private _exit = false;
if (PROF_rallyOutnumber) then {
	if ( _nearEnemiesNumber > _nearFriendliesNumber) exitWith {_exit = true; systemChat format ["Rallypoint creation failure, enemies outnumber friendlies within %1m!",PROF_rallyDistance]};
} else {
	if ( _nearEnemiesNumber > 0 ) exitWith {_exit = true; systemChat format ["Rallypoint creation failure, enemies are within %1m!",PROF_rallyDistance]};
};
if (_exit) exitWith {};

if (PROF_rallyHotelUsed == false) then { "rallypointHotelMarker" setMarkerAlpha 1; };  //first time rally is created, set its marker to visible
if (PROF_rallyHotelUsed == true) then {
	{deleteVehicle _x} forEach PROF_rallypointHotel;
	//PROF_rallypointHotelRespawn call BIS_fnc_removeRespawnPosition;
	private _path = [PROF_respawnLocations, "Hotel Rallypoint"] call BIS_fnc_findNestedElement;
	private _indexOfOldRallyPair = _path select 0;
	PROF_respawnLocations deleteAt _indexOfOldRallyPair;
}; //if rallypoint already exists, delete it so the new one can be spawned

//PROF_rallypointHotelRespawn = [side player, getPos player, "Hotel Rallypoint"] call BIS_fnc_addRespawnPosition; //not private so we can delete later
PROF_respawnLocations pushBack [_rallypointPosATL,"Hotel Rallypoint"];
publicVariable "PROF_respawnLocations";
"rallypointHotelMarker" setMarkerPosLocal getPos player; //updates the rallypoint's position on map
private _color = "Default";
switch (_friendlySide) do {
	case west: { _color = "colorBLUFOR" };
	case east: { _color = "colorOPFOR" };
	case independent: { _color = "colorIndependent" };
	case civilian: { _color = "colorCivilian" };
	default { _color = "colorCivilian" };
};
"rallypointHotelMarker" setMarkerColorLocal _color;	//last marker command is public
"rallypointHotelMarker" setMarkerText format ["%1 Rallypoint",groupId group player];

if (PROF_useSmallRally == false) then {
	PROF_rallypointHotel = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper; //not private so we can delete later
} else {
	PROF_rallypointHotel = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer

[player, format ["%1 Rallypoint established by %2 at gridref %3.", groupId group player, name player, mapGridPosition player]] remoteExec ["sideChat", _friendlySide]; //tell everyone on same side about it

PROF_rallyHotelUsed = true; //tell game that the squad's rally is used and so it must be deleted before being respawned
publicVariable "PROF_rallyHotelUsed"; //might be unneccessary since only 1 person can be SL so don't need public, just exist on SL's machine
										//might also need PROF_rallypointHotelRespawn and PROF_rallypointHotel to be public for functionality in case SL disconnects and is replaced
											//for now, keep local to current SL machine since it's an edge case and would use up much bandwidth to publicVariable

//systemChat "0";

if (PROF_rallypointOverrun) then {
	[_friendlySide,_enemySides,_radius,_nearEnemies,_nearFriendlies,_nearEnemiesNumber,_nearFriendliesNumber,_rallypointPosATL] remoteExec ["PROF_fnc_HotelRallyOverrun",2]; //run overrun on server to avoid issues with FPS or client disconnect
};
