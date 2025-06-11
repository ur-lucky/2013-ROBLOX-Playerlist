local React = require("@Packages/React")
local useAsyncCallback = require("./use-async-callback")

local useEffect = React.useEffect

return function(callback, deps: {} | nil)
	if deps == nil then
		deps = {}
	end
	local state, asyncCallback = useAsyncCallback(callback)
	useEffect(function()
		asyncCallback()
	end, deps)
	return state.value, state.status, state.message
end
