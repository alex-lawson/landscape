util = require 'util'
require 'skyline'
require 'skylinetemplates'

Game = {}

function Game:new(config)
    local newGame = setmetatable(util.copy(config), {__index=Game})

    return newGame
end

function Game:init()
    self.canvas = love.graphics.newCanvas()
    self.rng = love.math.newRandomGenerator(util.seedTime())
end

function Game:update(dt)

end

function Game:render()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.canvas)
end

function Game:clearCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.setCanvas()
end

function Game:placeSkyline(yPosition)
    love.graphics.setCanvas(self.canvas)

    love.graphics.setColor(self.rng:random(1, 255), self.rng:random(1, 255), self.rng:random(1, 255))

    local sl = Skyline:new(SkylineTemplates.Mountains, nil, 0.982373)
    sl:draw(yPosition)

    love.graphics.setCanvas()
end

function Game:generateScene()
    love.graphics.setCanvas(self.canvas)

    love.graphics.clear()

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local baseY = h * 0.2
    h = h - baseY

    local scaleRange = {0.5, 1.5}

    local function scaleFromY(fromY)
        return util.lerp(math.sin(fromY / h * 0.5 * math.pi), scaleRange)
    end

    local layerCount = self.rng:random(4, 7)

    local function colorVal(i)
        local lerpVal = 1 - (i / layerCount - self.rng:random() * (1 / layerCount))
        return math.floor(255 * lerpVal)
    end

    for i = 1, layerCount do
        local y = h - h * math.cos(i / layerCount * 0.4 * math.pi + self.rng:random() * 0.1)

        love.graphics.setColor(colorVal(i), colorVal(i), colorVal(i))

        local candidates = {}
        local yRatio = y / h
        for k, v in pairs(SkylineTemplates) do
            if yRatio >= v.yRange[1] and yRatio <= v.yRange[2] then
                table.insert(candidates, k)
            end
        end

        if #candidates == 0 then
            printf("no candidate templates found for yRatio %.2f", yRatio)
            break
        end

        local template = candidates[self.rng:random(1, #candidates)]

        printf("layer %s is type %s with scale %s", i, template, scaleFromY(y))

        local sl = Skyline:new(SkylineTemplates[template], self.rng:random(2147483647), scaleFromY(y))
        sl:draw(baseY + y)
    end


    love.graphics.setCanvas()
end
