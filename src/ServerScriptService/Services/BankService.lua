local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local GameData = require(ReplicatedStorage.GameData)

local BankService = Knit.CreateService {
    Name = "BankService";
    Client = {};
}


BankService.Client.BankRobbed = Knit.CreateSignal()
BankService.Client.BankOpened = Knit.CreateSignal()

local Bank = workspace['Payday Bank']

local params = OverlapParams.new()
params.FilterType = Enum.RaycastFilterType.Blacklist
params.MaxParts = 0

function BankService:RefreshBank()

    self.Client.BankOpened:FireAll()
    if Bank:FindFirstChild('CageDoor2') then
        Bank.CageDoor2:Destroy()
    end
    if Bank:FindFirstChild('CageDoor1') then
        Bank.CageDoor1:Destroy()
    end
    local newDoor1 = ReplicatedStorage.CageDoor1:Clone()
    newDoor1.Parent = Bank
    local newDoor2 = ReplicatedStorage.CageDoor2:Clone()
    newDoor2.Parent = Bank
    for _,v in pairs(workspace.OpenText.ThreeDTextObject:GetChildren()) do
        if v:IsA('BasePart') then
            v.Color = Color3.fromRGB(57, 176, 71)
        end
    end
    Bank.Vault.VaultDoor:PivotTo(self.OriginalVaultCFrame)
    for _,v in pairs(Bank.GoldBars:GetChildren()) do
        if v:IsA('BasePart') then
            v.Transparency = 0
        end
    end
    Bank.FirstC4.ProximityPrompt.Enabled = true
    Bank.SecondC4.ProximityPrompt.Enabled = true
    Bank.FirstC4.Transparency = 1
    Bank.SecondC4.Transparency = 1
    Bank.Vault.VaultDoor.VaultBase.Attachment.ProximityPrompt.Enabled = true
    Bank.Vault.VaultDoor.VaultSmallHandle.Orientation = Vector3.new()

    local parts = workspace:GetPartsInPart(Bank.BankRegion, params)
    local players = {}
    for _,v in pairs(parts) do
        if v.Parent and v.Parent:FindFirstChild('Humanoid') then
            local plrName = v.Parent.Name
            local plr = game.Players:FindFirstChild(plrName)
            if plr then
                if not table.find(players, plr) then
                    table.insert(players, plr)
                end
            end
        end
    end
    for _,v in pairs(players) do
        if v.Character and v.Character.PrimaryPart then
            v.Character:SetPrimaryPartCFrame(Bank.BankTeleportLocation.CFrame * CFrame.new(0,5,0))
        end
    end
    self.Robbable = true

end


function BankService:StartCooldown()

    if self.Robbable then
        self.Robbable = false
        for _,v in pairs(workspace.OpenText.ThreeDTextObject:GetChildren()) do
            if v:IsA('BasePart') then
                v.Color = Color3.fromRGB(6, 24, 8)
            end
        end
        task.wait(60 * GameData.BankCooldown)
        self:RefreshBank()
    end

end


function BankService:KnitStart()
    
    self.OriginalVaultCFrame = Bank.Vault.VaultDoor:GetPivot()
    self.Robbable = true
    self:RefreshBank()

    Bank.FirstC4.ProximityPrompt.Triggered:Connect(function(plr)
        if Bank.FirstC4.ProximityPrompt.Enabled then
            Bank.FirstC4.ProximityPrompt.Enabled = false
            Bank.FirstC4.Transparency = 0
            Bank.FirstC4.ticking:Play()
            task.wait(7)
            Bank.Pillars.sound['old alarm bell'].Playing = true
            task.delay(60, function() 
                Bank.Pillars.sound['old alarm bell'].Playing = false
            end)
            task.spawn(function()
                self:StartCooldown()
            end)
            self.Client.BankRobbed:FireAll(plr)
            Bank.FirstC4.Transparency = 1
            local explosion = Instance.new('Explosion')
            explosion.Parent = workspace
            explosion.BlastPressure = 10000
            explosion.Position = Bank.FirstC4.Position
        end
    end)

    Bank.SecondC4.ProximityPrompt.Triggered:Connect(function(plr)
        if Bank.SecondC4.ProximityPrompt.Enabled then
            Bank.SecondC4.ProximityPrompt.Enabled = false
            Bank.SecondC4.Transparency = 0
            Bank.SecondC4.ticking:Play()
            task.wait(7)
            Bank.SecondC4.Transparency = 1
            local explosion = Instance.new('Explosion')
            explosion.Parent = workspace
            explosion.BlastPressure = 10000
            explosion.Position = Bank.SecondC4.Position
        end
    end)

    Bank.Vault.VaultDoor.VaultBase.Attachment.ProximityPrompt.PromptButtonHoldBegan:Connect(function(plr)
        if not self.spinConnection then
            self.spinConnection = RunService.Stepped:Connect(function(et)
                Bank.Vault.VaultDoor.VaultSmallHandle.Orientation = Vector3.new(0,0,et*40)
            end)
        end
    end)

    Bank.Vault.VaultDoor.VaultBase.Attachment.ProximityPrompt.PromptButtonHoldEnded:Connect(function(plr)
        if self.spinConnection then
            self.spinConnection:Disconnect()
            self.spinConnection = nil
        end
    end)

    Bank.Vault.VaultDoor.VaultBase.Attachment.ProximityPrompt.Triggered:Connect(function()
        if Bank.Vault.VaultDoor.VaultBase.Attachment.ProximityPrompt.Enabled then
            Bank.Vault.VaultDoor.VaultBase.Attachment.ProximityPrompt.Enabled = false
            if self.spinConnection then
                self.spinConnection:Disconnect()
                self.spinConnection = nil
            end

            local cf = self.OriginalVaultCFrame * CFrame.Angles(0,math.rad(-90),0)
            for i = 0, 1, 0.03 do
                Bank.Vault.VaultDoor:PivotTo(self.OriginalVaultCFrame:lerp(cf, i))
                task.wait(0.03)
            end
        end
    end)

    for _,v in pairs(Bank.GoldBars:GetChildren()) do
        if v:IsA('BasePart') then
            v.ClickDetector.MouseClick:Connect(function(plr)
                if v.Transparency == 0 then
                    v.Transparency = 1
                    Knit.GetService('MoneyService'):ChangeMoney(plr, GameData.GoldBarWorth)
                end
            end)
        end
    end

end


function BankService:KnitInit()
    
end


return BankService
