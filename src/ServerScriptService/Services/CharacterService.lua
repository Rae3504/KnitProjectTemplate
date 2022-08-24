local InsertService = game:GetService('InsertService')

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local CharacterService = Knit.CreateService {
    Name = "CharacterService";
    Client = {};
}


function CharacterService.Client:AddAccessory(...)
    return CharacterService:AddAccessory(...)
end


function CharacterService.Client:DeleteAccessory(...)
    return CharacterService:DeleteAccessory(...)
end


function CharacterService:AddAccessory(plr, id)
    local acc = InsertService:LoadAsset(id):FindFirstChildWhichIsA('Accessory')
    if plr.Character and plr.Character:FindFirstChild('Humanoid') then
        plr.Character.Humanoid:AddAccessory(acc)
    end
    return acc
end


function CharacterService:DeleteAccessory(plr, acc)
    if acc:IsA('Accessory') and acc.Parent == plr.Character then
        acc:Destroy()
    end
end


function CharacterService:KnitStart()
    
end


function CharacterService:KnitInit()
    
end


return CharacterService
