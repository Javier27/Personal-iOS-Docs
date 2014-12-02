#Key Value Observing
KVO is a mechanism by which you observe changes to keys and their values bound to an object.
It allows you to make objects aware of changes made to values in other objects that are important to you.
When the values are changed (in any way) ```observeValueForKeyPath:ofObject:change:context``` is invoked on the listener.

A simple example of this implemented:
```
 - (id)initWithFrame:(CGRect)frame { 
    self = [super initWithFrame:frame];
    if (self) { 
        [self addObserver:self
               forKeyPath:@"color"
                  options:0
                  context:nil];
    }
}
 
 - (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    if ([keyPath isEqualToString:@"color"]) {
        mTitleLabel.textColor = self.color;
        mDescriptionLabel.textColor = self.color;
        [mButton setTitleColor:self.color
                      forState:UIControlStateNormal];
    }
 
    else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
```

Note that the above has a bug as it doesn't remove itself as an observer on dealloc.

Often it's nice to have an array of key paths. Consider this example
```
- (id)initWithFrame:(CGRect)frame {
     if (ObservableKeys == nil) {
        ObservableKeys = [[NSSet alloc] initWithObjects:
                          @"titleLabel.font",
                          @"descriptionLabel.font",
                          // ...
                          nil];
    }
 
    self = [super initWithFrame:frame];
    if (self) {
         for (NSString *keyPath in ObservableKeys)
            [self addObserver:self
                   forKeyPath:keyPath
                      options:0
                      context:nil];
    }
}
 
 - (void)dealloc {
    for (NSString *keyPath in ObservableKeys)
        [self removeObserver:self
                  forKeyPath:keyPath];
    [super dealloc];
}
 
  - (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    if ([ObservableKeys containsObject:keyPath]) {
        [self redrawView];
    }
 
    else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
```

This illustrates the value of KVO, instead of having to implement a whole bunch of custom getters and setters we can use this for any property we are interested in.


