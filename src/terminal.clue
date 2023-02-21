return {
	unfinished = {}
	write = fn(self, text, r = 0.125490196, g = 0.760784314, b = 0.054901961) {
		local text = {
			progress = 0
			text = $
			r = $
			g = $
			b = $
		}
		table.insert(self, text)
		table.insert(self.unfinished, text)
	}
	draw = fn(self) {
		for i, line in self {
			local {progress, text, r, g, b} = line
			love.graphics.setColor(r, g, b)
			local y = 5 + fontheight * (i - 1)
			if !progress {
				love.graphics.print(text, 5, y)
			} elseif progress > 0 {
				love.graphics.print(text::sub(1, math.ceil(progress)) .. "▇", 5, y)
			}
		}
	}
}