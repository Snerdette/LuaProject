function love.load()
  love.window.setTitle("Tower Defense")
  love.window.setMode(800, 640)
  
  map = require('map')
    love.graphics.setDefaultFilter("nearest")
    Tileset = love.graphics.newImage('tileset.png')

    TileW, TileH = 16, 16
    local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()

    local quadInfo = { 
        {  0,  0 }, -- 1 = grey 
        { 16,  0 }, -- 2 = ground
        {  0,  16}, -- 3 = grey
        { 16, 16 } -- 4 = ground
      }

    Quads = {}
    for i,info in ipairs(quadInfo) do
    -- info[1] = x, info[2] = y
    Quads[i] = love.graphics.newQuad(info[1], info[2], TileW, TileH, tilesetW, tilesetH)

    TileTable = map

    end
end

function love.update(dt)

end

function love.draw()
  love.graphics.scale(2, 2)
    for rowIndex,row in ipairs(TileTable) do
        for columnIndex,number in ipairs(row) do
          local x,y = (columnIndex-1)*TileW, (rowIndex-1)*TileH
          love.graphics.draw(Tileset, Quads[number], x, y)
        end
    end
end