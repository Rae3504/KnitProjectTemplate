local Players = game:GetService('Players')
local MarketplaceService = game:GetService('MarketplaceService')
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local GamepassService = Knit.CreateService {
    Name = "GamepassService";
    Client = {};
}


function GamepassService:_applyGamepasses(plr)
 
    local idTable = {
        Makarov = 57123598,
        M870 = 57123703,
        ['Grenade Launcher'] = 57123832,
        M67 = 57123899,
        AKM = 57123999,
        AK12 = 57124095
    }

    for i,v in pairs(idTable) do
        if MarketplaceService:UserOwnsGamePassAsync(plr.UserId, v) and not plr.Backpack:FindFirstChild(i) then
            local tool = game.ServerStorage:FindFirstChild(i, true)
            if tool then
                local cl = tool:Clone()
                cl.Parent = plr.Backpack
            end
        end
    end


end


function GamepassService:KnitStart()
    
    Players.PlayerAdded:Connect(function(plr)
        if plr.Character then
            self:_applyGamepasses(plr)
        else
            plr.CharacterAdded:Wait()
            self:_applyGamepasses(plr)
        end
        plr.CharacterAdded:Connect(function()
            self:_applyGamepasses(plr)
        end)
    end)

end


function GamepassService:KnitInit()
    
end


return GamepassService
