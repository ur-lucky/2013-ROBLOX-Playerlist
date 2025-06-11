local React = require("@Packages/React")

local e = React.createElement

type children = { [string]: React.ReactNode }

export type FrameProps = {
	size: UDim2 | React.Binding<UDim2>?,
	position: UDim2 | React.Binding<UDim2>?,
	anchorPoint: Vector2 | React.Binding<Vector2>?,
	rotation: number | React.Binding<number>?,
	backgroundColor: Color3 | React.Binding<Color3>?,
	backgroundTransparency: number | React.Binding<number>?,
	clipsDescendants: boolean | React.Binding<boolean>?,
	visible: boolean | React.Binding<boolean>?,
	zIndex: number | React.Binding<number>?,
	layoutOrder: number | React.Binding<number>?,

	cornerRadius: UDim | React.Binding<UDim>?,
}

return function(props: FrameProps & children)
	return e(
		"frame",
		{
			Size = props.size,
			Position = props.position,
			AnchorPoint = props.anchorPoint,
			Rotation = props.rotation,
			BackgroundColor3 = props.backgroundColor,
			BackgroundTransparency = props.backgroundTransparency,
			ClipsDescendants = props.clipsDescendants,
			Visible = props.visible,
			ZIndex = props.zIndex,
			LayoutOrder = props.layoutOrder,
		} :: FrameProps,
		props.children,
		props.cornerRadius and e("uicorner", {
			CornerRadius = props.cornerRadius,
		})
	)
end
