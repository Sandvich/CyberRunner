import "graphics" for Canvas, Color, ImageData, Point
import "io" for FileSystem

class Menu {
    construct init () {
        // Set up the background
        _background = ImageData.loadFromFile("res/gridbg.png")
        Canvas.resize(_background.width, _background.height)
        _background.draw(0, 0)

        // Construct the menu
        _buttons = {
            "start": ImageData.loadFromFile("res/start_button.png"),
            "quit": ImageData.loadFromFile("res/quit_button.png")
        }

        var y = 300
        for (button in _buttons.keys) {
            _buttons[button].draw(300, y)
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