//this is basically useless but it makes user-interface more friendly so zeuses dont need to copy paste of all this
//[object,"Flagpole 1"] remoteExec ["PROF_fnc_assignRespawnFlagpoleInit",2];
params ["_object","_name"];
if !(isServer) exitWith {systemChat "PROF-MISSION-TEMPLATE ERROR: fn_assignRespawnFlagpoleInit called on client instead of on server! Contact Admin!"};

if (isNil "PROF_respawnLocations") then { //mightve already been set up elsewhere
	PROF_respawnLocations = [];
	publicVariable "PROF_respawnLocations";
};
if !(PROF_flagpoleRespawn) then {
	PROF_flagpoleRespawn = true;
	publicVariable "PROF_flagpoleRespawn";
};

if (vehicleVarName _object == "") then { //if vic doesn't have a var name, then give it one
	_object setVehicleVarName format ["PROF_zeusRespawnFlagpole%1",count PROF_respawnLocations]; //TODO make better
	//systemChat format ["3: %1",_object];
};
private _objectName = vehicleVarName _object;
//systemChat format ["4: %1",_objectName];
missionNamespace setVariable [_objectName, _object];
publicVariable _objectName;

PROF_respawnLocations pushBack [_object,_name];