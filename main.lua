require 'game'

WindowSize = {800, 600}

function love.load()
    love.window.setMode(unpack(WindowSize))
    love.window.setTitle("Landscape Scratchproject")

    GuiFont = love.graphics.newFont("cour.ttf", 16)
    love.graphics.setFont(GuiFont)

    game = Game:new({})

    game:init()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:render()

    if game.skylines and #game.skylines > 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(string.format("Bottom layer cache size: %d", #game.skylines[#game.skylines].sampleCache), 10, 5)
    end
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.keypressed(key)
    local shifting = love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift")
    if key == "space" then
        game:generateScene()
    elseif key == "right" then
        game:adjustParallaxRate(shifting and 100 or 1)
    elseif key == "left" then
        game:adjustParallaxRate(shifting and -100 or -1)
    end
end

function love.keyreleased(key)

end

function love.focus(f)

end

function love.quit()

end

