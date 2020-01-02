import "audio" for AudioEngine
import "dome" for Window
import "input" for Mouse
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
        if (Mouse.isButtonPressed("left")) {
            __currentScreen.clickHandler("left", Mouse.x, Mouse.y)
        }
    }
    static draw(dt) {}
}

