#Introduction to Swift
##Some of the basics
####Printing
Should note that no main or entrace is required, the following is a complete program in Swift
```println("hellow, world")```

##Variable Declaration
to declare a mutable variable
```var languageName: String = “Swift”```

to make a constant
```let languageName: String = “Swift”```

more examples
```
var version: Double = 1.0
var introduced: Int = 2014
var isAwesome: Bool = true
```

Swift uses type inference so this will also work
```let languageName = “Swift”```

Swift provides more flexibility, any unicode character can be used for variable names (even emojis)

You can set values without initializing the variables, for example
```urlRequest.HTTPMethod = "POST"```

We can also call methods directly on objects
```
// ["~", "Documents", "Fun"]
let components = “~/Documents/Fun”.pathComponents
```

All NSString API capabilities are available with swift strings
```
for character in “mouse” {
println(character)
}
```

Appending is available with (+)
```"Hello" + " " + "Goodbye"```

Inputting values into strings
```
let a=3, b=5
let mathResult = “\(a) times \(b) is \(a * b)”
```
+= works for strings now too!
```
var variableString = “Horse”
variableString += ” and carriage”
```

##Dictionaries, Arrays, Loops
```
var names = ["anna", "alex", "brian", "jack"]
var numLegs = ["ant": 6, "snake": 0, "cheetah": 4]
```

arrays and dictionaries can work with any values (ints, objects, etc.)

typed collections can be specified (for compiling purposes)
if we initialize with only strings, this type will also be inferred
```
var names: String[] = [....]
```

Here's some loop examples
```
while !sated {
	eatCake()
}
```

```
for var doctor = 1; doctor <= 13; ++doctor {
	exterminate(doctor)
}
```

```
for character in “hello” {
	println(“hehe”)
}
```

```
// will do 1, 2, 3, 4, 5
// 1..5 will do 1, 2, 3, 4
for number in 1...5 {
	println(“\(number)”)
}
```

```
// with dictionary
for (animalName, legCount) in numberOfLegs {
	println(“\(animalName)s have \(legCount) legs”)
}
```

Some more examples
```
var shoppingList = ["Eggs", "Milk"]
shoppingList[0]
shoppingList += “Flour”
shoppingList[0] = “Six Eggs”
shoppingList[3...5] = [ new elements ]
```

```
var numberOfLegs = ["any": 6, "snake": 0, "cheetah": 4]
numberOfLegs["spider"] = 273
numberOfLegs["spider"] = 8
// optional (the ?) indicates this can take on empty (or nil) values
let possibleLegCount: Int? = numberOfLegs["aardvark"]
if possibleLegCount == nil {
	println(“Aardvark wasn’t found”)
} else {
	let legCount: Int = possibleLegCount! // gets just the value out
	println(“An aardvark has \(legCount) legs”)
}
```

Bundling the work into a single step
```
if let legCount = possibleLegCount {
	println(“An aardvark has \(legCount) legs”)
}
```

Swift doesn't require parenthesis
```
if legCount == 0 {
	// do something
} else if legCount == 1 {
	// do something else if
} else {
	// do something else
}
```

##Switches, Functions, Tuples
In swift, can match on anything, not just ints, even objects
```
switch legCount {
	case 0:
		println(“It slithers and slides around”)
	case 1:
		println(“It hops”)
	default:
		println(“It walks”)
}
```

```
switch legCount {
	case 1...4:
		println(“some stuff”)
	case 5, 6, 7:
		println(“some other stuff”)
	default:
		println(“must be exhaustive in swift”)
}
```


creating a function with a default param value of world
```
func sayHello(name: String = “World”) -> String {
	return “Hello! \(name)”
}
```

```
let greeting = sayHello()
```

Tuples can have any combination of types
```
(1, “hello”, 1.0)
```

An example of a function returning tuples
```
func refreshWebPage() -> (code: Int, message: String) {
	return (200, “Success”)
}

// first way is to unpack with a tuple
let (statusCode, message) = refreshWebPage()

// second way is to unback with a variable
let status = refreshWebPage() 
let code = status.code
let message = status.message
```

##Closures
Closures are blocks of code
```
let greetingPrinter: () -> () = {
	println(“Hello World!”)
}
```

You can call it like a function
```
greetingPrinter()
```

Here is an example of a closure being called repeatedly
```
func repeat(count: Int, task: () -> ()) {
	for i in 0..count {
		task()
	}
}
```

Can call a closure repeatedly using either of the following
```
repeat(2, {
	println(“Hello!”)
})

repeat(2) {
	println(“Hello!”)
}
```

##Defining Classes
Swift doesn't use header files or a base class but can still inherit from other classes (even Objective C classes like NSObject)
```
class Vehicle {
	var numberOfWheels = 0 // var so subclasses can change, stored property

	var description: String { // readonly property, can also lose the get and just have a return statement
		get {
			return “\(numberOfWheels) wheels”
		}
	}
}
```

Once you have your class definition, here is how you'd use it
```
let someVehicle = Vehicle()
```
This will have a default of 0 wheels, but you can change this
```
someVehicle.numberOfWheels = 2
println(someVehicle.numberOfWheels) // will print 2
```

Overriding a property
```
class Bicycle : Vehicle {
	init() {
		super.init()
		numberOfWheels = 2
	}
}

let myBicycle = Bicycle()
```

Overriding a function
```
class Car: Vehicle {
	var speed = 0.0

	init() {
		super.init()
		numberOfWheels = 4
	}

	override var description: String {
		return super.description + “, \(speed) mph”
	}
}
```

Overriding property observers
```
class ParentsCar: Car {
	override var speed: Double {
		willSet { // called just before property is set
			if newValue > 65.0 {
				println(“Careful now.”)
			}
		}

		didSet { // called just after property is set
			// can use oldValue just like newValue above
		}
	}
}
```

This is how you create methods
```
class Counter {
	var count = 0

	func incrementBy(amount: Int) {
		count += amount
	}

	func resetToCount(count: Int) {
		self.count = count
	}
}
```

##Structures
Define a structure using keyword struct
```
struct Point {
	var x, y: Double
}

var point = Point(x: 0.0, y: 0.0)
```

Structs can have properties that depend on other properties
```
struct Rect {
	var origin: Point
	var size: Size

	var area: Double {
		return size.width * size.height
	}
}
```

Classes and structures are very different
Structures cannot inherit from other structures
Structures are passed by value while objects are passed by reference

If we store a window object in the variable window using let, we can still change the properties of the window object, but we cannot change the reference in the variable.
```
let window = Window(frame: frame)
window = Window(frame: newFrame) // this will fail ...
```
With the struct, it's passed by value so all values become immutable
```
var point1 = Point(x: 0.0, y: 0.0) // values are mutable
let point2 = point1 // values are immutable
```
If you want your struct to have the ability to change its values, you should declare it with mutating so that errors are output as expected
```
struct Point {
	var x, y: Double

	mutating func moveToTheRightBy(dx: Double) {
		x += dx
	}
}
```

##Enums
Here is a simple enum example, the values take on 1, 2, 3, etc. as you'd expect
```
enum Planet: Int {
	case Mercury = 1, Venus, Earth, Mart, Jupiter, Saturn, Uranus, Neptune
}

// will equal 3
let earthNumber = Planet.Earth.toRaw()
```

```
enum ControlCharacter: Character {
	case Tab = “\t”
	case Linefeed = “\n”
	case CarriageReturn = “\r”
}
```

Sometimes you want the cases to be values unto themselves
```
enum CompassPoint {
	case North, South, East, West
}

var directionToHead = CompassPoint.West
directionToHead = .East // or CompassPoint.East is equivalent for clarity
```

As a useful example of enums, here's one for text alignment
```
let label = UILabel()
label.textAlignment = .Right
```

Swift allows enumeration with associated values, a property of sorts can be associated with a given enum case
```
enum TrainStatus {
	case OnTime
	case Delayed(Int)
}

var status = TrainStatus.OnTime
// when gets delayed
status = .Delayed(42)
```


To expand on this concept we can look at this case
```
enum TrainStatus {
	case OnTime, Delayed(Int)

	init() {
		self = OnTime
	}

	var description: String {
		switch self {
			case OnTime:
				return “on time”
			case Delayed(let minutes):
				return “delayed by \(minutes) minute(s)”
		}
	}
}
```

We can also next types in a class
```
class Train {
	enum Status {
		...
	}
}
```

##Extensions
```
extension CGSize {
	mutating func increaseByFactor(factor: Int) {
		width *= factor
		length *= factor
	}
}
```

```
extension Int {
	func repetitions(task: () -> ()) {
		for i in 0..self {
			task()
		}
	}
}
```

And now we are able to do
```
500.repetitions {
	println(“Hello!”)
}
```

##Generics
Swift provides the use of generics, a powerful tool in creating data structures and much much more, as an example
```
struct Stack<T> {
	var elements = T[]()

	mutating func push(element: T) {
		elements.append(element)
	}

	mutating func pop() -> T {
		return elements.removeLast()
	}
}

var intStack = Stack<Int>()
intStack.push(50)
let lastIn = intStack.pop()
```

##Additional Resources
Using Swift with Cocoa & Objective-C

Swift Books

Intermediate Swift

Advanced Swift

Integrating Swift with Objective-C

Swift Interoperability in Depth
