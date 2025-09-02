if !(isServer) exitWith {};

private _layersToSwawn = _this select 0; //provide as two dimensional array
private _delay = _this select 1;
private _clientToSpawnOn = _this select 2; //"2" (as number, not string) for server; "HC#" (as object, not string) to execute on HC

sleep _delay;

[_layersToSwawn,"spawnUnits.sqf"] remoteExec ["execVM",_clientToSpawnOn];

/*
this is completely fucking experimental, should work though
*/