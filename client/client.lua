ESX  = nil
local open = false
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local LaundererMenu = RageUI.CreateMenu("Blanchisseur", "Illégal")
LaundererMenu.EnableMouse = true
LaundererMenu:DisplayPageCounter(false)


local SliderPannel = {
    Minimum = 0,
    Index = 1,
}

LaundererMenu.Closed = function()  
    SliderPannel.Index = 1 
    RageUI.Visible(LaundererMenu, false)
    open = false
end 

local Percentage = 0.80 -- Fr: Pourcentage sur le prix final, ici le blanchisseur prend 20% (1-0.80 = 0.20) // En: Percentage of the final price here the laundryman takes 20% (1-0.80 = 0.20)
local Progress = nil 
local PercentagePannel = 0.0

function OpenLaundererMenu()
    if open then 
        open = false 
        RageUI.Visible(LaundererMenu,false)
        return
    else
        open = true 
        RageUI.Visible(LaundererMenu, true)

        Citizen.CreateThread(function ()
            while open do 
                RageUI.IsVisible(LaundererMenu, function()
                    
                    RageUI.Button('Argent à blanchir', false , {RightLabel = "$"..SliderPannel.Index}, true , {})
                    RageUI.Button('Blanchir', false, {RightLabel = "$"..Round(SliderPannel.Index * Percentage), Color = { HightLightColor = { 0, 155, 0, 150 }, BackgroundColor = { 38, 85, 150, 160 } }}, true, {
                        onSelected = function() 
                            local GetHeading = GetEntityHeading(PlayerPedId())
                            if GetHeading ~= 9.30 then
                                SetEntityHeading(PlayerPedId(), 9.30)
                            end
                            SetEntityCoords(PlayerPedId(), 1122.4825439453,-3194.7829589844,-41.40)
                            Progress = true
                            ClearPedTasks(PlayerPedId())
                            FreezeEntityPosition(PlayerPedId(), true)
                            startAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer")
                            LaundererMenu.Closable = false
                        end
                    })
                    RageUI.Separator("Votre Argent sale: ~g~$"..ESX.PlayerData.accounts[2].money)
                    RageUI.SliderPanel(SliderPannel.Index, SliderPannel.Minimum, "Quantité", ESX.PlayerData.accounts[2].money, {
                        onSliderChange = function(Index)
                            SliderPannel.Index = Index
                        end
                    }, 1)
                    
                    if Progress == true then
                        RageUI.PercentagePanel(PercentagePannel, 'Blanchiment en cours', '', '', {}, 2)
                        if PercentagePannel < 1.0 then
                            PercentagePannel = PercentagePannel + 0.0008
                        else
                            local FinalPercentage = Round(SliderPannel.Index * Percentage)
                            ClearPedTasks(PlayerPedId())
                            FreezeEntityPosition(PlayerPedId(), false)
                            Wait(50)
                            TriggerServerEvent('AddWitheningMoney', FinalPercentage, SliderPannel.Index)
                            PercentagePannel = 0.0
                            Progress = false
                            LaundererMenu.Closable = true
                            LaundererMenu.Closed()
                        end
                    end

                end)

                Wait(0)
            end
        end)


    end
end

LaundererPosition = {
    {pos = vector3(1122.4825439453,-3194.7829589844,-41.40)}, -- Fr: Configuration de la position // En: Position configuration
}

CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        local spam = false
        for _,v in pairs(LaundererPosition) do
            if #(pCoords - v.pos) < 1.2 then
                spam = true
                ESX.ShowHelpNotification('Appuyez sur ~INPUT_PICKUP~ pour blanchir votre ~b~argents')
                DrawMarker(25, v.pos , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.1, 1.1, 1.1, 27, 155, 207, 150, false, true, 2, false, false, false, false)
                if IsControlJustReleased(0, 38) then
                    RefreshPlayerData()
                    Wait(50)
                    OpenLaundererMenu()
                end                
            elseif #(pCoords - v.pos) < 1.3 then
                spam = false           
            end
        end
        if spam then
            Wait(1)
        else
            Wait(500)
        end
    end
end)