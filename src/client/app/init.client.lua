local Players = game:GetService("Players")

local React = require("@Packages/React")
local ReactRoblox = require("@Packages/ReactRoblox")

local e = React.createElement
local createRoot = ReactRoblox.createRoot
local createPortal = ReactRoblox.createPortal

local App = require("./app")

local root = createRoot(Instance.new("Folder"))
local target = Players.LocalPlayer:WaitForChild("PlayerGui")

root:render(createPortal(e(React.StrictMode, nil, e(App)), target))
