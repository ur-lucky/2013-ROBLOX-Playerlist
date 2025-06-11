local types = require("./players-types")

local selectPlayers = function(state: types.MockRootState)
	return state.players
end

local selectPlayerById = function(id: string | number)
	return function(state: types.MockRootState)
		return state.players[tostring(id)]
	end
end

local getPlayerId = function(player: types.PlayersData, index: string)
	return tostring(player.UserId)
end

return {
	selectPlayers = selectPlayers,
	selectPlayerById = selectPlayerById,
	getPlayerId = getPlayerId,
}
