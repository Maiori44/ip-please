static font = love.graphics.newFont("clacon2.ttf", 24, "mono")
static fontheight = font::getHeight() + 4
static screenheight = love.graphics.getHeight()
static leveltime = 0

io.stdout::setvbuf("no")

local terminal = import("terminal")
import("player")

font::setFilter("nearest", "nearest")
love.graphics.setFont(font)
love.keyboard.setKeyRepeat(true)

method love.load() {
	terminal::write("╔═╗ ╔═════╗     ╔═════╗ ╔═╗    ╔═════╗ ╔═════╗ ╔═════╗ ╔═════╗", 600)
	terminal::write("║ ║ ║ ╔═╗ ║     ║ ╔═╗ ║ ║ ║    ║ ╔═══╝ ║ ╔═╗ ║ ║ ╔═══╝ ║ ╔═══╝", 600)
	terminal::write("║ ║ ║ ╚═╝ ║     ║ ╚═╝ ║ ║ ║    ║ ╚═══╗ ║ ╚═╝ ║ ║ ╚═══╗ ║ ╚═══╗", 600)
	terminal::write("║ ║ ║ ╔═══╝     ║ ╔═══╝ ║ ║    ║ ╔═══╝ ║ ╔═╗ ║ ╚═══╗ ║ ║ ╔═══╝", 600)
	terminal::write("║ ║ ║ ║         ║ ║     ║ ╚══╗ ║ ╚═══╗ ║ ║ ║ ║ ╔═══╝ ║ ║ ╚═══╗", 600)
	terminal::write("╚═╝ ╚═╝         ╚═╝     ╚════╝ ╚═════╝ ╚═╝ ╚═╝ ╚═════╝ ╚═════╝", 600)
	terminal::write("A game for the LÖVE Jam 2023 - Created by Maiori")
	terminal::write("(Type start to begin)")
}

method love.update(dt) {
	leveltime += dt
	local unfinished = terminal.unfinished[1]
	if unfinished {
		unfinished.progress += dt * unfinished.speed
		if unfinished.progress >= #unfinished.text {
			unfinished.progress = nil
			table.remove(terminal.unfinished, 1)
		}
	}
}

method love.draw() {
	love.graphics.translate(0, 5 + offset)
	local y = terminal::draw()
	if terminal::finished() {
		love.graphics.setColor(0.125490196, 0.760784314, 0.054901961)
		local text = "$ " .. terminal.input
		love.graphics.print(text, 5, y)
		if math.floor(leveltime) % 2 == 0 {
			love.graphics.print("_", 5 + font::getWidth(text), y)
			//if I find the time: maybe you could edit the text from any location?
		}	
	}
}

method love.resize(_, height) {
	screenheight = height
	love.wheelmoved(0, 0)
}