local players = require("./players")

export type PlayerData = players.PlayerData
export type PlayerState = players.PlayerState
export type PlayerActions = players.PlayerActions

return {
	players = players.slice,
}
