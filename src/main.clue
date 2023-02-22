static font = love.graphics.newFont("clacon2.ttf", 24, "mono")
static fontheight = font::getHeight()
static leveltime = 0

local terminal = import("terminal")

love.graphics.setFont(font)

method love.load() {
	terminal::write("╔═╗ ╔═════╗    ╔═════╗ ╔═╗    ╔═════╗ ╔═════╗ ╔═════╗ ╔═════╗", 600)
	terminal::write("║ ║ ║ ╔═╗ ║    ║ ╔═╗ ║ ║ ║    ║ ╔═══╝ ║ ╔═╗ ║ ║ ╔═══╝ ║ ╔═══╝", 600)
	terminal::write("║ ║ ║ ╚═╝ ║    ║ ╚═╝ ║ ║ ║    ║ ╚═══╗ ║ ╚═╝ ║ ║ ╚═══╗ ║ ╚═══╗", 600)
	terminal::write("║ ║ ║ ╔═══╝    ║ ╔═══╝ ║ ║    ║ ╔═══╝ ║ ╔═╗ ║ ╚═══╗ ║ ║ ╔═══╝", 600)
	terminal::write("║ ║ ║ ║        ║ ║     ║ ╚══╗ ║ ╚═══╗ ║ ║ ║ ║ ╔═══╝ ║ ║ ╚═══╗", 600)
	terminal::write("╚═╝ ╚═╝        ╚═╝     ╚════╝ ╚═════╝ ╚═╝ ╚═╝ ╚═════╝ ╚═════╝", 600)
	terminal::write("A game for the LÖVE Jam 2023")
	terminal::write("Created by Maiori")
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
	terminal::draw()	
}