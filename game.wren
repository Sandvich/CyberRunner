import "dome" for Process
import "graphics" for Canvas, Color
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

		// Add the player
		_player = Player.new()

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

		// Check for game over
		if (_player.isDead()) { _parent.loadScene("gameover", [_score, _channelID]) }
	}

	mouseHandler() { _player.mouseHandler() }

	// Boilerplate + functions
	static run(parent) {
		return init(parent)
	}
}