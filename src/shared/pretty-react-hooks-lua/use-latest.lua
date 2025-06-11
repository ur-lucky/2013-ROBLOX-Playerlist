local React = require("@Packages/React")

local useMemo = React.useMemo
local useRef = React.useRef

type Predicate<T> = (previous: T | nil, current: T) -> boolean

local isStrictEqual = function(a: any, b: any)
	return a == b
end

return function<T>(value: T, predicate: Predicate<T>?)
	local predicateFunc: Predicate<T> = predicate or isStrictEqual

	local ref = useRef(value)

	useMemo(function()
		if not predicateFunc(ref.current, value) then
			ref.current = value
		end
	end, { value })

	return ref :: { current: T }
end
