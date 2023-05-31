data:extend{
    {
        type = "bool-setting",
        name = "cf-burner-leech",
        setting_type = "startup",
        default_value = true,
    },
    {
        type = "bool-setting",
        name = "cf-fast-replaceable-group",
        setting_type = "startup",
        default_value = true,
    },
    {
        type = "bool-setting",
        name = "cf-override-default-offset",
        setting_type = "startup",
        default_value = true,
    },
    {
        type = "int-setting",
        name = "cf-inserter-length",
        setting_type = "runtime-global",
        minimum_value = 1,
        default_value = 2,
    },
    {
        type = "int-setting",
        name = "cf-rotation-amount",
        setting_type = "runtime-per-user",
        allowed_values = {45, 90},
        default_value = 45,
    },
}