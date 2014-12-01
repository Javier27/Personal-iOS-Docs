#Protocols, Blocks and Animation
##Protocols
Protocols indicate intent, what methods we plan to call on a particular object.
```
id <MyProtocol> obj

@protocol Foo <Xyzzy, NSObject> // Xyzzy are "super protocols"

// some methods and properties
@property (readonly) int readonlyProperty;
@property NSString *readwriteProperty;

@optional

@required

@end
```

Common protocol users are delegates and data sources.
Views require these because they shouldn't know about their data source, they should simply ask for what data to display.

##Blocks
A block of code embedded in other code.
If you put __block type name then the variable is now available inside of the block. (only required for non-instance varaibles)

Blocks are not objects, however they are reference counted and can be stored in variables, properties, dictionaries and arrays. The only message they understand is copy

Example of block
```void (^doit)(void)``` is a block with a return type of void, name doit and arguments of void, you execute via ```doit();```

With blocks we need to be careful of strong pointers (self pointing to block and block pointing to self). Can easily break this cycle with a local variable.

```__weak MyClass *weakSelf = self;```

To learn more about blocks, look at the Xcode documentation

##Animation
Core Animation is very robust and important for games. You can do most animation at a high level.

Also important is sprite kit, which allows you to use 2D items to simulate a 3D env

3 Ways to animate views: frame, transform (translation, rotation, scale), alpha (opacity)

UIViewAnimationOptions are very important for getting the exact animation that you would like (fine details like how fast different parts of the animation happen)

Some options:</br>
BeginFromCurrentState</br>
AllowUserInteraction</br>
LayoutSubviews</br>
Repeat</br>
Autoreverse</br>
OverrideInheritedDuration</br>
OverrideInheritedCurve</br>
AllowAnimatedContent</br>
CurveEaseInEaseOut</br>
CurveEaseIn</br>
CurveLinear</br>

Can also use transitionWithView, read documentation to see how to use it

More complex animation can use dynamic animation which takes physics into account.

Create UIDynamicAnimator</br>
Add UIDynamicBehaviors (graity, collisions, etc.)</br>
Add UIDynamicItems (UIViews)</br>

Then it will start happening!

```
UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:aView];

UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
[animator addBehavior:gravity];

UICollisionBehavior *collider = [[UICollisionBehavior alloc] init];
[animator addBehavior:collider];
```

Then you need to add the items to the behavior
id <UIDynamicItem> item1 = ...;
[gravity addItem:item1];
[collider addItem:item1];

Behaviors: </br>
gravity (angle, magnitude //1.0 is 1000 points/s/s) </br>
collision (mode, boundries)
