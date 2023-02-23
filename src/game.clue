local terminal = import("terminal")

local names = {}

local i = 1
for name with love.filesystem.lines("names.txt") {
	names[i] = name
	i += 1
}

local user = {
	new = fn(self) {
		self.name = names[love.math.random(1, 3000)]
		self.age = math.floor(love.math.randomNormal(7, 49))
		self.code = "???"
		self.time = leveltime
	}
}

user::new()

local score = 0
local commands

commands = {
	score = {
		desc = "Display current score."
		code = fn {
			terminal::write("Score: " .. score, nil, 1, 0, 1)
		}
	}
	user = {
		desc = "Display the info of the user trying to connect."
		code = fn {
			terminal::write("Name: " .. user.name, 60, 1, 1, 0)
			terminal::write("Age: " .. user.age, 60, 1, 1, 0)
			terminal::write("Entry Code: " .. user.code, 60, 1, 1, 0)
		}
	}
}

return commands