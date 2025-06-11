local React = require("@Packages/React")
local ReactErrorBoundary = require("@Packages/ReactErrorBoundary")

local fallback = require("./fallback")

local e = React.createElement

return function(props)
	return e(ReactErrorBoundary.ErrorBoundary, {
		fallback = e(fallback),
	})
end
