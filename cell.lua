Cell = Object:extend()

function Cell:new(state, x, y, isCave)
    self.state = state
    self.x = x
    self.y = y
    self.isCave = isCave
end