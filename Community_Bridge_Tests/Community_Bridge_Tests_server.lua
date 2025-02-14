-- Server-Side Tests
Community_Bridge_Tests_server = {}

local Bridge = exports.community_bridge:Bridge()

local function advancedPrint(category, message, status)
    local colors = {
        info = "^3", -- Yellow for info
        success = "^2", -- Green for success
        error = "^1", -- Red for errors
        debug = "^5", -- Purple for debug
    }
    local statusColor = colors[status] or "^7"
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local formattedMessage = string.format("[%s] %s[%s]^7: %s", timestamp, statusColor, category, message)
    print(formattedMessage)
    TriggerClientEvent("community_bridge:debugPrint", -1, formattedMessage)
end

local function ensureBridgeReady()
    local attempts = 0
    while not Bridge or not Bridge.Framework do
        attempts = attempts + 1
        if attempts > 10 then
            advancedPrint("TEST", "Bridge not ready after 10 attempts. Aborting.", "error")
            return false
        end
        Wait(1000)
    end
    return true
end

-- Test Framework Functions
local function testFrameworkFunctions(src)
    advancedPrint("Framework", "Testing Framework Functions...", "info")
    -- Test GetFrameworkName
    if Bridge.Framework.GetFrameworkName then
        local frameworkName = Bridge.Framework.GetFrameworkName()
        if frameworkName then
            advancedPrint("Framework", "GetFrameworkName: " .. frameworkName, "success")
        else
            advancedPrint("Framework", "GetFrameworkName: FAILED", "error")
        end
    else
        advancedPrint("Framework", "GetFrameworkName: NOT IMPLEMENTED", "error")
    end
    -- Test GetPlayerData with valid and invalid source
    if Bridge.Framework.GetPlayerData then
        local validPlayerData = Bridge.Framework.GetPlayerData(src)
        if validPlayerData then
            advancedPrint("Framework", "GetPlayerData (valid src): " .. json.encode(validPlayerData), "success")
        else
            advancedPrint("Framework", "GetPlayerData (valid src): FAILED", "error")
        end

        local invalidPlayerData = Bridge.Framework.GetPlayerData(-1) -- Invalid source
        if not invalidPlayerData then
            advancedPrint("Framework", "GetPlayerData (invalid src): SUCCESS (expected failure)", "success")
        else
            advancedPrint("Framework", "GetPlayerData (invalid src): FAILED (unexpected success)", "error")
        end
    else
        advancedPrint("Framework", "GetPlayerData: NOT IMPLEMENTED", "error")
    end
    -- Test GetPlayerJob
    if Bridge.Framework.GetPlayerJob then
        local jobName, jobLabel, jobGradeName, jobGradeLevel = Bridge.Framework.GetPlayerJob(src)
        if jobName then
            advancedPrint("Framework", "GetPlayerJob: " .. jobName .. ", " .. jobLabel .. ", " .. jobGradeName .. ", " .. tostring(jobGradeLevel), "success")
        else
            advancedPrint("Framework", "GetPlayerJob: FAILED", "error")
        end
    else
        advancedPrint("Framework", "GetPlayerJob: NOT IMPLEMENTED", "error")
    end
    -- Test AddStress with positive and negative values
    if Bridge.Framework.AddStress then
        local resultPositive = Bridge.Framework.AddStress(src, 10) -- Add 10 stress
        if resultPositive then
            advancedPrint("Framework", "AddStress (positive value): SUCCESS", "success")
        else
            advancedPrint("Framework", "AddStress (positive value): FAILED", "error")
        end

        local resultNegative = Bridge.Framework.AddStress(src, -10) -- Add negative stress
        if resultNegative then
            advancedPrint("Framework", "AddStress (negative value): SUCCESS", "success")
        else
            advancedPrint("Framework", "AddStress (negative value): FAILED", "error")
        end
    else
        advancedPrint("Framework", "AddStress: NOT IMPLEMENTED", "error")
    end
    -- Test RemoveStress
    if Bridge.Framework.RemoveStress then
        local result = Bridge.Framework.RemoveStress(src, 5) -- Remove 5 stress
        if result then
            advancedPrint("Framework", "RemoveStress: SUCCESS", "success")
        else
            advancedPrint("Framework", "RemoveStress: FAILED", "error")
        end
    else
        advancedPrint("Framework", "RemoveStress: NOT IMPLEMENTED", "error")
    end
    -- Test GetPlayerMetaData
    if Bridge.Framework.GetPlayerMetaData then
        local metadata = Bridge.Framework.GetPlayerMetaData(src, "exampleKey")
        if metadata then
            advancedPrint("Framework", "GetPlayerMetaData: " .. json.encode(metadata), "success")
        else
            advancedPrint("Framework", "GetPlayerMetaData: FAILED", "error")
        end
    else
        advancedPrint("Framework", "GetPlayerMetaData: NOT IMPLEMENTED", "error")
    end
    -- Test GetPlayersByJob
    if Bridge.Framework.GetPlayersByJob then
        local jobTable = Bridge.Framework.GetPlayersByJob("police")
        if jobTable then
            advancedPrint("Framework", "GetPlayersByJob: " .. json.encode(jobTable), "success")
        else
            advancedPrint("Framework", "GetPlayersByJob: FAILED", "error")
        end
    else
        advancedPrint("Framework", "GetPlayersByJob: NOT IMPLEMENTED", "error")
    end
end

-- Test Inventory Functions
local function testInventoryFunctions(src)
    advancedPrint("Inventory", "Testing Inventory Functions...", "info")
    -- Test GetPlayerInventory
    if Bridge.Inventory.GetPlayerInventory then
        local inventory = Bridge.Inventory.GetPlayerInventory(src)
        if inventory then
            advancedPrint("Inventory", "GetPlayerInventory: " .. json.encode(inventory), "success")
        else
            advancedPrint("Inventory", "GetPlayerInventory: FAILED", "error")
        end
    else
        advancedPrint("Inventory", "GetPlayerInventory: NOT IMPLEMENTED", "error")
    end
    -- Test AddItem with valid and invalid items
    if Bridge.Inventory.AddItem then
        local resultValid = Bridge.Inventory.AddItem(src, "bread", 1) -- Add 1 bread
        if resultValid then
            advancedPrint("Inventory", "AddItem (valid item): SUCCESS", "success")
        else
            advancedPrint("Inventory", "AddItem (valid item): FAILED", "error")
        end

        local resultInvalid = Bridge.Inventory.AddItem(src, "invalid_item", 1) -- Add invalid item
        if not resultInvalid then
            advancedPrint("Inventory", "AddItem (invalid item): SUCCESS (expected failure)", "success")
        else
            advancedPrint("Inventory", "AddItem (invalid item): FAILED (unexpected success)", "error")
        end
    else
        advancedPrint("Inventory", "AddItem: NOT IMPLEMENTED", "error")
    end
    -- Test RemoveItem
    if Bridge.Inventory.RemoveItem then
        local result = Bridge.Inventory.RemoveItem(src, "bread", 1) -- Remove 1 bread
        if result then
            advancedPrint("Inventory", "RemoveItem: SUCCESS", "success")
        else
            advancedPrint("Inventory", "RemoveItem: FAILED", "error")
        end
    else
        advancedPrint("Inventory", "RemoveItem: NOT IMPLEMENTED", "error")
    end
end

-- Test Utility Functions
local function testUtilityFunctions(src)
    advancedPrint("Utility", "Testing Utility Functions...", "info")
    -- Test CreateVehicle with valid and invalid models
    if Bridge.Utility.CreateVehicle then
        local validVehicle = Bridge.Utility.CreateVehicle("adder", vector3(0, 0, 0), 0.0, true)
        if validVehicle then
            advancedPrint("Utility", "CreateVehicle (valid model): SUCCESS", "success")
        else
            advancedPrint("Utility", "CreateVehicle (valid model): FAILED", "error")
        end

        local invalidVehicle = Bridge.Utility.CreateVehicle("invalid_model", vector3(0, 0, 0), 0.0, true)
        if not invalidVehicle then
            advancedPrint("Utility", "CreateVehicle (invalid model): SUCCESS (expected failure)", "success")
        else
            advancedPrint("Utility", "CreateVehicle (invalid model): FAILED (unexpected success)", "error")
        end
    else
        advancedPrint("Utility", "CreateVehicle: NOT IMPLEMENTED", "error")
    end
    -- Test GetClosestPlayer
    if Bridge.Utility.GetClosestPlayer then
        local closestPlayer = Bridge.Utility.GetClosestPlayer(vector3(0, 0, 0), 10.0, false)
        if closestPlayer then
            advancedPrint("Utility", "GetClosestPlayer: SUCCESS", "success")
        else
            advancedPrint("Utility", "GetClosestPlayer: FAILED", "error")
        end
    else
        advancedPrint("Utility", "GetClosestPlayer: NOT IMPLEMENTED", "error")
    end
end

-- Test Dispatch Functions
local function testDispatchFunctions(src)
    advancedPrint("Dispatch", "Testing Dispatch Functions...", "info")
    if Bridge.Dispatch then
        if Bridge.Dispatch.SendAlert then
            local data = {
                vehicle = nil,
                plate = nil,
                ped = PlayerPedId(),
                pedCoords = GetEntityCoords(PlayerPedId()),
                coords = GetEntityCoords(PlayerPedId()),
                blipData = { sprite = 161, color = 1, scale = 0.8 },
                message = "Test Alert",
                code = '10-80',
                icon = 'fas fa-question',
                jobs = { 'police' },
                alertTime = 10
            }
            local result = Bridge.Dispatch.SendAlert(data)
            if result then
                advancedPrint("Dispatch", "SendAlert: SUCCESS", "success")
            else
                advancedPrint("Dispatch", "SendAlert: FAILED", "error")
            end
        else
            advancedPrint("Dispatch", "SendAlert: NOT IMPLEMENTED", "error")
        end
    else
        advancedPrint("Dispatch", "Dispatch module: NOT IMPLEMENTED", "error")
    end
end

RegisterCommand("start_server_tests", function(source)
    if not ensureBridgeReady() then
        return
    end
    advancedPrint("TEST", "Starting Server-Side Tests...", "info")
    testFrameworkFunctions(source)
    testInventoryFunctions(source)
    testUtilityFunctions(source)
    testDispatchFunctions(source)
    advancedPrint("TEST", "Server-Side Tests Completed.", "info")
end, false)

RegisterNetEvent("community_bridge:debugPrint")
AddEventHandler("community_bridge:debugPrint", function(message)
    print(message)
end)