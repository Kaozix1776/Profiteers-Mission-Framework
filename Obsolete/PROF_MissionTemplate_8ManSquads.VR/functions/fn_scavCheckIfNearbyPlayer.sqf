params ["_positionToCheck",["_distanceThreshold",PROF_scavPlayerDistanceThreshold]];

if (count (allPlayers select { (_x distance2D _positionToCheck) < _distanceThreshold}) > 0) then {
	true
} else {
	false
};