local CharmSync = require("@Packages/CharmSync")
local atoms = require("./atoms")
local filterPayload = require("./utils/filter-payload")
local remotes = require("@shared/remotes")

local syncer = CharmSync.server({
	atoms = atoms,
})
syncer:connect(function(player: Player, payload)
	remotes.sync(player, filterPayload(player, payload))
end)

remotes.init:connect(function(player)
	syncer:hydrate(player)
end)
