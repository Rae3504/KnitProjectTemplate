local Players = game:GetService('Players')
local MarketplaceService = game:GetService('MarketplaceService')

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local TeamService = Knit.CreateService {
    Name = "TeamService";
    Client = {};
}



function TeamService.Client:ChangeTeam(...)
    return TeamService:ChangeTeam(...)
end

function TeamService:ChangeTeam(plr, teamName)

    local pass = false
    if teamName == 'Admissions' then
        if plr:GetRankInGroup(5170982) >= 1 then
            pass = true
        end
    elseif teamName == 'Armed Forces' then
        if plr:GetRankInGroup(5170977) >= 1 then
            pass = true
        end
    elseif teamName == 'High Command' then
        if plr:GetRankInGroup(5169183) >= 121 then
            pass = true
        end
    elseif teamName == 'Citizen' then
        if plr:GetRankInGroup(5169183) >= 107 then
            pass = true
        end
    elseif teamName == 'The Grand Regent' and plr.Name == 'Rae3504' then
        pass = true
    elseif teamName == 'The Lord Regent' and plr.Name == 'billskills12' then
        pass = true
    elseif teamName == 'Immigrant' then
        pass = true
    elseif teamName == 'Federal Security Service' then
        if plr:GetRankInGroup(9756886) > 5 then
            pass = true
        end
    elseif teamName == 'Raider' then
        if MarketplaceService:UserOwnsGamePassAsync(plr.UserId, 65027645) or self.RaiderGamepassCache[plr] then
            pass = true
        else
            MarketplaceService:PromptGamePassPurchase(plr, 65027645)
        end
    end

    if pass then
        plr.Team = game.Teams[teamName]
        plr:LoadCharacter()
        return true
    end
    

end


function TeamService:KnitStart()
    
    self.RaiderGamepassCache = {}

    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            if plr.Team then
                for _,v in pairs(plr.Team:GetChildren()) do
                    if v:IsA('Tool') then
                        local cl = v:Clone()
                        cl.Parent = plr.Backpack
                    end
                end
            end
        end)
    end)

    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gamepassId, wasPurchased)
        if gamepassId == 65027645 and wasPurchased then
            self.RaiderGamepassCache[plr] = true
        end
    end)

    Players.PlayerRemoving:Connect(function(plr)
        self.RaiderGamepassCache[plr] = nil
    end)

end


function TeamService:KnitInit()
    
end


return TeamService
