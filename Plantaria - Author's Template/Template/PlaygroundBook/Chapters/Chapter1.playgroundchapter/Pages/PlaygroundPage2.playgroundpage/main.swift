//#-hidden-code
import UIKit
import PlaygroundSupport
import BookCore
//#-end-hidden-code

/*:
 
 # The Laboratoy
 
 This time, you can create your very own plant by tweaking every single parameter in it!
 
 Just edit the values and make sure to follow the minimum and maximum values, ;)
 
 Enjoy!
 
 - Note: For a better experience, use your iPad on landscape mode with both code and result view open :)
 */

/*:
 The length of each stem segment.
 
 _Changes the overall plant height_
 
 **A lower value creates a taller plant.**
 - minimum: 1
 - maximum: 2 */
var stemLengthProportion: Double = /*#-editable-code*/1.5/*#-end-editable-code*/

//: The color of the stem
var stemColor: UIColor = /*#-editable-code*/ #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1) /*#-end-editable-code*/


/*:
 The amount of stem layers a plant should have.
 
 _Changes the overall plant height_
 
 **A greater value creates a taller plant.**
 - minimum: 1
 - maximum: 6 */
var stemLayers: Int = /*#-editable-code*/ 4 /*#-end-editable-code*/

/*:
 The probability of a flower sprouting from a branch tip
 
 _Changes the stem density_
 
 **A lower value means more stems without flowers**
 - minimum: 0.1
 - maximum: 1 */
var flowerProbability: Double = /*#-editable-code*/ 0.5 /*#-end-editable-code*/

/*:
 The amount of flowers a plant has
 
 _Changes the flower count of a plant_
 
 **A greater value means more flowers**
 - minimum: 0
 - maximum: 20 */
var flowerCount: Int = /*#-editable-code*/ 5 /*#-end-editable-code*/

/*:
 The thickness of each stem segment
 
 _Changes the stem density_
 
 **A greater value means a thicker stem**
 - minimum: 0
 - maximum: 1 */
var stemWidth: Double = /*#-editable-code*/ 0.5 /*#-end-editable-code*/

/*:
 How likely the plant is to stems with greater angles
 
 _Changes the plant density_
 
 **A greater value means the plant is more likely to have greater angles**
 - minimum: 0.1
 - maximum: 1 */
var stemAngleFactor: Double = /*#-editable-code*/ 0.5 /*#-end-editable-code*/

/*:
 The flower core size
 
 _Changes the flower core size_
 
 **A greater value means the flower center will be bigger**
 - minimum: 0
 - maximum: 1 */
var flowerCoreRadius: Double = /*#-editable-code*/ 0.5 /*#-end-editable-code*/

//: The color that the flower core has
var flowerCoreColor: UIColor = /*#-editable-code*/ #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) /*#-end-editable-code*/

/*:
 The flower core border width size
 
 _Changes the flower core border size_
 
 **A greater value means the flower border will be bigger**
 - minimum: 1
 - maximum: 2 */
var flowerCoreStrokeWidth: Double = /*#-editable-code*/ 1.5 /*#-end-editable-code*/

//: The color that the flower core border has
var flowerCoreStrokeColor: UIColor = /*#-editable-code*/ #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) /*#-end-editable-code*/

/*:
 The flower's petal layers count
 
 _Changes the flower size and number of petals_
 
 **A greater value means the flower center will be bigger**
 - minimum: 1
 - maximum: 7 */
var flowerLayersCount: Int = /*#-editable-code*/ 4 /*#-end-editable-code*/

/*:
 The flower's petal height
 
 _Changes how "tall" each petal is_
 
 **A greater value means each petal will be taller**
 - minimum: 0.01
 - maximum: 0.8 */
var petalRadius: Double = /*#-editable-code*/ 0.4 /*#-end-editable-code*/

/*:
 The amount of petals in the flower's first petal layer
 
 _Changes how dense the flower is_
 
 **A greater value means the first layer will have more petals**
 - minimum: 2
 - maximum: 20 */
var petalsInFirstLayer: Int = /*#-editable-code*/ 4 /*#-end-editable-code*/

/*:
 The amount of petals in the flower's last petal layer
 
 _Changes how dense the flower is_
 
 **A greater value means the last layer will have more petals**
 - minimum: 4
 - maximum: 20 */
var petalsInLastLayer: Int = /*#-editable-code*/ 8 /*#-end-editable-code*/

/*:
 The width of each flower's petals
 
 _Changes how large each petal is and how dense the flower is_
 
 **A greater value means the petal will be larger**
 - minimum: 0
 - maximum: 5 */
var petalWidth: Double = /*#-editable-code*/ 1 /*#-end-editable-code*/

//: The color that the first petal layer has
var petalsFirstLayerColor: UIColor = /*#-editable-code*/ #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) /*#-end-editable-code*/

//: The color that the last petal layer has
var petalsLastLayerColor: UIColor = /*#-editable-code*/ #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) /*#-end-editable-code*/

//: The color of the petals border
var petalStrokeColor: UIColor = /*#-editable-code*/ #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1) /*#-end-editable-code*/

//#-hidden-code
PlaygroundPage.current.needsIndefiniteExecution = true

let storyboard = UIStoryboard(name: "SingleGame", bundle: nil)
let controller = storyboard.instantiateViewController(withIdentifier:"SingleGameViewController") as! SingleGameViewController

let plant = Plant(stemLengthProportion: stemLengthProportion,
        stemColor: stemColor,
        averageStemLayers: stemLayers,
        flowerProbability: flowerProbability,
        flowerCount: flowerCount,
        stemWidth: stemWidth,
        stemAngleFactor: stemAngleFactor,
        flowerCoreRadius: flowerCoreRadius,
        flowerCoreColor: flowerCoreColor,
        flowerCoreStrokeWidth: flowerCoreStrokeWidth,
        flowerCoreStrokeColor: flowerCoreStrokeColor,
        flowerLayersCount: flowerLayersCount,
        petalRadius: petalRadius,
        petalsInFirstLayer: petalsInFirstLayer,
        petalsInLastLayer: petalsInLastLayer,
        petalsFirstLayerColor: petalsFirstLayerColor,
        petalsLastLayerColor: petalsLastLayerColor,
        petalStrokeColor: petalStrokeColor,
        petalWidth: petalWidth
        )

controller.plant = plant

PlaygroundPage.current.liveView = controller
//#-end-hidden-code
