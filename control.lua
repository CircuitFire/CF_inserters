require("gui")
require("inserter")

local function entity(event)
    return game.players[event.player_index].selected
end

local function is_inserter(entity)
    if not entity then return false end
    if entity.type == "inserter" then return true end
    if entity.type == "entity-ghost" and entity.ghost_type == "inserter" then return true end
    return false
end

script.on_event(defines.events.on_gui_opened, function(event)
    if event.gui_type ~= defines.gui_type.entity then return end
    if not is_inserter(event.entity) then return end

    Gui.open(event)
end)

script.on_event(defines.events.on_gui_closed, function(event)
    if event.gui_type ~= defines.gui_type.entity then return end
    if not is_inserter(event.entity) then return end

    Gui.close(event)
end)

local function rotation(event)
    return settings.get_player_settings(event.player_index)["cf-rotation-amount"].value / 45
end

script.on_event("cf-drop-position", function(event)
    local entity = entity(event)
    if not is_inserter(entity) then return end

    Inserter.rotate_drop(entity, rotation(event))
    Gui.update(event, entity)
end)

script.on_event("cf-drop-position-r", function(event)
    local entity = entity(event)
    if not is_inserter(entity) then return end

    Inserter.rotate_drop(entity, -rotation(event))
    Gui.update(event, entity)
end)

script.on_event("cf-pickup-position", function(event)
    local entity = entity(event)
    if not is_inserter(entity) then return end

    Inserter.rotate_pickup(entity, rotation(event))
    Gui.update(event, entity)
end)

script.on_event("cf-pickup-position-r", function(event)
    local entity = entity(event)
    if not is_inserter(entity) then return end

    Inserter.rotate_pickup(entity, -rotation(event))
    Gui.update(event, entity)
end)

script.on_event("cf-drop-offset", function(event)
    local entity = entity(event)
    if not is_inserter(entity) then return end
    
    Inserter.rotate_offset(entity, 1)
    Gui.update(event, entity)
end)

script.on_event("cf-drop-offset-r", function(event)
    local entity = entity(event)
    if not is_inserter(entity) then return end

    Inserter.rotate_offset(entity, -1)
    Gui.update(event, entity)
end)

script.on_event("cf-length", function(event)
    local entity = entity(event)
    if not is_inserter(entity) then return end

    Inserter.rotate_length(entity, 1)
    Gui.update(event, entity)
end)

script.on_event("cf-length-r", function(event)
    local entity = entity(event)
    if not is_inserter(entity) then return end

    Inserter.rotate_length(entity, -1)
    Gui.update(event, entity)
end)