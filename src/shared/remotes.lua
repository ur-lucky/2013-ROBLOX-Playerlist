local Remo = require("@Packages/Remo")
local createRemotes = Remo.createRemotes
local remote = Remo.remote

local remotes = createRemotes({
	sync = remote(),
	init = remote(),
})

return remotes
