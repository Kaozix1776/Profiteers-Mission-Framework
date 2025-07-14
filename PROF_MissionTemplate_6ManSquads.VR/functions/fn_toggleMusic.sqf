//PROF Music Hotkey Script
//Written by Guac
//Requirements: CBA

//setup PROF_musicEnabled, if player does not have PROF_musicEnabled already defined then default to false
private _unit = player;
private _musicEnabled = _unit getVariable ["PROF_musicDisabled", false];


if (_musicEnabled) then { //undoes effect if player already has music enabled 
	if (_unit getVariable ["PROF_earplugsIn",false]) then { //change music volume to earplugs reduced volume value if earplugs are in
		0 fadeMusic PROF_earplugVolume;
	} else {
		3 fadeMusic 1; //fades in over 3 seconds
	};
	systemChat "Smoothly unmuting music over three seconds!";
	_unit setVariable ["PROF_musicDisabled",false];
} else { //Turns music off
	0 fadeMusic 0;
	systemChat "Muted music!";
	_unit setVariable ["PROF_musicDisabled",true];
};