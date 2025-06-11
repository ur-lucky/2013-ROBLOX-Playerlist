local flattenAtoms = require("./utils/flatten-atoms")
local playerlist = require("../playerlist").playerlist
local sessiondata = require("../session-data").data

return flattenAtoms({
	playerlist = playerlist,
	sessiondata = sessiondata,
})
