local ReplicatedStorage = game:GetService('ReplicatedStorage')

local QuestData = require(ReplicatedStorage.QuestData)

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local QuestService = Knit.CreateService {
    Name = "QuestService";
    Client = {};
}

QuestService.Client.QuestDataChanged = Knit.CreateSignal()


function QuestService.Client:GetQuestData(...)
    return QuestService:GetQuestData(...)
end


function QuestService.Client:CompleteQuest(...)
    return QuestService:CompleteQuest(...)
end


function QuestService.Client:DeleteQuest(...)
    return QuestService:DeleteQuest()
end


function QuestService.Client:AddQuest(...)
    return QuestService:AddQuest(...)
end


function QuestService:DeleteQuest(plr, questIndex)

    local PlayerDataService = Knit.GetService('PlayerDataService')
    local CurrentQuestData = PlayerDataService:GetDirectory(plr, 'QuestData')
    CurrentQuestData[questIndex] = nil
    PlayerDataService:SetDirectory(plr, 'QuestData', CurrentQuestData)
    return CurrentQuestData

end


function QuestService:CompleteQuest(plr, questIndex)

    local PlayerDataService = Knit.GetService('PlayerDataService')
    local MoneyService = Knit.GetService('MoneyService')
    local CurrentQuestData = PlayerDataService:GetDirectory(plr, 'QuestData')
    if CurrentQuestData[questIndex] then
        MoneyService:ChangeMoney(plr, CurrentQuestData[questIndex].Reward)
        CurrentQuestData[questIndex] = nil
        if QuestData.Quests[questIndex].NextQuest then
            CurrentQuestData[QuestData.Quests[questIndex].NextQuest] = QuestData.Quests[QuestData.Quests[questIndex].NextQuest]
        end
        PlayerDataService:SetDirectory(plr, 'QuestData', CurrentQuestData)
        return CurrentQuestData
    else
        return 'Error'
    end

end


function QuestService:GetQuestData(plr)

    local PlayerDataService = Knit.GetService('PlayerDataService')
    local CurrentQuestData = PlayerDataService:GetDirectory(plr, 'QuestData')
    --if not CurrentQuestData then
        PlayerDataService:SetDirectory(plr, 'QuestData', QuestData.DefaultQuestData)
        return QuestData.DefaultQuestData
    --end
   -- return CurrentQuestData

end


function QuestService:AddQuest(plr, questIndex)

    local PlayerDataService = Knit.GetService('PlayerDataService')
    local CurrentQuestData = PlayerDataService:GetDirectory(plr, 'QuestData')
    CurrentQuestData[questIndex] = QuestData.Quests[questIndex]

    PlayerDataService:SetDirectory(plr, 'QuestData', CurrentQuestData)
    return CurrentQuestData

end



function QuestService:KnitStart()
    
end


function QuestService:KnitInit()
    
end


return QuestService
