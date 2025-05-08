Sprite = Object:extend()

function Sprite:new(x, y, r, sx, sy, currAnimation, yVelocity, speed)
    self.x = x
    self.y = y
    self.r = r
    self.sx = sx
    self.sy = sy
    self.currAnimation = currAnimation
    self.yVelocity = yVelocity
    self.speed = speed
end