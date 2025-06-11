local React = require("@Packages/React")
--local RootProvider = require("@client/providers/root-provider")
local storybook = require("@shared/pretty-react-hooks-lua/utils/story-provider")
--local usePx = require("@shared/pretty-react-hooks-lua/use-px")

local Playerlist = require("@shared/charm-store/playerlist")

local Component = require("@client/components/playerlist")

local e = React.createElement

local Seed = Random.new()

local FAKE_NAMES = {
	"potato",
	"skibidi",
	"gamer",
	"guest",
	"cool",
	"robloxer",
	"awesome",
	"ninja",
	"admin",
	"character",
	"master",
	"king",
	"fortnite",
	"epic",
}

local MEMBERSHIP_NAMES = {
	Enum.MembershipType.BuildersClub,
	Enum.MembershipType.TurboBuildersClub,
	Enum.MembershipType.OutrageousBuildersClub,
	Enum.MembershipType.Premium,
	Enum.MembershipType.None,
}

local function createFakePlayer()
	local GENERATED_NAME =
		`{FAKE_NAMES[Seed:NextInteger(1, #FAKE_NAMES)]}_{FAKE_NAMES[Seed:NextInteger(1, #FAKE_NAMES)]}`
	local fakePlayer = {
		Username = GENERATED_NAME,
		DisplayName = GENERATED_NAME,
		UserId = Seed:NextInteger(10_000_000, 100_000_000),
		MembershipType = MEMBERSHIP_NAMES[Seed:NextInteger(1, #MEMBERSHIP_NAMES)],
		isVerified = Seed:NextInteger(1, 4) == 1,
		isFriends = Seed:NextInteger(1, 3) == 1,
	}

	return fakePlayer
end

for i = 1, 30 do
	local fakePlayer = createFakePlayer()
	Playerlist.setPlayer(fakePlayer.UserId, fakePlayer)
end

return storybook(function()
	return e(Component)
end)
