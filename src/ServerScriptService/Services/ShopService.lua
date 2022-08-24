local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(game:GetService("ReplicatedStorage").Packages.Signal)
local ShopData = require(game.ReplicatedStorage.ShopData)
local GameData = require(game.ReplicatedStorage.GameData)

local ShopService = Knit.CreateService {
    Name = "ShopService";
    Client = {};
}


function ShopService.Client:PurchaseItem(plr, shopType, itemData, index)

    local ItemData = ShopData[shopType][index]
    if ItemData.Price == itemData.Price and ItemData.ToolName == itemData.ToolName then
        local plrCash = Knit.GetService('PlayerDataService'):GetDirectory(plr, "Obrian", GameData.DefaultCash)
        if plrCash >= itemData.Price then
            local tool = game.ServerStorage.ShopItems:FindFirstChild(itemData.ToolName)
            if tool then
                ShopService.ItemBought:Fire(plr, shopType, itemData.ToolName)
                local cl = tool:Clone()
                cl.Parent = plr.Backpack
                Knit.GetService('PlayerDataService'):SetDirectory(plr, "Obrian", plrCash - itemData.Price)
                return true
            end
        end
    end

end


function ShopService:KnitStart()
    
    self.ItemBought = Signal.new()

end


function ShopService:KnitInit()
    
end


return ShopService