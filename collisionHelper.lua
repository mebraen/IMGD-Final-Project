CollisionHelper = Object:extend()

function CollisionHelper:bottomCollision(currCol)
    if sprite.sx == 1 then
        for j, cell in ipairs(cells[currCol]) do
            if State.inCollectibleStates(0,cell) then
                if spriteBox.y + spriteBox.height > cell.y - cellSize and spriteBox.y + spriteBox.height - cell.y - cellSize < 10 then
                    sprite.yVelocity = 0
                    sprite.y = cell.y - 60
                    spriteBox.y = sprite.y
                    collisionType = "bottom"

                    return true, collisionType
                end
            end
        end
    elseif sprite.sx == -1 then
        for j, cell in ipairs(cells[math.ceil((spriteBox.x+spriteBox.width)/cellSize)]) do
            if State.inCollectibleStates(0,cell) then
                if spriteBox.y + spriteBox.height > cell.y - cellSize and spriteBox.y + spriteBox.height - cell.y - cellSize < 10 then
                    sprite.yVelocity = 0
                    sprite.y = cell.y - 60
                    spriteBox.y = sprite.y
                    collisionType = "bottom"

                    return true, collisionType
                end
            end
        end
    end

    return false
end

function CollisionHelper:topCollision(currCol, currRow)
    for j = currRow, 1, -1 do
        if State.inCollectibleStates(0,cells[currCol][j]) or
            State.inCollectibleStates(0,cells[currCol+1][j]) then
            if spriteBox.y - 2 < cells[currCol][j].y then
                sprite.yVelocity = 0
                sprite.y = cells[currCol][j].y + 5
                spriteBox.y = sprite.y
                collisionType = "top"
                return true, collisionType
            end
        end
    end
end

function CollisionHelper:leftRightCollision(currCol, currRow)
    --right
    for i = currCol, width/cellSize do
        if State.inCollectibleStates(0,cells[i][currRow+2]) or 
            State.inCollectibleStates(0,cells[i][currRow+1]) then
            if spriteBox.x + spriteBox.width + 1 >= cells[i][currRow+2].x - cellSize then
                collisionType = "right"
                return true, collisionType
            end
        end
    end
    --left
    for i = currCol, 1, -1 do
        if State.inCollectibleStates(0,cells[i][currRow+2]) or 
            State.inCollectibleStates(0,cells[i][currRow+1]) then
            if spriteBox.x - 2 <= cells[i][currRow+2].x then
                collisionType = "left"
                return true, collisionType
            end
        end
    end
    return false
end