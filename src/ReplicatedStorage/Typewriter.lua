local Typewriter = {}

local sound = script:WaitForChild("Sound") :: Sound
function Typewriter.type(object, text, speed)
	for i = 1, #text, 1 do
		sound:Play()
		object.Text = string.sub(text, 1, i)
		task.wait(speed)
	end
end

return Typewriter
