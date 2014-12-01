#Multithreading, Scrolling, Table View
##Multithreading
All about queues, blocks put on queue and pulled off queue to be allowed to run.

iOS primarily uses serial queues, specifically the main queue

Main queue is important because we never want to block it and we use it for synchronization for all the UI methods. Blocks are pulled off of main queue when it is "quiet" meaning current events have been processed

You can create you own queues

###Executing a block on queues
dispatch_queue_t queue = ...;
dispatch_async(queue, ^{});

to get the main queue:
```
dispatch_queue_t mainQ = dispatch_get_main_queue();
NSOperationQueue *mainQ = [NSOperatinoQueue mainQueue];

dispatch_queue_t otherQ = dispatch_queue_create("name", NULL); // not this is a const char * and not an NSString
// NULL means this is a serial queue
```

easy mode, invoking a method on the main queue
```
- (void)performSelectorOnMainThread...
```


####Example
```
NSURLRequest *request = ...
NSURLConfiguration ...
NSURLSession ...
NSURLSessionDownloadTask ...
task = [session downloadTaskWithRequest:request completionHandler...];
[task resume];
```
The session determines what queue our task is completed on.

##UIScrollView
Need to set content size or use visual format strings to stretch the scroll view.

Can put any kinds of views into the scroll view.

Content offset gives the position in whatever you are scrolling (upper left)

Scroll view bounds gives bounds in superview, can use ```[scrollView convertRect:scrollView.bounds toView:subview]``` to get the bounds in the subview

Can scroll to a position in scroll view using scrollRectToVisible, flashScrollIndicators to indicate where you are in the scrolling

###Zooming
To zoom must set the minimum and maximum zoom scale

In order to have zooming, must implement delegate method viewForZomingInScrollView
