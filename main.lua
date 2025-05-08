io.stdout:setvbuf('no')

Object = require "classic"
    require "cell"
    require "conf"
    require "state"
    require "animation"
    require "caveHelper"
    require "sprite"
    require "collisionHelper"


function love.load()
    
    font = love.graphics.getFont()

    width, height = love.graphics.getDimensions()
    cellSize = 20

    --create all states
    State.loadStates()

    --initial cells array
    cells = {}
    newCells = {}

    for i = 1, width/cellSize do
        cells[i] = {}
        newCells[i] = {}
        for j = 1, height/cellSize do
            --generate state of cell
            if j*cellSize < height/2 then
                state = skyState
            elseif j*cellSize ~= height then
                state = undergroundStates[love.math.random( #undergroundStates )]
            end

            if state == caveState then
                isCave = 1
            else
                isCave = 0
            end

            currCell = Cell(state, i*cellSize, j*cellSize, isCave)
            cells[i][j] = currCell

        end
    end
    newCells = cells

    --cellular automata to generate ground
    CaveHelper.generateGround()

    --sprite setup
    runAnimation = Animation.newAnimation(0, love.graphics.newImage("run.png"), 20, 40, 1)
    idleAnimation = Animation.newAnimation(0, love.graphics.newImage("idle.png"), 20, 40, 1)

    sprite = Sprite(40, height/2 - 60, 0, 1, 1, idleAnimation, 0, 1.5)
    spriteBox = {}
    spriteBox.x = sprite.x + 3
    spriteBox.y = sprite.y 
    spriteBox.width = cellSize - 6
    spriteBox.height = (cellSize * 2) 

    --physics
    gravity = -500
    jumpHeight = -300

    --clouds
    clouds = {}
    clouds.image = love.graphics.newImage("cloud.png")
    clouds.clouds = {}
    
    for i = 1, 7 do
        clouds.clouds[i] = {}
        clouds.clouds[i].x = love.math.random(width)
        clouds.clouds[i].y = love.math.random(height/4)
        clouds.clouds[i].scale = 1+love.math.random()
        clouds.clouds[i].speed = .1 + love.math.random() * .3
    end

end

function love.update(dt)

    --state labels
    for i,state in ipairs(collectibleStates) do
        if state.count == 0 then
            state.textColor = {0,0,0}
            state.isHighlighted = false
        end
    end

    --animation/physics

    tc, topCollisionType = CollisionHelper.topCollision(0,math.ceil(spriteBox.x/cellSize), math.ceil(spriteBox.y/cellSize))
    bc = CollisionHelper.bottomCollision(0,math.ceil(spriteBox.x/cellSize))
    collision, collisionType = CollisionHelper.leftRightCollision(0,math.ceil(spriteBox.x/cellSize), math.ceil(spriteBox.y/cellSize))
    
    if bc == false then
        --constant gravity
        sprite.yVelocity = sprite.yVelocity - gravity * dt
    end

    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        sprite.speed = 2.5
    else
        sprite.speed = 1.5
    end

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        sprite.currAnimation = runAnimation
        if sprite.sx == -1 then
            sprite.x = sprite.x - cellSize
            sprite.sx = 1
        end
        if collisionType ~= "right"  and sprite.x + cellSize < width - cellSize then
            sprite.x = sprite.x + sprite.speed
            spriteBox.x = spriteBox.x + sprite.speed
        end
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        sprite.currAnimation = runAnimation
        if sprite.sx == 1 then
            sprite.x = sprite.x + cellSize
            sprite.sx = -1
        end
        if collisionType ~= "left" and sprite.x > cellSize then
            sprite.x = sprite.x - sprite.speed
            spriteBox.x = spriteBox.x - sprite.speed
        end
    else
        sprite.currAnimation = idleAnimation
    end

    if love.keyboard.isDown("space") or love.keyboard.isDown("up") or love.keyboard.isDown("w") then
		if sprite.yVelocity == 0 then
			sprite.yVelocity = jumpHeight
		end
	end

    if sprite.yVelocity ~= 0 and topCollisionType ~= "top" then
        sprite.y = sprite.y + sprite.yVelocity * dt
        spriteBox.y = spriteBox.y + sprite.yVelocity * dt
		sprite.yVelocity = sprite.yVelocity - gravity * dt
	end

    --spriteFrames
    sprite.currAnimation.currTime = sprite.currAnimation.currTime + dt
    if sprite.currAnimation.currTime >= sprite.currAnimation.duration then
        sprite.currAnimation.currTime = sprite.currAnimation.currTime - sprite.currAnimation.duration
    end

    spriteNum = math.floor(sprite.currAnimation.currTime / sprite.currAnimation.duration * #sprite.currAnimation.quads) + 1

    --clouds
    for i, cloud in ipairs(clouds.clouds) do
        cloud.x = cloud.x + cloud.speed
        if cloud.x > width then
            cloud.x = -200
        end
    end

end


function love.draw()

    --draw each cell
    for i,col in ipairs(cells) do
        for j, cell in ipairs(col) do

            love.graphics.setColor(love.math.colorFromBytes(cell.state.texture))
            love.graphics.rectangle("fill", cell.x-cellSize, cell.y-cellSize, cellSize, cellSize)

        end
    end

    --draw clouds
    love.graphics.setColor(love.math.colorFromBytes(255,255,255))
    for i, cloud in ipairs(clouds.clouds) do
        love.graphics.draw(clouds.image, cloud.x, cloud.y, 0, cloud.scale)
    end

    --draw sprite
    love.graphics.draw(sprite.currAnimation.spriteSheet, sprite.currAnimation.quads[spriteNum], sprite.x, sprite.y, sprite.r, sprite.sx, sprite.sy)

    --draw state counters
    local yOffset = 0
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))

    for i,state in ipairs(collectibleStates) do
        if state.count ~= 0 then 
            love.graphics.print({state.textColor, state.name .. ": " .. state.count}, width-70, yOffset)
            state.textPosY = yOffset
            yOffset = yOffset + 15
        end
    end
end


function love.mousepressed( x, y, button, istouch, presses )
    local relX = math.ceil(x/cellSize)
    local relY = math.ceil(y/cellSize)

    local currCell = cells[relX][relY]

    if currCell == nil then
        return
    end

    if button == 1 then
        if currCell.y == height then
            --bottom row
            return
        end
        --pick up block
        if State.inCollectibleStates(0, currCell) then
            if currCell.y > spriteBox.y - 2*cellSize and currCell.y < spriteBox.y + 5*cellSize and
            currCell.x > spriteBox.x - 3*cellSize and currCell.x < spriteBox.x + 4*cellSize then
                currCell.state.count = currCell.state.count + 1
                if currCell.y < height/2 then        
                    currCell.state = skyState
                else
                    currCell.state = caveState
                    currCell.isCave = 1
                end
            end
        end

        --labels
        if x >= width-70 and x < width and y < #collectibleStates * 15 then

            for i,state in ipairs(collectibleStates) do
                if y > state.textPosY and y < state.textPosY + 15 then
                    State.setText(0, state, {255, 0, 0}, true)
                else
                    State.setText(0, state, {0,0,0}, false)
                end
            end

        end
    end

    if button == 2 then
        local highlightedState = State.getHighlightedState()
        if currCell.y > spriteBox.y - 2*cellSize and currCell.y < spriteBox.y + 5*cellSize and
            currCell.x > spriteBox.x - 3*cellSize and currCell.x < spriteBox.x + 4*cellSize then
            if highlightedState ~= nil and highlightedState.count > 0 and (currCell.state == skyState or currCell.state == caveState) then
                currCell.state = highlightedState
                highlightedState.count = highlightedState.count - 1
            end
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end
    if key == "down" or key == "s" then
        local currX = math.ceil(sprite.x/cellSize)
        local currY = math.ceil(sprite.y/cellSize-.5)
        if currY + 3 < width/cellSize - 10 then
            cells[currX][currY+3].state.count = cells[currX][currY+3].state.count + 1
            if cells[currX][currY+3].y < height/2 then        
                cells[currX][currY+3].state = skyState
            else
                cells[currX][currY+3].state = caveState
                cells[currX][currY+3].isCave = 1
            end
        end
    end
end
