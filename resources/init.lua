hs.window.animationDuration = 0
units = {
    right50 = {
        x = 0.50,
        y = 0.00,
        w = 0.50,
        h = 1.00
    },
    left50 = {
        x = 0.00,
        y = 0.00,
        w = 0.50,
        h = 1.00
    },
    top50 = {
        x = 0.00,
        y = 0.00,
        w = 1.00,
        h = 0.50
    },
    bot50 = {
        x = 0.00,
        y = 0.50,
        w = 1.00,
        h = 0.50
    },
    upright50 = {
        x = 0.50,
        y = 0.00,
        w = 0.50,
        h = 0.50
    },
    botright50 = {
        x = 0.50,
        y = 0.50,
        w = 0.50,
        h = 0.50
    },
    upleft50 = {
        x = 0.00,
        y = 0.00,
        w = 0.50,
        h = 0.50
    },
    botleft50 = {
        x = 0.00,
        y = 0.50,
        w = 0.50,
        h = 0.50
    },
    maximum = {
        x = 0.00,
        y = 0.00,
        w = 1.00,
        h = 1.00
    },
    left33 = {
        x = 0.00,
        y = 0.00,
        w = 0.33,
        h = 1.00
    },
    mid33 = {
        x = 0.33,
        y = 0.00,
        w = 0.34,
        h = 1.00
    }, -- Use 0.34 width to cover rounding issues
    right33 = {
        x = 0.67,
        y = 0.00,
        w = 0.33,
        h = 1.00
    },
    left25 = {
        x = 0.00,
        y = 0.00,
        w = 0.25,
        h = 1.00
    },
    mid50 = {
        x = 0.25,
        y = 0.00,
        w = 0.50,
        h = 1.00
    },
    right25 = {
        x = 0.75,
        y = 0.00,
        w = 0.25,
        h = 1.00
    }
}

mash = {"cmd", "alt", "ctrl"}
hs.hotkey.bind(mash, 'right', function()
    hs.window.focusedWindow():move(units.right50, nil, true)
end)
hs.hotkey.bind(mash, 'left', function()
    hs.window.focusedWindow():move(units.left50, nil, true)
end)
hs.hotkey.bind(mash, 'm', function()
    hs.window.focusedWindow():move(units.maximum, nil, true)
end)
hs.hotkey.bind(mash, 'j', function()
    hs.window.focusedWindow():move(units.left25, nil, true)
end)
hs.hotkey.bind(mash, 'k', function()
    hs.window.focusedWindow():move(units.mid50, nil, true)
end)

hs.hotkey.bind(mash, 'l', function()
    hs.window.focusedWindow():move(units.right25, nil, true)
end)
