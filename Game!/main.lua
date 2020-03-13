-----------------------------------
--Space Invaders by Kate Lefrance--
-----Maze Game by Andrew Tran------
----- CST 223 Winter 2020 ---------
-----------------------------------

menu = require 'menu'
maze = require 'maze'
space = require 'space'

function love.load()
gamestate = "Menu"
maze.mazeload()
space.spaceload()
end

function love.draw()
    if gamestate == "Menu" then
        menu.menudraw()
    elseif gamestate == "Maze Select" then
        maze.mazedraw()
    elseif gamestate == "Space Select" then
        space.spacedraw()
    end

end

function love.update(dt)
    if gamestate == "Menu" then
        if love.keyboard.isDown('1') then
            gamestate = "Maze Select"
        elseif love.keyboard.isDown('2') then
            gamestate = "Space Select"
        end
    elseif gamestate == "Maze Select" then
        maze.mazeupdate(dt)
        if love.keyboard.isDown('escape') then
            gamestate = "Menu"
            maze.mazereset()
        end
    elseif gamestate == "Space Select" then
        space.spaceupdate(dt)
        if love.keyboard.isDown('escape') then
            gamestate = "Menu"
        end
    end
end