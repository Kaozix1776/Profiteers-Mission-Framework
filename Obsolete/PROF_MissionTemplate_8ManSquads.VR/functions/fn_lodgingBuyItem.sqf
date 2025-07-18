// Handles the buying logic of lodging
// If player has enough money to buy item, update their money, display text, and call PROF_fnc_lodgingSpawnItem
// Else, say that they're poor
// Uses PROF_vassShopSystemVariable
// Execute locally on player
// ["Box_IND_Support_F",100,"Supply Box"] call PROF_fnc_lodgingBuyItem;

params ["_itemClassname","_cost","_name",["_debug",true]];

private _currentMoney = profileNamespace getVariable [PROF_vassShopSystemVariable,0];

if (_debug) then { [format ["PROF_lodgingBuyItem: Trying to buy item %1 for player with money %2!",_itemClassname,_currentMoney]] call PROF_fnc_error; };

if (_currentMoney >= _cost) then {
	private _newMoney = _currentMoney - _cost;
	profileNamespace setVariable [PROF_vassShopSystemVariable,_newMoney];
	hint format ["You now have %1$ in cash after buying %2 for %3",_newMoney,_name,_cost];
	
	if (_debug) then { [format ["PROF_lodgingBuyItem: Item bought, player now has money %1!",_newMoney]] call PROF_fnc_error; };

	[_itemClassname] call PROF_fnc_lodgingSpawnItem;
} else {
	hint format ["You do not have enough to buy this item!\n\nIt costs %1 but you only have %2 available.",_cost,_currentMoney];
	
	if (_debug) then { [format ["PROF_lodgingBuyItem: Player doesn't have enough money, canceling buy!"]] call PROF_fnc_error; };
};