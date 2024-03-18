local sections = { 1, 2, 3, 5 }

function parseP8scii (str)
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
  return str:gsub("\\.", p8scii)
end

function stripHtml(str)
  return str:gsub("%b<>", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

function join(a, b, joiner)
  result = ""
  if (type(a) == "string" and #a > 0) then
    result = a
  end
  if (type(b) == "string" and #b > 0) then
    if (#result > 0) then
      result = result .. joiner
    end
    result = result .. b
  end
  return result
end

function findFirst(arr, finder)
  local result = nil
  for val in all(arr) do
    result = finder(val)
    if (type(result) != "nil") then
      break
    end
  end
  return result
end

function searchLocal(name, section)
  local baseManPath = '/appdata/system/man/' .. name
  local manPath = nil
  local result = nil

  local pathOfSection = function (section)
    local maybeManPath = baseManPath .. '.' .. section
    if (fstat(maybeManPath) == "file") then
      return maybeManPath
    end
  end

  if (section == nil) then
    manPath = findFirst(sections, pathOfSection)
  else
    manPath = pathOfSection(section)
  end

  if (type(manPath) == 'string') then
    result = parseP8scii(fetch(manPath))
  end

  return result
end

function searchWiki (name, manName)
  local result = nil
  -- TODO: This is brittle / based on the DOM layout
  -- Switch to https://pico-8.fandom.com/wikia.php?controller=UnifiedSearchSuggestions&method=getSuggestions&format=json&scope&query=p8scii
  -- once Picotron is fixed:
  -- 1. Has to stop forcing lowercase URLs
  -- 2. Has to stop crashing on URLs with long query strings
  local html = fetch("https://pico-8.fandom.com/wiki/Special:Search?query=" .. name)
  if (type(html) == "string" and #html > 0) then
    _, _, searchResult = string.find(html, '<li class="unified%-search__result">(.-)</li>')

    if (type(searchResult) == "string" and #searchResult > 0) then
      _, _, url, title = string.find(searchResult, '<a href="([^"]+)".-class="unified%-search__result__title".->(.-)</a>')
      _, _, blurb = string.find(searchResult, '<div class="unified%-search__result__content">(.-)</div>')

      title = stripHtml(title)
      blurb = stripHtml(blurb)

      local hasTitle = type(title) == "string" and #title > 0
      local hasBlurb = type(blurb) == "string" and #blurb > 0

      if (hasTitle or hasBlurb) then
        result = "A Wiki search for '" .. name .. "' returned:"
      end

      if (hasTitle) then
        result = join(result, "WIKI PAGE\n\t" .. join(title, url, ' - '), "\n\n")
      end
      if (hasBlurb) then
        result = join(result, "DESCRIPTION\n\t" .. blurb, "\n\n")
      end
    end
  end

  return result
end

function notFoundLocally (name)
  return "No local manual entry for " .. name .. "."
end

function notFoundOnWiki (name)
  return "No wiki manual entry for " .. name .. "."
end

local argv = env().argv

if (#argv < 1 or #argv > 2) then
  print(searchLocal("man") or "usage: man [section] name")
  exit(1)
end

local section = argv[1]
local name = argv[2]

-- Check for optional [section] parameter
if (name == nil) then
  name = section
  section = nil
end

local manual = nil
local error = nil

if (section != 'wiki') then
  manual = searchLocal(name, section)
  if (manual == nil) then
    error = notFoundLocally(name)
  end
end

if (manual == nil) then
  manual = searchWiki(name)
  if (manual == nil) then
    error = join(error, notFoundOnWiki(name), "\n")
  end
end

if (type(error) == "string" and #error > 0) then
  print(error)
end

if (type(manual) == "string" and #manual > 0) then
  print(manual)
  exit(0)
end

exit(1)
