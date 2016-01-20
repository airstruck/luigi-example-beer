-- Libraries.
local Layout = require 'lib.luigi.layout'
local Gamestate = require 'lib.hump.gamestate'

-- UI factories.
local MenuUI = require 'ui.menu'
local GameUI = require 'ui.game'
local ChoiceUI = require 'ui.choice'

-- Entities.
local beer = { x = 5, y = 5 }
local coffee = { x = 7, y = 3 }
local player = { x = 1, y = 1 }
local target = { x = 0, y = 0 }

-- Game states.
local menu = {}
local game = {}

-- Reusable UI instances.
local menuUI = MenuUI(game)
local gameUI = GameUI(game, menu)

-- Display stuff.
local screenShake = 0

-- Get drunk.
local function drinkBeer ()
    player.isDrunk = true
    gameUI.status.text = 'Drunk'
    gameUI.status.color = { 255, 0, 0 }
    screenShake = 20
end

-- Get sober.
local function drinkCoffee ()
    player.isDrunk = false
    gameUI.status.text = 'Sober'
    gameUI.status.color = { 0, 255, 0 }
end

-- Menu gamestate setup.
function menu:enter ()
    menuUI:show()
end

-- Menu gamestate teardown.
function menu:leave ()
    menuUI:hide()
end

-- Menu gamestate display (could be handled by UI).
function menu:draw ()
    love.graphics.print("Press S to start", 10, 400)
end

-- Menu gamestate key handling (could be handled by UI).
function menu:keyreleased (key, code)
    if key == 's' then
        Gamestate.switch(game)
    end
end

-- Pop up a modal dialog with confirm/cancel buttons.
local function choose (title, text, onConfirm, onCancel)
    return ChoiceUI(title, text, onConfirm, onCancel):show()
end

-- If there's something here to drink, ask if player wants to drink it.
function game:checkBeverage ()
    if player.x == beer.x and player.y == beer.y then
        choose("Drink beer?", "You found a keg of beer. Drink some?",
            drinkBeer)
    elseif player.x == coffee.x and player.y == coffee.y then
        choose("Drink coffee?", "You found a pot of coffee. Drink some?",
            drinkCoffee)
    end
end

-- Go somewhere.
function game:movePlayerTo (x, y)
    player.x = x
    player.y = y
    self:checkBeverage()
end

-- Move around.
function game:movePlayerBy (x, y)
    if player.isDrunk then x, y = x * -1, y * -1 end
    player.x = player.x + x
    player.y = player.y + y
    self:checkBeverage()
end

-- Game gamestate setup.
function game:enter ()
    gameUI:show()
end

-- Game gamestate teardown.
function game:leave ()
    gameUI:hide()
end

-- Game gamestate mouse input.
function game:mousepressed (x, y, button)
    target = { x = math.floor(x / 50), y = math.floor(y / 50) }
    choose("Move here?", "Do you want to move here?",
        function () self:movePlayerTo(target.x, target.y) end
    ):placeNear(x, y)
end

-- Game gamestate display.
function game:draw ()
    -- Quick and dirty screen shake, should really use easing.
    if screenShake ~= 0 then
        love.graphics.translate(screenShake, 0)
        screenShake = screenShake * -0.9
        if screenShake > -1 and screenShake < 1 then screenShake = 0 end
    end

    -- Scale everything up 5x.
    love.graphics.scale(5)

    -- Draw beer.
    love.graphics.setColor(192, 192, 0)
    love.graphics.rectangle('fill',
        beer.x * 10, beer.y * 10, 10, 10)

    -- Draw coffee.
    love.graphics.setColor(40, 40, 0)
    love.graphics.rectangle('fill',
        coffee.x * 10, coffee.y * 10, 10, 10)

    -- Draw player.
    love.graphics.setColor(0, 0, 255)
    love.graphics.circle('fill',
        player.x * 10 + 5, player.y * 10 + 5, 5, 16)

    -- Draw target.
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle('line',
        target.x * 10, target.y * 10, 10, 10)

    -- Reset transformations so they don't affect UI.
    love.graphics.reset()
end

-- Initialize everything.
function love.load ()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
    drinkCoffee()
end
