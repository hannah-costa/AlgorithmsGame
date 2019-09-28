function menu_load()
	menuBgIMG = love.graphics.newImage("images/bgMenu.png")
	menuFont1 = love.graphics.newFont("fonts/ARCADE.ttf", 80)
	menuFont2 = love.graphics.newFont("fonts/kenpixel_blocks.ttf", 25)

	buttons = {
		{text = "START GAME", x = 225, y = 330, execute = startGame},
		{text = "INSTRUCTIONS", x = 225, y = 375, execute = instructions},
		{text = "EXIT", x = 225, y = 420, execute = exitGame}
	}
end

function menu_update(dt)
end

function menu_draw()
	--bg
	love.graphics.setColor(255,255,255)
	love.graphics.draw(menuBgIMG,0,0)

	--title
	love.graphics.setColor(84, 131, 131)
	love.graphics.setFont(menuFont1)
	love.graphics.printf("BADDEST BOYE", 210, 60, 300, "center")

	--buttons
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(menuFont2)
	for i, k in pairs(buttons) do
		love.graphics.printf(k.text, k.x, k.y, 250, "center")
	end
end



function menu_mousepressed(x, y, button)
	for i, k in pairs(buttons) do
		if x > k.x and x < k.x + 250 and y > k.y and y < k.y + 45 then
			k.execute()
		end	
	end
end

function startGame()
	state = "game"
end

function instructions()
	state = "instructions"
end

function exitGame()
	love.event.quit()
end