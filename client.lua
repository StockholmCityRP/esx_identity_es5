--==================================================================================
--======               ESX_IDENTITY BY ARKSEYONET @Ark                        ======
--======    YOU CAN FIND ME ON MY DISCORD @Ark - https://discord.gg/cGHHxPX   ======
--======    IF YOU ALTER THIS VERSION OF THE SCRIPT, PLEASE GIVE ME CREDIT    ======
--======     Special Thanks To Alphakush and CMD.Telhada For Help Testing     ======
--==================================================================================

--===============================================
--==                 VARIABLES                 ==
--===============================================
local guiEnabled    = false
local myIdentity    = {}
local myIdentifiers = {}
local hasIdentity   = false

--===============================================
--==                 VARIABLES                 ==
--===============================================
function EnableGui(enable)
    SetNuiFocus(enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end


--===============================================
--==           Show Registration               ==
--===============================================
RegisterNetEvent("esx_identity:showRegisterIdentity")
AddEventHandler("esx_identity:showRegisterIdentity", function()
  EnableGui(true)
end)

--===============================================
--==           Show Registration               ==
--===============================================
RegisterNetEvent("esx_identity:saveID")
AddEventHandler("esx_identity:saveID", function(data)
  myIdentifiers = data
end)

--===============================================
--==           Identity Check                  ==
--===============================================
RegisterNetEvent("esx_identity:identityCheck")
AddEventHandler("esx_identity:identityCheck", function(data)
  hasIdentity = data
end)

--===============================================
--==              Close GUI                    ==
--===============================================
RegisterNUICallback('escape', function(data, cb)
  if hasIdentity == true then
      EnableGui(false)
  else
    TriggerEvent("chatMessage", "^1[IDENTITY]", {255, 255, 0}, "An identity is required to play.")
  end
end)

--===============================================
--==           Register Callback               ==
--===============================================
RegisterNUICallback('register', function(data, cb)
  myIdentity = data
  if data.firstname ~= '' and data.lastname ~= '' and data.sex ~= '' and data.dateofbirth ~= '' and data.height ~= '' then
    TriggerServerEvent('esx_identity:setIdentity', data, myIdentifiers)
    EnableGui(false)
    Wait (500)
    TriggerEvent('esx_skin:openSaveableMenu', myIdentifiers.id)
  else
    TriggerEvent("chatMessage", "^1[IDENTITY]", {255, 255, 0}, "Please fill in all of the fields.")
  end
end)

--===============================================
--==                 THREADING                 ==
--===============================================
Citizen.CreateThread(function()
    while true do
        if guiEnabled then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
			
			if IsControlJustPressed(1, 322) and hasIdentity == true then
		      EnableGui(false)
			end
        end
        Citizen.Wait(0)
    end
end)

function openRegistry()
  TriggerEvent('esx_identity:showRegisterIdentity')
end
