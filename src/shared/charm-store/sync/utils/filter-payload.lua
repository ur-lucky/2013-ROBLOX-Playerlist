local Sift = require("@Packages/Sift")

local filters = {
	["sessiondata/data"] = function(userId, data)
		return {
			[userId] = data[userId],
		}
	end,
}

return function(player: Player, payload)
	local userId = tostring(player.UserId)
	local updatedData = {}

	for key, filterFunc in pairs(filters) do
		if Sift.Dictionary.has(payload.data, key) then
			local filteredData = filterFunc(userId, payload.data[key])
			updatedData[key] = filteredData
		end
	end

	return Sift.Dictionary.merge(payload, {
		data = Sift.Dictionary.merge(payload.data, updatedData),
	})
end
