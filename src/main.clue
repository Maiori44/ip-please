static font = love.graphics.newFont("clacon2.ttf", 24, "mono")
static fontheight = font::getHeight()
static leveltime = 0

local terminal = import("terminal")

terminal::write("hello and welcome to this video this is a very long text")
terminal::write("this text on the other hand is red", 1, 0, 0)
terminal::write("this probably sucks")

love.graphics.setFont(font)

method love.update(dt) {
	leveltime += dt
	local unfinished = terminal.unfinished[1]
	if unfinished {
		unfinished.progress += dt * 60
		if unfinished.progress >= #unfinished.text {
			unfinished.progress = nil
			table.remove(terminal.unfinished, 1)
		}
	}
}

method love.draw() {
	terminal::draw()	
}