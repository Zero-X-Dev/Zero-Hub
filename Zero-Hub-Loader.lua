-- Zero Hub Chunk Loader for Delta
-- Fetches from: https://raw.githubusercontent.com/Zero-X-Dev/Zero-Hub/refs/heads/main/Zero-Hub.lua

local URL = "https://raw.githubusercontent.com/Zero-X-Dev/Zero-Hub/refs/heads/main/Zero-Hub.lua"

local body = game:HttpGet(URL)
if not body or body == "" then
    warn("Failed to fetch script. Check URL.")
    return
end

local chunks = {}
local marker = "--##SPLIT##--"

-- Split by marker
for part in body:gmatch("(.-)" .. marker) do
    if part:match("%S") then
        table.insert(chunks, part)
    end
end
-- Add remaining after last marker
local lastPart = body:match(marker .. "(.*)$")
if lastPart and lastPart:match("%S") then
    table.insert(chunks, lastPart)
end

print("Zero Hub Loader: Found " .. #chunks .. " chunks.")

for i, chunk in ipairs(chunks) do
    local fn, err = loadstring(chunk)
    if not fn then
        warn("Chunk " .. i .. " error: " .. err)
    else
        local success, result = pcall(fn)
        if not success then
            warn("Chunk " .. i .. " runtime error: " .. result)
        end
    end
    task.wait(0.2)  -- small delay between chunks
end

print("Zero Hub fully loaded.")
