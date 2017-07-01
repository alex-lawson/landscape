util = require 'util'

Skyline = {}

function Skyline:new(config, seed, scale)
    local newSkyline = setmetatable(util.copy(config), {__index=Skyline})

    newSkyline.scale = scale

    newSkyline.rng = love.math.newRandomGenerator(seed or util.seedTime())

    for i, v in ipairs(newSkyline.noiseLayers) do
        if v.noise == "perlin" then
            v.noiseOrigin = 100000 * newSkyline.rng:random()
        end
    end

    return newSkyline
end

function Skyline:draw(baseY)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local lastY = baseY - self:sample(0) * self.scale
    local lastX = 0
    local scaledInterval = self.sampleInterval * math.sqrt(self.scale)
    for x = scaledInterval, w + scaledInterval, scaledInterval do
        local nextY = baseY - self:sample(x) * self.scale
        local verts = {lastX, h, x, h, x, nextY, lastX, lastY}
        love.graphics.polygon("fill", verts)

        lastX = x
        lastY = nextY
    end
end

function Skyline:sample(x)
    local r = 0

    for _, v in ipairs(self.noiseLayers) do
        if v.noise == "perlin" then
            local sampleX = v.noiseOrigin + x * v.freq
            r = r + love.math.noise(sampleX) * v.amp
        end
    end

    return r
end