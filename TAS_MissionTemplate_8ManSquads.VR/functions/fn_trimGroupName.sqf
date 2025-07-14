// [group player,false] spawn PROF_fnc_trimGroupName;
params ["_group","_forced"];

if !(_forced) then {	//skip previous checking if forced trim
	if (_group getVariable ["PROF_groupNameTrimmed",false]) exitWith {};	//exit if name has already been trimmed
};

//trim the group name, apply it, and set var to group indicating that it doesnt need trimming again
private _groupName = groupID _group;
private _trimmedName = trim _groupName;
_group setGroupIdGlobal [_trimmedName];
_group setVariable ["PROF_groupNameTrimmed",true,true];	//broadcast to prevent other clients from trying to trim it on init