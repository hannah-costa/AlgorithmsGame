function instructions_load()
	instructFont = love.graphics.newFont("fonts/PressStart2P.ttf", 30)
	backButton = {text = "BACK", x = 265, y = 450}
end

function instructions_update(dt)
end

function instructions_draw()
	--bg
	love.graphics.setColor(115, 115, 115)
	love.graphics.draw(menuBgIMG,0,0)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(instructFont)
	love.graphics.printf("HELP THE DOG ESCAPE (FOR NO REASON AT ALL, HE'S JUST A BAD BOY.)! ", 10, 40, 700, "center")
	love.graphics.printf("SPACEBAR: \nJUMP", 0, 200, 400, "center")
	love.graphics.printf("ESC: \nGO TO MENU", 320, 200, 400, "center")
	love.graphics.printf("RETURN KEY: \nRESTART GAME \n(AFTER GAME OVER)", 140, 300, 400, "center")
	love.graphics.printf(backButton.text, backButton.x, backButton.y, 150,"center")

end

function instructions_mousepressed(x, y, button)
	if x > backButton.x and x < backButton.x + 180 and y > backButton.y and y < backButton.y + 60 then
		state = "menu"
		menu_load()
	end
end