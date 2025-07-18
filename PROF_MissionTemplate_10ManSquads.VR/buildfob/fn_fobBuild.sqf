//builds a fob with arsenals and repair boxes
//if (isNil fobBuilt) then {fobBuilt = false; publicVariable "fobBuilt";}; ////if variable is nonexistant, create it (first time setup)
private _player = player; //dummy for now for future rewriting for enhanced MP compat
//_nearestUnits = nearestObjects [_player,["Man","Car","Tank"],300];//if enemies are within 150m, exit with fail message
//_enemySides = playerSide call BIS_fnc_enemySides;
//if ( { _x countSide _nearestUnits > 0 } forEach _enemySides ) exitWith {systemChat "FOB creation failure, enemies are within 300m!"};
//_nearEntities = _player nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = _player countEnemy _nearEntities;
private _playerSide = side group _player;
PROF_fobSide = _playerSide;
publicVariable "PROF_fobSide";
private _enemySides = [_playerSide] call BIS_fnc_enemySides;
private _radius = PROF_fobDistance; //parameter from initServer.sqf, default 300
private _nearEnemies = allUnits select {_x distance _player < _radius AND side _x in _enemySides};
private _nearEnemiesNumber = count _nearEnemies;

PROF_fobPositionATL = getPosAtl _player;
publicVariable "PROF_fobPositionATL";

if ( _nearEnemiesNumber > 0 ) exitWith {systemChat format ["FOB creation failure, enemies are within %1m!",PROF_fobDistance]};

//map marker and respawns
if (PROF_fobRespawn) then {
	PROF_fobRespawn = [_playerSide, PROF_fobPositionATL, "FOB Respawn"] call BIS_fnc_addRespawnPosition;
};
"fobMarker" setMarkerPosLocal getPos logistics_vehicle; //updates the fob's position on map
"fobMarker" setMarkerAlphaLocal 1;
private _color = "Default";
switch (PROF_fobSide) do {
	case west: { _color = "colorBLUFOR" };
	case east: { _color = "colorOPFOR" };
	case independent: { _color = "colorIndependent" };
	case civilian: { _color = "colorCivilian" };
	default { _color = "colorCivilian" };
};
"fobMarker" setMarkerColor _color;	//last marker command is public

//handle objects and arsenals
PROF_fobObjects = [getPos logistics_vehicle, getDir logistics_vehicle, call (compile (preprocessFileLineNumbers "buildfob\fobComposition.sqf"))] call BIS_fnc_ObjectsMapper; //spawn the fob composition, public in case we want to delete like we do rallypoints (currently not used)
private _fobArsenals = nearestObjects [position logistics_vehicle, ["B_CargoNet_01_ammo_F"], 25]; //select boxes for arsenals
if (PROF_fobFullArsenals) then { //full arsenals
	{
		[_x, true] call ace_arsenal_fnc_initBox;
		//["AmmoboxInit",[_x,true]] call BIS_fnc_arsenal;
	} forEach _fobArsenals;
} else { //limited dynamic resupply
	{
		private _box = _x;
		clearItemCargoGlobal _box; clearWeaponCargoGlobal _box; clearMagazineCargoGlobal _box;
		
		{
			// Current result is saved in variable _x
			_box addMagazineCargoGlobal [primaryWeaponMagazine _x select 0, 6]; 
		} forEach allPlayers;
		
		//add medical in priority order
		_box addItemCargoGlobal ["ACE_fieldDressing", 75];
		_box addItemCargoGlobal ["ACE_morphine", 40];
		_box addItemCargoGlobal ["ACE_epinephrine", 20];
		_box addItemCargoGlobal ["ACE_bloodIV_500", 20];
		_box addItemCargoGlobal ["ACE_bloodIV", 10]; //1000 ml
		_box addItemCargoGlobal ["ACE_tourniquet", 15];
		_box addItemCargoGlobal ["ACE_Earplugs", 10];
	} forEach _fobArsenals;
};

[[_playerSide, "HQ"], format ["Forward Operating Base established by %1 at gridref %2.", name _player, mapGridPosition logistics_vehicle]] remoteExec ["sideChat", _playerSide];

PROF_respawnLocations pushBack [PROF_fobPositionATL,"Forward Operating Base"];
PROF_fobBuilt = true;

publicVariable "PROF_respawnLocations";
publicVariable "PROF_fobBuilt";
publicVariable "PROF_fobRespawn";
publicVariable "PROF_fobObjects"; //might be kinda high bandwidth, maybe just do publicVariableServer?

if (PROF_fobOverrun) then {
	//[] spawn PROF_fnc_fobOverrun;
	[] remoteExec ["PROF_fnc_fobOverrun",2];
};