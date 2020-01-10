import "graphics" for Canvas, Color, Point
import "input" for Mouse
import "./api" for AnimatedSprite

class Player is AnimatedSprite {
	construct new() {
		_loc = Point.new(10, 300)
		_lastMove = 0
		_teleportMovement = 10
		_lastTeleport = 10
		_collide = true

		_center = true
		setAnimation(["res/run-1.png",
						"res/run-2.png",
						"res/run-3.png",
						"res/run-4.png",
						"res/run-5.png",
						"res/run-6.png",
						"res/run-7.png",
						"res/run-8.png"])
	}

	mouseHandler() {
		// Intertia based movement
		_lastMove = ( Mouse.y - _loc.y + _lastMove ) * 0.15
		_loc.y = _loc.y + _lastMove

		// Set boundaries
		if (_loc.y < 30) (_loc.y = 30)
		if (_loc.y > 580) (_loc.y = 580)

		// Check for a click, like with the menu
		_mouseWasDown = _mouseIsDown
		_mouseIsDown = Mouse.isButtonPressed("left")
		// If the player has just clicked, then... We...
		if (_mouseIsDown && (!_mouseWasDown)) {
			_lastTeleport = _teleportMovement
			teleport()
		}
		// TELEPORT!
	}

	teleport() {
		_collide = false
		_lastTeleport = _lastTeleport * 0.9
		_loc.x = _loc.x + _lastTeleport
	}

	update() {
		super()
		// Keep going with the teleport if it's ongoing
		if (_lastTeleport != _teleportMovement) { teleport() }
		if (_lastTeleport < 1) {
			_collide = true
		}
	}

	isDead() {
		if ( _loc.x > (Canvas.width * 2 / 3 )) {
			return true
		} else {
			return false
		}
	}

	x { _loc.x }
	y { _loc.y }
}