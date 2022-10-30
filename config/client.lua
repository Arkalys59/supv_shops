Config.Menu = {
    ['default'] = {
        title = "Magasin",
        subtitle = "Selection",
        color = {0,0,0,200},
        glare = false,
        font = 1,
        texture = {dict = nil, name = nil},
        pos = {x = nil, y = nil}
    },

}

Config.Marker = {
    ['default'] = {
        visible = true,
        id = 27,
        z = -0.99,
        color1 = {6,34,86,100},
        dir = {0.0,0.0,0.0},
        rot = {0.0,0.0,0.0},
        scale = {2.0,2.0,2.0},
        updown = false,
        faceToCam = false,
        rotate = false,
        textureDict = nil,
        textureName = nil,
    },
}

Config.Text3D = {
    ['default'] = {
        message = "Appuyez sur ~r~[~w~E~r~]",
        police = 0, -- font
        color_rect1 = {0,0,0,200}, -- or nil
        color_rect2 = {0,200,0,200}, -- or nil
        z = 1
    },
}

Config.Blips = {
    ['weaponShop'] = {
        label = 'weapon shop',
        color = 51,
        sprite = 71,
        scale = 1.0,
        range = false,
    },

    ['shop'] = {
        label = '24/7',
        color = 25,
        sprite = 59,
        scale = 1.0,
        range = false
    }
}

Config.Npc = {
    ['shop'] = { -- ici il faut respecter l'ordre des coordonnées que vous avez mit dans Config.Shop.coords
        {model = `a_f_m_beach_01`, coords = vec4(373.8, 325.8, 103.5-1, 1.0)},
        {model = `a_f_m_beach_01`, coords = vec4(2557.4, 382.2, 108.6-1, 1.0)},
        {model = `a_f_m_beach_01`, coords = vec4(-3038.9, 585.9, 7.9-1, 1.0)},
        {model = `a_f_m_beach_01`, coords = vec4(-3241.9, 1001.4, 12.8-1, 1.0)},
        {model = `a_f_m_beach_01`, coords = vec4(547.4, 2671.7, 42.1-1, 1.0)},
        {model = `a_f_m_beach_01`, coords = vec4(1961.4, 3740.6, 32.3-1, 1.0)},
        {model = `a_f_m_beach_01`, coords = vec4(2678.9, 3280.6, 55.2-1, 1.0)},
        {model = `a_f_m_beach_01`, coords = vec4(1729.2, 6414.1, 35.0-1, 1.0)},
        {model = `a_f_m_fatcult_01`, coords = vec4(26.074829, -1346.379272, 29.497028-1, 1.0)},
    }
}