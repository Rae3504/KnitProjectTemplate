local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(game:GetService('ReplicatedStorage').Packages.Signal)
local ApartmentService = Knit.CreateService { Name = "ApartmentService" }

local LEADERSTAT_NAME = "Obrian"
local CONFIGURE_LEADERSTATS = false
local DEFAULT_APARTMENT_PRICE = 500
local REFUND_CASH_ON_SELL = true
local REFUND_AMOUNT_MULTIPLIER = 0.5

local CollectionSevice = game:GetService("CollectionService") 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")

local Apartment = require(Knit.Class.Apartment)

local ApartmentIntances = CollectionSevice:GetTagged("Apartment")

local PurchaseApartmentEvent = Instance.new("RemoteFunction")
PurchaseApartmentEvent.Name = "PurchaseApartment"
PurchaseApartmentEvent.Parent = ReplicatedStorage

local SellApartmentEvent = Instance.new("RemoteFunction")
SellApartmentEvent.Name = "SellApartment"
SellApartmentEvent.Parent = ReplicatedStorage

local ToggleDoorEvent = Instance.new("RemoteFunction")
ToggleDoorEvent.Name = "ToggleDoor"
ToggleDoorEvent.Parent = ReplicatedStorage

local ApartmentTable = {}

ApartmentService.ApartmentPurchased = Signal.new()
ApartmentService.Client.ApartmentPurchased = Knit.CreateSignal()

function OnPromptTriggered(promptObject, player)
	if promptObject:FindFirstChild("ApartmentModel") then
		ToggleDoor(player, promptObject:FindFirstChild("ApartmentModel").Value)
	end
end


function ConfigureLeaderstats(plr)
	local folder = Instance.new("Folder")
	folder.Name = "leaderstats"
	folder.Parent = plr
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = folder
	cash.Value = 1000
end


function PurchaseApartment(plr, apartmentModel)
	local MoneyService = Knit.GetService('MoneyService')
	if ApartmentTable[apartmentModel] and ApartmentTable[apartmentModel].Object.owner == "" then
		if MoneyService:GetMoney(plr) >= ApartmentTable[apartmentModel].Price then
            ApartmentService.ApartmentPurchased:Fire(plr)
			ApartmentService.Client.ApartmentPurchased:Fire(plr)
			ApartmentTable[apartmentModel].Object:SetOwner(plr)
			MoneyService:ChangeMoney(plr,  -ApartmentTable[apartmentModel].Price)
		else
			return "You do not have enough money to purchase this apartment" 
		end
	else
		return "That apartment is already owned"
	end
end


function SellApartment(plr, apartmentModel)
	
	local MoneyService = Knit.GetService('MoneyService')
	if ApartmentTable[apartmentModel] and ApartmentTable[apartmentModel].Object.owner == plr.Name then
		ApartmentTable[apartmentModel].Object:Disown()
		
		if REFUND_CASH_ON_SELL then
			MoneyService:ChangeMoney(plr, (apartmentModel:GetAttribute("Price") * REFUND_AMOUNT_MULTIPLIER))
		end
	else
		return "Insufficient permissions"
	end
	
end


function ToggleDoor(plr, apartmentModel)
	
	if ApartmentTable[apartmentModel] and ApartmentTable[apartmentModel].Object.owner == plr.Name then
		ApartmentTable[apartmentModel].Object:ToggleDoor(not ApartmentTable[apartmentModel].Object.doorOpen)
	else
		return "Insufficient permissions"
	end
	
end

function ApartmentService:KnitStart()
    for _,apartmentInstance in pairs(ApartmentIntances) do
		local apartment = Apartment.new(apartmentInstance)
		ApartmentTable[apartmentInstance] = {}
		ApartmentTable[apartmentInstance].Object = apartment
		ApartmentTable[apartmentInstance].Price = DEFAULT_APARTMENT_PRICE
		apartmentInstance.Screen.SurfaceGui.Frame.PurchaseButton.Text = DEFAULT_APARTMENT_PRICE.." Cash"
		
		local objval = Instance.new("ObjectValue")
		objval.Name = "ApartmentModel"
		objval.Parent = apartmentInstance.Door.ProximityDoorPart.ProximityAttachment.ProximityPrompt
		objval.Value = apartmentInstance
	end

    game.Players.PlayerRemoving:Connect(function(plr)
        for _,apartment in pairs(ApartmentTable) do
            if apartment.Object.owner == plr.Name then
                apartment.Object:Disown()
            end
        end
    end)

    PurchaseApartmentEvent.OnServerInvoke = PurchaseApartment
    SellApartmentEvent.OnServerInvoke = SellApartment
    ToggleDoorEvent.OnServerInvoke = ToggleDoor
    ProximityPromptService.PromptTriggered:Connect(OnPromptTriggered)
end

return ApartmentService