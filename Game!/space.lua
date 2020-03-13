--- Global Variables Set Up ----------
love.graphics.setDefaultFilter('nearest', 'nearest')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('enemy.png')
enemies_controller.hit_sound = love.audio.newSource("hit.wav", "static")
game_music = love.audio.newSource('GameMusic.mp3', 'static')

particle_systems = {}
particle_systems.img = love.graphics.newImage('particle.png')

space = {}

function particle_systems:spawn(x, y)
    local ps = {}
    ps.x = x
    ps.y = y
    ps.ps = love.graphics.newParticleSystem(particle_systems.img, 32)
    ps.ps:setParticleLifetime(2, 4)
    ps.ps:setEmissionRate(5)
    ps.ps:setSizeVariation(1)
    ps.ps:setLinearAcceleration(-20, -20, 20, 20)
    ps.ps:setColors(100, 255, 100, 255, 0, 255, 0, 255)
    table.insert(particle_systems.list, ps)
end

function particle_systems:draw()
    for _, v in pairs(particle_systems.list) do
        love.graphics.draw(v.ps, v.x, v.y )
    end
end

function particle_systems:update(dt) 
    for _, v in pairs(particle_systems.list) do
        v.pc:update(dt)
    end
end


function particle_systems:cleanup()
---- TODO : clean up old particles -----
end
--- Collision of Bullets and Enemies-------------------------------------------------  CHECK COLLISION  --------------------------------------
function checkCollisions(enemies, bullets)
    for _, e in ipairs(enemies) do
        for _, b in pairs(bullets) do
            if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
                -- Destroy Enemy ---
                particle_systems:spawn(e.x, e.y)
                print("Collision!")
                enemies_controller.hit_sound:play()
                table.remove(enemies, i)             
            end
        end
    end
end



--- Enemy set up because load is called after -- 
-------------------------------------------------------------------------------------  LOAD  -------------------------------------------------
function space.spaceload()
--- Game Music Looping  -----
    game_music:setLooping(true)
    love.audio.play(game_music)
--- Game Over & Game Win Variables ---
    game_over = false
    game_win = false
--- Background Image Assignment---
    background_image = love.graphics.newImage('space.jpg')
--- Player set up ---
	player = {}
    player.x = 0
    player.y = 110
	player.bullets = {}
    player.cooldown = 20
    player.speed = 2
    player.image = love.graphics.newImage('player.png')
    player.fire_sound = love.audio.newSource("fire.wav", "static")
    
--- Player Functions ---
    player.fire = function()
        player.fire_sound:play()
        if player.cooldown <= 0 then          
            player.cooldown = 20
            bullet = {}
            bullet.x = player.x + 4
            bullet.y = player.y
            table.insert(player.bullets, bullet)
        end
    end    
--- Spawning Multiple Enemies ---
    for i=0, 10 do
        enemies_controller:spawnEnemy(i * 15, 0)
    end
    
end
   
--- Spawning Each Enemy -------------------------------------------------------------  SPAWN ENEMY  ------------------------------------
function enemies_controller:spawnEnemy(x, y)
    enemy = {}
    enemy.x = x
    enemy.y = math.random(20) 
    enemy.width = 10
    enemy.height = 10
	enemy.bullets = {}
    enemy.cooldown = 20
    enemy.speed = .15
--- Used enemies_controller instead of self to fix bug ---
    table.insert(enemies_controller.enemies, enemy)
end

--- Shooting Each Bullet ------------------------------------------------------------  ENEMY:FIRE  ---------------------------------------
function enemy:fire ()
    if self.cooldown <= 0 then
        self.cooldown = 20
        bullet = {}
        bullet.x = self.x + 35
        bullet.y = self.y
        table.insert(self.bullets, bullet)
    end
end

--- Constantly updating Function ----------------------------------------------------  UPDATE  ------------------------------------------
function space.spaceupdate(dt) --- dt =  delta time variable
    
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

--- Game Win Scenario ---
    if #enemies_controller.enemies == 0 then
        game_win = true
    end
    
--- Moving the enemies around ---
    for _, e in pairs(enemies_controller.enemies) do
        if e.y == 0 then 
            e.y = 1 
        end
        if e.y >=love.graphics.getHeight()/4 then
            game_over = true 
        end
        e.y = e.y + 1 * e.speed        
    end
--- Removing Old Bullets ---
	for i, b in ipairs(player.bullets) do
		if b.y < -10 then
			table.remove(player.bullets, i)
		end
		b.y = b.y - 2
    end
    
    checkCollisions(enemies_controller.enemies, player.bullets)
end
-------------------------------------------------------------------------------------   DRAW   ---------------------------------------------------------
function space.spacedraw()
--- Setting Scale ---
    love.graphics.scale(3)
    --- Drawing background ---
    love.graphics.draw(background_image)
--- Drawing Game Over Screen if True ---
    if game_over then
        love.graphics.print("Game Over")
        --- Ends game ---
        return
    elseif game_win then
        love.graphics.print("Game Won!")
        --- Lets you keep shooting ---
    end

--- Drawing the Player ---
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(player.image, player.x, player.y)

-- Drawing Enemies ---
    for _, e in pairs(enemies_controller.enemies) do
        love.graphics.draw(enemies_controller.image, e.x, e.y, 0)
    end

--- Drawing Bullets ---
	love.graphics.setColor(255, 255, 255)	
	for _, b in pairs(player.bullets) do
		love.graphics.rectangle("fill", b.x, b.y, 2, 2)
	end
end

return space