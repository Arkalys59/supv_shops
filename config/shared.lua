Config.Shop = {

    coords = {
        ['weaponShop'] = {
            vec3(-662.1, -935.3, 20.8),
			vec3(810.2, -2157.3, 28.6),
			vec3(1693.4, 3759.5, 33.7),
			vec3(-330.2, 6083.8, 30.4),
			vec3(252.3, -50.0, 68.9),
			vec3(22.0, -1107.2, 28.8),
			vec3(2567.6, 294.3, 107.7),
			vec3(-1117.5, 2698.6, 17.5),
			vec3(842.4, -1033.4, 27.1)
        },

        ['shop'] = {
			vec3(373.8, 325.8, 103.5),
			vec3(2557.4, 382.2, 108.6),
			vec3(-3038.9, 585.9, 7.9),
			vec3(-3241.9, 1001.4, 12.8),
			vec3(547.4, 2671.7, 42.1),
			vec3(1961.4, 3740.6, 32.3),
			vec3(2678.9, 3280.6, 55.2),
			vec3(1729.2, 6414.1, 35.0),
            vec3(26.074829, -1346.379272, 29.497028)
        },

        --[[
        ['robsliquor'] = {
            vec3(1135.8, -982.2, 46.4),
			vec3(-1222.9, -906.9, 12.3),
			vec3(-1487.5, -379.1, 40.1),
			vec3(-2968.2, 390.9, 15.0),
			vec3(1166.0, 2708.9, 38.1),
			vec3(1392.5, 3604.6,  34.9),
			vec3(127.8,  -1284.7, 29.2), --StripClub
			vec3(-1393.4, -606.6, 30.3), --Tequila la
			vec3(-559.9, 287.0, 82.1) --Bahamamas
        },

        ['ltd'] = {
            vec3(-48.5,  -1757.5, 29.4),
			vec3(1163.3, -323.8, 69.2),
			vec3(-707.5, -914.2, 19.2),
			vec3(-1820.5, 792.5, 138.1),
			vec3(1698.3, 4924.4, 42.0)
        } 
        --]]
    },

    category = {
        ['weaponShop'] = {
            ['melee'] = "Arme blanche",
            ['pistol'] = "Pistolet"
        },

        ['shop'] = {
            ['food'] = "Nourriture",
            ['drink'] = "Boisson (sans alcool)",
            ['alcool'] = "Boisson (avec alcool)"
        }
    },

    orderCategory = {
        ['weaponShop'] = {'melee', 'pistol'},
        ['shop'] = {'food', 'drink', 'alcool'}
    },

    items = {
        ['weaponShop'] = {
            ['pistol'] = {
                ['weapon_pistol'] = {label = 'Pistolet', price = 500},
            },
            ['melee'] = {
                ['weapon_knife'] = {label = 'Couteau', price = 500}
            }                
        },

        ['shop'] = {
            ['food'] = {
                ['burger'] = {label = 'Burger', price = 10},
            },
            ['drink'] = {
                ['water'] = {label = 'Eau', price = 2},
            },
            ['alcool'] = {
                ['beer'] = {label = 'Bière', price = 25},
            }
        }
    },

    money = {
        ['weaponShop'] = {['bank'] = true, ['money'] = true, ['black_money'] = false},
        ['shop'] = {['bank'] = true, ['money'] = true, ['black_money'] = false},
    }
}