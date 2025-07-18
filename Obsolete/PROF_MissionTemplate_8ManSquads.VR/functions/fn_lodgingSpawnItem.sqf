// Spawns a lodging object after its bought, sets it up, and makes the player carry it
// Execute locally to player who should own the item

params ["_itemClassname",["_position",getPos player],["_debug",true]];

if (_debug) then { [format ["PROF_lodgingSpawnItem: Spawning item %1 at position %2",_itemClassname,_position]] call PROF_fnc_error; };

private _obj = createVehicle ['_itemClassname', _position, [], 0, 'CAN_COLLIDE']; 
[_obj, true, [0, 2, 0], 0, true] call ace_dragging_fnc_setCarryable;
[ace_player,_obj] call ace_dragging_fnc_carryObject;
_obj setVariable [format ["PROF_lodgingObject%1",name player],true];

private _oldItems = player getVariable ["PROF_lodgingSpawnedItems",[]];
player setVariable ["PROF_lodgingSpawnedItems",_oldItems pushBack _obj];

if (_debug) then { [format ["PROF_lodgingSpawnItem: Spawned item %1 and updated PROF_lodgingSpawnedItems with new value of %2!",_obj,_oldItems pushBack _obj]] call PROF_fnc_error; };

_obj