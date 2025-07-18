//basically just a space saver for assigning respawn vic through init field or through zeus function
//see fn_assignRespawnVic.sqf for zeus version
//should probably be only called from server but should work if called locally as long as it's not executed globally
//[this,"Respawn Vehicle 1"] spawn PROF_fnc_assignRespawnVicInit;	//and/or an ifServer check and/or a remoteExec on server

params ["_vehicle","_name"];

//waitUntil {!isNil "PROF_respawnInVehicle"}; //shouldnt be needed now that we have preinit for config.sqf
if !(PROF_respawnInVehicle) exitWith {};

waitUntil {!isNil "PROF_respawnLocations"};

private _oldVarName = vehicleVarName _vehicle;
if (_oldVarName == "") then { //if vic doesn't have a var name, then give it one
	_vehicle setVehicleVarName format ["PROF_zeusRespawnVehicle%1",count PROF_respawnLocations]; //TODO make better
	//systemChat format ["3: %1",_unit];
} else {
	//check if vehicleVarName is vehicle_# because thats the default
	if ("vehicle_" in _oldVarName) then {
		_vehicle setVehicleVarName format ["PROF_zeusRespawnVehicle%1",count PROF_respawnLocations]; //TODO make better
		_vehicle setVariable ["PROF_respawnVehicleOldVarName",_oldVarName]; //store in a var in case we were wrong and var name is needed
	};
};
private _vehicleName = vehicleVarName _vehicle;
//systemChat format ["4: %1",_name];
missionNamespace setVariable [_name, _vehicle];
publicVariable _vehicleName;

PROF_respawnLocations pushBack [_vehicle,_name];
[_vehicle,"hd_flag","ColorUNKNOWN",_name,true,5] remoteExec ["PROF_fnc_markerFollow",2];
publicVariable "PROF_respawnLocations";
_vehicle addMPEventHandler ["MPKilled", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	private _path = [PROF_respawnLocations, _unit] call BIS_fnc_findNestedElement;
	if (_path isNotEqualTo []) then {
		diag_log "PROF-MISSION-TEMPLATE fn_assignRespawnVic removing respawn vic from list!";
		private _indexOfOldVehiclePair = _path select 0;
		PROF_respawnLocations deleteAt _indexOfOldVehiclePair;
		publicVariable "PROF_respawnLocations";
	} else {
		diag_log "PROF-MISSION-TEMPLATE fn_assignRespawnVic cannot find vehicle to remove!";
	};
}];