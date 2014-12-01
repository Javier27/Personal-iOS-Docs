#Polymorphism in iOS and Multiple MVC's
##Writing an abstract class in obj-c 
No such thing, so simply write the methods that the subclass should implement and document in the methods (and make public)

In the header file, document that it's abstract and specify what methods the subclass should implement

In the implementation file, have the methods simply return nil or something to that effect

##UINavigationController
Push controller onto the stack that provides a finer level of detail, maintains the previous controllers on the stack that are available via the back button.

Simple example is calendar: provides year -> month -> day

UINavigationController components: </br>
Navbar: title, navigationItem.rightBarButtonItems, back button which is automatic </br>
The embedded MVC can specify toolbarItems (as well as rightBarButtonItems) to be at the bottom

When we go back in a navigation controller stack the controller we were on gets deallocated

##UITabBarController
Navigation controller can be put into a tab bar controller, but a tab bar controller cannot be in a navigation controller, typically the tab bar controller is the base controller for a project


