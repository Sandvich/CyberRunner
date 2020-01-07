import "audio" for AudioEngine
import "dome" for Window
import "io" for FileSystem
import "./menu" for Menu

// =================
//  GAME CODE BELOW
// =================

class Game {
	static init() {
		// Dome setup stuff

		Window.title = "CyberRunner"
		// The game should be pretty lightweight, so enabling this.
		Window.lockstep = true
		Window.resize(800, 600)

		// Open the menu
		__currentScreen = Menu.run(this)
	}

	static update() {
		__currentScreen.update()
		__currentScreen.mouseHandler()
		__currentScreen.keyboardHandler()
		__currentScreen.gamepadHandler()
	}
	
	static draw(dt) {
		__currentScreen.draw(dt)
	}

	static loadScene(sceneClass) {
		if (sceneClass is Class) {
			__currentScreen = sceneClass.run(this)
		}
	}

	static loadScene(sceneClass, args) {
		if (sceneClass is Class) {
			__currentScreen = sceneClass.run(this, args)
		}
	}

	static loadPrefs() {
		var loaded = null
		var loadFiber = Fiber.new {
			loaded = FileSystem.load("preferences")
		}
		loadFiber.try()

		if (loaded == null) { // Give a default set of prefs
			return {
			"mute": 0,
			"volume": 1.0,
			"difficulty": 0,
			"high": 0
			}
		} else { // Parse the string we loaded
			var listString = loaded.split("\n")
			var prefs = {}
			for (item in listString) {
				if (item.contains(":")) {
					// I'm so sorry
					var pair = item.split(":")
					prefs[pair[0]] = Num.fromString(pair[1])
					if (prefs[pair[0]] == null) {
						// This is a ludicrous indentation level
						if (pair[1] == "true") { prefs[pair[0]] = true }
						// I promise it won't happen again.
					}
				}
			}
			return prefs
		}
	}

	static savePrefs(prefs) {
		var output = ""
		for (item in prefs.keys) {
			output = output + "%(item):%(prefs[item])\n"
		}
		FileSystem.save("preferences", output)
	}
}

