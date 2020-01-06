import "graphics" for Canvas, Color, Point
import "input" for Mouse
import "./api" for Sprite

class Player is Sprite {
	construct new() {
		_loc = Point.new(10, 300)
		_radius = 5
		_color = Color.white
		_lastMove = 0
		_teleportMovement = 10
		_lastTeleport = 10
		_collide = true
	}

	draw(x, y) {
		Canvas.ellipsefill(x - _radius, y - _radius, x + _radius, y + _radius, _color)
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
		if (_mouseIsDown && (!_mouseWasDown)) { teleport() }
		// TELEPORT!
	}

	teleport() {
		_collide = false
		_lastTeleport = _lastTeleport * 0.9
		_loc.x = _loc.x + _lastTeleport
	}

	update() {
		// Keep going with the teleport if it's ongoing
		if (_lastTeleport != _teleportMovement) { teleport() }
		if (_lastTeleport < 1) {
			_lastTeleport = _teleportMovement
			_collide = true
		}
	}

	x { _loc.x }
	y { _loc.y }
}