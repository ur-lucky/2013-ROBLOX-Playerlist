local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local React = require("@Packages/React")
local Sift = require("@Packages/Sift")

local useMotion = require("@client/hooks/use-motion")
local e = React.createElement
local useState = React.useState
local useEffect = React.useEffect
local usePlayerlist = require("@client/hooks/use-playerlist")

local PlayerCard = require("./player-card")

local LocalPlayer = Players.LocalPlayer

type PlayerCardType = {
	PlayerInfo: PlayerCard.PlayerInfo,
	LayoutOrder: number,
}

local MemoizedPlayerCard = React.memo(function(info: PlayerCardType)
	return e(PlayerCard, {
		PlayerInfo = info.PlayerInfo,
		LayoutOrder = info.LayoutOrder,
	})
end, function(newProps: PlayerCardType, oldProps: PlayerCardType)
	return Sift.Dictionary.equals(newProps.PlayerInfo or {}, oldProps.PlayerInfo or {})
		and newProps.LayoutOrder == oldProps.LayoutOrder
end)

local function createPlayers(props: {
	Players: { PlayerCard.PlayerInfo },
})
	local frames = {}
	for orderIndex, player: PlayerCard.PlayerInfo in pairs(props.Players or {}) do
		frames[player.UserId] = e(MemoizedPlayerCard, {
			PlayerInfo = player,
			LayoutOrder = orderIndex,
		})
	end
	return e(React.Fragment, nil, frames)
end

return function(props)
	local playerListAbsoluteSizeY, setPlayerListAbsoluteSizeY = useState(0)
	local playerListContentSizeY, setPlayerListContentSizeY = useState(0)
	local playerListShrinkOffset, setPlayerListShrinkOffset = useState(0)
	local playerListSpring, setPlayerListSpring = useMotion(0)

	local isCollapsed, setCollapsed = useState(false)
	local collapseSpring, setCollapseSpring = useMotion(0)

	local dragConnection = React.useRef(nil :: RBXScriptConnection?)

	local playerList = usePlayerlist()
	local players, setPlayers = useState({})
	local playerCount, setPlayerCount = useState(0)

	useEffect(function()
		local _players = Sift.Dictionary.values(playerList)

		table.sort(_players, function(a, b)
			if a.UserId == LocalPlayer.UserId then
				return true
			elseif b.UserId == LocalPlayer.UserId then
				return false
			end

			return a.Username < b.Username
		end)

		setPlayerCount(#_players)
		setPlayers(_players)
	end, {
		playerList,
	})

	useEffect(function()
		if isCollapsed then
			setPlayerListSpring:spring(0, {
				friction = 40,
				tension = 400,
				restingPosition = 0,
				restingVelocity = 5,
			})
			setCollapseSpring:spring(1, {
				friction = 20,
				tension = 200,
				restingPosition = 0.001,
				restingVelocity = 0.01,
			})
		else
			setPlayerListSpring:spring(
				math.min(playerListContentSizeY, playerListAbsoluteSizeY - 48) - playerListShrinkOffset,
				{
					friction = 20,
					tension = 400,
					restingPosition = 0.001,
					restingVelocity = 0.01,
				}
			)
			setCollapseSpring:spring(0, {
				friction = 20,
				tension = 200,
				restingPosition = 0.001,
				restingVelocity = 0.01,
			})
		end
	end, {
		playerListAbsoluteSizeY,
		playerListContentSizeY,
		playerListShrinkOffset,
		playerList,
		isCollapsed == true and 1 or 0,
	})

	return e("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -10, 0, 10),
		Size = UDim2.new(0, 220, 0.5, 0),

		[React.Change.AbsoluteSize] = function(frame)
			setPlayerListAbsoluteSizeY(frame.AbsoluteSize.Y)
		end,
	}, {
		ListLayout = e("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
		}),

		Header = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 48), -- 24
			LayoutOrder = 1,
		}, {
			Decor = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://94692054",
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 1, 0),
				SliceCenter = Rect.new(20, 95, 445, 95), -- 15 55
			}),

			TitleLabel = e("TextLabel", {
				AnchorPoint = Vector2.new(1, 0),
				Name = "TitleLabel",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -5, 0, 0),
				Size = UDim2.new(1, 0, 0, 24),
				FontFace = Font.fromName("Arimo", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				TextSize = 16,
				TextColor3 = Color3.new(1, 1, 1),
				TextStrokeTransparency = 0,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Center,
				ZIndex = 3,

				Text = `{playerCount}`,
			}),
		}),

		MidSection = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			ClipsDescendants = true,
		}, {
			Decor = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://94692025",
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 1, 0),
				SliceCenter = Rect.new(430, 20, 430, 20), --Rect.new(460, 20, 460, 20),
				SliceScale = 0.5,

				Visible = false,
			}),

			ScrollableList = e("ScrollingFrame", {
				BackgroundTransparency = 1,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				--Size = UDim2.new(1, 5, 1, 0),
				Size = playerListSpring:map(function(y: number)
					return UDim2.new(1, 5, 0, y)
				end),
				Position = UDim2.new(0, 0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 2,
				ClipsDescendants = true,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = Color3.new(0.2, 0.2, 0.2),
				ScrollBarImageTransparency = collapseSpring:map(function(y: number)
					return y
				end),

				[React.Change.AbsolutePosition] = function(scrollFrame: ScrollingFrame, AbsolutePosition: Vector2) end,
			}, {
				scrollBarPadding = e("UIPadding", {
					PaddingLeft = UDim.new(0, 0),
					PaddingTop = UDim.new(0, 0),
					PaddingRight = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 0),
				}),

				playerListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 0),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					[React.Change.AbsoluteContentSize] = function(listLayout: UIListLayout)
						local ScrollingFrame = listLayout.Parent :: ScrollingFrame
						if not ScrollingFrame then
							return
						else
							local AbsoluteContentSize = listLayout.AbsoluteContentSize
							setPlayerListContentSizeY(AbsoluteContentSize.Y)
							return
						end
					end,
				}),

				players = e(createPlayers, {
					Players = players,
				}),
			}),
		}),

		Footer = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 24),
			LayoutOrder = 3,
		}, {
			Decor = e("ImageButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://94754966",
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 1, 0),
				SliceCenter = Rect.new(20, 47, 269, 47),

				[React.Event.InputBegan] = function(button, input)
					if
						input.UserInputType == Enum.UserInputType.MouseButton1
						or input.UserInputType == Enum.UserInputType.Touch
					then
						if not dragConnection.current and not isCollapsed then
							local startPos = UserInputService:GetMouseLocation()
								- Vector2.new(0, GuiService:GetGuiInset().Y)
							local startOffset = playerListShrinkOffset
							dragConnection.current = RunService.Heartbeat:Connect(function(dt)
								local mousePos = UserInputService:GetMouseLocation()
									- Vector2.new(0, GuiService:GetGuiInset().Y)

								local offset = math.clamp(
									startOffset + (startPos.Y - mousePos.Y),
									0,
									math.min(playerListContentSizeY, playerListAbsoluteSizeY)
								)
								print(offset)
								setPlayerListShrinkOffset(offset)
							end) :: RBXScriptConnection
						end
					end
				end,
				[React.Event.InputEnded] = function(_, input)
					if
						input.UserInputType == Enum.UserInputType.MouseButton1
						or input.UserInputType == Enum.UserInputType.Touch
					then
						if dragConnection.current then
							dragConnection.current:Disconnect()
							dragConnection.current = nil
						end
					end
				end,
			}, {
				MinimizeButton = e("ImageButton", {
					AnchorPoint = Vector2.new(0.5, 1),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Image = "rbxassetid://94825585",
					Position = UDim2.new(1, -57, 1, 0),
					Size = UDim2.new(0, 70, 0, 20),

					[React.Event.Activated] = function()
						setCollapsed(not isCollapsed)
					end,
				}),
			}),
		}),
	})
end
