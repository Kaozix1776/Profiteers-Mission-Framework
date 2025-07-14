//hide marker and reset to origin
"fobMarker" setMarkerAlphaLocal 0;
"fobMarker" setMarkerPosLocal [0,0,0];
"fobMarker" setMarkerPos [0,0,0];

//clean up objects 
{deleteVehicle _x} forEach PROF_fobObjects;

//remove respawn GUI stuff
//PROF_rallypointEchoRespawn call BIS_fnc_removeRespawnPosition;
if (PROF_fobRespawn) then {
	PROF_fobRespawn call BIS_fnc_removeRespawnPosition;
};
private _path = [PROF_respawnLocations, "Forward Operating Base"] call BIS_fnc_findNestedElement;
private _indexOfOldRallyPair = _path select 0;
PROF_respawnLocations deleteAt _indexOfOldRallyPair;

//apply new var
PROF_fobBuilt = false;
publicVariable "PROF_fobBuilt";