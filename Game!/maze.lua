--Importing other files--------------------- 
map     = require 'class.map'
entity  = require 'class.entity'
test    = require 'testmap'
p1      = require 'player'
require 'camera'

maze = {}

--loads the necessary stuff for maze-------------
function maze.mazeload()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  camera:setBounds(0, 0, width, height)
  camera:setScale(0.10, 0.10)
	velocity = 100
	
	test:setCallbacks(
		function(self,side,obj,gx,gy)
			local tileType = self:getTile(gx,gy).type
		
			if tileType == 2 then return true end
			
		end
	)
end

function maze.mazedraw()
  camera:set()
  test:draw()
  p1:draw()
  camera:unset()
end

function maze.mazeupdate(dt)
	if dt > 1/60 then dt = 1/60 end
		
	-- movement for p1
	if love.keyboard.isDown('left') then
		p1.vx = -velocity
	elseif love.keyboard.isDown('right') then
		p1.vx = velocity
	else 
		p1.vx = 0 
	end
	if love.keyboard.isDown('up') then
		p1.vy = -velocity
	elseif love.keyboard.isDown('down') then
		p1.vy = velocity
	else
		p1.vy = 0
	end
	
	leftSideGX,_,rightSideGX = test:getRange(p1.x,p1.y,p1.w,p1.h)
  p1:update(dt,test)
  camera:setPosition(p1.x - width / 20, p1.y - height / 20)
end

function maze.mazereset()
	p1.x = 16
	p1.y = 16
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

return maze