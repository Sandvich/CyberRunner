import "graphics" for Canvas, ImageData
import "io" for FileSystem
import "./api" for Sprite, Button

class Menu {
    construct init () {
        // Set up the background
        _background = ImageData.loadFromFile("res/gridbg.png")
        Canvas.resize(_background.width, _background.height)
        _background.draw(0, 0)

        // Construct the menu
        _buttons = [
            Button.new("res/start_button.png", "start pressed", true),
            Button.new("res/quit_button.png", "quit pressed", true)
        ]

        var y = 300
        for (button in _buttons) {
            button.draw(400, y)
            y = y + 50
        }
    }

    clickHandler(mouseButton, x, y) {
        // The only things to click on in this scene are held in _buttons
        // So iterate over them and check if the mouse is over any
        for (item in _buttons) {
            var size = item.getSize()
            if ( (size[0].x <= x) && (size[0].y <= y) && (size[1].x >= x) && (size[1].y >= y) ) {
                item.onClick()
                // Break here to avoid evaluating every button on every click
                break
            }
        }
    }

    static run () {
        // We use the static function run for all scenes instead of their constructors,
        // as this means that when we're done with the scene all memory associated with
        // it is freed automatically.
        return init()
    }
}