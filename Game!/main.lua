menu = require 'menu'
maze = require 'maze'

function love.load()
gamestate = "Menu"
maze.mazeload()
end

function love.draw()
    if gamestate == "Menu" then
        menu.menudraw()
    elseif gamestate == "Maze Select" then
        maze.mazedraw()
    elseif gamestate == "Space Select" then
        --space invaders
    end

end

function love.update(dt)
    if gamestate == "Menu" then
        if love.keyboard.isDown('1') then
            gamestate = "Maze Select"
        end
    elseif gamestate == "Maze Select" then
        maze.mazeupdate(dt)
        if love.keyboard.isDown('escape') then
            gamestate = "Menu"
            maze.mazereset()
        end
    end
end