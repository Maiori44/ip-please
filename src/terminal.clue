local utf8 = require("utf8")

return {
	input = ""
	unfinished = {}
	write = fn(self, text, speed = 60, r = 0.125490196, g = 0.760784314, b = 0.054901961) {
		local text = {
			progress = 0
			speed = $
			text = $
			r = $
			g = $
			b = $
		}
		table.insert(self, text)
		table.insert(self.unfinished, text)
		love.wheelmoved(0, -fontheight)
	}
	finished = fn(self) {
		return #self.unfinished == 0
	}
	draw = fn(self) {
		local y = 0
		for i, line in self {
			local {progress, text, r, g, b} = line
			love.graphics.setColor(r, g, b)
			if !progress {
				love.graphics.print(text, 5, y)
			} elseif progress > 0 {
				local toprint = ""
				local progress = math.ceil(progress)
				for p, c with utf8.codes(text) {
					toprint ..= utf8.char(c)
					if p >= progress {
						break
					}
				}
				love.graphics.print(toprint .. "▇", 5, y)
			}
			y += fontheight
		}
		return y
	}
}