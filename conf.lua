function love.conf(t)
	t.version = "11.4"
	t.window.title = "IP please"
	t.window.icon = "icon.png"
	t.window.resizable = true
	t.window.minwidth = 800
	t.window.minheight = 600
	
	t.modules.joystick = false
	t.modules.mouse = false
	t.modules.thread = false
	t.modules.physics = false
	t.modules.touch = false
	t.modules.video = false
end