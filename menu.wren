import "audio" for AudioEngine
import "dome" for Process
import "graphics" for Canvas, ImageData
import "input" for Mouse
import "./api" for Sprite, Button, Scene

class Menu is Scene {
    construct init (parent) {
        _parent = parent
        // Set up the window and load in the files we need.
        setupDrawLoop()
        _background = ImageData.loadFromFile("res/gridbg.png")
        Canvas.resize(_background.width, _background.height)
        _cursor = Sprite.new("res/arrow.png", false)

        // Load and play the background music
        AudioEngine.load("menu", "res/bluebeat.ogg")
        _channelID = AudioEngine.play("menu")
        AudioEngine.setChannelLoop(_channelID, true)
        _mute = false

        // Needs to be done manually once, to ensure that everything is set up.
        drawMainMenu()
        draw(0)
    }

    drawMainMenu() {
        clearCanvasItems()
        addCanvasItem(_background, 0, 0)

        // Create the functions used for the menu
        var startPressed = Fn.new { _parent.loadScene("Main game scene") }
        var settingsPressed = Fn.new { drawSettingsMenu() }
        var quitPressed = Fn.new { Process.exit() }

        // Construct the menu
        _buttons = [
            Button.new("res/start_button.png", startPressed, true),
            Button.new("res/start_button.png", settingsPressed, true), // Will become a settings button
            Button.new("res/quit_button.png", quitPressed, true)
        ]

        var y = 300
        for (button in _buttons) {
            addCanvasItem(button, 400, y)
            button.hover = Fn.new { addTempCanvasItem(_cursor, 295, button.getSize()[0].y + 10) }
            y = y + 50
        }
    }

    drawSettingsMenu() {
        clearCanvasItems()
        addCanvasItem(_background, 0, 0)

        // Create the functions used for the menu
        var mutePressed = Fn.new { 
            if (AudioEngine.isPlaying(_channelID)) {
                AudioEngine.stopAllChannels()
                _mute = true
            } else {
                _channelID = AudioEngine.play("menu")
                AudioEngine.setChannelLoop(_channelID, true)
                _mute = false
            }
        }

        var menuPressed = Fn.new { drawMainMenu() }

        // Construct the menu
        _buttons = [
            Button.new("res/quit_button.png", mutePressed, true), // Will become a toggle mute button
            Button.new("res/start_button.png", menuPressed, true) // Will become a back button
        ]

        var y = 300
        for (button in _buttons) {
            addCanvasItem(button, 400, y)
            button.hover = Fn.new { addTempCanvasItem(_cursor, 295, button.getSize()[0].y + 10) }
            y = y + 50
        }
    }

    mouseHandler() {
        // We use this pair of bools to ensure that a mouse click is only interpreted once
        // Kinda like using the SDL MouseEvent stuff, but not as good
        _mouseWasDown = _mouseIsDown
        _mouseIsDown = Mouse.isButtonPressed("left")

        for (item in _buttons) {
            var size = item.getSize()
            if ( (size[0].x <= Mouse.x) && (size[0].y <= Mouse.y) && (size[1].x >= Mouse.x) && (size[1].y >= Mouse.y) ) {
                item.onHover()
                if (_mouseIsDown && (!_mouseWasDown)) { item.onClick() }
            }
        }
    }

    // Boilerplate + functions
    static run(parent) {
        return init(parent)
    }
}