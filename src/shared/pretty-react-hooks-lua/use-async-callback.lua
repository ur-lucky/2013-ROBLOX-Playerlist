local Promise = require("@Packages/Promise")
local React = require("@Packages/React")
local useUnmountEffect = require("./use-unmount-effect")

local useRef = React.useRef
local useState = React.useState
local useCallback = React.useCallback

return function(callback)
	local currentPromise: { current: nil | Promise.Promise } = useRef(nil)
	local state, setState = useState({
		status = Promise.Status.Started :: Promise.Status,
	})
	local execute = useCallback(function(...)
		local result = currentPromise.current
		if result ~= nil then
			result:cancel()
		end
		if state.status ~= Promise.Status.Started then
			setState({
				status = Promise.Status.Started,
			})
		end
		local promise: Promise.Promise = callback(unpack({ ... }))
		promise:andThen(function(value)
			return setState({
				status = promise:getStatus(),
				value = value,
			})
		end, function(message)
			return setState({
				status = promise:getStatus(),
				message = message,
			})
		end)
		currentPromise.current = promise
		return currentPromise.current
	end, { callback })
	useUnmountEffect(function()
		local _result = currentPromise.current
		if _result ~= nil then
			_result:cancel()
		end
	end)
	return state, execute
end
