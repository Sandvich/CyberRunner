import "audio" for AudioEngine
import "./api" for Scene

class GameLevel is Scene {
    construct init(parent) {
        _parent = parent
        AudioEngine.stopAllChannels()

        // Load in the background and HUD
        setupDrawLoop()
        _prefs = _parent.loadPrefs()

        // Set up audio
        AudioEngine.load("bg", "res/cyberrunner.ogg")
        if (!_prefs["mute"]) {
            _channelID = AudioEngine.play("bg")
            AudioEngine.setChannelLoop(_channelID, true)
        }

        draw(0)
    }

    // Boilerplate + functions
    static run(parent) {
        return init(parent)
    }
}