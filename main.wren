import "audio" for AudioEngine
import "dome" for Window
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
        __currentScreen = Menu.run()
    }

    static update() {
        __currentScreen.mouseHandler()
        __currentScreen.keyboardHandler()
        __currentScreen.gamepadHandler()
    }
    
    static draw(dt) {
        __currentScreen.draw(dt)
    }
}

