local Info = {}

Info.Dialog = {
	[1] = {
		Text = "You seem to have a lot of questions. Go ahead.",
		Choices = {
			[1] = { Text = "Who are you?", Follow = true },
			[2] = { Text = 'What kind of "different" am i?', Next = 2 },
		},
	},
	[2] = {
		Text = "You got something special. Something that only someone like me could teach",
		Choices = {
			[1] = { Text = "That sounds menacing..." },
			[2] = { Text = 'What kind of "different" am i?', Next = 3 },
		},
	},
	[3] = {
		Text = "You got something called Heavenly path. I can feel it just by your presence.",
		Choices = {
			[1] = { Text = 'And what is a "Heavenly path"?', Next = 5, Follow = true },
			[2] = { Text = "That means that i can absorb energy?", Next = 4 },
		},
	},
	[4] = {
		Text = "You can cultivate Qi to become stronger by breaking through realms. But your body must be ready to do so.",
		Choices = {
			[1] = { Text = "Alright, when do i begin?" },
			[2] = { Text = "I... i think i am not certain of that." },
		},
	},
	[5] = {
		Text = "A heavenly path, basically, is something that flows inside you. A kind of energy.There are three primal types of energy, and it usually defines your alignement. Demonic Path, Bestial Path, and your path, the Heavenly Path.",
		Choices = {},
	},
}

return Info
