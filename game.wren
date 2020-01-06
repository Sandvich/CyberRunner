import "audio" for AudioEngine
import "graphics" for Canvas, Color
import "./api" for Scene

class GameLevel is Scene {
	construct init(parent) {
		_parent = parent
		AudioEngine.stopAllChannels()

		// Load in the background and HUD
		setupDrawLoop()
		addCanvasItem(CanvasString.new("Current Score:"), 10, 10)
		_score = 0
		_prefs = _parent.loadPrefs()

		// Set up audio
		AudioEngine.load("bg", "res/cyberrunner.ogg")
		if (!_prefs["mute"]) {
			_channelID = AudioEngine.play("bg")
			AudioEngine.setChannelLoop(_channelID, true)
		}

		draw(0)
	}

	update() {
		super()
		_score = _score + 1
		addTempCanvasItem(CanvasString.new("%(_score)"), 125, 10)
	}

	// Boilerplate + functions
	static run(parent) {
		return init(parent)
	}
}

class CanvasString {
	construct new(string) {
		_string = string
	}

	draw(x, y) {
		Canvas.print(_string, x, y, Color.white)
	}
}