#Rest Kit Basics
##Adding Rest Kit
You will need to begin by installing cocoapods and then adding the pod for rest kit. This is easy and can be executed using these commands:
'''
$ sudo gem install cocoapods
$ pod setup
$ cd path/to/your/project
$ touch Podfile
'''

Then you'll need to modify your podfile by adding
'''
platform :ios, ‘VERSION’
pod ‘RestKit’, ‘~> VERSION’
'''

Finally go ahead and run pod install to install the pod:
'''
$ pod install
'''

##Basic Ideas of Rest Kit
Rest Kit enables you to easily map the payload from (ideally) RESTful API's into iOS class objects. Let's go ahead and assume that we're hitting some API endpoint and the base url is '''https://api.example.com'''
and that we are hitting variations of the endpoint such as
'''https://api.example.com/users and https://api.example.com/products'''
and that after hitting this endpoint (specifically '''https://api.example.com/users''') we get back the following JSON payload:
'''
{
“meta”: {
“code”: 200
},
“response”: {
“users”: [
{
“name”: “Lancelot”,
“location”: {
“country”: “USA”,
“state”: “OH”,
“city”: “Cincinnati”
},
“dimensions” {
“height”: 182,
“weight”: 160
}
},
{
“name”: “Spence”,
“location”: {
“country”: “USA”,
“state”: “PA”,
“city”: “Pittsburgh”
},
“dimensions” {
“height”: 160,
“weight”: 150
}
}
]
}
}
'''
Now that we have the payload we want, we need to store that payload into the relevant model classes. Rest Kit will enable us to take the different objects described by the payload and map their attributes and sub objects directly into iOS classes such as a user class with attributes including dimensions, name, etc.

##Using Rest Kit to Map
The first step is to set up objects for everything in the payload. We would need to make .h files for each meaning we'd has User.h, Location.h and Dimensions.h; each would have interfaces as below:
'''
@interface User : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) Dimensions *dimensions;
@end

@interface Location : NSObject
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *city;
@end

@interface Dimensions : NSObject
@property (strong, nonatomic) NSNumber *height;
@property (strong, nonatomic) NSNumber *weight;
@end
'''

Now it’s time to start with RestKit, we need to configure it at some point. We need to initialize the AFNetworking HTTPClient, the RestKit, setup our object mappings and register the mappings with our provider (the api) using a response descriptor.

Some things that we should note: we should only perform the initialization once (one HTTPClient and RKObjectManager in a given app), this can be done easily if you have a view controller that will only be loaded once (viewDidLoad) or if necessary by using a dispatch_once block. Both examples are shown below

###Using instance type with dispatch_once_t to insure there is only one shared instance (my personal preference)
'''
+ (instancetype)objectManager;
{
    static RKObjectManager *instance;
    static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
NSURL *baseURL = [NSURL URLWithString:@"https://api.example.com"];
AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
instance = [[RKObjectManager alloc] initWithHTTPClient:client];
   });
   return instance;
}
'''

###Unique initialization in viewDidLoad
NSURL *baseURL = [NSURL URLWithString:@"https://api.example.com"];
AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];

###Setting up the object mappings
All of this setup should be fairly straightforward, just reference the payload and interfaces for clarity.
'''
RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
[userMapping addAttributeMappingsFromArray:@[@"name"]];

RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
[locationMapping addAttributeMappingsFromArray:@[@"country", @"state", @"city"]];

RKObjectMapping *dimensionsMapping = [RKObjectMapping mappingForClass:[Dimensions class]];
[dimensionsMapping addAttributeMappingsFromArray:@[@"height", @"weight"]];
'''

Once the mappings are setup, we need to connect the location and dimension mappings to the user.
'''
[userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];

[userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dimensions" toKeyPath:@"dimensions" withMapping:dimensionsMapping]];
'''

A quick note, if we wanted to pull in the attributes from location but we wanted to (for example’s sake) set the property name for state on our model to be province, then we would need the following instead
'''
RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass[Location class]];
[locationMapping addAttributeMappingsFromDictionary:@{@"country": @"country", @"state": @"province", @"city": @"city"}];
'''

###Making the request and getting our final result
Now that we have this setup we need to make the actual request. Consider our request has the query params of planet and nothing else, then we would make the following method
'''
- (void)getUsers
{
NSDictionary *queryParams = @{@”planet”: “earth”};
[[RKObjectManager sharedManager] getObjectsAtPath:@”/users” parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) { /* here is where you would put whatever code you want executed after the call is cpt, note that mappingResult.array will have the user objects returned */} failure:^(RKObjectRequestOperation *operation, NSError *error) { /* this is where you put whatever you want to handle the error, for example NSLog(@”booo %@”, error);}];
}
'''

And that's it! Pretty great, just hope this get's maintained with the updates to AFNetworking, etc.
