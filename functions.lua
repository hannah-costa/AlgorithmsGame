function checkCollision(playerX,playerY,playerWDTH,playerHGHT, obstX,obstY,obstWDTH,obstHGHT)
	--if one of the values is false, function returns false (no collision)
	return playerX < obstX+obstWDTH and
		   obstX < playerX+playerWDTH and
		   playerY < obstY+obstHGHT and
		   obstY < playerY+playerHGHT
end
--!!
function obstacleGenerator()
	deltaObstacle = deltaObstacle - 5
	if deltaObstacle <= 0 then
		deltaObstacle = math.random(1800,4200)
		obstacles[#obstacles+1] = {
			x = 700,
			y = 360,
			width = 32,
			height = 50
			}
	end
end