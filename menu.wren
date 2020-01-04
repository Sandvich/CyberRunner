import "dome" for Process
import "graphics" for Canvas, ImageData
import "input" for Mouse
import "./api" for Sprite, Button, Scene

class Menu is Scene {
    construct init () {
        // Set up the background
        setupDrawLoop()
        _background = ImageData.loadFromFile("res/gridbg.png")
        Canvas.resize(_background.width, _background.height)
        addCanvasItem(_background, 0, 0)

        // Create the functions used for the menu
        var cursor = Sprite.new("res/arrow.png", false)
        var startPressed = Fn.new { System.print("Pressed the start button") }
        var quitPressed = Fn.new { Process.exit() }

        // Construct the menu
        _buttons = [
            Button.new("res/start_button.png", startPressed, true),
            Button.new("res/quit_button.png", quitPressed, true)
        ]

        var y = 300
        for (button in _buttons) {
            addCanvasItem(button, 400, y)
            button.hover = Fn.new { addTempCanvasItem(cursor, 295, button.getSize()[0].y + 10) }
            y = y + 50
        }

        draw(0)
    }

    mouseHandler() {
        for (item in _buttons) {
            var size = item.getSize()
            if ( (size[0].x <= Mouse.x) && (size[0].y <= Mouse.y) && (size[1].x >= Mouse.x) && (size[1].y >= Mouse.y) ) {
                item.onHover()
                if (Mouse.isButtonPressed("left")) item.onClick()
            }
        }
    }

    // Boilerplate + functions
    static run() { 
        return init()
    }
}