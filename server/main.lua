local ox_inv <const>, cfg <const> = exports.ox_inventory, Config

local function SendToWebhook(player, reason, types, style, title)
    if cfg.Webhook.active or #cfg.Webhook.url > 10 then
        if types == 'message' then
            supv.webhook.message(cfg.Webhook.url, reason, style.bot_name)
        elseif types == 'embed' then
            supv.webhook.embed(cfg.Webhook.url, {title = title, description = reason}, style.bot_name, style.avatar)
        end
    end
end

ESX.RegisterServerCallback('supv_shops:buy', function(source, cb, money, basket, total, key)
    -- supv player obj (vérifie si la coord du joueur correspond a la position du shop provenant de la clé)
    local supv_player, ok = supv.player.getFromId(source), false

    -- player obj esx
    local player = ESX.GetPlayerFromId(source)

    if player then
        -- vérifie si le callback joué envoie la valeur de la clé pour récuperer la coord
        if not cfg.Shop.coords[key] then print(1) SendToWebhook(player, ('**__Callback lancé manuellement sans la clé__**\n*__Joueur :__* %s | %s"'):format(player.getName(), player.identifier), 'embed', cfg.Webhook.style, 'Triche') return end

        -- vérifie si cette coords est une table (contient plusieurs vector) ou seulement .. quelque teste a refaire car du coups un vector retourne une table
        if #cfg.Shop.coords[key] > 1 then
            print('table')
            for i = 1, #cfg.Shop.coords[key] do
                local coords = cfg.Shop.coords[key][i]
                if supv_player:distance(coords) < 3.0 then ok = true break end
            end
        else
            print('non table')
            if supv_player:distance(cfg.Shop.coords[key]) < 3.0 then ok = true end
        end

        print('ici')

        -- si le check de coords n'est pas bon alors la personne a jouer le callback manuellement donc on return ca sert à rien de jouer le reste logique
        if not ok then SendToWebhook(player, ("__**Callback lancé manuellement avec clé mais trop loin d'une de ses coordonnées.**__\n*__Joueur :__* %s | %s"):format(player.getName(), player.identifier), 'embed', cfg.Webhook.style, 'Triche') return end
        
        
        -- si le joueur n'a pas d'argent dans le compte selectionner on revoie false et l'erreur 1 puis on return car on s'en fou de check le reste
        if player.getAccount(money).money < total then cb(false, 1) SendToWebhook(player, ("**Le joueur __%s__ n'a pas eu assez d'argent rip pour lui**"):format(player.getName()), 'message', cfg.Webhook.style) return end
        local carry = {} -- création de la table qui va insérer les items qu'on pourra prendre depuis le panier (basket)
        
        -- On vérifie si le joueur peut prendre les items de son panier, si il peut pas alors on renvoie false ainsi que le code erreur 2 puis onreturn car on s'en fou du reste x)

        for k,v in pairs(basket) do
            if ox_inv:CanCarryItem(source, k, v.count) then
                carry[k] = v.count
            else
                SendToWebhook(player, "Le joueur %s n'a pas assez de place dans son inventaire rip pour lui", 'message', cfg.Webhook.style)
                cb(false, 2)
                return
            end
        end

        -- on donne les items qui ont passé la vérification du panier
        for k,v in pairs(carry) do
            ox_inv:AddItem(source, k, v)
        end

        -- on retire le total de l'argent sur le compte selectionné
        player.removeAccountMoney(money, total)

        local str, long = '', ''
        for _,v in pairs(basket) do
            str = ("__%s :__ *x%s*"):format(v.label, v.count)
            long = long..'\n'..str
        end

        long = long..'\n'

        SendToWebhook(player, ("*Le joueur __**%s**__ a acheté avec succès, __récap de son achat:__*\n%s\n__Total :__ *%s$* en *%s*"):format(player.getName(), long, total, money == 'bank' and 'banque' or money == 'money' and 'cash' or money == 'black_money' and 'argent sale'), 'embed', cfg.Webhook.style, 'Achat avec succès')

        -- on peut enfin renvoyer true au client pour validez son achat et fermez le menu etc
        cb(true)
    end
end)

local message <const> = {
    needUpate = "^3Veuillez mettre à jour la ressource %s\n^3votre version : ^1%s ^7->^3 nouvelle version : ^2%s\n^3liens : ^4%s",
    error = "^1Impossible de vérifier la version du script"
}

supv.version.check("https://raw.githubusercontent.com/SUP2Ak/supv_shops/main/fxmanifest.lua", message.needUpate, message.error, 'lua', 'https://github.com/SUP2Ak/supv_shops')