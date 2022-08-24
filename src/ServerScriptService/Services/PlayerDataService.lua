local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local DataStore2 = require(ReplicatedStorage.DataStore2)


local PlayerDataService = Knit.CreateService {
    Name = "PlayerDataService";
    Client = {};
}

function PlayerDataService.Client:SetFirstJoin(plr)
    PlayerDataService:SetDirectory(plr, 'FirstJoin', true)
end

function PlayerDataService.Client:GetDirectory(...)
    return PlayerDataService:GetDirectory(...)
end

function PlayerDataService:KnitStart()
    
end


function PlayerDataService:GetDirectory(plr, directory, defaultValue)

    DataStore2.Combine('DATA', directory)
    local dataStore = DataStore2(directory, plr)
    local val = dataStore:Get(defaultValue)
    if directory == 'Obrian' then
        if plr:FindFirstChild('leaderstats') then
            if plr.leaderstats:FindFirstChild('Cash') then
                plr.leaderstats.Cash.Value = val
            end
        end
    end
    return val

end


function PlayerDataService:SetDirectory(plr, directory, value)

    DataStore2.Combine('DATA', directory)
    local dataStore = DataStore2(directory, plr) 
    dataStore:Set(value)

    if directory == 'Obrian' then
        Knit.GetService('MoneyService').Client.MoneyChanged:Fire(plr, value)
        plr.leaderstats.Cash.Value = value
    end

    return value

end


return PlayerDataService
