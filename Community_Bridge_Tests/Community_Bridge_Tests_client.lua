-- Client-Side Tests
Community_Bridge_Tests_client = {}

local Bridge = exports.community_bridge:Bridge()

local function advancedPrint(category, message, status)
    local colors = {
        info = "^3", -- Yellow for info
        success = "^2", -- Green for success
        error = "^1", -- Red for errors
        debug = "^5", -- Purple for debug
    }
    local statusColor = colors[status] or "^7"
    local timestamp = GetGameTimer() -- Use game timer instead of os.date
    local formattedMessage = string.format("[%s] %s[%s]^7: %s", timestamp, statusColor, category, message)
    print(formattedMessage)
    TriggerServerEvent("community_bridge:debugPrint", formattedMessage)
end

-- Test Client-Side Functions
local function testClientFunctions()
    advancedPrint("Client", "Testing Client-Side Functions...", "info")
    -- Test GetAppearance
    if Bridge.Clothing.GetAppearance then
        local appearance = Bridge.Clothing.GetAppearance()
        if appearance then
            advancedPrint("Client", "GetAppearance: SUCCESS", "success")
        else
            advancedPrint("Client", "GetAppearance: FAILED", "error")
        end
    else
        advancedPrint("Client", "GetAppearance: NOT IMPLEMENTED", "error")
    end
    -- Test ReloadSkin
    if Bridge.Clothing.ReloadSkin then
        local result = Bridge.Clothing.ReloadSkin()
        if result then
            advancedPrint("Client", "ReloadSkin: SUCCESS", "success")
        else
            advancedPrint("Client", "ReloadSkin: FAILED", "error")
        end
    else
        advancedPrint("Client", "ReloadSkin: NOT IMPLEMENTED", "error")
    end
    -- Test GetClosestDoor
    if Bridge.Doorlock.GetClosestDoor then
        local door = Bridge.Doorlock.GetClosestDoor()
        if door then
            advancedPrint("Client", "GetClosestDoor: SUCCESS", "success")
        else
            advancedPrint("Client", "GetClosestDoor: FAILED", "error")
        end
    else
        advancedPrint("Client", "GetClosestDoor: NOT IMPLEMENTED", "error")
    end
end

-- Command to run client-side tests
RegisterCommand("start_client_tests", function()
    advancedPrint("TEST", "Starting Client-Side Tests...", "info")
    testClientFunctions()
    advancedPrint("TEST", "Client-Side Tests Completed.", "info")
end, false)

RegisterNetEvent("community_bridge:debugPrint")
AddEventHandler("community_bridge:debugPrint", function(message)
    print(message)
end)