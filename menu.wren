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
            y = y + 100
        }
    }

    static run () {
        // We use the static function run for all scenes instead of their constructors,
        // as this means that when we're done with the scene all memory associated with
        // it is freed automatically.
        init()
    }    
}