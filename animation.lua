Animation = Object:extend()

function Animation:new(spriteSheet, quads, duration, currTime)
    self.spriteSheet = spriteSheet
    self.quads = quads
    self.duration = duration
    self.currTime = currTime
end

function Animation:newAnimation(image, width, height, duration)
    local quads = {}

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    local animation = Animation(image, quads, duration, 0)

    return animation
end