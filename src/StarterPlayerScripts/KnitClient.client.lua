local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.Gui = script.Parent.Gui
Knit.Class = script.Parent.Class
Knit.Modules = script.Parent.Modules
Knit.SharedModules = ReplicatedStorage.Modules

Knit.AddControllers(script.Parent.Controllers)

Knit.Start({ServicePromises = false}):andThen(function()
    print('Knit started')
end):catch(warn)

for _,v in pairs(script.Parent.Components:GetChildren()) do
    require(v)
end