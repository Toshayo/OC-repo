local com = require("component")
local event = require("event")
local tunnel = com.tunnel
local gpu = com.gpu
local width, height = gpu.getResolution()
local BACKGROUND = 0xAAAAAA
local FOREGROUND = 0x000000
local buttons = {}
local running = true


function clearButton(button)
	gpu.setBackground(BACKGROUND)
	gpu.setForeground(FOREGROUND)
	gpu.fill(button.x, button.y, button.width, button.height, " ")
end

function drawButton(button)
	gpu.setBackground(button.back)
	gpu.setForeground(button.color)
	gpu.fill(button.x, button.y, button.width, button.height, " ")
	gpu.set(button.x + 1 + button.width / 2 - button.text:len() / 2, button.y+1, button.text)
end


function updateStatus(componentName, button, status)
	clearButton(button)
	button.text = componentName .. " " .. status
	if status == "disabled" then
		button.back = 0xFF0000
	elseif status == "enabled" then
		button.back = 0x00FF00
	else
		button.back = 0x888888
	end
	drawButton(button)
end


buttons[1] = {
	text = "Loading state...",
	x = 3,
	y = 2,
	width = string.len("Loading state...") + 2,
	height = 3,
	back = 0x888888,
	color = 0xFFFFFF,
	onclick = function()
		tunnel.send("TOGGLE_LIFT")
	end
}

buttons[2] = {
	text = "Loading state...",
	x = 3,
	y = 6,
	width = string.len("Loading state...") + 2,
	height = 3,
	back = 0x888888,
	color = 0xFFFFFF,
	onclick = function()
		tunnel.send("TOGGLE_CLOAK")
	end
}

buttons[3] = {
	text = "Loading state...",
	x = 3,
	y = 10,
	width = string.len("Loading state...") + 2,
	height = 3,
	back = 0x888888,
	color = 0xFFFFFF,
	onclick = function()
		tunnel.send("TOGGLE_LASER_MODE")
	end
}

buttons[4] = {
	text = "Loading state...",
	x = 3,
	y = 14,
	width = string.len("Loading state...") + 2,
	height = 3,
	back = 0x888888,
	color = 0xFFFFFF,
	onclick = function()
		tunnel.send("TOGGLE_SHIELD")
	end
}

gpu.setBackground(BACKGROUND)
gpu.setForeground(FOREGROUND)
gpu.fill(1, 1, width, height, " ")

for i=1,#buttons do
	buttons[i].width = width / 2
	buttons[i].x = width / 2 - buttons[i].width / 2
	drawButton(buttons[i])
end

function onModemMessage(...)
	local msg = {...}
	msg = msg[6]
	sep = string.find(msg, "_")
	component = string.sub(msg, 0, sep - 1)
	state = string.lower(string.sub(msg, sep + 1, -1))
	if component == "LIFT" then
		updateStatus("Lift", buttons[1], state)
	elseif component == "CLOAK" then
		updateStatus("Cloak", buttons[2], state)
	elseif component == "SHIELD" then
		updateStatus("Shield", buttons[4], state)
	elseif component == "LASER" then
		if state == "SINGLE_MODE" then
			state = "single mode"
		elseif state == "BOOST_MODE" then
			state = "boost mode"
		end
		updateStatus("Laser", buttons[3], state)
	end
end

function onClick(eventName, address, x, y, button, user)
	for i=1,#buttons do
		if buttons[i].x <= x and x <= buttons[i].x + buttons[i].width and buttons[i].y <= y and y <= buttons[i].y + buttons[i].height then
			buttons[i].onclick()
		end
	end
end

function onInterrupt(...)
	running = false
end

event.listen("modem_message", onModemMessage)
event.listen("touch", onClick)
event.listen("interrupted", onInterrupt)

tunnel.send("GET_STATE")

while running do
	os.sleep(1)
end

event.ignore("modem_message", onModemMessage)
event.ignore("touch", onClick)
event.ignore("interrupted", onInterrupt)


gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
gpu.fill(1, 1, width, height, " ")
