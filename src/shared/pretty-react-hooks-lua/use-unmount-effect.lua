local React = require("@Packages/React")
local useLatest = require("./use-latest")

local useEffect = React.useEffect

return function(callback)
	local callbackRef = useLatest(callback, function(a, b)
		return a == b
	end)

	useEffect(function()
		return function()
			callbackRef.current()
		end
	end, {})
end
