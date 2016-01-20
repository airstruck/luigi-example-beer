-- Libraries.
local Layout = require 'lib.luigi.layout'
local Gamestate = require 'lib.hump.gamestate'

-- UI factory.
return function (game, menu)
    -- Create in-game UI overlay.
    local ui = Layout {
        -- Top buttons (just pause for now).
        { flow = 'x',
            {}, -- Spacer.
            { id = 'pause', type = 'button', text = '||', width = 36 },
        },
        {},
        { flow = 'x',
            -- Directional controls. These have an ad-hoc `walkdir` property.
            -- Event handling is delegated to an ancestor widget that looks for
            -- the `walkdir` property in the target widget.
            { width = 200, height = 200,
                { flow = 'x',
                    {},
                    { style = 'arrow', text = '^', shortcut = 'up',
                        walkdir = { 0, -1 } },
                    {},
                },
                { flow = 'x',
                    { style = 'arrow', text = '<', shortcut = 'left',
                        walkdir = { -1, 0 } },
                    {},
                    { style = 'arrow', text = '>', shortcut = 'right',
                        walkdir = { 1, 0 } },
                },
                { flow = 'x',
                    {},
                    { style = 'arrow', text = 'v', shortcut = 'down',
                        walkdir = { 0, 1 } },
                    {},
                }
            },
            -- Status indicator.
            { id = 'status', align = 'bottom right', padding = 8, size = 24 },
        }
    }

    -- Use the built-in dark theme.
    ui:setTheme(require 'lib.luigi.theme.dark')

    -- Style the directional controls.
    ui:setStyle {
        arrow = {
            type = 'button',
            width = false, height = false,
            align = 'middle center',
        }
    }

    -- Don't use tab navigation.
    ui.behavior.navigate:destroy()

    -- Switch to menu gamestate when paused.
    ui.pause:onPress(function (event)
        if event.button ~= 'left' then return end
        Gamestate.switch(menu)
    end)

    -- Handle directional controls.
    ui:onPress(function (event)
        if event.button ~= 'left' then return end
        local walkdir = event.target.walkdir
        if walkdir then
            game:movePlayerBy(walkdir[1], walkdir[2])
        end
    end)

    -- Set global alpha before draw.
    ui.root:onPreDisplay(function (event)
        love.graphics.setColor(255, 255, 255, 128)
    end)

    -- Unset global alpha after draw.
    ui.root:onDisplay(function (event)
        love.graphics.reset()
    end)

    -- Return UI instance.
    return ui
end
