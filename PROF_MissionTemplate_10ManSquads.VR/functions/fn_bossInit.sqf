if !(isServer) exitWith {};
if !(PROF_bossEnabled) exitWith {};

[] remoteExec ["PROF_fnc_displayHealth",0,true]; //run health display locally on each client and JIP
{
	[_x select 0,_x select 1,_x select 2] spawn PROF_fnc_bossHandleDamage; //variableName, stringName, integerHealth. intended to be executed on server or where vehicle is local
} forEach PROF_bossParts;