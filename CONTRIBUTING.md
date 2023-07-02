# Contributing to Zuma Blitz Remake

## Reporting Issues
1. Please search for existing issues before adding a new one. 
2. For crashes, share as much information leading up to the crash. Include a crash dump if possible (the crash screen has a Copy to Clipboard button)

## Code Changes
As this project is a fork of OpenSMCE, please look at [OpenSMCE's contribution
guidelines](https://github.com/jakubg1/OpenSMCE/blob/master/CONTRIBUTING.md).

In addition, we are also adhering to the following guidelines:
 - Always test to make sure the game runs to the main menu.
 - Don't use code that checks for specific powers or items on the player. This may work for local games but the server does not pass this information to the game client.
 - Keep modifications to OpenSMCE game engine code and game-specific code in separate commits.
 - Avoid functions that heavily rely on getting/setting information using `_Game`. If the majority of the function is doing that, it may be better off in another class.
 - Don't use `if not x` or exact values for items that depend on an internal timer for checking if a value is zero or otherwise. While the game runs at 60 frames a second the game does not always add values cleanly so the timer may be very close to but not evaluate to zero.
 - Avoid functions that run every frame unless it is necessary.
 - Write stable functions that do not crash if unexpected data is passed to it.
 - Only use _Log.printt if action is needed for level developers or contains useful information that can be submitted in case of crashes. printt outputs data to log.txt as well, while the standard print() outputs to the console only.
 - Do not use math.random() for anything that affects the outcome of a game. Use love.math.newRandomGenerator with a RNG seed that is passed from the server, so that the server can recreate the exact game state.

### Specification Changes
If you are making any changes to how the game interprets the game's .json files (including ones pulled from the server) or adding new ones, please update the game documentation (data.txt) and/or schemas in your PR with this information. 

## Assets
Many assets will have to be defined before they can be used in ZBR - take a look at the documentation and other .json files for examples as to how to incorporate them into the game.

A number of assets themselves are loaded from the server directly and are outside the scope of this project.

## Gameplay Mechanics
These have been researched mostly on [The Other Zuma Blitz Guide](http://bchantech.dreamcrafter.com/zumablitz/)
and [PopCap's ZB Customer Support page](https://web.archive.org/web/20130130103017/http://support.popcap.com/facebook/zuma-blitz), as well as from examining the game files and data sent to/from the game servers.

You are free to refine what we currently have right now via these and gameplay footage on YouTube.

While we will generally be following the mechanics from Kroakatoa, we are open to 
accepting new features that help the modding community, or to fix game breaking bugs. Any modifications outside of the base game will need to be manually defined by the map and/or server implementation.

## Other Changes and Suggestions
Please open an issue on the Issues page, or discuss on Discord for larger changes or proposals.