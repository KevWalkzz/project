local Typewriter = {}

local sound = script:WaitForChild("Sound") :: Sound
function Typewriter.type(object: { Text: string }, text: string, speed: number?, skipFlag: { value: boolean }): ()
	for i = 1, #text, 1 do
		if skipFlag.value then
			object.Text = text
			return
		end
		sound:Play()
		object.Text = string.sub(text, 1, i)
		task.wait(speed or 0.05)
	end
end

return Typewriter
