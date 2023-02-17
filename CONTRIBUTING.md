# Contributing to Zuma Blitz Remake
If you would like to contribute to the project, please contact me on
Discord: `Shambles#3117`. You can also join the [Sphere Matchers](https://discord.gg/gJgy5x5)
Discord server, verify yourself, and find the "Zuma Blitz Remake" thread.

## Cloning
If you are new to Git, or are uncomfortable with command-line,
it is recommended to download [GitHub Desktop](https://desktop.github.com/).

1. Fork the repository.
2. Clone your fork.
2. Start testing, or editing code/assets.

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

This will be argurably **the hardest part of contributing to the project**.
While we have found the initial release SWF of Kroakatoa Island, there is
still much to be found...

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
  - Life's A Beach
  - Major Mouthful
  - Mine Board
  - Platter Board
  - Reef Madness
  - Sea Queen
  - Sea Turtles Board
  - Snakes Board
- In-game HUD
- Spirit Animals (only from Customer Support page; bar their Hot Frog
  & hot frog transition states and `eyeblink`s)
- Shooter `eyeblink` images; these differ from the Frogatar, the Spirit
  Animal, Cannons powerup state, and Hot Frog state.
- Sound effects
- Majority of UI assets (buttons, dialog boxes...)
- Release/scrapped frogatars

**List of assets we are in need of are the following:**
- Raw Spirit Animal assets
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
- [Other lost assets][lost]
  - Lost SWF files
    - `Congrats`
    - `DailySpin`
    - `ExchangeDialog`
    - `LockedPowers`
    - `Migration` SWFs (Arriving, Packing, Splash, Travelling)
    - `Promotion`
    - `PurchaseDialog`
    - `Shop`
    - `Shrines`
    - `SkillClass`
    - `Splash`
    - `Stats`
  - Frogatars (Cobalt Frog, Werefrog, Pink Frog, etc.) were added circa
    2014 and was loaded from their servers, assumedly directly instead
    of dedicated SWF files.
  - Boards were loaded server-side and not as SWF files. [Likely because
    a Fiddler session from March 2011 revealed that the level files (and
    levels.xml) were outside SWF files.][2011]

[lost]: https://twitter.com/shambles_sm/status/1625491062344273924
[2011]: https://twitter.com/shambles_sm/status/1625888194578481153

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