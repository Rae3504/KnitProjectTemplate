local Players = game:GetService('Players')

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local NameGuiService = Knit.CreateService {
    Name = "NameGuiService";
    Client = {};
}


function NameGuiService:KnitStart()
    
    local function addGui(plr, gr, ar, adr, fs)
        local rank
        if ar >= 1 and gr < 121 then
            rank = plr:GetRoleInGroup(5170977)
        elseif adr >= 1 and gr < 121 then
            rank = plr:GetRoleInGroup(5170982)
        else
            rank = plr:GetRoleInGroup(5169183)
        end

        local gui = game.ReplicatedStorage.NameGui:Clone()
        gui.Parent = plr.Character:WaitForChild('HumanoidRootPart')
        gui.Frame.NameText.Text = plr.DisplayName
        if rank == 'Guest' then
            rank = 'Immigrant'
        end
        gui.Frame.RankText.Text = rank
        if game.Teams:FindFirstChild(rank) then
            gui.Frame.RankText.TextColor3 = game.Teams[rank].TeamColor.Color
        end
        
        if ar >= 1 and adr == 0 then
            gui.Frame.DivisionText.Text = 'Armed Forces'
            gui.Frame.RankText.TextColor3 = game.Teams['Armed Forces'].TeamColor.Color
        elseif adr >= 1 and ar == 0 then
            gui.Frame.DivisionText.Text = 'Admissions'
            gui.Frame.RankText.TextColor3 = game.Teams['Admissions'].TeamColor.Color
        elseif fs >= 1 and gr < 254 then
            gui.Frame.DivisionText.Text = 'Federal Security Service'
            gui.Frame.RankText.TextColor3 = game.Teams['Federal Security Service'].TeamColor.Color
        else
            gui.Frame.DivisionText.Visible = false
        end
    end

    Players.PlayerAdded:Connect(function(plr)
        local gr = plr:GetRankInGroup(5169183)
        local ar = plr:GetRankInGroup(5170977)
        local adr = plr:GetRankInGroup(5170982)
        local fs = plr:GetRankInGroup(9756886)
        if not gr then
            gr = 0
        end
        if not ar then
            ar = 0
        end
        if not adr then
            adr = 0
        end
        if not fs then
            fs = 0
        end
        if not plr.Character then
            plr.CharacterAdded:Wait()
            addGui(plr, gr, ar, adr, fs)
        else
            addGui(plr, gr, ar, adr, fs)
        end
        plr.CharacterAdded:Connect(function()
            addGui(plr, gr, ar, adr, fs)
        end)
    end)

end


function NameGuiService:KnitInit()
    
end


return NameGuiService
