<h1 align="center">Zuma Blitz Remake</h1>
<div align="center">
</div>

![Discord](https://img.shields.io/discord/315202394118029314?color=%235865F2&label=Discord%20&logo=discord&style=flat-square)

> A preservation & recreation project for **Zuma Blitz** - an old Facebook game
from 2010-2017, specifically the *Kroakatoa Island* update

--------

**Zuma Blitz** was a Facebook game that used Adobe Flash, from 2010-2017. It
released on December 14, 2010. It then had a revamp in 2012, called
*Kroakatoa Island*, and was closed March 31, 2017.

This project is a collaborative effort in order for past Zuma Blitz players
to relive their 1-minute ball shooting memories.

## Prerequisites
This project uses [OpenSMCE](https://github.com/jakubg1/OpenSMCE) as it's
framework. You will then need to install [LÖVE2D 11.3](https://github.com/love2d/love/releases/tag/11.3)
on your machine.

## Running from source
Fetch the repository, as you would any other, or download the repository.

### Windows
Run `start.bat`.

### macOS
Experimental. Do the following in a terminal:
```sh
cd ZumaBlitzRemake
chmod +x ./start-macos.command
```

After that, you can double-click on `start-macos.command`.

## Building

### Windows
Make sure you have [LÖVE2D 11.3](https://github.com/love2d/love/releases/tag/11.3)
installed on your machine. 32-bit or 64-bit doesn't matter - although the build
script can detect both 32-bit and 64-bit EXE installation directories.

You will also need [7-zip](https://www.7-zip.org/download.html) and
 installed
and it's directory added in `%PATH%`.

Then, simply run `build.bat`. You will see a new folder named `build` after
it's finished. To skip creation of `*.zip` files, pass `--no-packages`.

### macOS
I unfortunately don't have a Mac, so someone else has to build these.

Follow [the instructions on the LÖVE2D wiki.](https://love2d.org/wiki/Game_Distribution#Creating_a_macOS_Application)

### Linux
As OpenSMCE uses LÖVE2D 11.3 due to 11.4's stability issues, AppImages
aren't an option. The only option for now is to run from source or
distributing a `.love` file.

## Contributing
See [CONTRIBUTING.md](/CONTRIBUTING.md).

## Why is this a fork of OpenSMCE?
Contribution reasons.

Any new features added in this fork may be added for OpenSMCE in general.

## Credits
### Project Leads
- **jakubg1** - OpenSMCE developer, lead programmer
  - GitHub: [jakubg1](https://github.com/jakubg1)
  - Discord: jakubg1#2036
- **Shambles_SM** - Sub programmer
  - GitHub: [ShamblesSM](https://github.com/ShamblesSM)
  - Twitter: [shambles_sm](https://twitter.com/shambles_sm)
  - Discord: Shambles#3117

### Contributors
- **Brendan Chan** - Zuma Blitz SWF file contribution
  - GitHub: [bchantech](https://github.com/bchantech)
- **Cat Warrior** - Asset contributions
  - GitHub: [CatWarriorOfficial](https://github.com/CatWarriorOfficial)
  - Discord: Cta warrior#4126
- **Nagi** - Asset contributions
  - GitHub: [Nxgi](https://github.com/Nxgi)
  - Discord: nagi#1547
- **FREN-ZC** - Asset fixes
  - GitHub: [FREN-ZC](https://github.com/FREN-ZC)
  - Discord: FREN-Z\C#7664
- **Tacos** - Sound ripping from videos
  - Discord: Tacos#8810
- **Glows Lythos** - Board backgrounds
  - GitHub: [glowslythos](https://github.com/glowslythos)
  - Discord: glowslythos#0001
- **Oreztov** - Wild Ball 3d cube recreation
  - GitHub: [Oreztov](https://github.com/Oreztov)
  - Discord: Oreztov#2411
