local Reflex = require("@Packages/Reflex")

export type PlayersData = {
	Username: string,
	DisplayName: string,
	UserId: number,
	MembershipType: Enum.MembershipType,
	isVerified: boolean,
}

type userId = string
export type PlayersState = {
	[userId]: PlayersData,
}

export type PlayersActions = {
	addPlayer: (userId: string | number, playerData: PlayersData) -> (),
	removePlayer: (userId: string | number) -> (),
	updatePlayerPremium: (userId: string | number, membershipType: Enum.MembershipType) -> (),
	updatePlayerVerified: (userId: string | number, isVerified: boolean) -> (),
}

export type PlayersProducer = Reflex.Producer<PlayersState, PlayersActions>

export type MockRootState = {
	players: PlayersState,
}

return {}
