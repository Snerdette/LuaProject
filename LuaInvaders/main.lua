function love.load()
	player = {}
	player.x = 0
	player.bullets = {}
	player.cooldown = 20
	player.fire = function()
		player.cooldown = 20
		bullet = {}
		bullet.x = player.x + 35
		bullet.y = 400
		table.insert(player.bullets, bullet)
		end
end

function love.update(dt) --- dt =  delta time variable
	--- Bullet Cool down Increment ---
	player.cooldown = player.cooldown - 1
	--- Move box left and right --
	if love.keyboard.isDown("right") then
		player.x = player.x + 1
	elseif love.keyboard.isDown("left") then
		player.x = player.x - 1
	end
	
	if love.keyboard.isDown("space") then
		player.fire()
	end
	
	for i,b in ipairs(player.bullets) do
		if b.y < -10 then
			table.remove(player.bullets, i)
		end
		b.y = b.y - 10
	end
end

function love.draw ()
	--- Set color of box---
	love.graphics.setColor(0, 0, 255)
	--- Drawing the box that moves ---
	love.graphics.rectangle("fill", player.x, 400, 80, 20)
	love.graphics.setColor(255, 255, 255)	
	for _,b in pairs(player.bullets) do
		love.graphics.rectangle("fill", b.x, b.y, 10, 10)
	end
end