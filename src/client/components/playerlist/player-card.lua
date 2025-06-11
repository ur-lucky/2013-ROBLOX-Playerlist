local React = require("@Packages/React")

local e = React.createElement
local useMotion = require("@client/hooks/use-motion")
local useEffect = React.useEffect

export type PlayerInfo = {
	Username: string,
	DisplayName: string,
	UserId: number,
	MembershipType: Enum.MembershipType,
	isVerified: boolean,
	isFriends: boolean,
}

export type PlayerCardProps = {
	PlayerInfo: PlayerInfo,
	LayoutOrder: number | React.Binding<number>?,
}

local MEMBERSHIP_TYPE_ICONS = {
	[Enum.MembershipType.None] = "", -- loser
	[Enum.MembershipType.Premium] = "rbxasset://textures/ui/PlayerList/PremiumIcon.png", -- PREMIUM
	[Enum.MembershipType.BuildersClub] = "http://www.roblox.com/asset/?id=107701633816007", -- BC
	[Enum.MembershipType.TurboBuildersClub] = "http://www.roblox.com/asset/?id=109535634995737", -- TBC
	[Enum.MembershipType.OutrageousBuildersClub] = "http://www.roblox.com/asset/?id=97210617382654", -- OBC
}

return function(props: PlayerCardProps)
	local frameSize, setFrameSize = useMotion(0)

	useEffect(function()
		setFrameSize:spring(20, {
			friction = 30,
			tension = 200,
			restingPosition = 0,
			restingVelocity = 5,
		})
	end)

	return e("Frame", {
		Name = `{props.PlayerInfo.Username}`, --"MidTemplate",
		BackgroundTransparency = 1,
		Size = frameSize:map(function(y: number)
			return UDim2.new(1, 0, 0, y)
		end), --UDim2.new(1, 0, 0, 20),
		Position = UDim2.new(0, 0, 0, 0),
		LayoutOrder = props.LayoutOrder,
	}, {
		Background = e("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Name = "Background",
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(430, 20, 430, 20), --Rect.new(460, 20, 460, 20),
			SliceScale = 0.5,
			Image = if props.LayoutOrder % 2 == 1
				then "http://www.roblox.com/asset/?id=94692025"
				else "http://www.roblox.com/asset/?id=94691980",
			ZIndex = 1,
		}),

		Info = e("Frame", {
			Size = UDim2.new(1, -5, 1, 0),
			Position = frameSize:map(function(y: number)
				return UDim2.new(1 - (y / 20), 5, 0, 0)
			end), --UDim2.new(0, 5, 0, 0),
			Name = "Info",
			BackgroundTransparency = 1,
			ZIndex = 2,
		}, {
			ListLayout = e("UIListLayout", {
				Padding = UDim.new(0, 2),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			PremiumLabel = e("ImageLabel", {
				Name = "PremiumLabel",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 2),
				Size = UDim2.new(0, 16, 0, 16),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Image = MEMBERSHIP_TYPE_ICONS[props.PlayerInfo.MembershipType],
				ZIndex = 3,
				LayoutOrder = 1,
			}),
			FriendFrame = e(
				"Frame",
				{
					Name = "FriendFrame",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 21, 0, 0),
					Size = UDim2.new(0, 14, 0, 16),
					ZIndex = 3,
					LayoutOrder = 2,
					Visible = props.PlayerInfo.isFriends,
				},
				e("ImageLabel", {
					Name = "FriendLabel",
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 20, 0, 20),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					ScaleType = Enum.ScaleType.Fit,
					Image = props.PlayerInfo.isFriends and "http://www.roblox.com/asset/?id=139581149110952" or "",
				})
			),
			TitleFrame = e("Frame", {
				Name = "TitleFrame",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 37, 0, 0),
				Size = UDim2.new(0, props.PlayerInfo.isVerified and 156 or 140, 1, 0),
				ClipsDescendants = true,
				LayoutOrder = 3,
			}, {
				TitleLabel = e("TextLabel", {
					Name = "TitleLabel",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					FontFace = Font.fromName(
						"Arimo",
						1 == props.PlayerInfo.UserId and Enum.FontWeight.Bold or Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					),
					TextSize = 14,
					TextColor3 = Color3.new(1, 1, 1),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					ZIndex = 3,

					Text = `{props.PlayerInfo.DisplayName}{props.PlayerInfo.isVerified and utf8.char(0xe000) or ""}`,
				}),

				DropShadow = false and e("TextLabel", {
					Name = "DropShadow",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 6, 0, 1),
					Size = UDim2.new(100, 0, 1, 0),
					FontFace = Font.fromName("Arimo", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
					TextSize = 14,
					TextColor3 = Color3.new(0, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					ZIndex = 2,

					Text = `{props.PlayerInfo.DisplayName}{props.PlayerInfo.isVerified and utf8.char(0xe000) or ""}`,
				}),
			}),
		}),
	})
end
