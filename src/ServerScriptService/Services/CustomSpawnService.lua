local Players = game:GetService('Players')

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local CustomSpawnService = Knit.CreateService {
    Name = "CustomSpawnService";
    Client = {};
}



CustomSpawnService.CustomSpawnPlayers = {}
CustomSpawnService.Client.CustomSpawnActivated = Knit.CreateSignal()
CustomSpawnService.Client.CustomSpawnDeactivated = Knit.CreateSignal()

function CustomSpawnService.Client:SetCustomSpawn(player, spawnName)

	local spawnLocation = workspace:WaitForChild("CustomSpawnLocations"):FindFirstChild(spawnName)

	if spawnLocation then
		CustomSpawnService.CustomSpawnPlayers[player] = spawnLocation
	end

end

function CustomSpawnService.Client:DisableCustomSpawn(player)

	CustomSpawnService.CustomSpawnPlayers[player] = nil
    CustomSpawnService.Client.CustomSpawnDeactivated:Fire(player)

end



function CustomSpawnService:KnitStart()
    
    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            local char = plr.Character
            if char.PrimaryPart and self.CustomSpawnPlayers[plr] then
                task.wait(0.1)
                char:SetPrimaryPartCFrame(self.CustomSpawnPlayers[plr].CFrame * CFrame.new(0,1,0))
            end
        end)
    end)

    for _,v in pairs(workspace.CustomSpawnInteractionPodiums:GetChildren()) do
        v.Screen.ClickDetector.MouseClick:Connect(function(plr)
            if plr.Team.Name ~= 'Immigrant' and plr.Team.Name ~= 'Citizen' and plr.Team.Name ~= 'Raider' then
                self.Client:SetCustomSpawn(plr, v.Name)
                self.Client.CustomSpawnActivated:Fire(plr, v)
            end
        end)
    end

end


function CustomSpawnService:KnitInit()
    
end


return CustomSpawnService
