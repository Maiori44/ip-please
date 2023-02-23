static offset = 0
static pointer = 1

local utf8 = require("utf8")
local terminal = import("terminal")

local commands
commands = {
	help = {
		desc = "Display this message."
		code = fn {
			terminal::write("List of currently available commands:")
			for k, v of commands {
				terminal::write(string.format("%s - %s", k::upper(), v.desc))
			}
			local game_commands = getmetatable(commands)?.__index
			if game_commands {
				for k, v of game_commands {
					terminal::write(string.format("%s - %s", k::upper(), v.desc))
				}
			}
		}
	}
	fps = {
		desc = "Display the game's FPS."
		code = fn {
			local fps = love.timer.getFPS()
			terminal::write("FPS: " .. tostring(fps), 30, (1 - fps / 60) * 2, fps / 60, 0)
		}
	}
	memory = {
		desc = "Display the amount of memory in use."
		code = fn {
			terminal::write(string.format("Used memory: %dkb", collectgarbage("count")))
		}
	}
	clear = {
		desc = "Clears the terminal."
		code = fn {
			for k, _ in terminal {
				terminal[k] = nil
			}
			love.wheelmoved(0, 0)
		}
	}
	guide = {
		desc = "Explains how to play the game."
		code = fn {
			terminal::write("Welcome to IP Please!")
			terminal::write("You are the admin of a private server.")
			terminal::write("Many people want to join, your job is to let them in.")
			terminal::write("(Type 'allow' to let a user in)")
			terminal::write("Hackers may try to infiltrate, do not let them in.")
			terminal::write("(Type 'deny' to not let a user in)")
			terminal::write("Hackers will have an invalid entry code.")
			terminal::write("Type 'codes' to get a list of currently valid codes.")
			terminal::write("(Valid codes change every 30 seconds)")
			terminal::write("Trolls will try to join with high ages (80+), do not let them in.")
			terminal::write("Lastly, deny anyone younger than 14.")
			terminal::write("Allowing and denying correctly will grant you points.")
			terminal::write("(The faster you are the more points you get)")
			terminal::write("Messing up may lead to the end of the server.")
			terminal::write("Good luck, and thanks for playing!", 60, 1, 1, 0)
		}
	}
	start = {
		desc = "Starts the game."
		code = fn {
			terminal::write("Starting server...", 5)
			terminal::write("Done!")
			terminal::write("Reading first user's information...", 15)
			commands.start = nil
			setmetatable(commands, {
				__index = import("game")
			})
			commands.user.code()
			terminal::write("(If this is your first time playing, type 'guide' for help)")
		}
	}
}

method love.keypressed(key) {
	if hacked {
		return
	}
	if terminal::finished() {
		local input = terminal.input[1]::gsub("%s+", "")
		match key {
			"up" if pointer < #terminal.input => {
				pointer += 1
				terminal.input[1] = terminal.input[pointer]
			}
			"down" if pointer > 1 => {
				pointer -= 1
				terminal.input[1] = terminal.input[pointer]
			}
			"backspace" => {
				local byteoffset = utf8.offset(input, -1)
				if byteoffset {
					terminal.input[1] = $::sub(1, byteoffset - 1)
				}
			}
			"return" => {
				pointer = 1
				if input == "" {
					terminal.input[1] = ""
					return
				}
				local command = commands[input::lower()]?.code
				if command {
					command()
				} else {
					terminal::write(input .. ": command not found", nil, 1, 0, 0)
				}
				table.insert(terminal.input, 1, "")
			}
		}
	}
}

method love.textinput(t) {
	terminal.input[1] ..= t
	love.wheelmoved(0, -math.huge)
}

method love.wheelmoved(_, y) {
	local terminal_size = -((#terminal + 1) * fontheight - screenheight)
	offset = math.min(math.max($ + y * fontheight, math.min(terminal_size, 0)), 0)
}