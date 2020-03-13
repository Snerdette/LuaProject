-----------------------------------------------------------
-- class
local e   = {class = 'entity'}
e.__index = e
e.new     = function(self,t)
	return setmetatable(t,self)
end
e.__call  = e.new
setmetatable(e,{__call = e.new})

-----------------------------------------------------------
-- apply collision resolution and movement update
function e:update(dt,map)
	-- move horizontally first
	self.x  = self.x + self.vx*dt
	self.x  = map:resolveXdirection(self,self.x,self.y,self.w,self.h)
	
	-- apply vertical movement
	self.y  = self.y + dt*self.vy
	self.y  = map:resolveYdirection(self,self.x,self.y,self.w,self.h)
end

function e:draw()
	local x,y,w,h = self.x,self.y,self.w,self.h
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill',x,y,w,h)
end
-----------------------------------------------------------
return e