if !(isServer) exitWith { diag_log text "PROF-MISSION-TEMPLATE WARNING: PROF_fnc_autoDisableGroupIcons called from locality other than server!"};

//two modes: time based or range based
private ["_isTimeBased","_isRangeBased"];
private _timeBetweenChecks = 20;

if (PROF_3dGroupIconsTime != 0) then {
	_isTimeBased = true;
} else {	//0 to disable
	_isTimeBased = false;
};

if (PROF_3dGroupIconsRange != 0) then {
	_isRangeBased = true;
} else {	//0 to disable
	_isRangeBased = false;
};


switch (true) do {
	case ( _isTimeBased && _isRangeBased): {
		systemChat "PROF_fnc_autoDisableGroupIcons called but both time and range based endings are enabled!";
		diag_log text "PROF-MISSION-TEMPLATE WARNING: PROF_fnc_autoDisableGroupIcons called but both time and range based endings are enabled!";
	};
	case _isTimeBased: {
		private _sleepTime = PROF_3dGroupIconsTime + serverTime;
		waitUntil {
			sleep _timeBetweenChecks; serverTime >= _sleepTime
		};
		PROF_3dGroupIcons = false;
		publicVariable "PROF_3dGroupIcons";
	};
	case _isRangeBased: { //requires aceHealObject
		if (isNil "AceHealObject") exitWith {
			systemChat "PROF_fnc_autoDisableGroupIcons called and range-based checking is enabled but AceHalObject is not present in the mission!";
			diag_log text "PROF-MISSION-TEMPLATE WARNING: PROF_fnc_autoDisableGroupIcons called and range-based checking is enabled but AceHalObject is not present in the mission";
		};
		private _range = PROF_3dGroupIconsRange;
		waitUntil {
			sleep _timeBetweenChecks;
			//private _headlessClients = entities "HeadlessClient_F";
			//private _numberOfAllPlayers = count (allPlayers - _headlessClients);
			private _numberPlayersFarAway = count (allPlayers select { _x distance2D AceHealObject > PROF_3dGroupIconsRange });
			private _numberPlayersClose = count (allPlayers select { _x distance2D AceHealObject < PROF_3dGroupIconsRange });
			if (_numberPlayersFarAway > _numberPlayersClose) exitWith { true };
			false
		};
		PROF_3dGroupIcons = false;
		publicVariable "PROF_3dGroupIcons";
	};
	default {
		systemChat "PROF_fnc_autoDisableGroupIcons called but mission is not configured to automatically end group icons!";
		diag_log text "PROF-MISSION-TEMPLATE WARNING: PROF_fnc_autoDisableGroupIcons called but mission is not configured to automatically end group icons!";
	};
};