local Players = game:GetService('Players')

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local LeaderstatsService = Knit.CreateService {
    Name = "LeaderstatsService";
    Client = {};
}


function LeaderstatsService:KnitStart()

    Players.PlayerAdded:Connect(function(plr)

        local folder = Instance.new('Folder')
        folder.Name = 'leaderstats'
        folder.Parent = plr

        local cash = Instance.new('IntValue')
        cash.Name = 'Cash'
        cash.Parent = folder

        local kills = Instance.new('IntValue')
        kills.Name = 'Kills'
        kills.Parent = folder

    end)
    
end


function LeaderstatsService:KnitInit()
    
end


return LeaderstatsService
