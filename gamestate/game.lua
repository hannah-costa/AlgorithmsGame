anim8 = require "anim8"

function game_load()
	gameFont = love.graphics.newFont("fonts/PressStart2P.ttf", 15)
	bgm = love.audio.newSource("sound/MrBlueSky.mp3", "stream")
	jumpSND = love.audio.newSource("sound/jump.mp3", "static")
	hitSND = love.audio.newSource("sound/bark.mp3", "static")
	obstIMG = love.graphics.newImage("images/firehydrant.png")
	bgIMG = love.graphics.newImage("images/bgAnim.png")

	scores = {
		distance = 0,
		high = 0
		}
	
	if love.filesystem.exists("highScore.txt") then
		scoreSave = love.filesystem.read("highScore.txt")
		scores.high = tonumber(scoreSave)
	end

	player = {
		x = 100,
		initialY = 335,
		width = 60,
		height = 60,
		currentY = 335,
		xSpeed = 5,
		ySpeed = 0,
		jump = -500,
		isJumping = false,
		gravity = -1000,
		runIMG = love.graphics.newImage("images/run.png"),
		jumpIMG = love.graphics.newImage("images/jump.png")
		}
	spdLimit = 100
	obstacles = {}
	deltaObstacle = 3000
	isGameOver = false
	local g1 = anim8.newGrid(84, 84, player.runIMG:getWidth(), player.runIMG:getHeight())
 	local g2 = anim8.newGrid(84, 84, player.jumpIMG:getWidth(), player.jumpIMG:getHeight())
 	local g3 = anim8.newGrid(700, 500, bgIMG:getWidth(), bgIMG:getHeight())
 	animation1 = anim8.newAnimation(g1('1-8',1), 0.06)
  	animation2 = anim8.newAnimation(g2('1-14',1), 0.07)
  	bgAnim = anim8.newAnimation(g3('1-10',1,'1-10',2,'1-10',3,'1-10',4,'1-10',5,'1-9',6), 0.04)

end

function game_update(dt)
	--this is for going back to the menu
	if love.keyboard.isDown("escape") then
		isGameOver = false
		scores.distance = 0
		obstacles = {}
		state = "menu"
		menu_load()
	end

	if isGameOver == false then
		animation1:update(dt)
  		animation2:update(dt)
  		bgAnim:update(dt)
		love.audio.play(bgm)
		if scores.distance > spdLimit then
			player.xSpeed = player.xSpeed + 0.5
			spdLimit = spdLimit + 100
		end

		scores.distance = scores.distance + (player.xSpeed*dt)
		-- if jump key (spacebar) is pressed
		if love.keyboard.isDown("space") then
			if player.ySpeed == 0 then
				player.ySpeed = player.jump
				animation2:gotoFrame(1)
				player.isJumping = true
				love.audio.play(jumpSND)
			end
		end
 
		if player.ySpeed ~= 0 then
			player.currentY = player.currentY + player.ySpeed * dt
			player.ySpeed = player.ySpeed - player.gravity * dt
		end
 
		if player.currentY > player.initialY then
			player.ySpeed = 0
    		player.currentY = player.initialY
    		player.isJumping = false
		end

		obstacleGenerator()

		--moves obstacles !!!!
		for i, obstacle in ipairs(obstacles) do
			if scores.distance > 550 then
				obstacle.x = obstacle.x - 3
			elseif scores.distance > 450 then
				obstacle.x = obstacle.x - 2.75
			elseif scores.distance > 350 then
				obstacle.x = obstacle.x - 2.5
			elseif scores.distance > 250 then
				obstacle.x = obstacle.x - 2.25
			else
				obstacle.x = obstacle.x - 2
			end
		end

		--collision check
		for i, obstacle in ipairs(obstacles) do
			if checkCollision(player.x, player.currentY, player.width, player.height, obstacle.x, obstacle.y, obstacle.width, obstacle.height) then
				isGameOver = true
				love.audio.play(hitSND)
			end
		end
	end	
	if isGameOver then
		if scores.distance > scores.high then
			scoreSave = scores.distance
		end

		if love.keyboard.isDown("return") then
			if scores.distance > scores.high then
				scores.high = scores.distance
			end
			isGameOver = false
			player.xSpeed = 5
			obstacles = {}
			scores.distance = 0
			animation1:resume()
			animation2:resume()
			bgAnim:resume()
		end
	end
end

function game_draw()
	--BG image
	love.graphics.setColor(255,255,255)
	bgAnim:draw(bgIMG, 0, 0)
	

	--High score
	love.graphics.setFont(gameFont)
	love.graphics.setColor(98,133,162)
	love.graphics.print("HIGH: "..math.floor(scores.high), 10, 10)

	--Distance travelled
	love.graphics.print(math.floor(scores.distance), 10, 25)
	
	--Exit
	love.graphics.setColor(98,133,162)
	love.graphics.print("MENU: ESC", 560, 10)

	--obstacles
	for i, obstacle in ipairs(obstacles) do
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(obstIMG, obstacle.x, obstacle.y)
	end	

	--player
	love.graphics.setColor(255,255,255)
	if player.isJumping == false then
	  	animation1:draw(player.runIMG, player.x, player.currentY)
	else
	  	animation2:draw(player.jumpIMG, player.x, player.currentY)
	end

	if isGameOver then
		love.graphics.setColor(255,255,255)
		
		love.graphics.print("         GAME OVER!\nPRESS THE RETURN KEY TO RESTART.", 130, 230)
	end
end

function love.quit()
	love.filesystem.write("highScore.txt", math.floor(scoreSave))
end
