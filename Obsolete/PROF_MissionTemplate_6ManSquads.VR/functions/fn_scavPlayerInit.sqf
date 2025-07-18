/*
Initializes the scav system on a (local) player.
[] call PROF_fnc_scavPlayerInit;
*/

params [["_firstTime",true]];
if (_firstTime) then {
	[player,5] call PROF_fnc_scavLoadout;
	[player] joinSilent (createGroup PROF_scavPlayerSide);
	(group player) setGroupIdGlobal [format ["%1's Scav Gang", name player]];

	//do markers. dont worry about markers created during scaving, would be immersion breaking anyways
	{
		_x setMarkerAlphaLocal 1;
	} forEach (missionNamespace getVariable ["PROF_scavPROFkMarkers",[]]);
	{
		_x setMarkerAlphaLocal 0;
	} forEach PROF_scavPmcMarkers;
};

player setVariable ["PROF_playerIsScav",true,true];
player setVariable ["ace_medical_medicclass", 1, true]; //medic 
player setUnitTrait ["Medic", true];
//play audio briefing, give text diary entries, and assign PROFk
//playSound ["scavBriefing",1,0];
//_path spawn PROF_fnc_playCornerVideo;

private _PROFkId = format ["PROF_PersonalScavPROFk%1",name player];
player setVariable ["PROF_PersonalScavPROFkName",_PROFkId];

[player,_PROFkId,[
	format ["Your contact has marked several locations containing items that will satisfy the contract. Locate at least the minimum number of items and move to an extraction point with them in your inventory to complete your contract.<br/><br/><br/><br/>Accepted Items: Pizza Rations.<br/>Quantity Needed: %1",PROF_scavNeededValuables],
	"Fulfill Scavenger Contract",
	""
],objNull,"ASSIGNED"] call BIS_fnc_PROFkCreate;

/*
class CfgSounds
{
	sounds[] = {};
	class thisiswhattheysay
	{
		name = "w/e";
		sound[] = {pathtotheactyualsoundfileinyourmissionfolder}; IE: /sounds/sound1.ogg
		titles[] = {1,"this is what the subtitles will say when the sound is triggered"};
	};
};
*/

//add extraction areas
private _scavActions = [];
private _availableExtracts = missionNamespace getVariable ["PROF_scavExtracts",[]];
{
	_actionID = [
		_x,											// Object the action is attached to
		"Extract",										// Title of the action
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
		"_this distance _target < 5",						// Condition for the action to be shown
		"(_caller distance _target < 5) && ({PROF_scavValuableClassname == _x} count (items player) >= PROF_scavNeededValuables)",						// Condition for the action to progress
		{ [_target,3] call BIS_fnc_dataTerminalAnimate; },													// Code executed when action starts
		{},													// Code executed on every progress tick
		{
			[false] call PROF_fnc_scavPlayerEnd; [_target,0] call BIS_fnc_dataTerminalAnimate;
		},												// Code executed on completion
		{ [_target,0] call BIS_fnc_dataTerminalAnimate; hint "You don't have the required items to successfully extract and complete your contract yet!"; systemChat "You don't have the required items to successfully extract and complete your contract yet!" },													// Code executed on interrupted
		[],													// Arguments passed to the scripts as _this select 3
		10,													// Action duration [s]
		4,													// Priority
		false,												// Remove on completion
		false												// Show in unconscious state 
	] call BIS_fnc_holdActionAdd;
	_scavActions pushBack [_x,_actionID,"scav_extract"];
} forEach _availableExtracts;
player setVariable ["PROF_extractActions",_scavActions];

[missionNamespace getVariable ["PROF_scavExtracts",[]]] spawn PROF_fnc_scavHandleExtractSmokes;

//[player] remoteExec ["PROF_fnc_scavInsertPlayer",2];
private _tpHelper = PROF_scavSafeZoneTpHelper;
_tpHelper = missionNamespace getVariable [_tpHelper, objNull]; //convert from string to object, otherwise we get errors
if (!isNull _tpHelper) then {
	player setPosATL (getPosATL _tpHelper);
} else {
	[format ["fn_scavPlayerInit: Critical error: PROF_scavSafeZoneTpHelper object with name %1 is null!",PROF_scavSafeZoneTpHelper],false] call PROF_fnc_error;
};

"Scav Intro" hintC [
	"You are now playing as a scavenger.",
	"One of the local power players has contracted you, they recently had a convoy get raided and its contents stolen.",
	"The raiders have spread out their gains to a number of caches throughout the region.",
	"Acquire at least 3 of the stolen Pizza items and get to an extraction point. Bonus pizzas will earn you a higher reward.",
	"You may cooperate with other player scavengers if you wish. They can be contacted on the default radio frequency of 44.",
	"You have been placed into the Shop safe zone. When ready, use the flagpole to enter the AO.",
	"Contact Zeus if you have questions, or if you wish to propose an alternative objective that you might get paid for."
];