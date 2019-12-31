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
        // Window.resize() <- we'll see

        // Open the menu
        Menu.run()
    }
    static update() {}
    static draw(dt) {}
}

