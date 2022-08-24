local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local ComponentService = Knit.CreateService {
    Name = "ComponentService";
    Client = {};
}


function ComponentService:KnitStart()
    
    for _,v in pairs(Knit.Components:GetChildren()) do
        require(v)
    end

end


function ComponentService:KnitInit()
    
end


return ComponentService
