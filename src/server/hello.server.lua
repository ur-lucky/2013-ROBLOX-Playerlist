local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local Promise = require("@Packages/Promise")
--local playerStore = require("@shared/store/players")
--local store = require("@server/store")
--local useAsync = require("@shared/pretty-react-hooks-lua/use-async")
--local playerSelector = playerStore.selector

local Charm = require("@Packages/Charm")
local playerlist = require("@shared/charm-store/playerlist")
local sessionData = require("@shared/charm-store/session-data")

local function async(callback)
	return function(...)
		local n = select("#", ...)
		local args = { ... }
		return Promise.new(function(resolve, reject)
			coroutine.wrap(function()
				local ok, result = pcall(callback, unpack(args, 1, n))
				if ok then
					resolve(result)
				else
					reject(result)
				end
			end)()
		end)
	end
end

local ownsAsset = function(player: Player, assetId: number)
	local info = Promise.retryWithDelay(function()
		return Promise.new(function(resolve, reject)
			local success, result = pcall(MarketplaceService.PlayerOwnsAsset, MarketplaceService, player, assetId)
			if success then
				resolve(result)
			else
				reject(result)
			end
		end)
	end, 10, 5)
	return info
end

local function checkOldMembershipType(player: Player)
	return Promise.new(function(resolve, reject)
		--print("Premium:", player.MembershipType == Enum.MembershipType.Premium)
		if player.MembershipType == Enum.MembershipType.Premium then
			local hadBuildersClub = ownsAsset(player, 24814192):expect()
			--print("Builders Club:", hadBuildersClub)
			if not hadBuildersClub then
				resolve(Enum.MembershipType.Premium)
			end

			local hadTurboBuildersClub = ownsAsset(player, 11895536):expect()
			--print("Turbo Builders Club:", hadTurboBuildersClub)
			if not hadTurboBuildersClub then
				resolve(Enum.MembershipType.BuildersClub)
			end
			local hadOutrageousBuildersClub = ownsAsset(player, 17407931):expect()
			--print("Outrageous Builders Club:", hadOutrageousBuildersClub)
			if not hadOutrageousBuildersClub then
				resolve(Enum.MembershipType.TurboBuildersClub)
			end

			resolve(Enum.MembershipType.OutrageousBuildersClub)
		end
		resolve(Enum.MembershipType.None)
	end)
end

local function playerAdded(player: Player)
	-- store.addPlayer(player.UserId, {
	-- 	Username = player.Name,
	-- 	DisplayName = player.DisplayName,
	-- 	UserId = player.UserId,
	-- 	MembershipType = checkOldMembershipType(player):expect(),
	-- 	isVerified = player.HasVerifiedBadge,
	-- })

	playerlist.setPlayer(player.UserId, {
		Username = player.Name,
		DisplayName = player.DisplayName,
		UserId = player.UserId,
		MembershipType = checkOldMembershipType(player):expect(),
		isVerified = player.HasVerifiedBadge,
		isFriends = false,
	})

	sessionData.setPlayer(player.UserId, {
		sessionStart = workspace:GetServerTimeNow(),
	})
end

local function playerRemoving(player: Player)
	-- store.removePlayer(player.UserId)
	playerlist.removePlayer(player.UserId)
end

-- store:observe(
-- 	playerSelector.selectPlayers,
-- 	playerSelector.getPlayerId,
-- 	function(playerData: playerStore.PlayerData, userId: string)
-- 		task.delay(1, function()
-- 			store.updatePlayerVerified(userId, true)
-- 			task.wait(1)
-- 			store.updatePlayerVerified(userId, false)
-- 		end)

-- 		local selectPlayer = playerSelector.selectPlayerById(userId)

-- 		local disconnect = store:subscribe(selectPlayer, function(newData)
-- 			print(newData)
-- 		end)

-- 		return function()
-- 			disconnect()
-- 		end
-- 	end
-- )

Charm.observe(playerlist.playerlist.players, function(data, userId: string)
	local player: Player = Players:FindFirstChild(data.Username)

	local getMembership = function()
		local result = playerlist.getPlayer(userId)

		return if result
			then result.MembershipType
			else (Players:FindFirstChild(data.Username) :: Player).MembershipType
	end

	local disconnect = nil

	if player then
		local leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"

		local membership = Instance.new("StringValue")
		membership.Name = "Membership"
		membership.Value = data.MembershipType.Name
		membership.Parent = leaderstats

		leaderstats.Parent = player
		disconnect = Charm.subscribe(getMembership, function(membershipType)
			membership.Value = membershipType.Name
		end)
	end

	-- task.delay(1, function()
	-- 	playerlist.updatePlayerMembership(userId, function(playerData)
	-- 		local newData = table.clone(playerData)
	-- 		newData.MembershipType = Enum.MembershipType.Premium
	-- 		return newData
	-- 	end)
	-- end)

	return function()
		if disconnect then
			disconnect()
		end
		print(data.Username, "left :(")
	end
end)

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)
for _, player: Player in pairs(Players:GetPlayers()) do
	playerAdded(player)
end

--print("hi!")
task.wait(2)
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
	"builder",
	"speedy",
	"shadow",
	"pro",
	"legend",
	"warrior",
	"sniper",
	"hunter",
	"stealth",
	"runner",
	"god",
	"joker",
	"dragon",
	"beast",
	"star",
	"zombie",
	"phantom",
	"queen",
	"wizard",
	"vortex",
	"champion",
	"blaster",
	"captain",
	"cyber",
	"hero",
	"demon",
	"alpha",
	"beta",
	"omega",
	"savage",
	"spark",
	"crusher",
	"blaze",
	"phantom",
	"knight",
	"mystic",
	"destroyer",
	"elite",
	"storm",
	"toxic",
	"phoenix",
	"striker",
	"skull",
	"titan",
	"void",
	"raven",
	"ghost",
	"flash",
	"viper",
	"venom",
	"chaos",
	"infinite",
	"arcade",
	"reaper",
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

for i = 1, 1 do
	while true do
		local fakePlayer = createFakePlayer()
		local user = playerlist.getPlayerByName(fakePlayer.Username)
		if user then
			continue
		end
		playerlist.setPlayer(fakePlayer.UserId, fakePlayer)
		sessionData.setPlayer(fakePlayer.UserId, {
			sessionStart = workspace:GetServerTimeNow(),
		})

		task.delay(1, function()
			sessionData.setPlayer(fakePlayer.UserId, {
				sessionStart = workspace:GetServerTimeNow(),
			})
		end)
		break
	end
	task.wait(0.4)
end
