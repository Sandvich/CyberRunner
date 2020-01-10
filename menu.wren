import "dome" for Process
import "graphics" for Canvas, ImageData
import "input" for Mouse
import "./api" for Button, Fading, Scene, Sprite

class Menu is Scene {
	construct init (parent) {
		_parent = parent
		_prefs = parent.loadPrefs()
		_mouseIsDown = true

		// Set up the window and load in the files we need.
		setupDrawLoop()
		_background = Sprite.new("res/gridbg.png")
		_title = Sprite.new("res/title.png", true)
		Canvas.resize(_background.width, _background.height)
		_cursor = Sprite.new("res/arrow.png", false)

		// Load and play the background music
		if (!_prefs["mute"]) { _channelID = Fading.play("bluebeat") }

		// Needs to be done manually once, to ensure that everything is set up.
		drawMainMenu()
		draw(0)
	}

	drawMainMenu() {
		// Create the functions used for the menu
		var startPressed = Fn.new {
			Fading.stop(_channelID)
			_parent.loadScene("game")
		}
		var settingsPressed = Fn.new { drawSettingsMenu() }
		var quitPressed = Fn.new { Process.exit() }

		// Fill the button list
		_buttons = [
			Button.new("res/start_button.png", startPressed, true),
			Button.new("res/settings_button.png", settingsPressed, true),
			Button.new("res/quit_button.png", quitPressed, true)
		]

		// This function does all work needed to draw a menu
		drawMenuCommon()
	}

	drawSettingsMenu() {
		// Create the functions used for the menu
		var mutePressed = Fn.new { 
			if (Fading.isPlaying(_channelID)) {
				Fading.stopAllChannels()
				_prefs["mute"] = true
			} else {
				_channelID = Fading.play("bluebeat")
				_prefs["mute"] = false
			}
			_parent.savePrefs(_prefs)
			drawSettingsMenu()
		}

		var menuPressed = Fn.new { drawMainMenu() }

		// Fill the button list
		var mute_img
		if (_prefs["mute"]) {
			mute_img = "res/mute_active_button.png"
		} else {
			mute_img = "res/mute_button.png"
		}

		_buttons = [
			Button.new(mute_img, mutePressed, true),
			Button.new("res/back_button.png", menuPressed, true)
		]

		drawMenuCommon()
	}

	drawMenuCommon() {
		// Clear everything, and then draw the background
		clearCanvasItems()
		addCanvasItem(_background, 0, 0)
		addCanvasItem(_title, 400, 120)

		// Draw the buttons that we currently want
		var y = 300
		for (button in _buttons) {
			addCanvasItem(button, 400, y)
			button.hover = Fn.new { addTempCanvasItem(_cursor, 265, button.getSize()[0].y + 15) }
			y = y + 75
		}
	}

	mouseHandler() {
		// We use this pair of bools to ensure that a mouse click is only interpreted once
		// Kinda like using the SDL MouseEvent stuff, but not as good
		_mouseWasDown = _mouseIsDown
		_mouseIsDown = Mouse.isButtonPressed("left")

		for (item in _buttons) {
			var size = item.getSize()
			if ( (size[0].x <= Mouse.x) && (size[0].y <= Mouse.y) && (size[1].x >= Mouse.x) && (size[1].y >= Mouse.y) ) {
				item.onHover()
				if (_mouseIsDown && (!_mouseWasDown)) { item.onClick() }
			}
		}
	}

	// Boilerplate + functions
	static run(parent) {
		return init(parent)
	}
}