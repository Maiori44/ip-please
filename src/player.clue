static offset = 0
static pointer = 1

local utf8 = require("utf8")
local terminal = import("terminal")

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
				match input::lower() {
					"" => {
						return
					}
					"fps" => {
						local fps = love.timer.getFPS()
						terminal::write("FPS: " .. tostring(fps), 30, (1 - fps / 60) * 2, fps / 60, 0)
					}
					"memory" => {
						terminal::write(string.format("Used memory: %dkb", collectgarbage("count")))
						collectgarbage("collect")
					}
					"clear" => {
						for k, _ in terminal {
							terminal[k] = nil
						}
						love.wheelmoved(0, 0)
					}
					default => {
						terminal::write(input .. ": command not found", 120, 1, 0, 0)
					}
				}
				table.insert(terminal.input, 1, "")
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