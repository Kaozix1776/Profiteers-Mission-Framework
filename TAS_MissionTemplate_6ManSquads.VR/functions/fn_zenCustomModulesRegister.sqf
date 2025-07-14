//inspiration taken from Crow's Zeus Additions

private _moduleList = [];
private _systemsModuleList = [];
private _logisticsModuleList = [];
private _protectModuleList = [];
private _vassModuleList = [];

if (PROF_zeusResupply) then {
	_logisticsModuleList pushBack ["Spawn Resupply Crate", {_this call PROF_fnc_ammoCrateZeus}];
	player createDiaryRecord ["PROFMissionTemplate", ["Custom Zeus Resupply Modules", "Enabled.<br/><br/>Adds two custom resupply modules to Zeus. One spawns the crate at the cursor location, while the other paradrops it. Each spawns a large crate with medical and 6 mags for each player's weapon. You can find it under 'PROF Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Custom Zeus Resupply Modules", "Disabled."]]; };
};

if (PROF_respawnInVehicle) then {
	_logisticsModuleList pushBack ["Assign As Respawn Vehicle", {_this call PROF_fnc_assignRespawnVic}];
	//diary handled in initPlayerLocal
};

if (PROF_zeusInfoText) then {
	_moduleList pushBack ["Play Info Text", {_this call PROF_fnc_zeusInfoText}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Info Text", "Enabled.<br/><br/>Adds a Zeus module to play info text to all players. You can find it under 'PROF Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Zeus Info Text", "Disabled."]]; };
};

if (PROF_zeusHcTransfer) then {
	_systemsModuleList pushBack ["Transfer Group Ownership", {_this call PROF_fnc_zeusTransferGroupOwnership}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Headless Client Group Trasnfer", "Enabled.<br/><br/>Adds a zeus module to manually transfer ownership of AI groups. You can find it under 'PROF Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Zeus Headless Client Group Trasnfer", "Disabled."]]; };
};

if (PROF_3dGroupIcons) then {
	_systemsModuleList pushBack ["Manage 3d Group Icons", {_this call PROF_fnc_zeus3dGroupIcons}];
	player createDiaryRecord ["PROFMissionTemplate", ["3d Group Icons", "Enabled.<br/><br/>Adds 3d icons over group leaders' heads (enable/disable is managable through a zeus module). You can find the management zeus module under 'PROF Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["3d Group Icons", "Disabled."]]; };
};

if (PROF_zeusActionDebug) then {
	_systemsModuleList pushBack ["Reapply Hold Actions", {_this remoteExec ["PROF_fnc_applyHoldActions",0]; systemChat "Reapplied hold actions for all players."}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Hold Action Debug", "Enabled.<br/><br/>Adds a module to Zeus to allow them to trigger automatic debugging of the various hold actions present in a mission (i.e. medical box heal and stuff)."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Zeus Hold Action Debug", "Disabled."]]; };
};

if (PROF_zeusSpectateManager) then {
	_logisticsModuleList pushBack ["Manage ACE Spectator Settings", {_this call PROF_fnc_zeusSpectatorOptions}];
	_logisticsModuleList pushBack ["Apply ACE Spectator", {_this call PROF_fnc_zeusApplySpectator}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Manage ACE Spectator Settings", "Enabled.<br/><br/>Adds a module to Zeus to allow them to edit available sides and camera modes for spectator, as well as adding a module to let them manage the spectator status of individual units."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Zeus Manage ACE Spectator Settings", "Disabled."]]; };
};

if (PROF_respawnInVehicle || PROF_fobEnabled || PROF_rallypointsEnabled || PROF_flagpoleRespawn) then {
	_logisticsModuleList pushBack ["Open Respawn GUI on Unit", {
		private _unit = _this select 1;
		if (isNull _unit) exitWith { systemChat "Place the module on a unit!"};
		[] remoteExec ["PROF_fnc_openRespawnGui",_unit];
		systemChat format ["Opened respawn GUI for unit %1",_unit];
	}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Open Respawn GUI on Unit", "Enabled.<br/><br/>Adds a module to Zeus to allow them to activate the respawn GUI on a unit."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Zeus Open Respawn GUI on Unit", "Disabled."]]; };
};

if (PROF_zeusGroupDeletion) then {
	_systemsModuleList pushBack ["Enable Empty Group Deletion", {
		private _groupNumber = count allGroups;
		diag_log format ["PROF-MISSION-TEMPLATE Empty group deletion starting, old groups: %1", _groupNumber];
		[{
			if (local _x) then
			{
				if (count units _x != 0) then {
					_x deleteGroupWhenEmpty true;
				} else {
					deleteGroup _x;
				};
			}
			else
			{
				if (count units _x != 0) then {
					[_x, true] remoteExec ["deleteGroupWhenEmpty", groupOwner _x];
				} else {
					_x remoteExec ["deleteGroup", groupOwner _x];
				};
			};
		}, allGroups] remoteExec ["forEach",2];
		private _newGroupNumber = count allGroups;
		diag_log format ["PROF-MISSION-TEMPLATE Empty group deletion ending, deleted groups: %1", _groupNumber - _newGroupNumber];
		systemChat format ["Deleted %1 empty groups and queued all others for deletion after being empty! Remaining groups: %2", _groupNumber - _newGroupNumber, _newGroupNumber];
	}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Empty Group Deletion", "Enabled.<br/><br/>Adds a module to Zeus that deletes currently empty groups and tags occupied groups for deletion once they are empty."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Zeus Empty Group Deletion", "Disabled."]]; };
};

if (PROF_zeusFollowMarker) then {
	_moduleList pushBack ["Attach Marker to Object", {_this call PROF_fnc_zeusMarkerFollow}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Attach Marker to Object", "Enabled.<br/><br/>Adds a module to Zeus to allow them to attach markers on objects that follow them at the set interval."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Zeus Attach Marker to Object", "Disabled."]]; };
};

if (PROF_globalTfarEnabled) then {
	_systemsModuleList pushBack ["Toggle Global TFAR On/Off", {_this call PROF_fnc_zeusGlobalTfar}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Global TFAR", "Enabled.<br/><br/>Adds a module to Zeus to allow them to activate or disable the Global TFAR script."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Zeus Global TFAR", "Disabled."]]; };
};

if (PROF_zeusServiceVehicle) then {
	_logisticsModuleList pushBack ["Service Vehicle (RRR)", {if (isNull (_this select 1)) exitWith {systemChat "Place the module on a vehicle!"}; [(_this select 1)] remoteExec ["PROF_fnc_serviceHeli",(_this select 1)]}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Service Vehicle", "Enabled.<br/><br/>Adds a module to Zeus to allow them to RRR a vehicle with chat messages to its crew."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Zeus Service Vehicle", "Disabled."]]; };
};

if (PROF_vassEnabled) then {
	_vassModuleList pushBack ["Edit Balance of Player", {
		if (isNull (_this select 1)) exitWith {systemChat "Place the module on a unit!"};
		_this call PROF_fnc_vassZeusEditMoney
	}];
	_vassModuleList pushBack ["View balance of player", {
		if (isNull (_this select 1)) exitWith {systemChat "Place the module on a unit!"}; 
		[[], {
			private _currentMoney = profileNamespace getVariable [PROF_vassShopSystemVariable,0];
			[[name player, _currentMoney], {
				private _message = format ["%1 has a balance of %2.",_this select 0, _this select 1];
				systemChat _message;
				hint _message;
			}] remoteExec ["spawn",remoteExecutedOwner];
		}] remoteExec ["spawn",_this select 1];
	}];
	_vassModuleList pushBack ["End Mission", {
		[] remoteExec ["PROF_fnc_vassEndMission"];
	}];
};

if (true) then { //always be available
	_protectModuleList pushBack ["Add Protected Unit", {
		private _unit = _this select 1;
		if (isNull _unit) exitWith { systemChat "Place the module on an unit!"};
		[_unit] remoteExec ["PROF_fnc_punishCivKillerServer",_unit];
	}];
	_protectModuleList pushBack ["Timeout Unit", {
		private _unit = _this select 1;
		if (isNull _unit) exitWith { systemChat "Place the module on an unit!"};
		_this call PROF_fnc_zeusPunishPlayer;
	}];
	_protectModuleList pushBack ["Check Civ Kills of Unit", {
		private _unit = _this select 1;
		if (isNull _unit) exitWith { systemChat "Place the module on an unit!"};
		systemChat format ["%1 has killed %2 protected units!",name _unit, _unit getVariable ["PROF_civsKilledByUnit",0]];
	}];
	_protectModuleList pushBack ["Forgive Unit", {
		private _unit = _this select 1;
		if (isNull _unit) exitWith { systemChat "Place the module on an unit!"};
		systemChat format ["%1 has been forgiven of %2 protected kills!",name _unit, _unit getVariable ["PROF_civsKilledByUnit",0]];
		_unit setVariable ["PROF_civsKilledByUnit",0,true];
	}];
	_protectModuleList pushBack ["Protect All Units of Side", {
		_this call PROF_fnc_zeusPunishProtectAllUnitsOfSide;
	}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Protect/Punish Modules", "Enabled.<br/><br/>"]];

	_logisticsModuleList pushBack ["Add Flagpole as Respawn Position", {
		private _unit = _this select 1;
		if (isNull _unit) exitWith { systemChat "Place the module on an object like a flagpole!"};
		_this call PROF_fnc_assignRespawnFlagpole;
	}];
	player createDiaryRecord ["PROFMissionTemplate", ["Zeus Flagpole Respawn", "Enabled.<br/><br/>Adds a module to Zeus to allow them to add flagpoles as respawn positions."]];

	_moduleList pushBack ["Spawn Attack Dog", {
		_this call PROF_fnc_zeusSpawnAttackDog;
	}];

	_moduleList pushBack ["Give Scav Loadout", {
		_this call PROF_fnc_zeusScavLoadout;
	}];

	_moduleList pushBack ["Make Unit Into Juggernaut", {
		_this call PROF_fnc_zeusAceJuggernaut;
	}];

	_systemsModuleList pushBack ["Add Admin Zeus", {
		[] call PROF_fnc_createZeusAdmin;
	}];

	_systemsModuleList pushBack ["Add Guac Zeus", {
		[] call PROF_fnc_createZeusGuac;
	}];

	_moduleList pushBack ["Set Unit/Area on Fire", {
		_this call PROF_fnc_zeusSetUnitOnFire;
	}];

	_moduleList pushBack ["Spawn Scav Group", {
		_this call PROF_fnc_zeusSpawnScavGroup;
	}];
	
	if (isClass(configFile >> "CfgPatches" >> "PhoenixSystems_Exosuits")) then {
		_moduleList pushBack ["Equip Unit with Exosuit (EXOMOD)", {
			(_this select 1) call PROF_fnc_addExo;
		}];
	};

	_systemsModuleList pushBack ["Add Unit to Map FPS Display", {
		[] spawn PROF_fnc_showFps;
	}];

	_systemsModuleList pushBack ["Log Unit's FPS", { //TODO make this into an actual zeus module with options
		[true,300,2,true] remoteExec ["PROF_fnc_debugPerfRpt",_this select 1]; //log infinitely, log every 300 seconds, log to server, save log copy to client
	}];

	_moduleList pushBack ["Mark Unit/Vehicle", {
		_this call PROF_fnc_zeusMarkUnit;
	}];

} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	//if !(PROF_cleanBriefing) then { player createDiaryRecord ["PROFMissionTemplate", ["Zeus Flagpole Respawn", "Disabled."]]; };
};



//private _image = "media/logo256x256.paa";
{
	private _successfullyRegistered = 
	[
		"PROF Main", 
		(_x select 0), 
		(_x select 1)
	] call zen_custom_modules_fnc_register;
	if (!_successfullyRegistered) then {
		systemChat format ["PROF-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
		diag_log format ["PROF-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
	};
} forEach _moduleList;

{
	private _successfullyRegistered = 
	[
		"PROF Respawns and Logistics", 
		(_x select 0), 
		(_x select 1)
	] call zen_custom_modules_fnc_register;
	if (!_successfullyRegistered) then {
		systemChat format ["PROF-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
		diag_log format ["PROF-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
	};
} forEach _logisticsModuleList;

{
	private _successfullyRegistered = 
	[
		"PROF Systems", 
		(_x select 0), 
		(_x select 1)
	] call zen_custom_modules_fnc_register;
	if (!_successfullyRegistered) then {
		systemChat format ["PROF-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
		diag_log format ["PROF-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
	};
} forEach _systemsModuleList;

{
	private _successfullyRegistered = 
	[
		"PROF Punish / Protect", 
		(_x select 0), 
		(_x select 1)
	] call zen_custom_modules_fnc_register;
	if (!_successfullyRegistered) then {
		systemChat format ["PROF-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
		diag_log format ["PROF-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
	};
} forEach _protectModuleList;

if (PROF_vassEnabled) then {
	{
		private _successfullyRegistered = 
		[
			"PROF Shop System", 
			(_x select 0), 
			(_x select 1)
		] call zen_custom_modules_fnc_register;
		if (!_successfullyRegistered) then {
			systemChat format ["PROF-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
			diag_log format ["PROF-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
		};
	} forEach _vassModuleList;
};