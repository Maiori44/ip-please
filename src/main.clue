static font = love.graphics.newFont("clacon2.ttf", 24, "mono")
static fontheight = font::getHeight() + 4
static screenheight = love.graphics.getHeight()
static leveltime = love.math.random(0, 3000)

io.stdout::setvbuf("no")

local utf8 = require("utf8")
local terminal = import("terminal")
import("player")

font::setFilter("nearest", "nearest")
love.graphics.setFont(font)
love.keyboard.setKeyRepeat(true)

method love.load() {
	terminal::write("╔═╗ ╔═════╗     ╔═════╗ ╔═╗    ╔═════╗ ╔═════╗ ╔═════╗ ╔═════╗", 400)
	terminal::write("║ ║ ║ ╔═╗ ║     ║ ╔═╗ ║ ║ ║    ║ ╔═══╝ ║ ╔═╗ ║ ║ ╔═══╝ ║ ╔═══╝", 400)
	terminal::write("║ ║ ║ ╚═╝ ║     ║ ╚═╝ ║ ║ ║    ║ ╚═══╗ ║ ╚═╝ ║ ║ ╚═══╗ ║ ╚═══╗", 400)
	terminal::write("║ ║ ║ ╔═══╝     ║ ╔═══╝ ║ ║    ║ ╔═══╝ ║ ╔═╗ ║ ╚═══╗ ║ ║ ╔═══╝", 400)
	terminal::write("║ ║ ║ ║         ║ ║     ║ ╚══╗ ║ ╚═══╗ ║ ║ ║ ║ ╔═══╝ ║ ║ ╚═══╗", 400)
	terminal::write("╚═╝ ╚═╝         ╚═╝     ╚════╝ ╚═════╝ ╚═╝ ╚═╝ ╚═════╝ ╚═════╝", 400)
	terminal::write("A game for the LÖVE Jam 2023 - Created by Maiori")
	terminal::write("(Type 'start' to begin)")
}

method love.update(dt) {
	leveltime += dt
	local unfinished = terminal.unfinished[pointer]
	if unfinished {
		unfinished.progress += dt * unfinished.speed * 2
		if unfinished.progress >= #unfinished.text {
			unfinished.progress = nil
			table.remove(terminal.unfinished, 1)
		}
	} elseif hacked && leveltime > hacked {
		for _, line in terminal {
			local len = utf8.len(line.text)
			local i = love.math.random(len)
			local corrupted = ""
			for p, c with utf8.codes(line.text) {
				corrupted ..= p == i || p == love.math.random(len)
					? (hackamount > 0.00005
						? string.char(love.math.random(33, 122))
						: " ")
					: utf8.char(c)
			}
			line.text = corrupted
			line.r = love.math.random()
			line.g = love.math.random()
			line.b = love.math.random()
		}
		hacked = leveltime + hackamount
		hackamount = $ / 1.25
		if hackamount < 0.00000000000001 {
			hacked = nil
			hackamount = nil
			commands.clear.code()
			terminal::write("GAME OVER", 1, 1, 0, 0)
		}
	}
}

method love.draw() {
	love.graphics.translate(0, 5 + offset)
	local y = terminal::draw()
	if terminal::finished() && !hacked {
		love.graphics.setColor(0.125490196, 0.760784314, 0.054901961)
		local text = "$ " .. terminal.input[1]
		love.graphics.print(text, 5, y)
		if math.floor(leveltime) % 2 == 0 {
			love.graphics.print("_", 5 + font::getWidth(text), y)
		}	
	}
}

method love.resize(_, height) {
	screenheight = height
	love.wheelmoved(0, 0)
}