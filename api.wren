import "graphics" for ImageData, Point, Canvas, Color
import "audio" for AudioEngine
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
	width { _sprite.width }
	height { _sprite.height }

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
	clearCanvasItems() { setupDrawLoop() } // Really just a convenience.

	mouseHandler() {}
	keyboardHandler() {}
	gamepadHandler() {}
}

class CanvasString {
	construct new(string) {
		_string = string
		_center = false
	}
	construct new(string, center) {
		_string = string
		_center = center
	}

	draw(x, y) {
		if (_center) {
			x = x - (4 * _string.count)
			// Imperfect, but we shouldn't be using any multi-byte characters
		}
		Canvas.print(_string, x, y, Color.white)
	}
}

class Fading {
	static init() {
		AudioEngine.load("bluebeat", "res/bluebeat.ogg")
		AudioEngine.load("cyberrunner", "res/cyberrunner.ogg")
		__fadeIn = []
		__fadeOut = []
	}

	static play(trackname) {
		var channelID = AudioEngine.play(trackname, 0, true)
		System.print("Now fading in %(trackname) on channel %(channelID)")
		__fadeIn.add(channelID)
		__fadeIn.add(0)
		return __fadeIn[0]
	}

	static stop(channelID) {
		__fadeOut.add(channelID)
		if (__fadeIn.count > 0 && __fadeIn[0] == channelID) {
			__fadeOut.add(__fadeIn[1])
			__fadeIn = []
		} else {
			__fadeOut.add(1)
		}
	}

	static update() {
		if (__fadeIn.count > 0) {
			__fadeIn[0].volume = __fadeIn[0].volume + 0.01
			if (__fadeIn[0].volume >= 1.0) {
				__fadeIn = []
			}
		}

		if (__fadeOut.count > 0) {
			__fadeOut[0].volume = __fadeOut[0].volume - 0.01
			if (__fadeOut[0].volume <= 0) {
        __fadeOut[0].stop()
				__fadeOut = []
			}
		}
	}

	static isPlaying(channelID) { AudioEngine.isPlaying(channelID) }
	static stopAllChannels() { AudioEngine.stopAllChannels() }
}

class AnimatedSprite is Sprite {
	construct new(filenames, center) {
		_center = center
		setAnimation(filenames)
	}

	construct new(filenames) {
		_center = false
		setAnimation(filenames)
	}

	setAnimation(filenames) {
		_count = 0
		speed = 5
		_frameNumber = 0
		_animationFrames = []
		for (file in filenames) {
			_animationFrames.add(Sprite.new(file, _center))
		}
	}

	draw(x,y) {
		_animationFrames[_frameNumber].draw(x,y)
		_loc = Point.new(x, y)
	}

	speed=(speed) { _speed = speed }
	getSpeed { _speed }
	update() {
		_count = _count + 1
		if (_count == getSpeed) {
			_frameNumber=_frameNumber+1
			if (_frameNumber == _animationFrames.count) { _frameNumber = 0 }
			_count = 0
		}
	}

	getSize() {
		if (_loc != null) {
			return [_loc, Point.new(_loc.x + _animationFrames[_frameNumber].width, _loc.y + _animationFrames[_frameNumber].height)]
		}
	}
}
