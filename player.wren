import "graphics" for Canvas, Color, Point
import "input" for Mouse
import "./api" for Sprite

class Player is Sprite {
	construct new() {
		_loc = Point.new(10, 300)
		_radius = 5
		_color = Color.white
	}

	draw(x, y) {
		Canvas.ellipsefill(x - _radius, y - _radius, x + _radius, y + _radius, _color)
	}

	update() {
		var diff = Mouse.y - _loc.y
		var move = diff * 0.15
		_loc.y = _loc.y + move
		if (_loc.y < 30) (_loc.y = 30)
		if (_loc.y > 580) (_loc.y = 580)
	}

	x { _loc.x }
	y { _loc.y }
}