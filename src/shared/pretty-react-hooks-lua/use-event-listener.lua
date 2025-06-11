local React = require("@Packages/React")
local useLatest = require("./use-latest")

local useEffect = React.useEffect

type EventLike = RBXScriptSignal | {
	Connect: ((...any) -> any) -> RBXScriptConnection,
	connect: ((...any) -> any) -> RBXScriptConnection?,
	subscribe: ((...any) -> any) -> any?,
}

local connect = function(event: RBXScriptSignal, callback)
	if typeof(event) == "RBXScriptSignal" then
		local connection: RBXScriptConnection
		connection = event:Connect(function(...)
			local args = { ... }
			if connection.Connected then
				return callback(unpack(args))
			end
		end)
		return connection
	elseif event.Connect ~= nil then
		return event:Connect(callback)
	elseif event.connect ~= nil then
		return event:connect(callback)
	elseif event.subscribe ~= nil then
		return event:subscribe(callback)
	else
		error("Event-like object does not have a supported connect method.")
	end
end

local disconnect = function(connection: RBXScriptConnection | (any?) -> any? | { disconnect: (any?) -> any? })
	if type(connection) == "function" then
		connection()
	else
		if typeof(connection) == "RBXScriptConnection" and connection.Disconnect ~= nil then
			connection:Disconnect()
		elseif typeof(connection) ~= "RBXScriptConnection" and connection.disconnect ~= nil then
			connection:disconnect()
		else
			error("Connection-like object does not have a supported disconnect method.")
		end
	end
end

type options = {
	once: boolean?,
	connected: boolean?,
}

return function(event: RBXScriptSignal, listener: (any?) -> nil, options: options?)
	local _options = (if options == nil then {} else options) :: options
	--local _listener = listener or function(...) end
	local once = if _options.once == nil then false else _options.once
	local connected = if _options.connected == nil then true else _options.connected

	local listenerRef = useLatest(listener)
	useEffect(function(): nil | () -> ()
		if not event or not listener or not connected then
			return nil
		end
		local canDisconnect = true
		local connection
		connection = connect(event, function(...)
			local args = { ... }
			if once then
				disconnect(connection)
				canDisconnect = false
			end
			local _result = listenerRef.current
			if _result ~= nil then
				_result(unpack(args))
			end
		end)
		return function()
			if canDisconnect then
				disconnect(connection)
			end
		end
	end, { event })
end
