An activity is an instace of Activity, a class in the Android SDK. An activity is resopnsbile for managing user interaction with a screen of information.
Subclasses of Activity are used to impolement the functionality that your app requires.

A layout defines a set of user interface objects and their position. It is made up of XML files. 

Widgets are the building blocks used to compose a user interface, they include text views, graphics, interactions with the user, arrangements of other widgets on screen.

For almost every widget we need to set layout_width and layout_height, often they will be set as
```
layout_*="match_parent" // view will be as big as its parent
layout_*="wrap_content" // view will be as big as its content
```

We can also set padding with ```android:padding="24dp"``` where dp is density-independent pixels.
Set the LinearLayout to be horizontal or vertical via ```android:orientation="horizontal"```
