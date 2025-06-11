local useAtom = require("@Packages/ReactCharm").useAtom

local getPlayers = require("@shared/charm-store/playerlist").getPlayers

return function()
	return useAtom(function()
		return getPlayers()
	end)
end
