local UserInputService = game:GetService("UserInputService")
local React = require("@Packages/React")
local useEventListener = require("@shared/pretty-react-hooks-lua/use-event-listener")
local useInputDevice = require("@client/hooks/use-input-device")
local useLatest = require("@shared/pretty-react-hooks-lua/use-latest")

local useState = React.useState
local useMemo = React.useMemo

return function(enabled: boolean)
	local _enabled = if enabled == nil then true else enabled
	local state, setState = useState({
		press = false,
		hover = false,
	})
	local press = state.press
	local hover = state.hover
	local on = useLatest(enabled)
	local touch = useLatest(useInputDevice() == "touch")
	local events = useMemo(function()
		return {
			onMouseDown = function()
				return setState(function(state)
					local newState = table.clone(state)
					newState.press = on.current
					return newState
				end)
			end,
			onMouseUp = function()
				return setState(function(state)
					local newState = table.clone(state)
					newState.press = false
					return newState
				end)
			end,
			onMouseEnter = function()
				return setState(function(state)
					local newState = table.clone(state)
					newState.hover = on.current and not touch.current
					return newState
				end)
			end,
			onMouseLeave = function()
				return setState({
					press = false,
					hover = false,
				})
			end,
		}
	end, {})
	-- Touch devices might not fire mouse leave events, so assume that all
	-- releases are a mouse leave.
	useEventListener(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			setState({
				press = false,
				hover = false,
			})
		end
	end)
	return press, hover, events
end
