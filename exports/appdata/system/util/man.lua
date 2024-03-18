include "../lib/man.lua"

local argv = env().argv

if (#argv < 1 or #argv > 2) then
  print(man("man", 1) or "usage: man [section] name")
  exit(1)
end

local section = argv[1]
local name = argv[2]

-- Check for optional [section] parameter
if (name == nil) then
  name = section
  section = nil
end

local out, err = man(name, section)

if (err != nil) then
  print(err)
  exit(1)
end

print(out)
exit(0)
