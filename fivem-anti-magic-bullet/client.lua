local AntiMagicBullet = {}

-- Safe Resource
AntiMagicBullet.whitelistedResources = {
    "ornekKaynak1",
    "ornekKaynak2"
}

local discordWebhookURL = "WEBHOOK_URL" -- WebHook Gir

function AntiMagicBullet.isWhitelisted(resourceName)
    for _, whitelistedResource in ipairs(AntiMagicBullet.whitelistedResources) do
        if resourceName == whitelistedResource then
            return true
        end
    end
    return false
end

function AntiMagicBullet.sendDiscordLog(message)
    PerformHttpRequest(discordWebhookURL, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('gameEventTriggered', function(eventName, eventData)
    if eventName == 'CEventNetworkEntityDamage' then
        local hedef = eventData[1]
        local saldiran = eventData[2]
        local silahHash = eventData[4]
        local magicBulletMi = eventData[11] 

        if magicBulletMi then
            local saldiranKaynak = NetworkGetEntityOwner(saldiran)
            local saldiranResource = GetPlayerName(saldiranKaynak)

            if not AntiMagicBullet.isWhitelisted(saldiranResource) then
                CancelEvent()
                DropPlayer(saldiranKaynak, "Neden Magic Kullaniyorsun Malmisin?")
                AntiMagicBullet.sendDiscordLog("Magic bullet kullanmaya çalışan oyuncu atıldı: " .. saldiranResource)
            end
        end
    end
end)

