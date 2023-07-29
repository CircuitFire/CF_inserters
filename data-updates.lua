require("inserter")

--try and filter out weird modded inserters
local function normal_inserter(i)
    return (
        i.draw_held_item ~= false
        and i.draw_inserter_arrow ~= false
        and math.floor(math.abs(i.pickup_position[1])) == math.floor(math.abs(i.insert_position[1]))
        and math.floor(math.abs(i.pickup_position[2])) == math.floor(math.abs(i.insert_position[2]))
        and (i.collision_box[2][1] - i.collision_box[1][1]) < 1
    )
end

local leech = settings.startup["cf-burner-leech"].value
local fast_replace = settings.startup["cf-fast-replaceable-group"].value
local override_offset = settings.startup["cf-override-default-offset"].value

for _, inserter in pairs(data.raw.inserter) do
    if normal_inserter(inserter) then
        inserter.allow_custom_vectors = true
        inserter.allow_burner_leech = leech
        if fast_replace and inserter.fast_replaceable_group == "long-handed-inserter" then
            inserter.fast_replaceable_group = "inserter"
        end
        if override_offset then
            inserter.insert_position = Inserter.default_offset(inserter)
        end
        inserter.extension_speed = inserter.rotation_speed * 8
    end
end
