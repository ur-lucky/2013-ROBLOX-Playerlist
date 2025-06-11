local React = require("@Packages/React")

local e = React.createElement

local ErrorBoundary = require("../components/error-boundary")
local Playerlist = require("../components/playerlist")

return function()
	React.useEffect(function()
		print("mounted!")
	end)

	return e("ScreenGui", { ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, e(Playerlist, nil, nil))
end
