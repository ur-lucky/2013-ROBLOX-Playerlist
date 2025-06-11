local Reflex = require("@Packages/Reflex")
local Sift = require("@Packages/Sift")
local types = require("./players-types")

local createProducer = Reflex.createProducer

local initialState: types.PlayersState = {}

return createProducer(initialState, {
	addPlayer = function(state, userId: string | number, data: types.PlayersData)
		local newState = table.clone(state)

		newState[tostring(userId)] = data

		return newState
	end,

	removePlayer = function(state, userId: string | number)
		local newState = table.clone(state)

		newState[tostring(userId)] = nil

		return newState
	end,

	updatePlayerPremium = function(state, userId: string | number, membershipType: Enum.MembershipType)
		--return Sift.Dictionary.update(state, userId, function(playersData: { [string]: PlayersState })

		return Sift.Dictionary.update(state, tostring(userId), function(playerData: types.PlayersData)
			return Sift.Dictionary.set(playerData, "MembershipType", membershipType)
		end)

		--end)
	end,

	updatePlayerVerified = function(state, userId: string | number, isVerified: boolean)
		--return Sift.Dictionary.update(state, userId, function(playersData: { [string]: PlayersState })

		return Sift.Dictionary.update(state, tostring(userId), function(playerData: types.PlayersData)
			return Sift.Dictionary.set(playerData, "isVerified", isVerified)
		end)

		--end)
	end,
}) :: types.PlayersProducer
