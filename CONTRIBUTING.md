# Contributing to Zuma Blitz Remake
If you would like to contribute to the project, please contact me on
Discord: `Shambles#3117`. You can also join the [Sphere Matchers](https://discord.gg/gJgy5x5)
Discord server, verify yourself, and find the "Zuma Blitz Remake" thread.

## Code
Since ZBR will be implementing features from Zuma Blitz that OpenSMCE does not
have, you may want to edit the codebase in order for things to, well... work!

As this project is based on OpenSMCE, please look at [OpenSMCE's contribution
guidelines](https://github.com/jakubg1/OpenSMCE/blob/master/CONTRIBUTING.md).

Keep in mind that you should mark any code that is only useful for Zuma Blitz
Remake, like so:
```lua
-- FORK-SPECIFIC CODE: My code that only makes sense on this fork.
_Game:getCurrentProfile():getPowerLevel("sands_of_time")
```

## Assets
> **See also:** [ZumaBlitzRemake/ZumaBlitzAssetRetrieval](https://github.com/ZumaBlitzRemake/ZumaBlitzAssetRetrieval)

This will be argurably **the hardest part of contributing to the project**, as
little to no assets have been found for the game.

### Asset Lists
**List of assets that we currently have in possession:**
- These board backgrounds in particular have been found, edited and/or
  upscaled:
  - Journey to Kroakatoa
  - Journey to Kroakatoa (Easter variant)
  - Zulu Bravado
  - Crab Board
  - Bronze Board
  - Clockwork Board
  - Octupus Board
  - Splish Splash
  - Christmas Kroakatoa Creeper Copse
  - Smooth Creamy
  - Summer Solstice
  - FALLing Skies
  - Journey to Kroakatoa (Easter variant)
  - Life's A Beach
  - Major Mouthful
  - Mine Board
  - Platter Board
  - Reef Madness
  - Sea Queen
  - Sea Turtles Board
  - Snakes Board
- In-game HUD
- Spirit Animals (bar their Hot Frog & hot frog transition states)

**List of assets we are in need of are the following:**
- Shooter `eyeblink` images; these will differ from the Frogatar, the Spirit
  Animal, Cannons powerup state, and Hot Frog state.
- Classic Frog's hot frog transition states
- These board backgrounds in particular have been found either only with
  balls/UI/frogs blocking the image, no edits done for them yet and/or
  low-quality:
  - **Many** boards, both Kroakatoa and Beta, including but not limited to:
    - [One Giant Leap](https://www.youtube.com/watch?v=PSgFs_DSl54)
    - [Valentine's Day](https://www.youtube.com/watch?v=szaGw8xbW4k)
    - [Sweet Shot](https://www.youtube.com/watch?v=LxtixkwukP8)
    - Eagle Wings
    - Progressive Board
    - Shamrock Board
    - Trailblazer <!-- Ew, it's the Autism Speaks board. Why, PopCap? -->
    - Inward Falls
    - Hot Springs
    - Kroakatoa Lava Board
    - [Thanksgiving Board](https://www.youtube.com/watch?v=gFyCgHN3oMU)
    - Spiral Gateway
    - **These boards will be ported and edited accordingly in order to be
      playable, if they are from the Beta/Pre-Kroakatoa version.**
- UI assets (buttons, dialog boxes...)

If you have any doubts or questions regarding the status of a specific
asset, please contact us.

### Regarding AI Tools & Asset Recreation
While AI **upscalers** are accepted, such as Waifu2x and ESRGAN,
please refrain from using inpainters or outpainters. The model you may have
used may have sampled from works that was taken without permission.

Regardless, manually outpainting via using the Photoshop brush strokes and
the Content Aware tools (fill, healing brush, patch, etc) may be more of an
appropriate and "accurate" approach since the AI won't get much context
around what should be outpainted, beyond prompts and the image source.
Furthermore, the resulting images may have unwanted artifacts and may be of
lower resolution, assuming you are using a site that hosts the AI tool and
not a powerful computer that you own.

## Gameplay Mechanics
These have been researched mostly on [Brendan Chan's Zuma Blitz blog](http://bchantech.dreamcrafter.com/zumablitz/)
and [PopCap's ZB Customer Support page](https://web.archive.org/web/20130130103017/http://support.popcap.com/facebook/zuma-blitz).

You are free to refine what we currently have right now via these and gameplay
footage on YouTube.

We will be following the mechanics from Kroakatoa, so if you are going to
suggest something such as crits or Mastery, forget about it.