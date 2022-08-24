local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local CarService = Knit.CreateService {
    Name = "CarService";
    Client = {};
}

CarService.PlayerCars = {}

CarService.Client.VehiclePurchased = Knit.CreateSignal()

function CarService:PurchaseCar(plr, button)

    local PlayerDataService = Knit.GetService('PlayerDataService')
    local cost = button:GetAttribute('Cost') and tonumber(button:GetAttribute('Cost')) or 0
    local obrian = PlayerDataService:GetDirectory(plr, 'Obrian')
    if (cost == 0) or obrian >= cost then
        self.Client.VehiclePurchased:Fire(plr)
        if self.PlayerCars[plr] then
            self.PlayerCars[plr]:Destroy()
        end
        if cost ~= 0 then
            PlayerDataService:SetDirectory(plr, 'Obrian', obrian - cost)
        end
        local car = button.CarModel.Value:Clone()
        car.Parent = workspace.Cars
        self.PlayerCars[plr] = car
        local selectedSpawn
        local largestDelta = 0
        for _,v in pairs(workspace.CarSpawns[button:GetAttribute('Spawn')]:GetChildren()) do
            local delta = tick() - (v:GetAttribute('LastSpawned') or 0)
            if delta > largestDelta then
                largestDelta = delta
                selectedSpawn = v
            end
        end
        selectedSpawn:SetAttribute('LastSpawned', tick())
        car:PivotTo(selectedSpawn.CFrame)
        if plr.Character then 
            plr.Character:SetPrimaryPartCFrame(selectedSpawn.CFrame * CFrame.new(0,5,0))
        end
        car.DriveSeat.Disabled = false
        car['A-Chassis Tune'].Initialize.Disabled = false
    end

end


function CarService:KnitStart()
    
    game:GetService('Players').PlayerRemoving:Connect(function(plr)
        if self.PlayerCars[plr] then
            self.PlayerCars[plr]:Destroy()
            self.PlayerCars[plr] = nil
        end
    end)

end


function CarService:KnitInit()
    
end


return CarService
