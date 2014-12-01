#Views and Gestures
use frame and center to position a view in the hierarchy, frame is the rectangle which contains the view in its superview, bounds is the rectangle of the view in its own coordinate system, be careful of this for rotated views

Example init:
CGRect labelRect = CGRectMake(20, 20, 50, 30);
UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
label.text = @"Hello!";
[self.view addSubview:label];

If you want custom drawing, implement this in drawRect:
never call drawRect in your code, let iOS handle this, you can however indicate that you want something redrawn via setNeedsDisplay or setNeedsDisplayInRect

Implement drawRect using core graphics (CG methods) and UIBezierPath (very powerful!)

Core Graphics Concepts:
Get a context to draw into (iOS prepares one on drawRect)</br>
Create paths (from lines, arcs, etc.)</br>
Set all of the configurables (fonts, colors, etc.)</br>
Stroke or fill these paths</br>

UIBezierPath will do all the core graphics concepts for you

Context determines where your drawing goes (pdf, offscreen bitmap, screen, printer, etc)

To get the context: CGContextRef context = UIGraphicsGetCurrentContext();

Example of Bezier:
UIBezierPath *path = [[UIBezierPath alloc] init];
[path moveToPoint:CGPointMake(75, 10)];
[path addLineToPoint:CGPointMake(160, 150)];
[path addLineToPoint:CGPointMake(10, 150)];

[path closePath];

[[UIColor greenColor] setFill];
[[UIColor redColor] setStroke];
[path fill; [path stroke];

Transparency causes a performance hit, should consider it carefully.

Can hide views so that they have a space in the subviews list but will not appear on screen.

Can draw text on screen using NSAttributedString

Gestures: add UIGestureRecognizer to a view and indicate what method should handle that gesture.
