local UserInputService = game:GetService("UserInputService")

local React = require("@Packages/React")
local useEventListener = require("@shared/pretty-react-hooks-lua/use-event-listener")

local useState = React.useState

local getInputType = function(inputType: Enum.UserInputType | nil)
	if inputType == nil then
		inputType = UserInputService:GetLastInputType()
	end

	if inputType == Enum.UserInputType.Keyboard or inputType == Enum.UserInputType.MouseMovement then
		return "keyboard"
	elseif inputType == Enum.UserInputType.Gamepad1 then
		return "gamepad"
	elseif inputType == Enum.UserInputType.Touch then
		return "touch"
	end

	return "unknown"
end

return function()
	local device, setDevice = useState(function()
		return getInputType() or "keyboard"
	end)

	useEventListener(UserInputService.LastInputTypeChanged, function(inputType)
		local newDevice = getInputType(inputType)
		if newDevice ~= nil then
			setDevice(newDevice)
		end
	end)
	return device
end
