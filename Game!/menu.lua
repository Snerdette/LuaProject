local menu = {}
width = love.graphics.getWidth()
  height = love.graphics.getHeight()

function menu.menudraw()
    love.graphics.setNewFont(80)
    love.graphics.print("Lua Project!", width/4 - 50, height/4 - 50)
    love.graphics.setNewFont(40)
    love.graphics.print("Press 1 for Maze Game!", width/4 - 50, height/2 - 50)
    love.graphics.setNewFont(40)
    love.graphics.print("Press 2 for Space Game!", width/4 - 50, height/2)
end

return menu