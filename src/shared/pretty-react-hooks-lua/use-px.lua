-- Pulled from https://gist.github.com/grilme99/c67a14caa7417b09276f50abbf03a9a4
-- Based on this Typescript implementation by Littensy:
--  https://github.com/littensy/charm-example/blob/7def4fbbfafe13d482edd7b6b89417d4ee42516b/src/client/composables/use-px.ts

local React = require("@Packages/React")

local useState = React.useState
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo

-- Design UI at this resolution
local BASE_RESOLUTION = Vector2.new(1280, 832)
local MIN_SCALE = 0.5
local DOMINANT_AXIS = 0.5

--[[
    Rounds and scales a number to the current `px` unit. Includes additional
    methods for edge cases.
]]
type PxWithMethods = ((value: number) -> number) & {
	even: (value: number) -> number,
	scale: (value: number) -> number,
	floor: (value: number) -> number,
	ceil: (value: number) -> number,
}

--[[
    Scales the current `px` unit based on the current viewport size.
]]
local function usePx(): PxWithMethods
	local scale, setScale = useState(1)

	local camera = workspace.CurrentCamera

	local updateScale = useCallback(function()
		local width = math.log(camera.ViewportSize.X / BASE_RESOLUTION.X, 2)
		local height = math.log(camera.ViewportSize.Y / BASE_RESOLUTION.Y, 2)
		local centered = width + (height - width) * DOMINANT_AXIS

		setScale(math.max(2 ^ centered, MIN_SCALE))
	end, { scale })

	useEffect(function()
		updateScale()

		local connection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

		return function()
			connection:Disconnect()
		end
	end, {})

	local px = useMemo(function()
		return setmetatable({
			even = function(_, value: number)
				return math.round(value * scale * 0.5) * 2
			end,
			scale = function(_, value: number)
				return value * scale
			end,
			floor = function(_, value: number)
				return math.floor(value * scale)
			end,
			ceil = function(_, value: number)
				return math.ceil(value * scale)
			end,
		}, {
			__call = function(_, value: number)
				return math.round(value * scale)
			end,
		})
	end, { scale })

	return px :: any
end

return usePx
