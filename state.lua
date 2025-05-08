State = Object:extend()

function State:new(name, texture, textColor, textPosY, count, text, isHighlighted)
    self.name = name
    self.texture = texture
    self.textColor = textColor
    self.textPosY = textPosY
    self.count = count
    self.isHighlighted = isHighlighted
end

function State:setText(state, textColor, isHighlighted)
    state.textColor = textColor
    state.isHighlighted = isHighlighted
end

function State:loadStates() 
    --create states
    dirtState = State("dirt", {139,69,19}, {0,0,0}, 0, 0, false)
    caveState = State("cave", {0,0,0}, {0,0,0}, 0, 0, false)
    grassState = State("grass", {0, 128, 0}, {0,0,0}, 0, 0, false)
    skyState = State("sky", {135, 206, 235}, {0,0,0}, 0, 0, false)
    stoneState = State("stone", {105, 105, 105}, {0,0,0}, 0, 0, false)
    goldState = State("gold", {255, 215, 0}, {0,0,0}, 0, 0, false)
    diamondState = State("diamond", {82, 219, 255}, {0,0,0}, 0, 0, false)

    allStates = {
        dirtState,
        caveState,
        grassState,
        skyState,
        stoneState,
        goldState,
        diamondState
    }

    undergroundStates = {
        dirtState,
        grassState,
        stoneState,
        caveState,
        goldState,
        diamondState
    }

    collectibleStates = {
        dirtState, 
        grassState,
        stoneState,
        goldState,
        diamondState
    }

    commonStates = {
        dirtState, 
        grassState,
        stoneState,
        caveState
    }

    nonCaveCommonStates = {
        dirtState, 
        grassState,
        stoneState
    }

end

function State:getHighlightedState()
    
    for i,state in ipairs(collectibleStates) do
        if state.isHighlighted == true then
            highlightedState = state
            break
        end
    end

    return highlightedState
end

function State:inCollectibleStates(cell)
    for i, state in ipairs(collectibleStates) do
        if cell.state == state then
            return true
        end
    end
    return false
end