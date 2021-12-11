function RefreshPlayerData()
    Citizen.CreateThread(function()
        ESX.PlayerData = ESX.GetPlayerData()
    end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 2.0, 2.0, -1, 51, 0, false, false, false)
	end)
end


