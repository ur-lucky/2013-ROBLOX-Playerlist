local CharmSync = require("@Packages/CharmSync")
local atoms = require("./atoms")
local remotes = require("@shared/remotes")

local syncer = CharmSync.client({
	atoms = atoms,
})

remotes.sync:connect(function(payload)
	print(payload)
	syncer:sync(payload)
end)

remotes.init()
