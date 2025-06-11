local Charm = require("@Packages/Charm")
local Sift = require("@Packages/Sift")

local atom = Charm.atom

type userId = string | number

export type PlayersData = {
	sessionStart: number,
}

local data = atom({})

local function setPlayer(id: userId, playerData: PlayersData)
	local _id = tostring(id)

	data(function(state)
		local newState = table.clone(state)
		newState[_id] = playerData
		return newState
	end)
end

local function removePlayer(id: userId)
	local _id = tostring(id)

	data(function(state)
		local newState = table.clone(state)
		newState[_id] = nil
		return newState
	end)
end

local function getPlayers()
	return data()
end

local function getPlayer(id: userId)
	local _id = tostring(id)

	return data()[_id]
end

local function getPlayerByName(username: string)
	local matches = Sift.Dictionary.values(Sift.Dictionary.filter(data(), function(data)
		return data.Username == username
	end))
	return matches[1]
end

return {
	data = { data = data },
	setPlayer = setPlayer,
	removePlayer = removePlayer,
	getPlayers = getPlayers,
	getPlayer = getPlayer,
	getPlayerByName = getPlayerByName,
}
