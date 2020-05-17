/*:
 
 # The Garden
 
 Create, mix and enjoy plants!
 
 Controls:
 
 - Creating a plant: Swipe up
 - Removing a plant: Swipe down
 - Copying a plant: Drag 'n drop the plant into **an empty space**
 - **Mixing two plants**: Drag 'n drop the plant into another plant. The result will grown in an empty space. **If no space available, mixing will have no results**
 
 Changing "nature" to "true" will make the game play by itself
 
 **Have fun!**
 
 - Note: For a better experience, use your iPad on landscape mode and, after reading this text, hide it by dragging the middle bar. We'll be using the full view :)
 */

let nature = /*#-editable-code*/ false /*#-end-editable-code*/

//#-hidden-code
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let storyboard = UIStoryboard(name: "Main", bundle: nil)
let controller = storyboard.instantiateViewController(withIdentifier:"GameViewController") as! GameViewController
controller.natureOn = nature

PlaygroundPage.current.liveView = controller
//#-end-hidden-code
