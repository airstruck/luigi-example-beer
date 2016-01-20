-- Libraries.
local Layout = require 'lib.luigi.layout'

-- UI factory.
return function (title, text, onConfirm, onCancel)
    -- Create choice dialog.
    local ui = Layout {
        type = 'submenu', modal = 'true', width = 250, height = 150,
        { type = 'panel', text = title, size = 18, height = 38,
            align = 'center middle' },
        { flow = 'x',
            { text = '?', size = 48, width = 100, color = { 0, 0, 255 },
                align = 'center middle' },
            { text = text, align = 'left middle', wrap = true },
        },
        { type = 'panel', flow = 'x', height = 'auto',
            {},
            { id = 'cancel', type = 'button', text = 'Cancel' },
            { id = 'confirm', type = 'button', text = 'Confirm' },
        }
    }

    -- Use the built-in dark theme.
    ui:setTheme(require 'lib.luigi.theme.dark')

    -- Focus default button.
    ui.cancel:focus()

    -- Handle "cancel" button.
    ui.cancel:onPress(function (event)
        if event.button ~= 'left' then return end
        if onCancel and onCancel() ~= nil then return end
        ui:hide()
    end)

    -- Handle "confirm" button.
    ui.confirm:onPress(function (event)
        if event.button ~= 'left' then return end
        if onConfirm and onConfirm() ~= nil then return end
        ui:hide()
    end)

    -- Return UI instance.
    return ui
end
