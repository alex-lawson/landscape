util = require 'util'
require 'skyline'
require 'skylinetemplates'

Game = {}

function Game:new(config)
    local newGame = setmetatable(util.copy(config), {__index=Game})

    return newGame
end

function Game:init()
    self.rng = love.math.newRandomGenerator(util.seedTime())
    self.baseYRatio = 0.2
    self.scaleRange = {0.5, 1.5}
    self.parallaxRange = {3, 80}
    self.parallaxRate = 1
    self.parallax = 0

    self:generateScene()
end

function Game:update(dt)
    self.parallax = self.parallax + self.parallaxRate * dt
end

function Game:render()
    local h = love.graphics.getHeight()

    for _, sl in ipairs(self.skylines) do
        local px = self.parallax * util.lerp(math.sin(math.pi * 0.5 * (sl.baseY - h * self.baseYRatio) / h), self.parallaxRange)
        sl:draw(px)
    end
end

function Game:setParallaxRate(value)
   self.parallaxRate = value
end

function Game:adjustParallaxRate(amount)
    self.parallaxRate = self.parallaxRate + amount
end

function Game:clearCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.setCanvas()
end

function Game:generateScene()
    self:setParallaxRate(1)
    self.parallax = 0

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    self.baseY = h * self.baseYRatio
    h = h - self.baseY

    local function scaleFromY(fromY)
        return util.lerp(math.sin(fromY / h * 0.5 * math.pi), self.scaleRange)
    end

    local layerCount = self.rng:random(6, 8)

    local function colorVal(i)
        return 1 - (i / layerCount - self.rng:random() * (1 / layerCount))
    end

    self.skylines = {}

    for i = 1, layerCount do
        local y = h - h * math.cos(i / layerCount * 0.4 * math.pi + self.rng:random() * 0.1)

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

        -- printf("layer %s is type %s with scale %s", i, template, scaleFromY(y))

        local color = {colorVal(i), colorVal(i), colorVal(i)}

        local sl = Skyline:new(SkylineTemplates[template], self.rng:random(2147483647), self.baseY + y, scaleFromY(y), color)
        table.insert(self.skylines, sl)
    end
end
