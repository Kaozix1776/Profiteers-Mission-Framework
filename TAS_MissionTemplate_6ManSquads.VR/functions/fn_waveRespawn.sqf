if !(isServer) exitWith {};

//setup
PROF_waveRemainingTime	= PROF_waveTime;
publicVariable "PROF_waveRemainingTime";
private _playersWaiting = [];

while {PROF_waveRespawn} do {

	//countdown, server side with broadcasting to clients every so often
	private _time = PROF_waveTime;
	diag_log format ["PROF MISSION TEMPLATE: WAVE RESPAWN beginning new cycle, %1 remaining",[((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
	while { _time > 0 } do {
		_time = _time - 1;  
		if (_time % 20 == 0) then { //debug message and timer broadcast every 20 seconds
			_playersWaiting = [];	//reset array
			{
				if (_x getVariable ["PROF_waitingForReinsert",false]) then {
					_playersWaiting pushBack _x;
				};
			} forEach allPlayers;
			PROF_waveRemainingTime = _time;
			publicVariable "PROF_waveRemainingTime";
			diag_log format ["PROF MISSION TEMPLATE: WAVE RESPAWN waiting, %1 remaining in cycle, %2 players waiting.",[((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring, count _playersWaiting];
		};
		sleep 1;
	};

	//do the reinsert
	_playersWaiting = [];	//reset array
	{
		if (_x getVariable ["PROF_waitingForReinsert",false]) then {
			_playersWaiting pushBack _x;
		};
	} forEach allPlayers;
	diag_log format ["PROF MISSION TEMPLATE: WAVE RESPAWN occuring, %1 players %2 being reinserted.", count _playersWaiting, _playersWaiting];
	/*{
		[false,false,false] call ace_spectator_fnc_setSpectator; 
		switch (PROF_waveReinsertType) do {
			case "base": 		{
				//nothing, they're already at the reinsert point
			};
			case "rallypoint": 	{
				"rallypoint" remoteExec ["PROF_fnc_respawnGui",_x];
			};
			case "vehicle":		{
				"vehicle" remoteExec ["PROF_fnc_respawnGui",_x];
			};
			case "custom":		{
				//add whatever code you want here. The current player iterated is referred to as "_x".



			};
			default 			{
				//nothing, same as "base"
				diag_log "PROF MISSION TEMPLATE: WAVE RESPAWN using default case for reinserts!";
			};
		};
		_x setVariable ["PROF_waitingForReinsert",false];
	} forEach _playersWaiting;*/
	_playersWaiting 		= [];	//reset array
	PROF_waveRemainingTime	= 0;
	publicVariable "PROF_waveRemainingTime";

	sleep 30;	//grace period for respawns

	//back to top
};