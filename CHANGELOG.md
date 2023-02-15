
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/).
Keep in mind that this project may not adhere to [Semantic Versioning](http://semver.org/)
until stable release builds are available.

## alpha v0.1.1 - 2023-02-15

### Additions
- [`d759264`][a-v.0.1.1-a1] Offline leaderboards
- [`30d72da`][a-v.0.1.1-a2] Implement Spirit Turtle
- [`b23be0e`][a-v.0.1.1-a3] Implement Spirit Eagle
- [`9cb0291`][a-v.0.1.1-a4] Add Roots Board (tentative: Back to your Roots)
- [`6f14add`][a-v.0.1.1-a5] Implement Hot Frog transition
- [`a9dea16`][a-v.0.1.1-a6] Food variants now have the same effects as their base
- [`abe7b54`][a-v.0.1.1-a7] Add temporary/debug player info and food selection
- [`be22de0`][a-v.0.1.1-a8] Add Cannons functionality
- [`bb43eef`][a-v.0.1.1-a9] Add Discord button

### Changes
- [`0b9726c`][a-v.0.1.1-c1] Use sounds from SWF file
- [`19c9951`][a-v.0.1.1-c2] Use frog from SWF file
- [`4683b13`][a-v.0.1.1-c3] Use HUD from SWF file
- [`5936215`][a-v.0.1.1-c4] Use Blitz Meter pointer from SWF file
- [`58fbc48`][a-v.0.1.1-c5] Food now grants extra points on Curve Clear
- [`27ed4cd`][a-v.0.1.1-c6] Hot Frog fireballs are no longer swappable
- [`3491416`][a-v.0.1.1-c7] Accelerate spheres on Curve Clear
- [`80a6ddc`][a-v.0.1.1-c8] Ensure multiplier doesn't go above cap
- [`2d4a287`][a-v.0.1.1-c9] Prevent losing if matches are predicted
- [`cf28b32`][a-v.0.1.1-c10] Temporarily disable fullscreen and resizing
- [`0a36570`][a-v.0.1.1-c11] Add Targets to Bronze Board

### Bugfixes
- [`dd73b31`][a-v.0.1.1-b1] Fix rolling sound not pausing
- [`12a4a4b`][a-v.0.1.1-b2] Fix largestGap crash on LOVE 11.4
- [`54c4e5c`][a-v.0.1.1-b3] Fix Curve Clears scoring 1000 + time instead of 1000 + (100 * time)
- [`5c83131`][a-v.0.1.1-b4] Fix profiles having more than 3 powers
- [`836ddda`][a-v.0.1.1-b5] Fix powers over max level crashing the game
- [`f4e6a7a`][a-v.0.1.1-b6] Fix powers crashing the game on profileless launches
- [`9929a05`][a-v.0.1.1-b7] Fix rare Curve Clear bug
- [`5757470`][a-v.0.1.1-b8] Fix crashes not saving the log
- [`0058351`][a-v.0.1.1-b9] Fix Targets crashing the game on load
- [`0e9c196`][a-v.0.1.1-b10] Fix Multiplier undercap

### Removed
- [`6ef7f44`][a-v.0.1.1-r1] Remove leftover Luxor 1 maps

[a-v.0.1.1-a1]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/d759264
[a-v.0.1.1-a2]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/30d72da
[a-v.0.1.1-a3]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/b23be0e
[a-v.0.1.1-a4]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/9cb0291
[a-v.0.1.1-a5]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/6f14add
[a-v.0.1.1-a6]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/a9dea16
[a-v.0.1.1-a7]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/abe7b54
[a-v.0.1.1-a8]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/be22de0
[a-v.0.1.1-a9]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/bb43eef

[a-v.0.1.1-c1]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/0b9726c
[a-v.0.1.1-c2]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/19c9951
[a-v.0.1.1-c3]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/4683b13
[a-v.0.1.1-c4]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/5936215
[a-v.0.1.1-c5]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/58fbc48
[a-v.0.1.1-c6]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/27ed4cd
[a-v.0.1.1-c7]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/3491416
[a-v.0.1.1-c8]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/80a6ddc
[a-v.0.1.1-c9]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/2d4a287
[a-v.0.1.1-c10]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/0e9c196
[a-v.0.1.1-c11]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/0a36570

[a-v.0.1.1-b1]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/dd73b31
[a-v.0.1.1-b2]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/12a4a4b
[a-v.0.1.1-b3]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/54c4e5c
[a-v.0.1.1-b4]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/5c83131
[a-v.0.1.1-b5]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/836ddda
[a-v.0.1.1-b6]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/f4e6a7a
[a-v.0.1.1-b7]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/9929a05
[a-v.0.1.1-b8]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/5757470
[a-v.0.1.1-b9]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/0058351
[a-v.0.1.1-b10]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/0e9c196

[a-v.0.1.1-r1]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/6ef7f44

## alpha v0.1.0 - 2023-01-27

### Additions
- [`e54b493`][a-v0.1.0-a1] Play sounds on gap and chain bonuses
- [`7c00630`][a-v0.1.0-a2] Add code to change shooter definitions (OpenSMCE change)
- [`42f6852`][a-v0.1.0-a3] Add combo pitching
- [`80501b8`][a-v0.1.0-a4] Add Bronze Board (tentative: Bronze Age)
- [`03c2478`][a-v0.1.0-a5] Add Crab Board (tentative: Crab Snap)
- [`0d9f500`][a-v0.1.0-a6] Add Powers
- [`fcdaa70`][a-v0.1.0-a7] Add Targets (Fruits)
- [`030706f`][a-v0.1.0-a8] Add rolling sound
- [`91bef2e`][a-v0.1.0-a9] Add Food items
- [`b5a1897`][a-v0.1.0-a10] Implement Blend Modes (OpenSMCE change)

### Bugfixes
- [`22bdb61`][a-v0.1.0-b1] Fix crash on non-Windows OSes

### Changes
- [`61691bd`][a-v0.1.0-c1] Graceful end on time up
- [`8860ef0`][a-v0.1.0-c2] Use placeholder Zuma sounds from a Luxor mod
- [`e324d14`][a-v0.1.0-c3] Change score strings
- [`0962059`][a-v0.1.0-c4] Change scoring to +10 per sphere
- [`a404037`][a-v0.1.0-c5] Replace Fireball sounds
- [`4d9f19f`][a-v0.1.0-c6] Implement Curve Clears
- [`a340c1a`][a-v0.1.0-c7] Replace Luxor music with Zuma Blitz music
- [`9070e44`][a-v0.1.0-c8] Implement Colorblind Mode
- [`c9ef6a7`][a-v0.1.0-c9] Change Wild Ball asset
- [`5d438ab`][a-v0.1.0-c10] Losing causes a win
- [`78cdcc7`][a-v0.1.0-c11] Replicate Zuma sphere physics
- [`fab065b`][a-v0.1.0-c12] Replicate Zuma powerup logic
- [`6dbdb93`][a-v0.1.0-c13] Replicate Blitz Meter arc
- [`3a29956`][a-v0.1.0-c14] Fix window resolution
- [`aa1d484`][a-v0.1.0-c15] Notify when the time's up

### Removed
- [`6e5b1c0`][a-v0.1.0-r1] Remove Luxor collectibles from the game
- [`708d0e5`][a-v0.1.0-r2] Remove Luxor scarabs
- [`cf486a8`][a-v0.1.0-r3] Remove colon key debug functionality

[a-v0.1.0-a1]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/e54b493
[a-v0.1.0-a2]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/7c00630
[a-v0.1.0-a3]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/42f6852
[a-v0.1.0-a4]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/80501b8
[a-v0.1.0-a5]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/03c2478
[a-v0.1.0-a6]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/0d9f500
[a-v0.1.0-a7]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/fcdaa70
[a-v0.1.0-a8]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/030706f
[a-v0.1.0-a9]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/91bef2e
[a-v0.1.0-a10]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/b5a1897

[a-v0.1.0-b1]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/22bdb61

[a-v0.1.0-c1]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/61691bd
[a-v0.1.0-c2]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/8860ef0
[a-v0.1.0-c3]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/e324d14
[a-v0.1.0-c4]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/0962059
[a-v0.1.0-c5]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/a404037
[a-v0.1.0-c6]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/4d9f19f
[a-v0.1.0-c7]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/a340c1a
[a-v0.1.0-c8]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/9070e44
[a-v0.1.0-c9]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/c9ef6a7
[a-v0.1.0-c10]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/5d438ab
[a-v0.1.0-c11]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/78cdcc7
[a-v0.1.0-c12]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/fab065b
[a-v0.1.0-c13]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/6dbdb93
[a-v0.1.0-c14]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/3a29956
[a-v0.1.0-c15]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/aa1d484

[a-v0.1.0-r1]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/6e5b1c0
[a-v0.1.0-r2]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/708d0e5
[a-v0.1.0-r3]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/cf486a8

## alpha v0.0.8 - 2023-01-01

No releases available.

### Additions
- [`30d6ca6`][a-v0.0.8-a1] Add shooter knockback
- [`81d0861`][a-v0.0.8-a2] Add level timers
- [`21d3061`][a-v0.0.8-a3] Add disclaimer screen
- [`fd493a5`][a-v0.0.8-a4] Implement Hot Frog

### Changes
- [`b51204d`][a-v0.0.8-c1] Remove intro banner
- [`54d4aa7`][a-v0.0.8-c2] Replace HUD with placeholder
- [`0fde583`][a-v0.0.8-c3] Replace loading screen with placeholder
- [`339936d`][a-v0.0.8-c4] Replace Fireball with Blitz fireball
- [`98a54ff`][a-v0.0.8-c5] De-hardcode starting functions (OpenSMCE change)
- [`b753158`][a-v0.0.8-c6] De-hardcode loading (OpenSMCE change)

[a-v0.0.8-a1]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/30d6ca6
[a-v0.0.8-a2]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/81d0861
[a-v0.0.8-a3]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/21d3061
[a-v0.0.8-a4]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/fd493a5

[a-v0.0.8-c1]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/b51204d
[a-v0.0.8-c2]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/54d4aa7
[a-v0.0.8-c3]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/0fde583
[a-v0.0.8-c4]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/339936d
[a-v0.0.8-c5]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/98a54ff
[a-v0.0.8-c6]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/b753158

## alpha v0.0.1 - 2022-12-31
  
Initial version. No releases are available.

Tag: [`466fa8a`][466fa8a]

[466fa8a]: https://github.com/ZumaBlitzRemake/ZumaBlitzRemake/commit/466fa8a