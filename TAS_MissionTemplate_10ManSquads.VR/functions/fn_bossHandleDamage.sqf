//[this,"Left Leg"] spawn PROF_fnc_bossHandleDamage;
//intended to be executed on server or where vehicle is local
private _debug = false;

if !(PROF_bossEnabled) exitWith {
	diag_log "PROF MISSION TEMPLATE: attempted to handle boss health system without the boss system being enabled!";
	if (_debug) then {
		systemChat format ["attempted to handle boss health system without the boss system being enabled!"];
	};
};

//setup
params ["_object","_componentName","_inputHealth"];
if !(local _object) exitWith {
	diag_log "PROF MISSION TEMPLATE: bossHandleDamage target vehicle is not local!";
	//if (_debug) then {
	systemChat format ["bossHandleDamage target vehicle is not local!"];
	//};
};
private _varName = format ["PROF_%1",_componentName];

/*private ["_health"];
switch (_componentName) do
{
	case "RightFoot": 			{ _health = [(10 * PROF_bossHealthModifier),(10 * PROF_bossHealthModifier)]; }; //1st is current health, 2nd is default health
	case "RightFootCritical": 	{ _health = [(5 * PROF_bossHealthModifier),(5 * PROF_bossHealthModifier)]; };
	case "RightLeg": 			{ _health = [(10 * PROF_bossHealthModifier),(10 * PROF_bossHealthModifier)]; };
	case "RightArm": 			{ _health = [(15 * PROF_bossHealthModifier),(15 * PROF_bossHealthModifier)]; };
	case "Belly": 				{ _health = [(10 * PROF_bossHealthModifier),(10 * PROF_bossHealthModifier)]; };
	case "Center": 				{ _health = [(10 * PROF_bossHealthModifier),(10 * PROF_bossHealthModifier)]; };
	case "Radar": 				{ _health = [(20 * PROF_bossHealthModifier),(20 * PROF_bossHealthModifier)]; };
	case "Gun": 				{ _health = [(20 * PROF_bossHealthModifier),(20 * PROF_bossHealthModifier)]; };
	case "SecondaryTurret": 			{ _health = [(10 * PROF_bossHealthModifier),(10 * PROF_bossHealthModifier)]; };
	case "LeftFoot": 			{ _health = [(10 * PROF_bossHealthModifier),(10 * PROF_bossHealthModifier)]; };
	case "LeftFootCritical": 	{ _health = [(5 * PROF_bossHealthModifier),(5 * PROF_bossHealthModifier)]; };
	case "LeftLeg": 			{ _health = [(10 * PROF_bossHealthModifier),(10 * PROF_bossHealthModifier)]; };
	case "LeftArm": 			{ _health = [(15 * PROF_bossHealthModifier),(15 * PROF_bossHealthModifier)]; };
	default 					{ _health = [(10 * PROF_bossHealthModifier),(10 * PROF_bossHealthModifier)]; if (_debug) then { systemChat format ["Boss component health not found, defaulting to (10 * PROF_bossHealthModifier)!"]; }; };
};*/
private _health = [(_inputHealth * PROF_bossHealthModifier),(_inputHealth * PROF_bossHealthModifier)];


//setup
_object setVariable ["PROF_bossPartName",_componentName,true];
missionNamespace setVariable [_varName, _health, true];
//_object AllowCrewInImmobile true;

//add component name to variable array for displaying. create new array is array doesnt exist yet
if !(isNil "PROF_bossComponents") then {
	PROF_bossComponents pushBack _componentName;
} else {
	PROF_bossComponents = [_componentName];
	if (_debug) then {
		systemChat format ["Boss health components array created! Current value: %1",PROF_bossComponents];
	};
};
publicVariable "PROF_bossComponents";

//debug
if (_debug) then {
	systemChat format ["Setting up %1 with value of %2",_componentName,_health];
};

//add event handler to process damage. Will only fire on pc where vehicle is local
private _eventHandler = _object addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
	private _componentName = _unit getVariable ["PROF_bossPartName","error: no component name"];
	private _varName = format ["PROF_%1",_componentName];
	private _debug = false;

	//take hit value and subtract it from health pool
	private _oldHealth = missionNamespace getVariable [_varName, [0,1]];;
	private _newHealth = (_oldHealth select 0) - _damage;
	missionNamespace setVariable [_varName, [_newHealth,_oldHealth select 1], true];

	if (_debug) then {
		systemChat format ["Processing hit on %1 with varName of %2 and value of %3. Old health: %4. New health: %5",_componentName,_varName,_damage,_oldHealth select 0,_newHealth];
		diag_log format ["Processing hit on %1 with varName of %2 and value of %3. Old health: %4. New health: %5",_componentName,_varName,_damage,_oldHealth select 0,_newHealth];
	};

	//return 0 as we dont want to actually damage the object here
	0
}];

//if health ever reaches 0, then destroy the component
waitUntil {sleep 1; (missionNamespace getVariable [_varName, [0,1]] select 0) <= 0};
_object removeEventHandler ["HandleDamage", _eventHandler];
_object setDamage 0.95; //dont fully kill cause cookoff
_object setVehicleAmmo 0;
private _eventHandler = _object addEventHandler ["HandleDamage", { //just disables damage without the rest of the code
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
	0
}];
//_object setObjectTextureGlobal [0,"#(rgb,8,8,3)color(0,0,0,0)"]; //TODO global?