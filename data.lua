data:extend{
    {
        type = "custom-input",
        name = "cf-drop-position",
        key_sequence = "CONTROL + E",
    },
    {
        type = "custom-input",
        name = "cf-drop-position-r",
        key_sequence = "",
    },

    {
        type = "custom-input",
        name = "cf-pickup-position",
        key_sequence = "CONTROL + R",
    },
    {
        type = "custom-input",
        name = "cf-pickup-position-r",
        key_sequence = "",
    },

    {
        type = "custom-input",
        name = "cf-drop-offset",
        key_sequence = "CONTROL + F",
    },
    {
        type = "custom-input",
        name = "cf-drop-offset-r",
        key_sequence = "",
    },

    {
        type = "custom-input",
        name = "cf-length",
        key_sequence = "SHIFT + F",
    },
    {
        type = "custom-input",
        name = "cf-length-r",
        key_sequence = "",
    },
}

data:extend{
    {
        type = "sprite",
        name = "pickup-drop",
        height = 64,
        width  = 64,
        scale = 0.5,
        layers = {
            {
                filename = "__core__/graphics/arrows/indication-arrow.png",
                height = 64,
                width  = 64,
                scale = 0.5,
                shift = { 0, -10 }
            },
            {
                filename = "__core__/graphics/arrows/indication-line.png",
                height = 64,
                width  = 64,
                scale = 0.5,
                shift = { 0, 10 }
            },
        }
    },
}