while {!(PROF_fobBuilt)} do { //fobBuilt can be set false here (when destroyed) or in fobPackup.sqf
	/*private _nearUnits = nearestObjects [PROF_fobPositionATL, ["Man"], PROF_fobOverrunDistance];	//wont find vehicles/infantry in vehicles!
	private _nearUnitsAlive = [];
	{ if (alive _x ) then { _nearUnitsAlive set [(count _nearUnitsAlive), _x]; }; } forEach _nearUnits;
	private _nearEnemies = 
	PROF_fobPositionATL*/

	//variable setup
		//dont care about performance or I will go insane
	private _friendlySide = PROF_fobSide;
	private _enemySides = [_friendlySide] call BIS_fnc_enemySides;
	private _fobLocation = PROF_fobPositionATL;
	private _radius = PROF_fobDistance; //parameter from initServer.sqf, default 300
	private _minimumEnemies = PROF_fobOverrunMinEnemy;
	private _nearUnits = allUnits select { _x distance _fobLocation < _radius };
	private _nearEnemies = _nearUnits select {alive _x && { side _x in _enemySides && { !(_x getVariable ["ACE_isUnconscious",false]) } } };
	private _nearEnemiesNumber = count _nearEnemies;
	private _nearFriendlies = _nearUnits select {alive _x && { side _x == _friendlySide && { !(_x getVariable ["ACE_isUnconscious",false]) } } }; //limitation: does not account for multiple friendly sides
	private _nearFriendliesNumber = count _nearFriendlies;

	//account for mission setting overrun factor
	private _nearFriendliesNumberWeighted = _nearFriendliesNumber * PROF_fobOverrunFactor;

	//check if overrun
	if ( ( _nearEnemiesNumber >= _minimumEnemies) && { _nearEnemiesNumber > _nearFriendliesNumberWeighted } ) then {
		//overrun
		private _overrunActive = true;
		private _timeRemaining = PROF_fobOverrunTimer;
		while { _overrunActive && { (_timeRemaining > 0) } } do {
			private _msg = format ["The Forward Operating Base at grid reference %1 is in danger of being overrun!\n\nNearby Friendlies: %2\nNearby Enemies: %3\n\nTime left until FOB is abandoned: %4", mapGridPosition PROF_fobPositionATL,_nearFriendliesNumber,_nearEnemiesNumber,[((_timeRemaining)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
			_msg remoteExec ["hint"];
			sleep PROF_fobOverrunInterval;
			_timeRemaining = _timeRemaining - PROF_fobOverrunInterval;

			//check if overrun is canceled
			_nearUnits = allUnits select { _x distance _fobLocation < _radius };
			_nearEnemies = _nearUnits select {alive _x && { side _x in _enemySides && { !(_x getVariable ["ACE_isUnconscious",false]) } } };
			_nearEnemiesNumber = count _nearEnemies;
			_nearFriendlies = _nearUnits select {alive _x && { side _x == _friendlySide && { !(_x getVariable ["ACE_isUnconscious",false]) } } }; //limitation: does not account for multiple friendly sides
			_nearFriendliesNumber = count _nearFriendlies;
			_nearFriendliesNumberWeighted = _nearFriendliesNumber * PROF_fobOverrunFactor;
			if !( ( _nearEnemiesNumber >= _minimumEnemies) && { _nearEnemiesNumber > _nearFriendliesNumberWeighted } ) then {
				_overrunActive = false;
			};
		};
		if (_overrunActive) then {
			private _msg = format ["The Forward Operating Base at grid reference %1 has been overrun!", mapGridPosition PROF_fobPositionATL];
			_msg remoteExec ["hint"];
			PROF_fobBuilt = false;
			publicVariable "PROF_fobBuilt";
			PROF_fobDestroyed = true;
			publicVariable "PROF_fobDestroyed";

			//DESTROY FOB
			//hide marker and reset to origin
			"fobMarker" setMarkerAlpha 0.5;
			"fobMarker" setMarkerColor "ColorGrey";
			//"fobMarker" setMarkerPos [0,0,0];

			//disable arsenals but keep normal inventories
			private _fobArsenals = nearestObjects [_fobLocation, ["B_CargoNet_01_ammo_F"], 25]; 
			if (PROF_fobFullArsenals) then { //full arsenals
				{
					[_x, true] call ace_arsenal_fnc_removeBox;
					//["AmmoboxInit",[_x,true]] call BIS_fnc_arsenal;
				} forEach _fobArsenals;
			};

			//clean up objects
			//{deleteVehicle _x} forEach PROF_fobObjects;
			if (PROF_fobOverrunDestroy) then {
				{_x setDamage 1 } forEach (PROF_fobObjects - _fobArsenals); //dont destroy ammo boxes
			};
			
			//remove respawn GUI stuff
			//PROF_rallypointEchoRespawn call BIS_fnc_removeRespawnPosition;
			if (PROF_fobRespawn) then {
				PROF_fobRespawn call BIS_fnc_removeRespawnPosition;
			};
			private _path = [PROF_respawnLocations, "Forward Operating Base"] call BIS_fnc_findNestedElement;
			private _indexOfOldRallyPair = _path select 0;
			PROF_respawnLocations deleteAt _indexOfOldRallyPair;
		} else {
			private _msg = format ["The Forward Operating Base at grid reference %1 is no longer in immediate danger of being overrrun!", mapGridPosition PROF_fobPositionATL];
			_msg remoteExec ["hint"];
		};
	};
	sleep PROF_fobOverrunInterval;	//check condition for overrun event every config'd interval
};




//hint parseText "<img image='f4.jpg' <img size='20' /> ";