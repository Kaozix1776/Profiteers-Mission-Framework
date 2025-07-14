//Save dead player's loadout. Vanilla code sometimes breaks things, like radios and current weapon, so use CBA.
private _loadout = [player] call CBA_fnc_getLoadout;
player setVariable ["PROF_deathLoadout",_loadout];

if (PROF_fixDeathColor) then {
	private _team = assignedTeam player;
	player setVariable ["PROF_deathFireteamColor",_team];
};