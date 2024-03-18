The missing man pages for Lexaloffle's [Picotron fantasy workstation](https://www.lexaloffle.com/picotron.php).

# Installation

1. Setup yotta:

   - In the terminal
   - `load #yotta`
   - Press Ctrl-r
   - Press x to install

2. Install this package:
   - In the terminal
   - `yotta util install #man`

This will install the following files for you:

```
appdata
└── system
    ├── lib
    │   └── man.lua  # The `man()` function for library usage
    ├── man/         # Man files live here
    └── util
        └── man.lua  # The `man` terminal utility
```

# Usage

In the Picotron terminal, run `man`.

```
NAME
    man -- format and display the manual pages

SYNOPSIS
    man [section] name

DESCRIPTION
    man formats and displays the manual pages. If you specify section, man only looks in that section of the manual. name is normally the name of the manual page, which is typically the name of a command, function, or file.

    See below for a description of where man looks for the manual page files.

MANUAL SECTIONS
    The standard sections of the manual include:

    1        User Commands from /appdata/system/util

    2        System Calls such as fetch

    3        Picotron Lua Library Functions

    wiki    Wiki pages from https://pico-8.fandom.com

P8SCII FORMATTING
    man understands most of p8scii formatting. The \a command to play audio is not supported.

SEARCH PATH FOR MANUAL PAGES
    man searches /appdata/system/man for local manual pages in the format <name>.<section>.

WIKI PAGES
    When section is 'wiki', or local manual pages are not found, man will return the first search result from the unofficial PICO-8 wiki: https://pico-8.fandom.com

AUTHOR
    Created by Jess Telford <hi+picotron@jes.st>
```

# Contributing

PRs welcome! ❤️

When creating new man pages in `appdata/system/man`, be sure to use the correct
section number (see above)

## TODO

- [ ] Add support for section 4: `Special files` (eg; `/ram/cart`, etc)
- [ ] `pwd.3` manual page
- [ ] `fetch.2` manual page
- [ ] `open.2` manual page
- [ ] `print.2` manual page
- ... etc
