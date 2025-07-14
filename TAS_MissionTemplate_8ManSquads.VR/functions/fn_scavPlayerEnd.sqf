

params [["_isFail",true]];

//todo fadeout?
[objNull, player] call ace_medical_treatment_fnc_fullHeal;

/*
private _PROFkId = player getVariable ["PROF_PersonalScavPROFkName",""];

if (_isFail) then {
	[_PROFkId,"FAILED",true] call BIS_fnc_PROFkSetState;
	[_PROFkId,player,true] call BIS_fnc_deletePROFk;
} else {
	[_PROFkId,"SUCCEEDED",true] call BIS_fnc_PROFkSetState;
	[_PROFkId,player,true] call BIS_fnc_deletePROFk;
	//todo find number of pizzas and reward appropriately
};

private _actionsToRemove = player getVariable ["PROF_scavActions",[]]; //[[object,id,string for name]]
{
	[_x select 0,_x select 1] call BIS_fnc_holdActionRemove;
} forEach _actionsToRemove;


{
	_x setMarkerAlphaLocal 0;
} forEach (missionNamespace getVariable ["PROF_scavPROFkMarkers",[]]);
{
	_x setMarkerAlphaLocal 1;
} forEach PROF_scavPmcMarkers;


//sleep 3;

//voiceline?

player setVariable ["PROF_playerIsScav",false,true];
*/

if (_isFail) then {
	[] call PROF_fnc_scavPlayerInit; //start whole scav thing over again if you want nonstop scaving
} else {
	private _numberPizzas = {PROF_scavValuableClassname == _x} count (items player);
	private _moneyChange = _numberPizzas * PROF_scavRewardPerItem;
	private _doChangeRelative = true;
	private _PROFOldMoney = profileNamespace getVariable PROF_vassShopSystemVariable;
	private _PROFNewMoney = 0;
	if (_doChangeRelative) then {
		_PROFNewMoney = _PROFOldMoney + _moneyChange;
		hint format ["You now have %1$ in cash due to extracting successfully!",_PROFNewMoney];
	} else { //absolute change
		_PROFNewMoney = _moneyChange;
		hint format ["You now have %1$ in cash due to a Zeus editing your previous balance by %2!",_PROFNewMoney,_moneyChange];
	};
	profileNamespace setVariable [PROF_vassShopSystemVariable,_PROFNewMoney];
	player removeItems PROF_scavValuableClassname;
	player setPosATL (getPosATL scavTpHelper);
};

/*
//restore old pmc loadout and position
private _loadout = player getVariable ["PROF_scavPmcLoadout",[]];
if (_loadout != []) then {
	[player, _loadout, false] call CBA_fnc_setLoadout;
} else {
	["Your old PMC loadout was not applied due to not being previously saved!",false] call PROF_fnc_error;
};
*/