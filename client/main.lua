local cfg <const>, menu, index, isOpen, Npc, basket, category, total, blips, iter = Config, {}, {}, false, {}, {}, "", 0, {}, 1

-- menu part
local function CreateMenu(key)
    local set = {}
    index.method, index.iMethod = {}, 1

    set.title = cfg.Menu[key] and cfg.Menu[key]?.title or cfg.Menu.default.title
    set.subtitle = cfg.Menu[key] and cfg.Menu[key]?.subtitle or cfg.Menu.default.subtitle
    set.color = cfg.Menu[key] and cfg.Menu[key]?.color or cfg.Menu.default.color
    set.glare = cfg.Menu[key] and cfg.Menu[key]?.glare or cfg.Menu.default.glare
    set.font = cfg.Menu[key] and cfg.Menu[key]?.font or cfg.Menu.default.font
    set.texture = {dict = cfg.Menu[key] and cfg.Menu[key]?.texture.dict or cfg.Menu.default.texture.dict, name = cfg.Menu[key] and cfg.Menu[key]?.texture.name or cfg.Menu.default.texture.name}
    set.pos = {x = cfg.Menu[key] and cfg.Menu[key]?.pos.x or cfg.Menu.default.pos.x, y = cfg.Menu[key] and cfg.Menu[key]?.pos.y or cfg.Menu.default.pos.y}

    menu.main = RageUI.CreateMenu(set.title, set.subtitle, set.pos.x, set.pos.y, set.texture.dict, set.texture.name)
    menu.sub = RageUI.CreateSubMenu(menu.main, set.title, set.subtitle, set.pos.x, set.pos.y, set.texture.dict, set.texture.name)
    menu.payment = RageUI.CreateSubMenu(menu.main, set.title, set.subtitle, set.pos.x, set.pos.y, set.texture.dict, set.texture.name)

    menu.main.Closed = function() isOpen = false end

    for _,v in pairs(menu) do
        v:SetRectangleBanner(set.color[1], set.color[2], set.color[3], set.color[4])
        v:DisplayGlare(set.glare)
        v.TitleFont = set.font
    end

    if cfg.Shop.money[key]['money'] then index.method[#index.method+1] = {Name = "~g~Liquide~s~", Value = 'money'} end
    if cfg.Shop.money[key]['bank'] then index.method[#index.method+1] = {Name = "~b~Banque~s~", Value = 'bank'} end
    if cfg.Shop.money[key]['black_money'] then index.method[#index.method+1] = {Name = "~r~Argent sale~s~", Value = 'black_money'} end

    isOpen = true
end

index.basket = {'Ajoutez', 'Retirer'}

local function AddBasket(item, count)
    local time = GetGameTimer()
    CreateThread(function()
        while true do
            Wait(0)
            supv.draw.text2d(('~y~Ajoutez au panier :\n~w~%s +%s'):format(item, count), 1500, 900, 0, 0.75, {255,255,255,255})
            if (GetGameTimer() - time) > 2000 then return false end
        end
    end)
end

local function OpenShop(key)
    CreateMenu(key)
    basket, iter, maxIter = {}, 1, 1
    RageUI.Visible(menu.main, true)
    CreateThread(function()
        while isOpen do
            Wait(0)
            
            RageUI.IsVisible(menu.main, function()
                for i = 1, #cfg.Shop.orderCategory[key] do
                    local label_cat = cfg.Shop.orderCategory[key][i]
                    RageUI.Button(cfg.Shop.category[key][label_cat], nil, {}, true, {
                        onSelected = function()
                            category = label_cat
                            menu.sub:SetSubtitle(cfg.Shop.category[key][label_cat])
                        end
                    }, menu.sub)
                end
                RageUI.Line()
                RageUI.Button("Panier", nil, {}, next(basket) ~= nil, {
                    onSelected = function() 
                        index.iMethod, index.ibasket, total = 1, 1, 0
                        for _,v in pairs(basket) do
                            total += (v.price*v.count)
                        end
                    end
                }, menu.payment)
            end)

            RageUI.IsVisible(menu.sub, function()
                if cfg.Shop.items[key][category] then
                    for k,v in pairs(cfg.Shop.items[key][category]) do
                        RageUI.Button(v.label, nil, {RightLabel = ("%s~g~$"):format(v.price)}, true, {
                            onSelected = function()
                                local quantity = tonumber(supv.keyboard.input("Montant", nil, 20))
                                if quantity and math.type(quantity) == 'integer' and quantity > 0 then
                                    if not basket[k] then basket[k] = {} end
                                    basket[k].label, basket[k].category, basket[k].price = v.label, category, v.price
                                    if basket[k].count then basket[k].count += quantity else basket[k].count = quantity end
                                    AddBasket(v.label, quantity)
                                end
                            end
                        })
                    end
                end
            end)

            RageUI.IsVisible(menu.payment, function()
                if not next(basket) then RageUI.GoBack() else
                    for k,v in pairs(basket) do
                        RageUI.List(("%s - (x%s)"):format(v.label, v.count), index.basket, index.ibasket, ("Catégorie: %s"):format(v.category), {RightLabel = ("%s~g~$"):format(v.price*v.count)}, true, {
                            onListChange = function(Index) index.ibasket = Index end,
                            onSelected = function(Index)
                                if Index == 1 then -- add
                                    local quantity = tonumber(supv.keyboard.input("Montant", nil, 20))
                                    if quantity and math.type(quantity) == 'integer' and quantity > 0 then
                                        basket[k].count += quantity
                                        total += (quantity*basket[k].price)
                                    end
                                elseif Index == 2 then -- remove
                                    local quantity = tonumber(supv.keyboard.input("Montant", nil, 20))
                                    if quantity and math.type(quantity) == 'integer' and quantity > 0 then
                                        if quantity >= basket[k].count then
                                            total -= (basket[k].count*basket[k].price)
                                            basket[k] = nil
                                        elseif quantity < basket[k].count then
                                            total -= (quantity*basket[k].price)
                                            basket[k].count -= quantity 
                                        end
                                    end
                                end
                            end
                        })
                    end
                end
                RageUI.Line()
                RageUI.List("Mode de paiement", index.method, index.iMethod, nil, {}, true, {onListChange = function(Index) index.iMethod = Index end})
                RageUI.Button(("Payez %s~g~$ ~s~en %s"):format(total, string.lower(index.method[index.iMethod].Name)), nil, {}, true, {
                    onSelected = function()
                        RageUI.Visible(menu.payment, false)
                        supv.draw.progressbar('Achat en cours', 5000, {
                            canCancel = true,
                            textCancel = "Vous avez annulé l'achat",
                            showCancelStatus = true,
                            timeCancel = 4000,
                            freeze = true
                        }, {}, {
                            success = function()
                                ESX.TriggerServerCallback('supv_shops:buy', function(can, err)
                                    if can then
                                        supv.notification.simple('Achat avec succès')
                                        isOpen = false
                                    else
                                        if err == 1 then
                                            supv.notification.simple("Vous n'avez pas assez d'argent")
                                        elseif err == 2 then
                                            supv.notification.simple("Votre inventaire ne peut pas contenir tout ce qu'il y a dans votre panier")
                                        end
                                    end
                                end, index.method[index.iMethod].Value, basket, total, key)
                            end,
                            cancel = function()
                                RageUI.Visible(menu.payment, true)
                            end
                        })
                    end
                })
            end)
        end
        menu.main = RMenu.DeleteType(menu.main, true)
        menu = {}
    end)
end

-- create blips
for k,v in pairs(cfg.Shop.coords) do
    if cfg.Blips[k] then
        if not blips[k] then blips[k] = {} end
        blips[k] = supv.blips.new(v, cfg.Blips[k])
    end
end

-- shop part (npc/action)
CreateThread(function()
    local player, sleep, distance, coord, dist = supv.player.get()
    while true do
        sleep = 800
        if not player:currentVehicle() then
            for k,v in pairs(cfg.Shop.coords) do
            
                -- coords part
                for i = 1, #v do
                    distance = player:distance(v[i])
                    coord = v[i]

                    -- Npc part
                    if distance < 30 then
                        if cfg.Npc[k] then
                            if not Npc[k] then Npc[k] = {} end
                            if not Npc[k][i] then
                                if cfg.Npc[k][i] then
                                    Npc[k][i] = supv.npc.unNet(cfg.Npc[k][i].model, cfg.Npc[k][i].coords, cfg.Npc[k][i].data or nil, cfg.Npc[k][i].weapon or nil)
                                end
                            end
                        end
                    elseif distance > 30 and Npc[k] and Npc[k][i] then
                        Npc[k][i] = Npc[k][i]:remove()
                    end

                    -- Action part
                    if distance < 10 then sleep = 0
                
                        if not next(menu) and not isOpen then
                            supv.marker.show(coord, cfg.Marker[k] or cfg.Marker.default)
                        end
                        
                        if distance < 2 and not next(menu) and not isOpen then
                            supv.draw.text3d(coord, cfg.Text3D[k] and cfg.Text3D[k]?.message or cfg.Text3D.default.message, cfg.Text3D[k] or cfg.Text3D.default)
                            if IsControlJustPressed(0, 38) then
                                OpenShop(k)
                            end
                        elseif distance > 2 and next(menu) and isOpen then
                            menu.main.Closed()
                        end
                    end
                end
            end
        else
            if next(menu) and isOpen then
                menu.main.Closed()
            end
        end

        Wait(sleep)
    end
end)

-- type of command to remove blip
RegisterCommand('removeB', function()
    for k,v in pairs(blips) do
        if k == 'weaponShop' then
            for i = 1, #blips[k] do
                local blip = blips[k][i]
                blip:remove()
            end
        end 
    end
end)