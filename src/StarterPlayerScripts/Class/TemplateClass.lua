local TemplateClass = {}
TemplateClass.__index = TemplateClass


function TemplateClass.new()
    local self = setmetatable({}, TemplateClass)
    return self
end


function TemplateClass:Destroy()
    
end


return TemplateClass
