
love.graphics.setDefaultFilter('nearest', 'nearest')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('enemy.png')
---player.fire_sound = love.audio.newSource('fire.wav')
--- Enemy set up because load is called after -- 
function love.load()
--- Player set up ---
	player = {}
    player.x = 0
    player.y = 110
	player.bullets = {}
    player.cooldown = 20
    player.speed = 2
    player.image = love.graphics.newImage('player.png')
    ---player.fire_sound = love.audio.newSource('fire.wav') 
    player.fire = function()
        ---love.audio.play(player.fire_sound)
        if player.cooldown <= 0 then          
            player.cooldown = 20
            bullet = {}
            bullet.x = player.x + 4
            bullet.y = player.y + 3
            table.insert(player.bullets, bullet)
        end
    end    
    --- Enemy set up ---
    enemies_controller.spawnEnemy(0, 0)
    enemies_controller.spawnEnemy(20, 0)
    
end

function enemies_controller:spawnEnemy(x, y)
    enemy = {}
    enemy.x = x
    enemy.y = y
	enemy.bullets = {}
    enemy.cooldown = 20
    enemy.speed = 2
    --- Used enemies_controller instead of self to fix bug ---
    table.insert(enemies_controller.enemies, enemy)
end

function enemy:fire ()
    if self.cooldown <= 0 then
        self.cooldown = 20
        self = {}
        buselfllet.x = self.x + 35
        self.y = self.y
        table.insert(self.bullets, bullet)
    end
end

function love.update(dt) --- dt =  delta time variable
    
    --- Bullet cooldown decrement---
	player.cooldown = player.cooldown - 1
    
    --- Move box left and right --
	if love.keyboard.isDown("right") then
		player.x = player.x + player.speed
	elseif love.keyboard.isDown("left") then
		player.x = player.x - player.speed
	end
    
    --- Fire bullet ---
	if love.keyboard.isDown("space") then
		player.fire()
    end
    
    --- Moving the enemies around --- !!!!CURRENTLY THROWS ERROR THAT y doesn't exsist
    ---for _,e in pairs(enemies_controller.enemies) do
        ---e.y = e.y + 1
    ---end
	
	for i,b in ipairs(player.bullets) do
		if b.y < -10 then
			table.remove(player.bullets, i)
		end
		b.y = b.y - 2
	end
end

function love.draw ()
    love.graphics.scale(3)
	--- Draw the Player / Shooter---
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(player.image, player.x, player.y)

    -- Draw Enemies ---
    for _,e in pairs(enemies_controller.enemies) do
        love.graphics.draw(enemies_controller.image, e.x, e.y, 0)
    end

	--- Drawing Bullets ---
	love.graphics.setColor(255, 255, 255)	
	for _,b in pairs(player.bullets) do
		love.graphics.rectangle("fill", b.x, b.y, 2, 2)
	end
end