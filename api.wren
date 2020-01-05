import "graphics" for ImageData, Point, Canvas
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

    hover=(func) {
        _hover = func
    }

    onHover() {
        if (_hover != null) {
            _hover.call()
        } else {
            System.print("Hovering!")
        }
    }
}

class Scene {
    // The core class for scenes. Will do little on its own, other than managing the
    // draw loop.
    // Subclass to create a scene.

    construct init() {}

    static run() {
        // We use the static function run for all scenes instead of their constructors,
        // as this means that when we're done with the scene all memory associated with
        // it is freed automatically.
        return init()
    }

    update() {
        _tempDraw = []
    }

    draw(dt) {
        Canvas.cls()
        for (item in _toDraw) {
            item[0].draw(item[1].x, item[1].y)
        }
        for (item in _tempDraw) {
            item[0].draw(item[1].x, item[1].y)
        }
    }

    setupDrawLoop() {
        _toDraw = []
        _tempDraw = []
    }

    addCanvasItem(item, x, y) { _toDraw.add([item, Point.new(x,y)]) }
    addTempCanvasItem(item, x, y) { _tempDraw.add([item, Point.new(x,y)]) }

    mouseHandler() {}
    keyboardHandler() {}
    gamepadHandler() {}
}