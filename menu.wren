import "graphics" for Canvas, Color, ImageData, Point
import "io" for FileSystem

class Menu {
    construct init () {
        _background = ImageData.loadFromFile("res/gridbg.png")
        Canvas.resize(_background.width, _background.height)
        _background.draw(0, 0)
    }

    static run () {
        this.init()
    }    
}