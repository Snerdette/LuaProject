-----------------------------------------------------------
-- locals
local lg    = love.graphics
local floor = math.floor
local ceil  = math.ceil
local min   = math.min
local max   = math.max
-----------------------------------------------------------
-- map class
local m   = {class = 'map'}
m.__index = m
m.new     = function(self,t)
	return setmetatable(t,self)
end
m.__call  = m.new
setmetatable(m,{__call = m.new})

-----------------------------------------------------------
-- add tile image
TileW, TileH = 16,16
love.graphics.setDefaultFilter("nearest")
Tileset = love.graphics.newImage('tileset.png')
  
local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()
  
local quadInfo = { 
    {  0,  0 }, 
    { 16,  0 },
    {  0, 16 },
    { 16, 16 },
}

Quads = {}
for i,info in ipairs(quadInfo) do
    -- info[1] = x, info[2] = y
	Quads[i] = love.graphics.newQuad(info[1], info[2], TileW, TileH, tilesetW, tilesetH)
end
-----------------------------------------------------------
-- draw map
function m.draw(map)
	-- draw each cell
	for y,row in pairs(map.grid) do
    for x,id in pairs(row) do
        local xx,yy = (x-1)*TileW, (y-1)*TileH
        love.graphics.draw(Tileset, Quads[id], xx, yy)  
      -- first cell in positive quadrant starts at (1,1)
    end
	end	
end
-----------------------------------------------------------
-- setters
function m:setTileID(x,y,id)
	self.grid[y][x] = id
end

function m:setTileSize(w,h)
	self.tileheight = h
	self.tilewidth  = w
end

function m:setGrid(grid)
	self.grid = grid
end

function m:setTileset(tileset)
	self.tileset = tileset
end

function m:setCallbacks(preSolve,postSolve)
	self.preSolve = preSolve; self.postSolve = postSolve
end
-----------------------------------------------------------
-- getters
function m:getTile(x,y)
	return self.tileset[ self.grid[y][x] ]
end

function m:getTileSize()
	return self.tilewidth,self.tileheight
end

function m:getRange(x,y,w,h)
	local mw,mh = self:getTileSize()
	local gx,gy =  
		floor(x/mw)+1,
		floor(y/mh)+1
	local gx2,gy2 =
		ceil((x+w)/mw),
		ceil((y+h)/mh)
	return gx,gy,gx2,gy2
end
-----------------------------------------------------------
-- collision callback when tile overlaps with sensor
-- return true if collision should be resolved
function m:preSolve(side,obj,gx,gy)
end

-----------------------------------------------------------
-- callback when collision is resolved
function m:postSolve(side,obj,gx,gy)
end
-----------------------------------------------------------
-- resolve horizontal collisions
function m:resolveXdirection(obj,x,y,w,h)
	local mw,mh         = self:getTileSize()
	local gx,gy,gx2,gy2 = self:getRange(x,y,w,h)

	-- right sensor check
	for gy = gy,gy2 do
		-- do collision if callback returns true
		if self:preSolve('right',obj,gx2,gy) then
			x = ((gx2-1)*mw)-w
			self:postSolve('right',obj,gx2,gy)
		end
	end

	-- left sensor check
	for gy = gy,gy2 do
		if self:preSolve('left',obj,gx,gy) then
			x = gx*mw
			self:postSolve('left',obj,gx,gy)
		end
	end
	return x
end

-----------------------------------------------------------
-- resolve vertical collisions
function m:resolveYdirection(obj,x,y,w,h)
	local mw,mh         = self:getTileSize()
	local gx,gy,gx2,gy2 = self:getRange(x,y,w,h)

	-- floor sensor check
	for gx = gx,gx2 do
		if self:preSolve('floor',obj,gx,gy2) then
			y = (gy2-1)*mh-h
			self:postSolve('floor',obj,gx,gy2)
		end
	end

	-- ceiling sensor check
	for gx = gx,gx2 do
		if self:preSolve('ceiling',obj,gx,gy) then
			y = gy*mh
			self:postSolve('ceiling',obj,gx,gy)
		end
	end
	return y
end
-----------------------------------------------------------
return m