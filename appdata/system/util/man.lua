local sections = { 1, 2, 3, 5 }
local p8scii = {
  ["\\0"] = chr(0),
  ["\\*"] = chr(1),
  ["\\#"] = chr(2),
  ["\\-"] = chr(3),
  ["\\|"] = chr(4),
  ["\\+"] = chr(5),
  ["\\^"] = chr(6),
  -- Disallow audio
  --["\\a"] = chr(7),
  ["\\b"] = chr(8),
  ["\\t"] = chr(9),
  ["\\n"] = chr(10),
  ["\\v"] = chr(11),
  ["\\f"] = chr(12),
  ["\\r"] = chr(13),
  ["\\014"] = chr(14),
  ["\\015"] = chr(15)
}
local argv = env().argv

if (#argv < 1) then
  print("usage: man [section] name")
  exit(1)
end

local section = argv[1]
local name = argv[2]

if (name == nil) then
  name = section
  section = nil
  -- Search for first section match
  for searchSection in all(sections) do
    if (fstat('/appdata/system/man/' .. name .. '.' .. searchSection) == "file") then
      section = searchSection
      break
    end
  end
end

local manName = name
if (section != nil) then
  manName = manName .. '.' .. section
end

local manPath = '/appdata/system/man/' .. manName

if (fstat(manPath) == "file") then
  local manPage = fetch(manPath)
  manPage = manPage:gsub("\\.", p8scii)
  print(manPage)
  exit(0)
else
  print("No manual entry for " .. manName)
  exit(1)
end
