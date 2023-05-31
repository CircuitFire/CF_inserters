
Inserter = {}

--[[
    812
    7 3
    654
]]
local rotation_table = {
    { x =  0, y = -1 },--1
    { x =  1, y = -1 },--2
    { x =  1, y =  0 },--3
    { x =  1, y =  1 },--4
    { x =  0, y =  1 },--5
    { x = -1, y =  1 },--6
    { x = -1, y =  0 },--7
    { x = -1, y = -1 },--8
}

--[[
    12
    43
]]
local offset_table = {
    { x = -0.2, y = -0.2 },--1
    { x =  0.2, y = -0.2 },--2
    { x =  0.2, y =  0.2 },--3
    { x = -0.2, y =  0.2 },--4
}

local function get_rotation(pos)
    if pos.y < 0 then
        if pos.x < 0 then
            return 8
        elseif pos.x > 0 then
            return 2
        else
            return 1
        end
    elseif pos.y > 0 then
        if pos.x < 0 then
            return 6
        elseif pos.x > 0 then
            return 4
        else
            return 5
        end
    else
        if pos.x < 0 then
            return 7
        else
            return 3
        end
    end
end

local function get_offset(pos)
    if pos.y < 0 then
        if pos.x < 0 then
            return 1
        else
            return 2
        end
    else
        if pos.x < 0 then
            return 4
        else
            return 3
        end
    end
end

local function rotate_index(index, amount, total)
    return math.fmod(math.fmod(index + amount - 1, total) + total, total) + 1
end

local function sub_coord(a, b)
    return {
        x = a.x - b.x,
        y = a.y - b.y,
    }
end

local function add_coord(a, b)
    return {
        x = a.x + b.x,
        y = a.y + b.y,
    }
end

local function mul_coord(a, b)
    return {
        x = a.x * b,
        y = a.y * b,
    }
end

local function split_drop(pos)
    local sign = 1
    if pos < 0 then sign = -1 end

    local main, offset = math.modf(pos, 1)
    local comp = math.abs(offset)

    if comp > 0.5 then
        main = main + sign          -- remove effect of shortening offset on main length
    end
        
    if comp < 0.1 or comp > .9 then -- ignore rounding error
    elseif comp < .3 then           -- longer arm
        offset = sign
    elseif comp > .7 then           -- shorter arm
        offset = sign * -1
    end

    return main, offset
end

local function positions(entity)
    local p = {
        pickup = sub_coord(entity.pickup_position, entity.position)
    }

    local temp = sub_coord(entity.drop_position, entity.position)

    local main_x, offset_x = split_drop(temp.x)
    local main_y, offset_y = split_drop(temp.y)

    p.drop = {x = main_x, y = main_y}
    p.offset = {x = offset_x, y = offset_y}
    
    return p
end

function Inserter.analyze(entity)
    local data = {}
    local positions = positions(entity)

    data.length = math.max(math.abs(positions.drop.x), math.abs(positions.drop.y))
    data.pickup = get_rotation(positions.pickup)
    data.drop   = get_rotation(positions.drop)
    data.offset = get_offset(positions.offset)

    return data
end

local function get_absolute_pickup_pos(entity, data)
    return add_coord(
        mul_coord(rotation_table[data.pickup], data.length),
        entity.position
    )
end

local function get_drop_pos(data)
    return add_coord(
        mul_coord(rotation_table[data.drop], data.length),
        offset_table[data.offset] 
    )
end

local function get_absolute_drop_pos(entity, data)
    return add_coord(
        get_drop_pos(data),
        entity.position
    )
end

function Inserter.offset_change(old, new)
    return math.floor((new - old) / 2) + (old % 2)
end

function Inserter.rotate_pickup(entity, amount)
    if amount == 0 then return end
    local data = Inserter.analyze(entity)
    data.pickup = rotate_index(data.pickup, amount, 8)

    entity.pickup_position = get_absolute_pickup_pos(entity, data)
end

function Inserter.rotate_drop(entity, amount)
    if amount == 0 then return end
    local data = Inserter.analyze(entity)
    new = rotate_index(data.drop, amount, 8)

    local offset = Inserter.offset_change(data.drop, new)
    data.drop = new
    data.offset = rotate_index(data.offset, offset, 4)
    
    entity.drop_position = get_absolute_drop_pos(entity, data)
end

function Inserter.rotate_offset(entity, amount)
    if amount == 0 then return end
    local data = Inserter.analyze(entity)
    data.offset = rotate_index(data.offset, amount, 4)

    entity.drop_position = get_absolute_drop_pos(entity, data)
end

function Inserter.rotate_length(entity, amount)
    if amount == 0 then return end
    local data = Inserter.analyze(entity)
    data.length = rotate_index(data.length, amount, settings.startup["cf-inserter-length"].value)

    entity.pickup_position = get_absolute_pickup_pos(entity, data)
    entity.drop_position = get_absolute_drop_pos(entity, data)
end

function Inserter.default_offset(prototype)
    local main_x, offset_x = split_drop(prototype.insert_position[1])
    local main_y, offset_y = split_drop(prototype.insert_position[2])

    local pos = {x = main_x, y = main_y}

    local drop = get_rotation(pos)
    local data = {
        drop   = drop,
        offset = math.ceil(drop / 2),
        length = math.max(pos.x, pos.y)
    }
    
    return get_drop_pos(data)
end