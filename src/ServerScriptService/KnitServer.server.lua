local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.Components = script.Parent.Components
Knit.Class = script.Parent.Class
Knit.Modules = script.Parent.Modules
Knit.SharedModules = ReplicatedStorage.Modules

Knit.AddServices(script.Parent.Services)

Knit.Start():andThen(function()
    print('Knit started')
end):catch(warn):await()