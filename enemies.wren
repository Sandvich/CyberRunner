import "graphics" for Canvas, Color, Point
import "input" for Mouse
import "random" for Random
import "./api" for Sprite

class Enemy is Sprite {
	construct new(y) {
		_loc = Point.new(800, y)
	}

	draw(x, y) {
		Canvas.rectfill(x, y, 20, 20, Color.red)
	}

	update() {
		_loc = Point.new(_loc.x - 2, _loc.y)
	}

	getSize() { [_loc, Point.new(20, 20)] }
	x { _loc.x }
	y { _loc.y }

	loc=(location) {_loc = location}
}

class EnemySpawner {
	construct new(difficulty) {
		_enemies = []
		_difficulty = 0.01 + 0.02 * difficulty
		_num = Random.new()
	}

	update(scene) {
		for (item in _enemies) {
			item.loc = Point.new(item.x -2, item.y)
			scene.addTempCanvasItem(item, item.x, item.y)
		}
		
		if (_num.float() < _difficulty) {
			_enemies.add(Enemy.new(_num.int(20, 580)))
		}
	}

	enemyList { _enemies }
}