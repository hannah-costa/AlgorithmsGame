initialY = 360 --player's default Y-position, on the floor.
jumpHeight = 20
initialGravity = 90
obstacles = {}
lastTimeObstacle = 4000
gravity = 90

--jumpSND = nil
--hitSND = nil

scores = {
	distance = 0,
	high = 0
	}

player = {
	x = 100, 
	y = initialY,
	speed = 5, 
	jumping = false, 
	jump = jumpHeight,
	}
--player.jump is how high the player can jump.
isGameOver = false

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
		   x2 < x1+w1 and
		   y1 < y2+h2 and
		   y2 < y1+h1
end

function love.load()
	player.img = love.graphics.newImage("images/dog.png")
	love.graphics.setBackgroundColor(230,242,255)
	font = love.graphics.setNewFont("PressStart2P.ttf", 15)
	bgm = love.audio.newSource("sound/MrBlueSky.mp3", "stream")
	jumpSND = love.audio.newSource("sound/jump.mp3", "static")
	hitSND = love.audio.newSource("sound/bark.mp3", "static")
end


function love.update(dt)
	love.audio.play(bgm)
	--this is for exiting the game
	if love.keyboard.isDown("escape") then
		love.event.push("quit")
	end

	if isGameOver == false then
		scores.distance = scores.distance + (player.speed*dt)
		-- if jump key (spacebar) is pressed
		if love.keyboard.isDown("space") and player.jumping == false then
			love.audio.play(jumpSND)
			player.jumping = true	
		end
		
		--jumping
		if player.jumping and player.jump>0 then
			player.y = player.y - player.jump
			--!!!
			player.jump = player.jump - 0.8
		end

		--Gravity "gets stronger" as the player falls back to the ground
		if player.y < initialY then
			player.y = player.y + gravity*dt
			gravity = gravity + 6.5
		end
		--Player reaches the ground
		if player.y > initialY then
			player.y = initialY
		end

		if player.y == initialY then
			player.jumping = false
			player.jump = jumpHeight
			gravity = initialGravity
		end

		--generates obstacles
		lastTimeObstacle = lastTimeObstacle - 5
		if lastTimeObstacle <= 0 then
			lastTimeObstacle = love.math.random(2000,5000)

			newObstacle = {
				x = 800, 
				y = 370, 
				width = 25, 
				height = 50
				}
			table.insert(obstacles, newObstacle)
		end

		--moves obstacles
		for i, obstacle in ipairs(obstacles) do
			obstacle.x = obstacle.x - 2
			--obstacle off screen gets removed
			if obstacle.x < 0 then
				table.remove(obstacle, i)
			end
		end

		--collision check
		for i, obstacle in ipairs(obstacles) do
			if checkCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(), obstacle.x, obstacle.y, obstacle.width, obstacle.height) then
				isGameOver = true
				love.audio.play(hitSND)
			end
		end
	end	
	if isGameOver then
		if love.keyboard.isDown("return") then
			if scores.distance > scores.high then
				scores.high = scores.distance
			end
			isGameOver = false
			obstacles = {}
			scores.distance = 0
		end
	end

end


function love.draw()
	--High score
	love.graphics.setColor(0,0,0)
	love.graphics.print("High: "..math.floor(scores.high), 10, 10)

	--Distance travelled
	love.graphics.print(math.floor(scores.distance), 10, 25)
	
	--Exit
	love.graphics.setColor(0,0,0)
	love.graphics.print("Exit: Esc", 660, 10)

	--floor
	love.graphics.setColor(64,199,84)
	love.graphics.rectangle("fill", 0 , 420, 800, 80)

	--player
	love.graphics.setColor(255,255,255)
	love.graphics.draw(player.img,player.x,player.y)

	if isGameOver then
		love.graphics.setColor(94,117,113)
		love.graphics.print("Game over!\nPress the return key to restart.", 200, 200)
	end

	--obstacles
	for i, obstacle in ipairs(obstacles) do
			love.graphics.setColor(255, 0, 0)
			love.graphics.rectangle("fill", obstacle.x, obstacle.y, obstacle.width, obstacle.height)
	end	
end