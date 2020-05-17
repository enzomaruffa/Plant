
/*:
 
 # garden
 
 controls are simple:
 - swipe up = create a plant
 - swipe down = destroy the plant
 - drag 'n drop on an empty space = copy the plant into that space
 - drag 'n drop on another plant = mix those plant into and plants it in an empty space. if no space is available, mixing will have no results
 
 turning "isNatureOn" on will make the game play by itself
 
 **have fun!**
 
 - note: for a proper experience, use your iPad on landscape mode and, after reading this text, hide it by dragging the middle bar. we'll be using the full view :)
 */

let isNatureOn = false

//#-hidden-code
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let storyboard = UIStoryboard(name: "Main", bundle: nil)
let controller = storyboard.instantiateViewController(withIdentifier:"GameViewController")

PlaygroundPage.current.liveView = controller

//#-end-hidden-code
