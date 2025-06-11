local selector = require("./players-selector")
local slice = require("./players-slice")
local types = require("./players-types")

export type PlayerData = types.PlayersData
export type PlayerState = types.PlayersState
export type PlayerActions = types.PlayersActions

return {
	slice = slice,
	selector = selector,
}
