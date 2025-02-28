addon.name = "spellsea"
addon.author = "ggVGsVivi"
addon.version = "1.0"
addon.desc = "An addon to relatively quickly use any ability/spell without text commands or menuing."
addon.link = ""

local ffi = require("ffi")
local imgui = require("imgui")

require("direct")

-- both abilities and spells are in abilities cause i said so
local allAbilities = {}
local abilities = {}
local filteredAbilities = {}

local typing = false
local searchTerm = ""

local abilityTypes = {
    [1] = "ja",
    [2] = "pet",
    [3] = "ws",
    [18] = "pet",
}

function getAllAbilities ()
    allAbilities = {}
    for id = 0, 2048 do  -- crime against all that is holy
        local abt = AshitaCore:GetResourceManager():GetAbilityById(id)
        if abt and abt.Type ~= 4 then -- 4 = trait
            allAbilities[#allAbilities + 1] = {
                id = id,
                name = abt.Name[3],
                sname = abt.Name[3]:lower():gsub("%s+", ""),
                cmd = abilityTypes[abt.Type],
                targets = abt.Targets,
            }
        end
        local spl = AshitaCore:GetResourceManager():GetSpellById(id)
        if spl then
            allAbilities[#allAbilities + 1] = {
                id = id + 10000, -- 10k just to be sure
                name = spl.Name[3],
                sname = spl.Name[3]:lower():gsub("%s+", ""),
                cmd = "ma",
                targets = spl.Targets,
            }
        end
    end
    table.sort(allAbilities, function (x, y) return x.name < y.name end)
end

function refreshAbilities ()
    abilities = {}
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    for i = 1, #allAbilities do
        local abt = allAbilities[i]
        if player:HasWeaponSkill(abt.id) then
            abilities[#abilities + 1] = abt
        elseif player:HasPetCommand(abt.id) then
            abilities[#abilities + 1] = abt
        elseif player:HasAbility(abt.id) then
            abilities[#abilities + 1] = abt
        elseif player:HasSpell(abt.id - 10000) then
            local spl = AshitaCore:GetResourceManager():GetSpellById(abt.id - 10000)
            local mjReq = spl.LevelRequired[player:GetMainJob() + 1]
            local sjReq = spl.LevelRequired[player:GetSubJob() + 1]
            if (mjReq ~= -1 and mjReq <= player:GetMainJobLevel())
            or (sjReq ~= -1 and sjReq <= player:GetSubJobLevel()) then
                abilities[#abilities + 1] = abt
            end
        end
    end
end

function updateFilter (toFilter)
    local newFiltered = {}
    for i = 1, #toFilter do
        local abt = toFilter[i]
        if abt.sname:find(searchTerm) then
            newFiltered[#newFiltered + 1] = abt
        end
    end
    filteredAbilities = newFiltered
end

function getTargetMode (abt)
    -- 000001 = warp (self)
    -- 011101 = protect (friendlies? + alliance? + party + self)
    -- 100000 = fire (enemy)
    -- 000101 = sneak (party + self)
    if abt.targets >= 1 and abt.targets < 4 then
        return "<me>"
    elseif abt.targets == 32 then
        return "<stnpc>"
    elseif abt.targets >= 4 and abt.targets < 8 then
        return "<stpt>"
    elseif abt.targets < 32 then
        return "<stpc>"
    else
        return "<st>"
    end
end

function executeCommand (n)
    if n == 0 then n = 10 end
    local abt = filteredAbilities[n]
    if abt then
        local command = "/" .. abt.cmd .. " \"" .. abt.name .. "\" " .. getTargetMode(abt)
        AshitaCore:GetChatManager():QueueCommand(-1, command)
    end
    typing = false
end

local keyMap = {}
keyMap[0x1b] = function (k) -- Esc = exit
    typing = false
end
for i = 0x30, 0x39 do -- 0..9
    keyMap[i] = function (k)
        local c = string.char(k):lower()
        executeCommand(tonumber(c))
    end
end
keyMap[0x0d] = function (k) -- Enter = 1
    executeCommand(1)
end
for i = 0x41, 0x5a do -- a..z
    keyMap[i] = function (k)
        local c = string.char(k):lower()
        searchTerm = searchTerm .. c
        updateFilter(filteredAbilities)
    end
end
keyMap[0x08] = function (k)  -- Backspace
    searchTerm = searchTerm:sub(1, searchTerm:len() - 1)
    updateFilter(abilities)
end

ashita.events.register("command", "command_callback1", function (e)
    if (e.command == "/spellsea") then
        if typing then
            typing = false
        else
            typing = true
            searchTerm = ""
            refreshAbilities()
            for i = 1, #abilities do
                filteredAbilities[i] = abilities[i]
            end
        end
        e.blocked = true;
    end
end)

ashita.events.register("key", "key_callback1", function (e)
    if e.lparam >= 2^31 then -- sin
        return
    end
    if keyMap[e.wparam] then
        e.blocked = true
        keyMap[e.wparam](e.wparam)
    end
end)

ashita.events.register("key_data", "key_data_callback1", function (e)
    if typing then
        local t = translate(e.key)
        if t:len() == 1 and keyMap[t:byte()] then
            e.blocked = true
        end
    end
end)

ashita.events.register("key_state", "key_state_callback1", function (e)
    local ptr = ffi.cast("uint8_t*", e.data_raw)
    if typing then
        for i = 1, 256 do -- i'm honestly just guessing that there's 256 of these
            local t = translate(i)
            if t and t:len() == 1 and keyMap[t:byte()] then
                ptr[i] = 0
            end
        end
    end
end)

ashita.events.register("d3d_present", "present_callback1", function ()
    if not typing then
        return
    end
    imgui.SetNextWindowBgAlpha(0.6)
    imgui.SetNextWindowSize({ 192, -1 }, ImGuiCond_Always)
    if imgui.Begin(
        "SpellSea",
        typing,
        bit.bor(
            ImGuiWindowFlags_NoDecoration,
            ImGuiWindowFlags_AlwaysAutoResize,
            ImGuiWindowFlags_NoFocusOnAppearing,
            ImGuiWindowFlags_NoNav
        )
    ) then
        imgui.Text(searchTerm)
        imgui.Separator()
        for i = 1, 10 do
            if i > #filteredAbilities then
                break
            end
            local si = i
            if si == 10 then si = 0 end
            imgui.Text(si .. "   " .. filteredAbilities[i].name)
        end
    end
    imgui.End()
end)

ashita.events.register("load", "load_callback1", function ()
    getAllAbilities()
    refreshAbilities()
end)
