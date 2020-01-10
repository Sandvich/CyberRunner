import "dome" for Process
import "graphics" for Canvas, Color, Point
import "./api" for CanvasString, Fading, Scene, Sprite
import "./player" for Player

class GameLevel is Scene {
	construct init(parent) {
		_parent = parent

		// Load in the background and HUD
		setupDrawLoop()
		_background = Sprite.new("res/level_bg.jpg")
		_bgOffset = 0
		addTempCanvasItem(_background, _bgOffset, 0)
		addCanvasItem(CanvasString.new("Current Score:"), 10, 10)
		_score = 0
		_prefs = _parent.loadPrefs()

		// Set up audio
		if (!_prefs["mute"]) {
			_channelID = Fading.play("cyberrunner")
		}

		// Add the player and a list to track the enemies
		_player = Player.new()
		addTempCanvasItem(_player, _player.x, _player.y)
		_enemies = []
		_enemies.add(Enemy.new(300))

		draw(0)
	}

	update() {
		super()
		// Background and Score
		_bgOffset = _bgOffset - 2
		if (_bgOffset + _background.width < 0) { _bgOffset = _bgOffset + _background.width }
		addTempCanvasItem(_background, _bgOffset, 0)
		addTempCanvasItem(_background, _bgOffset+_background.width, 0)
		_score = _score + 1
		addTempCanvasItem(CanvasString.new("%(_score)"), 125, 10)

		// Update the player
		_player.update()
		addTempCanvasItem(_player, _player.x, _player.y)
		for (enemy in _enemies) {
			enemy.update()
			addTempCanvasItem(enemy, enemy.x, enemy.y)
		}

		// Check for game over
		if (_player.isDead(_enemies)) {
			Fading.stop(_channelID)
			_parent.loadScene("gameover", [_score])
		}
	}

	mouseHandler() { _player.mouseHandler() }

	// Boilerplate + functions
	static run(parent) {
		return init(parent)
	}
}

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
}