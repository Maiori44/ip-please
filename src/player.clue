static offset = 0
static pointer = 1

local utf8 = require("utf8")
local terminal = import("terminal")

local commands
commands = {
	help = {
		desc = "Display this message."
		code = fn {
			for k, v of commands {
				terminal::write(string.format("%s - %s", k::upper(), v.desc))
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
}

method love.keypressed(key) {
	if terminal::finished() {
		local input = terminal.input[pointer]
		match key {
			"up" if pointer < #terminal.input => {
				pointer += 1
			}
			"down" if pointer > 1 => {
				pointer -= 1
			}
			"backspace" => {
				local byteoffset = utf8.offset(input, -1)
				if byteoffset {
					input = $::sub(1, byteoffset - 1)
				}
			}
			"return" => {
				pointer = 1
				local command = commands[input::lower()]?.code
				if command {
					command()
				} else {
					terminal::write(input .. ": command not found", 120, 1, 0, 0)
				}
				table.insert(terminal.input, 1, "")
			}
			"start" => {

			}
		}
	} else {
		for _, text in terminal.unfinished {
			text.progress = nil
		}
		terminal.unfinished = {}
	}
}

method love.textinput(t) {
	terminal.input[pointer] ..= t
	love.wheelmoved(0, -math.huge)
}

method love.wheelmoved(_, y) {
	local terminal_size = -((#terminal + 1) * fontheight - screenheight)
	offset = math.min(math.max($ + y * fontheight, math.min(terminal_size, 0)), 0)
}