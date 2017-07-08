util = require 'util'

Skyline = {}

function Skyline:new(config, seed, scale)
    local newSkyline = setmetatable(util.copy(config), {__index=Skyline})

    newSkyline.scale = scale

    newSkyline.rng = love.math.newRandomGenerator(seed or util.seedTime())

    newSkyline.noiseSource = makeNoiseSource(config.noiseConfig, newSkyline.rng)

    return newSkyline
end

function Skyline:draw(baseY)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    local y = baseY - self:sample(0)
    local x = 0

    while x < w do
        local interval
        if type(self.sampleInterval) == "table" then
            interval = util.lerp(self.rng:random(), self.sampleInterval) * self.scale
        else
            interval = self.sampleInterval * self.scale
        end

        local nextX = x + interval
        local nextY = baseY - self:sample(nextX)

        local verts = {x, h, nextX, h, nextX, nextY, x, y}
        love.graphics.polygon("fill", verts)

        x = nextX
        y = nextY
    end
end

function Skyline:sample(x)
    return self.noiseSource:sample(x) * self.scale
end

function makeNoiseSource(config, rng)
    local newNoise = util.copy(config)

    newNoise.rng = rng

    if config.noiseType == "rand" then
        newNoise.sample = function(self, x)
            return util.lerp(rng:random(), self.range)
        end
    elseif config.noiseType == "nrand" then
        newNoise.sample = function(self, x)
            return rng:randomNormal(self.stdev, self.mean or 0)
        end
    elseif config.noiseType == "perlin" then
        newNoise.noiseOrigin = 100000 * rng:random()

        newNoise.sample = function(self, x)
            local sampleX = self.noiseOrigin + x * self.freq
            return love.math.noise(sampleX) * self.amp
        end
    elseif config.noiseType == "sum" then
        newNoise.sources = {}
        for _, sourceConfig in ipairs(config.sources) do
            table.insert(newNoise.sources, makeNoiseSource(sourceConfig, rng))
        end

        newNoise.sample = function(self, x)
            local r = 0

            for _, source in ipairs(self.sources) do
                r = r + source:sample(x)
            end

            return r
        end
    elseif config.noiseType == "min" then
        newNoise.sources = {}
        for _, sourceConfig in ipairs(config.sources) do
            table.insert(newNoise.sources, makeNoiseSource(sourceConfig, rng))
        end

        newNoise.sample = function(self, x)
            local r

            for _, source in ipairs(self.sources) do
                r = r and math.min(r, source:sample(x)) or source:sample(x)
            end

            return r
        end
    elseif config.noiseType == "max" then
        newNoise.sources = {}
        for _, sourceConfig in ipairs(config.sources) do
            table.insert(newNoise.sources, makeNoiseSource(sourceConfig, rng))
        end

        newNoise.sample = function(self, x)
            local r

            for _, source in ipairs(self.sources) do
                r = r and math.max(r, source:sample(x)) or source:sample(x)
            end

            return r
        end
    end

    return newNoise
end