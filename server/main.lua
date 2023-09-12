local webhookUrl = "https://discord.com/api/webhooks/1150702076398141461/85eq5W7VvTa6UTvO-Kb-CsBOK6-qC-5W8BKbZgYco_kmKuF5OWsRU99lezIU1-2xCd-z"

function sendToDiscord(embed)
    local embeds = {embed}
    PerformHttpRequest(webhookUrl, function(statusCode, text, headers)
        -- Check if the request was successful
        if statusCode == 204 then
            print("[Resource Logger] Message sent to Discord successfully.")
        else
            print("[Resource Logger] Error sending message to Discord. Status Code: " .. statusCode)
        end
    end, 'POST', json.encode({embeds = embeds}), {['Content-Type'] = 'application/json'})
end

function createEmbed(title, description, color)
    local embed = {
        title = title,
        description = description,
        color = color or 16711680, -- Default color (red)
    }
    return embed
end

-- Delay before logging
Citizen.CreateThread(function()
    Citizen.Wait(120000) -- Wait for 2 minutes before logging
    -- After the delay, start logging
    AddEventHandler("onResourceStop", function(resourceName)
        local message = "Resource **" .. resourceName .. "** stopped."
        local embed = createEmbed("Resource Stopped", message, 16711680) -- Red color
        sendToDiscord(embed)
    end)

    AddEventHandler("onResourceStart", function(resourceName)
        local message = "Resource **" .. resourceName .. "** started."
        local embed = createEmbed("Resource Started", message, 65280) -- Green color
        sendToDiscord(embed)
    end)

    AddEventHandler("onResourceRestart", function(resourceName)
        local message = "Resource **" .. resourceName .. "** restarted."
        local embed = createEmbed("Resource Restarted", message, 65535) -- Yellow color
        sendToDiscord(embed)
    end)
end)
