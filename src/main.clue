static font = love.graphics.newFont("assets/clacon2.ttf", 24, "mono")
static fontheight = 23 //force it to 23 cause windows and linux use different sizes...
static screenheight = love.graphics.getHeight()
static leveltime = love.math.random(0, 3000)

io.stdout::setvbuf("no")

local utf8 = require("utf8")
local terminal = import("terminal")
import("player")

local screen = love.graphics.newCanvas()

love.graphics.setFont(font)
love.keyboard.setKeyRepeat(true)
love.graphics.setShader(love.graphics.newShader("assets/shader.glsl"))

local start_command = commands.start

method love.load() {
	terminal::write("╔═╗ ╔═════╗     ╔═════╗ ╔═╗    ╔═════╗ ╔═════╗ ╔═════╗ ╔═════╗", 400)
	terminal::write("║ ║ ║ ╔═╗ ║     ║ ╔═╗ ║ ║ ║    ║ ╔═══╝ ║ ╔═╗ ║ ║ ╔═══╝ ║ ╔═══╝", 400)
	terminal::write("║ ║ ║ ╚═╝ ║     ║ ╚═╝ ║ ║ ║    ║ ╚═══╗ ║ ╚═╝ ║ ║ ╚═══╗ ║ ╚═══╗", 400)
	terminal::write("║ ║ ║ ╔═══╝     ║ ╔═══╝ ║ ║    ║ ╔═══╝ ║ ╔═╗ ║ ╚═══╗ ║ ║ ╔═══╝", 400)
	terminal::write("║ ║ ║ ║         ║ ║     ║ ╚══╗ ║ ╚═══╗ ║ ║ ║ ║ ╔═══╝ ║ ║ ╚═══╗", 400)
	terminal::write("╚═╝ ╚═╝         ╚═╝     ╚════╝ ╚═════╝ ╚═╝ ╚═╝ ╚═════╝ ╚═════╝", 400)
	terminal::write("A game for the LÖVE Jam 2023 - Created by Maiori")
	terminal::write("(Type 'guide' for instructions)")
}

method love.update(dt) {
	leveltime += dt
	local unfinished = terminal.unfinished[pointer]
	if unfinished {
		unfinished.progress += dt * unfinished.speed * 2
		if unfinished.progress >= #unfinished.text {
			unfinished.progress = nil
			table.remove(terminal.unfinished, 1)
			love.wheelmoved(0, -fontheight)
			if unfinished.text::sub(-7) == "glitch!" {
				terminal::corrupt()
			}
		}
	} elseif hacked && leveltime > hacked {
		terminal::corrupt()
		hacked = leveltime + hackamount
		hackamount = $ / 1.25
		if hackamount < 0.00000000000001 {
			hacked = nil
			hackamount = 0.5
			commands.clear.code()
			setmetatable(commands, {})
			commands.restart = start_command
			score = 0
			mistakes = 1
			terminal::write("GAME OVER", 1, 1, 0, 0)
			terminal::write("You server was destroyed...will you try again?", 15, 1, 0, 0)
			terminal::write("(Type 'restart' to try again)", nil, 1, 0, 0)
		}
	}
}

local fn UpdateCanvas() {
	love.graphics.clear()
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

method love.draw() {
	screen::renderTo(UpdateCanvas)
	love.graphics.setColor(1, 1, 1)
	love.graphics.origin()
	love.graphics.draw(screen)
}

method love.resize(_, height) {
	screenheight = height
	screen = love.graphics.newCanvas()
	love.wheelmoved(0, 0)
}