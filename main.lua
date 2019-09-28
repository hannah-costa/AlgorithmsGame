require "gamestate/menu"
require "gamestate/game"
require "gamestate/instructions"
require "functions"

function love.load()
	state = "menu"
	menu_load()
	game_load()
	instructions_load()
end

function love.update(dt)
	if state == "menu" then
		menu_update(dt)
		love.audio.stop(bgm)

	elseif state == "game" then
		game_update(dt)

	elseif state == "instructions" then
		instructions_update(dt)
	end
end


function love.draw()
	if state == "menu" then
		menu_draw()

	elseif state == "game" then
		game_draw()

	elseif state == "instructions" then
		instructions_draw()
	end
end

function love.mousepressed(x, y, button)
	if state == "menu" then
		menu_mousepressed(x, y, button)

	elseif state == "instructions" then
		instructions_mousepressed(x, y, button)
	end
end
