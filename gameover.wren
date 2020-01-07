import "audio" for AudioEngine
import "./api" for Scene

class GameOver is Scene {
	construct init(parent, args) {
		_parent = parent
		_score = args[0]
		_prefs = _parent.loadPrefs()
		AudioEngine.stopAllChannels()

		// Work out if _score is our highscore
		if (_score > _prefs["high"]) {
			_prefs["high"] = _score
			_parent.savePrefs(_prefs)
		}

		// Draw items
		setupDrawLoop()

		draw(0)
	}

	static run(parent, args) {
		return init(parent, args)
	}
}