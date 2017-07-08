util = require 'util'
require 'noise'

Skyline = {}

function Skyline:new(config, seed, baseY, scale, color)
    local newSkyline = setmetatable(util.copy(config), {__index=Skyline})

    newSkyline.baseY = baseY
    newSkyline.scale = scale
    newSkyline.color = color

    newSkyline.rng = love.math.newRandomGenerator(seed or util.seedTime())

    newSkyline.noiseSource = makeNoiseSource(config.noiseConfig, newSkyline.rng)

    newSkyline.sampledRange = {0, 0}
    newSkyline.sampleCache = {}

    return newSkyline
end

function Skyline:draw(xOffset)
    love.graphics.setColor(unpack(self.color))

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    local polys = self:buildPolys(xOffset, xOffset + w)

    for _, p in pairs(polys) do
        love.graphics.polygon("fill", p)
    end
end


-- TODO: this is a terrible method, should completely refactor
function Skyline:buildPolys(minX, maxX)
    -- initialize cache if needed
    if #self.sampleCache == 0 then
        table.insert(self.sampleCache, {0, self:sample(0)})
    end

    -- extend sample cache left past minX
    while minX < self.sampledRange[1] do
        local x = self.sampledRange[1] - self:interval()
        table.insert(self.sampleCache, 1, {x, self:sample(x)})
        self.sampledRange[1] = x
    end

    -- extend sample cache right past maxX
    while maxX > self.sampledRange[2] do
        local x = self.sampledRange[2] + self:interval()
        table.insert(self.sampleCache, {x, self:sample(x)})
        self.sampledRange[2] = x
    end

    -- create polys from samples
    local h = love.graphics.getWidth(), love.graphics.getHeight()

    local res = {}

    local p1 = self.sampleCache[1]
    for i = 2, #self.sampleCache do
        local p2 = self.sampleCache[i]

        if p1[1] < maxX and p2[1] > minX then
            table.insert(res, {p1[1] - minX, h, p2[1] - minX, h, p2[1] - minX, p2[2], p1[1] - minX, p1[2]})
        elseif p1[1] > maxX then
            break
        end

        p1 = p2
    end

    return res
end

function Skyline:sample(x)
    return self.baseY + self.noiseSource:sample(x) * self.scale
end

function Skyline:interval()
    if type(self.sampleInterval) == "table" then
        return util.lerp(self.rng:random(), self.sampleInterval) * self.scale
    else
        return self.sampleInterval * self.scale
    end
end
