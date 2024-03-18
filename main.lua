-- man pages for picotron
-- by Jess Telford
include "./exports/appdata/system/lib/man.lua"

local LEFT_COLUMN = 95
local RIGHT_COLUMN = 280
local CENTER = 480 / 2
local title = "\^w\^tPICOTRON'S MISSING MAN PAGES\^-w\^-t"
local manMan, err = man('man', 1, './exports/appdata/system/man/')
local space = string.rep(" ", 50)
space = space:rep(20, "\n")
function _draw()
  cls(5)
  print(title, CENTER - #title * 4, 40, 23)
  print("")
  print("Installation", LEFT_COLUMN)
  print("")
  print("  1. Setup yotta:")
  print("    - In the terminal")
  print("    - > \^iload #yotta\^-i")
  print("    - Press Ctrl-r")
  print("    - Press x to install")
  print("")
  print("  2. Install this package:")
  print("    - In the terminal")
  print("    - > \^iyotta util install #man\^-i")
  print("")
  print("Usage", RIGHT_COLUMN, 74)
  print("")
  print("  - In the terminal")
  print("  - > \^iman man\^-i")
  print("")
  print("    \f7\#0\^h" .. space .. "\^g" .. manMan)
end
