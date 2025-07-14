params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_startIcons"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	[_startIcons, {
		if (_this) then {
			PROF_3dGroupIcons = true;
			publicVariable "PROF_3dGroupIcons";
			private _clientsToSpawnOn = [0, -2] select (isDedicated); //is3DENMultiplayer || is3DEN
			[] remoteExec ["PROF_fnc_3dGroupIcons",_clientsToSpawnOn];
		} else {
			PROF_3dGroupIcons = false;
			publicVariable "PROF_3dGroupIcons";
		};
	}] remoteExec ["spawn",2];
};

[
	"3d Group Icons Manager", 
	[
		["TOOLBOX:YESNO", ["Show 3d Group Icons?", ""], false]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;