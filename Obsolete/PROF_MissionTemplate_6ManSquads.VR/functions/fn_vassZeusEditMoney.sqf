//Note: Code structure from Crowdedlight's setNumberplate as ZEN does a horrible job at explaining. Thanks Crow, I think I know it now!

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_applyToAllPlayers",
		"_doChangeRelative",
		"_moneyChange"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	_moneyChange = parseNumber _moneyChange;
	//systemChat format ["%1_%2_%3",_applyToAllPlayers,_doChangeRelative,_moneyChange];

	if (_applyToAllPlayers) then {
		[[_moneyChange,_doChangeRelative],{
			params ["_moneyChange","_doChangeRelative"];
			private _PROFOldMoney = profileNamespace getVariable PROF_vassShopSystemVariable;
			private _PROFNewMoney = 0;
			if (_doChangeRelative) then {
				_PROFNewMoney = _PROFOldMoney + _moneyChange;
				hint format ["You now have %1$ in cash due to a Zeus setting your balance!",_PROFNewMoney];
			} else { //absolute change
				_PROFNewMoney = _moneyChange;
				hint format ["You now have %1$ in cash due to a Zeus editing your previous balance by %2!",_PROFNewMoney,_moneyChange];
			};
			profileNamespace setVariable [PROF_vassShopSystemVariable,_PROFNewMoney];
		}] remoteExec ["spawn"]; //TODO everywhere except on the server unless server is a player
	} else {
		[[_moneyChange,_doChangeRelative],{
			params ["_moneyChange","_doChangeRelative"];
			private _PROFOldMoney = profileNamespace getVariable PROF_vassShopSystemVariable;
			private _PROFNewMoney = 0;
			if (_doChangeRelative) then {
				_PROFNewMoney = _PROFOldMoney + _moneyChange;
				hint format ["You now have %1$ in cash due to a Zeus setting your balance!",_PROFNewMoney];
			} else { //absolute change
				_PROFNewMoney = _moneyChange;
				hint format ["You now have %1$ in cash due to a Zeus editing your previous balance by %2!",_PROFNewMoney,_moneyChange];
			};
			profileNamespace setVariable [PROF_vassShopSystemVariable,_PROFNewMoney];
		}] remoteExec ["spawn",_unit];
	};
};

[
	"Edit Player(s)'s Balance for Shop System", 
	[
		["TOOLBOX:YESNO", ["Apply to all players?", "If false, only applies to this specific player."], false],
		["TOOLBOX:YESNO", ["Change relative to current balance?", "If false, sets the player's balance to the amount specified. If true, changes the player's balance by the amount specified."], false],
		["Edit","Amount to change"]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;