local RunService = game:GetService("RunService")

local React = require("@Packages/React")
local Ripple = require("@Packages/Ripple")



local function useMotion<T>(initialValue: T)
    local motion = React.useMemo(function()
        return Ripple.createMotion(initialValue)
    end, {})

    local binding, setValue = React.useBinding(initialValue)

    React.useEffect(function()
        local connection = RunService.Heartbeat:Connect(function(dt)
            local value = motion:step(dt)

            if value ~= binding:getValue() then
                setValue(value)
            end
        end)

        return function()
            connection:Disconnect()
        end
    end, {})

    return binding, motion
end

return useMotion