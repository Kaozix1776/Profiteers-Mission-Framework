params [["_emitters",missionNamespace getVariable ["PROF_scavExtracts",[]]]];
private _debug = false;

if (_debug) then {[format ["PROF_fnc_scavHandleExtractSmokes starting with _emitters %1",_emitters]] call PROF_fnc_error};

while { player getVariable ["PROF_playerIsScav",false] } do {
	if (_debug) then {[format ["PROF_fnc_scavHandleExtractSmokes running loop!"]] call PROF_fnc_error};
	{
		private _smoke = "SmokeShellGreen" createVehicleLocal [0,0,0];
		_smoke attachTo [_x, [0, 0, 0]];
		if (_debug) then {[format ["PROF_fnc_scavHandleExtractSmokes adding smoke %1 to emitter %2!",_smoke,_x]] call PROF_fnc_error};
	} forEach _emitters;
	sleep 60;
};