static offset = 0

local utf8 = require("utf8")
local terminal = import("terminal")

method love.keypressed(key) {
	if terminal::finished() {
		match key {
			"backspace" => {
				local byteoffset = utf8.offset(terminal.input, -1)
				if byteoffset {
					terminal.input = $::sub(1, byteoffset - 1)
				}
			}
			"return" => {
				match terminal.input::lower() {
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
						terminal::write(terminal.input .. ": command not found", 120, 1, 0, 0)
					}
				}
				terminal.input = ""
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
	terminal.input ..= t
	love.wheelmoved(0, -math.huge)
}

method love.wheelmoved(_, y) {
	local terminal_size = -((#terminal + 1) * fontheight - screenheight)
	offset = math.min(math.max($ + y * fontheight, math.min(terminal_size, 0)), 0)
}