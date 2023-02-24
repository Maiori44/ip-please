static score, mistakes = 0, 1
static hacked, hackamount

local terminal = import("terminal")

local names = {}

local i = 1
for name with love.filesystem.lines("assets/names.txt") {
	names[i] = name
	i += 1
}

local commands

local fn EntryCode(seed = math.floor(leveltime / 30) * 10 + love.math.random(1, 10)) {
	local rng = love.math.newRandomGenerator(seed)
	local code = ""
	for _ = 1, 20 {
		code ..= string.char(rng::random(33, 122))
	}
	return code
}

local user = {
	new = fn(self) {
		local hacker = love.math.random() > 0.7
		self.name = names[love.math.random(5000)]
		self.age = math.floor(hacker ? love.math.random(14, 50) : love.math.random(9, 150))
		self.code = EntryCode(hacker ? leveltime : nil)
		self.time = leveltime
		self.hacker = hacker
	}
	next = fn(self) {
		commands.score.code()
		terminal::write("Reading next user's information...", 15)
		self::new()
		commands.user.code()
	}
}

user::new()

local fn AwardScore(amount) {
	if amount < 0 {
		amount = math.ceil($ * mistakes)
		terminal::write(string.format("(%d points)", amount), 60, 1, 0, 0)
		mistakes += 0.5
	} else {
		terminal::write(string.format("(+%d points)", amount), 60, 1, 1, 0)
	}
	score += amount
}

commands = {
	score = {
		desc = "Display current score."
		code = fn {
			terminal::write("Score: " .. score, nil, 1, 0, 1)
			local mistakes = (mistakes - 1) * 2
			if mistakes == 0 {
				terminal::write("You never messed up so far.", nil, 1, 0, 1)
			} else {
				terminal::write("You messed up " .. mistakes .. " times.", nil, 1, 0, 1)
			}
		}
	}
	user = {
		desc = "Display the info of the user trying to connect."
		code = fn {
			terminal::write("Name: " .. user.name, 60, 1, 1, 0)
			terminal::write("Age: " .. user.age, 60, 1, 1, 0)
			terminal::write("Entry Code: " .. user.code, 60, 1, 1, 0)
		}
	}
	codes = {
		desc = "Display the 10 currently valid codes."
		code = fn {
			terminal::write("Currently valid codes:")
			local seed = math.floor(leveltime / 30) * 10
			for i = 1, 10 {
				terminal::write(EntryCode(seed + i), 60, 1, 1, 0)
			}
			terminal::write(string.format(
				"The codes will change in %d seconds.",
				29 - math.floor(leveltime % 30)
			))
		}
	}
	allow = {
		desc = "Allow the current user."
		code = fn {
			terminal::write(user.name .. " was allowed connection...", 10)
			if user.hacker {
				terminal::write("But they were an hacker!", 60, 1, 0, 0)
				hacked = leveltime + 0.5
				hackamount = 0.5
				user::new()
				return
			} elseif user.age < 14 {
				terminal::write("But they were too young to join.", 60, 1, 0, 0)
				AwardScore(-100)
			} elseif user.age >= 80 {
				terminal::write("But they were a troll.", 60, 1, 0, 0)
				AwardScore(-300)
			} else {
				terminal::write("And that was the correct choice!", 60, 1, 1, 0)
				AwardScore(math.max(500 + math.floor((user.time - leveltime) * 20), 10))
			}
			user::next()
		}
	}
	deny = {
		desc = "Deny the current user."
		code = fn {
			terminal::write(user.name .. " was denied connection...", 10)
			if !user.hacker && user.age >= 14 && user.age < 80 {
				terminal::write("But they had no bad intentions.", 60, 1, 0, 0)
				AwardScore(-200)
			} else {
				terminal::write("And that was the correct choice!", 60, 1, 1, 0)
				AwardScore(math.max(300 + math.floor((user.time - leveltime) * 20), 10))
			}
			user::next()
		}
	}
}

return commands