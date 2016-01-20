-- Libraries.
local Layout = require 'lib.luigi.layout'
local Gamestate = require 'lib.hump.gamestate'

-- UI factory.
return function (game)
    -- Create menu UI.
    local ui = Layout {
        { flow = 'x',
            { width = 200,
                { type = 'button', id = 'play', text = 'Play' },
                { type = 'button', id = 'quit', text = 'Quit' },
            },
            { color = { 255, 0, 0 }, align = 'middle center',
                text = 'A preview goes here' },
        }
    }

    -- Use the built-in dark theme.
    ui:setTheme(require 'lib.luigi.theme.dark')

    -- Focus default button.
    ui.play:focus()

    -- Pressing "play" switches to "game" gamestate.
    ui.play:onPress(function (event)
        if event.button ~= 'left' then return end
        Gamestate.switch(game)
    end)

    -- Pressing "quit" exits the game.
    ui.quit:onPress(function (event)
        if event.button ~= 'left' then return end
        love.event.quit()
    end)

    -- Return UI instance.
    return ui
end
