local TweenService = game:GetService("TweenService")

local anim = {}

function anim.Animate(
	object: Instance,
	propertyTable: { [string]: any },
	duration: number?,
	easingStyle: Enum.EasingStyle?,
	easingDirection: Enum.EasingDirection?
): ()
	easingStyle = easingStyle or Enum.EasingStyle.Linear
	easingDirection = easingDirection or Enum.EasingDirection.Out

	local tweenInfo = TweenInfo.new(duration or 1, easingStyle, easingDirection, 0, false, 0)

	local tween = TweenService:Create(object, tweenInfo, propertyTable)

	tween:Play()
end

return anim
