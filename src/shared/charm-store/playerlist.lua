local Charm = require("@Packages/Charm")
local Sift = require("@Packages/Sift")

local atom = Charm.atom

type userId = string | number

export type PlayersData = {
	Username: string,
	DisplayName: string,
	UserId: number,
	MembershipType: Enum.MembershipType,
	isVerified: boolean,
}

local playerlist = {
	players = atom({}),
}

local function setPlayer(id: userId, data: PlayersData)
	local _id = tostring(id)
	playerlist.players(function(state)
		local newState = table.clone(state)
		newState[_id] = data
		return newState
	end)
end

local function removePlayer(id: userId)
	local _id = tostring(id)

	playerlist.players(function(state)
		local newState = table.clone(state)
		newState[_id] = nil
		return newState
	end)
end

local function getPlayers()
	return playerlist.players()
end

local function getPlayer(id: userId)
	local _id = tostring(id)

	return playerlist.players()[_id]
end

local function getPlayerByName(username: string)
	local matches = Sift.Dictionary.values(Sift.Dictionary.filter(playerlist.players(), function(data)
		return data.Username == username
	end))
	return matches[1]
end

local function updatePlayerMembership(id: userId, updater: (PlayersData) -> PlayersData)
	local _id = tostring(id)
	playerlist.players(function(state)
		local newState = table.clone(state)
		newState[_id] = state[_id] and updater(state[_id])
		return newState
	end)
end

return {
	playerlist = playerlist,
	setPlayer = setPlayer,
	removePlayer = removePlayer,
	getPlayers = getPlayers,
	getPlayer = getPlayer,
	getPlayerByName = getPlayerByName,
	updatePlayerMembership = updatePlayerMembership,
}
