ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterNetEvent('AddWitheningMoney')
AddEventHandler('AddWitheningMoney', function(Money, BlackMoney)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local GetBlackMoney = xPlayer.getAccount('black_money').money
    if Money <= GetBlackMoney then
        xPlayer.removeAccountMoney('black_money', BlackMoney)
        xPlayer.addMoney(Money)
        TriggerClientEvent('esx:showNotification', source, "Vous avez blanchis ~r~"..BlackMoney.."$ d'argents sale~w~ pour recevoir ~g~"..Money.."$ d'argents propre")
    end
end)
