CaveHelper = Object:extend()

function CaveHelper:generateGround()
    --5 iterations to smooth out caves
    for x = 1, 5 do
        for s, state in ipairs(undergroundStates) do
            for i, col in ipairs(cells) do
                for j, cell in ipairs(col) do
                    if cell.x ~= cellSize and cell.x ~= width and cell.y ~= height and cell.state ~= skyState then

                        stateCount = CaveHelper.calculateStateNeighbors(0, cell, state)

                        if isState(cell, state) == 0 and stateCount > 4 then
                            newCells[i][j].state = state
                            if state == caveState then
                                newCells[i][j].isCave = 1
                            end
                        end

                        if isState(cell, state) == 1 and stateCount < 3 then
                            newCells[i][j].state = undergroundStates[love.math.random( #undergroundStates )]
                            if state == caveState then
                                newCells[i][j].isCave = 0
                            end
                        end
                    end
                end
            end
        end
        cells = newCells
    end

    groundCleanup()

end

function CaveHelper:calculateStateNeighbors(cell, state)

    cellArrayX = cell.x/cellSize
    cellArrayY = cell.y/cellSize
    stateCount = 0

    stateCount = stateCount + isState(cells[cellArrayX-1][cellArrayY-1], state)
    stateCount = stateCount + isState(cells[cellArrayX-1][cellArrayY], state)
    stateCount = stateCount + isState(cells[cellArrayX-1][cellArrayY+1], state)

    stateCount = stateCount + isState(cells[cellArrayX][cellArrayY-1], state)
    stateCount = stateCount + isState(cells[cellArrayX][cellArrayY+1], state)

    stateCount = stateCount + isState(cells[cellArrayX+1][cellArrayY+1], state)
    stateCount = stateCount + isState(cells[cellArrayX+1][cellArrayY], state)
    stateCount = stateCount + isState(cells[cellArrayX+1][cellArrayY+1], state)

    return stateCount
end

function isState(cell, state)
    if cell.state == state then
        return 1
    else
        return 0
    end
end

function groundCleanup()

    for i,col in ipairs(cells) do
        for j, cell in ipairs(col) do

            --cave cleanup
            if cell.state == caveState and (cell.x == cellSize or cell.x == width or cell.y == height) then
                cell.state = collectibleStates[love.math.random( #collectibleStates)]
            end
            if cell.state == caveState and CaveHelper.calculateStateNeighbors(0, cell, cell.state) == 0 then
                cell.state = collectibleStates[love.math.random( #collectibleStates)]
            end

            --stone on bottom
            if j*cellSize == height then
                cell.state = stoneState
            end

            --gold only on bottom 25%
            if cell.state == goldState and cell.y < .75*height then
                cell.state = nonCaveCommonStates[love.math.random( #nonCaveCommonStates)]
            end

            --diamond only on bottom 10%
            if cell.state == diamondState and cell.y < .90*height then
                cell.state = nonCaveCommonStates[love.math.random( #nonCaveCommonStates)]
            end

            --grass only on top
            if cell.state == grassState and State.inCollectibleStates(0, cells[i][j-1]) then
                cell.state = dirtState
            end

        end
    end

end