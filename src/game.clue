local terminal = import("terminal")

local score = 0
local commands

commands = {
	score = {
		desc = "Display current score."
		code = fn {
			terminal::write("Score: " .. score, nil, 1, 0, 1)
		}
	}
}

return commands