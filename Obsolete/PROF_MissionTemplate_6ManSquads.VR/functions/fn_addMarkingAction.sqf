/*
	Author: Guac

	Requirements: None
	
	Helper function to add a userAction to a player which calls fn_markUnit when executed.

	Examples:
	[] call PROF_fnc_addMarkingAction;
*/

player addAction [
	"Spot Unit",
	"[cursorTarget,side player,PROF_markTargetOnMap,PROF_markTarget3d] remoteExec ['PROF_fnc_markUnit',2]", //params ["_target", "_caller", "_actionId", "_arguments"];
	[],
	1.5,
	false,
	false,
	"",
	"(_this == _originalTarget) && !(isNull cursorTarget)" //only allow local player to execute. TODO: better validation/feedback to player if mark "misses"
];