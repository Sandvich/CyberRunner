import "graphics" for Canvas, ImageData, Point
// A set of common classes that we can use to make life easier

class Sprite {
    // An image that can be displayed on the screen.
    construct new(filename, center) {
        _center = center
        setImage(filename)
    }

    construct new(filename) {
        _center = false
        setImage(filename)
    }

    setImage(filename) {
        _sprite = ImageData.loadFromFile(filename)
    }

    draw (x, y) {
        if (_center) {
            x = x - (_sprite.width / 2)
            y = y - (_sprite.height / 2)
        }

        _sprite.draw(x, y)
    }
}

class Button is Sprite {
    // An interactable button, including a sprite.

}