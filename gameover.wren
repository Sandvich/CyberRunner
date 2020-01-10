import "audio" for AudioEngine
import "input" for Mouse
import "./api" for Scene, Sprite, CanvasString

class GameOver is Scene {
	construct init(parent, args) {
		_parent = parent
		_score = args[0]
		_prefs = _parent.loadPrefs()
		_newHigh = false
		_clicked = true
		AudioEngine.stopAllChannels()

		// Work out if _score is our highscore
		if (_score > _prefs["high"]) {
			_prefs["high"] = _score
			_parent.savePrefs(_prefs)
			_newHigh = true
		}

		// Draw items
		setupDrawLoop()
		addCanvasItem(Sprite.new("res/gameover.png", true), 400, 100)
		addCanvasItem(CanvasString.new("You scored: %(_score)", true), 400, 300)
		addCanvasItem(CanvasString.new("Your high score: %(_prefs["high"])", true), 400, 325)
		if (_newHigh) {
			addCanvasItem(Sprite.new("res/highscore.png", true), 400, 450)
		}
		addCanvasItem(CanvasString.new("Click anywhere to return to the main screen.", true), 400, 500)

		draw(0)
	}

	mouseHandler() {
		if (Mouse.isButtonPressed("left")) {
			if (!_clicked) { _parent.loadScene("menu") }
		} else {
			_clicked = false
		}
	}

	static run(parent, args) {
		return init(parent, args)
	}
}