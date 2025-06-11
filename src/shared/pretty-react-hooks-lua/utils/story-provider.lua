local React = require("@Packages/React")
local ReactRoblox = require("@Packages/ReactRoblox")
local UILabs = require("@Packages/UI-Labs")

return function(TestComponent, controls: {} | nil)
	return UILabs.CreateReactStory({
		react = React,
		reactRoblox = ReactRoblox,
		controls = {},
	}, function(props)
		return React.createElement(TestComponent, { Controls = props })
	end)
end
