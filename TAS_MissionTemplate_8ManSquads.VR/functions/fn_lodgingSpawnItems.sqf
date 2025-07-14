// Spawns a player's items from profileNamespace
params [["_position",getPos player],["_debug",true]];

if (_debug) then { [format ["PROF_lodgingSpawnItems: Spawning player's saved items from profileNamespace at position %1!",_position]] call PROF_fnc_error; };

private _items = profileNamespace getVariable ["PROF_lodging",[]];

private _spawnedItems = [_position, getDir player, _items, 0] call BIS_fnc_objectsMapper;

player setVariable ["PROF_lodgingSpawnedItems",_spawnedItems];

if (_debug) then { [format ["PROF_lodgingSpawnItems: Items spawned: %1",_spawnedItems]] call PROF_fnc_error; };