import "graphics" for ImageData, Point
// A set of common classes that we can use to make life easier

class Sprite {
    // An image that can be displayed on the screen.
    construct new(filename, center) {
        _center = center
        sprite = filename
    }
    construct new(filename) {
        _center = false
        sprite = filename
    }

    sprite=(filename) { _sprite = ImageData.loadFromFile(filename) }

    draw (x, y) {
        if (_center) {
            x = x - (_sprite.width / 2)
            y = y - (_sprite.height / 2)
        }

        _sprite.draw(x, y)
        // Store this so that we know the co-ordinates that refer to this sprite
        _loc = Point.new(x, y)
    }

    getSize() {
        if (_loc != null) {
            return [_loc, Point.new(_loc.x + _sprite.width, _loc.y + _sprite.height)]
        }
    }
}

class Button is Sprite {
    // An interactable button, including a sprite.
    construct new(image, action, center) {
        super(image, center)
        this.action = action
    }
    construct new(image, action) {
        super(image, false)
        this.action = action
    }

    action=(function) {
        if (function is Fn) {
            _action = function
        } else {
            _action = Fn.new { System.print(function) }
        }
    }

    onClick() {
        _action.call()
    }
}