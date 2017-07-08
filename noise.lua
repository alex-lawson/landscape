util = require 'util'

function makeNoiseSource(config, rng)
    local newNoise = util.copy(config)
    newNoise.offset = newNoise.offset or 0

    newNoise.rng = rng

    if config.noiseType == "rand" then
        newNoise.sample = function(self, x)
            return util.lerp(rng:random(), self.range) + self.offset
        end
    elseif config.noiseType == "nrand" then
        newNoise.sample = function(self, x)
            return rng:randomNormal(self.stdev, self.mean or 0) + self.offset
        end
    elseif config.noiseType == "perlin" then
        newNoise.noiseOrigin = 100000 * rng:random()
        newNoise.amp = newNoise.amp or 1
        newNoise.freq = newNoise.freq or 1

        newNoise.sample = function(self, x)
            local sampleX = self.noiseOrigin + x * self.freq
            return (2 * love.math.noise(sampleX) - 1) * self.amp + self.offset
        end
    elseif config.noiseType == "sum" then
        newNoise.sources = {}
        for _, sourceConfig in ipairs(config.sources) do
            table.insert(newNoise.sources, makeNoiseSource(sourceConfig, rng))
        end

        newNoise.sample = function(self, x)
            local r = self.offset

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

            return r + self.offset
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

            return r + self.offset
        end
    elseif config.noiseType == "select" then
        newNoise.selectSource = makeNoiseSource(config.selectSource, rng)
        newNoise.aSource = makeNoiseSource(config.aSource, rng)
        newNoise.bSource = makeNoiseSource(config.bSource, rng)

        newNoise.sample = function(self, x)
            local selection = self.selectSource:sample(x)

            if selection > 0 then
                return self.aSource:sample(x) + self.offset
            else
                return self.bSource:sample(x) + self.offset
            end
        end
    elseif config.noiseType == "flat" then
        newNoise.sample = function(self, x)
            return self.offset
        end
    end

    return newNoise
end