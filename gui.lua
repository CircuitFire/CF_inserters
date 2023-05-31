require("inserter")

Events = {
    gui_click = {},
}

local function handel_event(event, type)
    local func = Events[type][event.element.tags.func]
    if func ~= nil then func(event) end
end

script.on_event(defines.events.on_gui_click, function(event)
    handel_event(event, "gui_click")
end)

Gui = {}

local function globe(event)
    return global[event.player_index]
end

local function player(event)
    return game.get_player(event.player_index)
end

local pos_to_offset = {
    "1","2","4","3"
}

local function update_offset_table(globe, old)
    if old then
        globe.offset_table[pos_to_offset[old.offset]].sprite = nil
    end

    globe.offset_table[pos_to_offset[globe.data.offset]].sprite = "utility/indication_arrow"
end

--[[
    12
    43
]]
local function init_offset_table(globe)
    local buttons = {
        1, 2, 4, 3
    }

    for i, button in pairs(buttons) do
        globe.offset_table.add{
            type = "sprite-button",
            name = tostring(i),
            tags={func="update_offset", pos=button}
        }
    end
end

function Events.gui_click.update_offset(event)
    local globe = globe(event)
    local inserter = globe.inserter

    Inserter.rotate_offset(inserter, event.element.tags.pos - globe.data.offset)

    local old = globe.data
    globe.data = Inserter.analyze(inserter)
    update_offset_table(globe, old)
end

local pos_to_main = {
    "2","3","6","9","8","7","4","1"
}

local function update_main_table(globe, old)
    globe.main_table["5"].number = globe.data.length

    if old then
        globe.main_table[pos_to_main[old.pickup]].sprite = nil
        globe.main_table[pos_to_main[old.drop]].sprite =   nil
    end

    if globe.data.pickup == globe.data.drop then
        globe.main_table[pos_to_main[globe.data.pickup]].sprite = "pickup-drop"
    else
        globe.main_table[pos_to_main[globe.data.pickup]].sprite = "utility/indication_line"
        globe.main_table[pos_to_main[globe.data.drop]].sprite = "utility/indication_arrow"
    end

    update_offset_table(globe, old)
end

--[[
    812
    7 3
    654
]]
local function init_main_table(globe)
    local buttons = {
        {func="update_position", pos=8},--1
        {func="update_position", pos=1},--2
        {func="update_position", pos=2},--3
        {func="update_position", pos=7},--4
        {func="update_length", sprite="item/inserter"},--5
        {func="update_position", pos=3},--6
        {func="update_position", pos=6},--7
        {func="update_position", pos=5},--8
        {func="update_position", pos=4},--9
    }
    
    for i, button in pairs(buttons) do
        globe.main_table.add{
            type = "sprite-button",
            name = tostring(i),
            number = button.len,
            sprite = button.sprite,
            tags={func=button.func, pos=button.pos},
        }
    end
end

function Events.gui_click.update_position(event)
    local globe = globe(event)
    local pos = event.element.tags.pos
    local inserter = globe.inserter

    if event.button == defines.mouse_button_type.left then
        Inserter.rotate_drop(inserter, pos - globe.data.drop)
    else
        Inserter.rotate_pickup(inserter, pos - globe.data.pickup)
    end

    local old = globe.data
    globe.data = Inserter.analyze(inserter)
    update_main_table(globe, old)
end

function Events.gui_click.update_length(event)
    local globe = globe(event)
    local inserter = globe.inserter

    if event.button == defines.mouse_button_type.left then
        Inserter.rotate_length(inserter, 1)
    else
        Inserter.rotate_length(inserter, -1)
    end

    globe.data = Inserter.analyze(inserter)
    update_main_table(globe, old)
end

function Gui.open(event)
    local player = player(event)
    global[event.player_index] = {}
    local globe = globe(event)

    globe.inserter = event.entity
    globe.data = Inserter.analyze(event.entity)
    
    globe.gui = player.gui.relative.add{
        type = "frame",
        direction = "vertical",
        anchor = {
            gui = defines.relative_gui_type.inserter_gui,
            position = defines.relative_gui_position.right,
        },
    }

    globe.gui.add{
        type = "label",
        caption = {"cf-inserters.rotation"},
    }

    local main_flow = globe.gui.add{
        type = "frame",
        direction = "vertical",
        style = "entity_frame",
    }
    main_flow.style.minimal_width = 0

    globe.main_table = main_flow.add{
        type = "table",
        column_count = 3,
    }
    init_main_table(globe)

    globe.gui.add{
        type = "label",
        caption = {"cf-inserters.offset"},
    }

    local offset_flow = globe.gui.add{
        type = "frame",
        direction = "vertical",
        style = "entity_frame",
    }
    offset_flow.style.minimal_width = 0

    globe.offset_table = offset_flow.add{
        type = "table",
        column_count = 2
    }
    init_offset_table(globe)
    
    update_main_table(globe)
end

function Gui.close(event)
    if not global[event.player_index] then return end
    global[event.player_index].gui.destroy()
    global[event.player_index] = nil
end

function Gui.update(event, entity)
    local globe = globe(event)
    if not globe then return end

    local old = globe.data
    globe.data = Inserter.analyze(entity)
    update_main_table(globe, old)
end