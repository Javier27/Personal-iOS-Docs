#Core Data
Core data allows you to create a map between objects and a database

Core data works by creating a map between objects and a database

Create a data model file:</br>
Entities (objects or tables), Attributes (columns or properties on objects), Relationships (pointers to other objects in database), Fetched Properties (calculated pointer)

Setup your relationships and your delete rules for all core data objects

Once we've setup all of our data formats, to access we use NSManagedObjectContext

Create a UIManagedDocument and ask for its managedObjectContext

UIManagedDocument (container for core data database) inherits from UIDocument (management of storage)

##Creating a UIManagedDocument
```
NSFileManager *fileManager = [NSFileManager defaultManager];
NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];

NSString *documentName = @"MyDocument";
NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];

UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
```

To open or create a UIManagedDocument we need to check if it exists:
```BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];```

If it does then we open, using
```[document openWithCompletionHandler:^....];```

Otherwise we need to create it
```[document saveToURL ......];```

##Core Data with Table Views
NSFetchedResultsController connects NSFetchRequest to a UITableViewController and the table view controller then uses this for data source. 

```return [[self.fetchedResultsController sections] count];```

Can tell you what in your database is being shown (objectAtIndexPath)

###Example Creation
```
NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityname:@"Photo"];
request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ...]];
request.predicate = [NSPredicate predicateWithFormat:@"whoTook.name = %@", photogName];

NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
	initWithFetchRequest:(NSFetchRequest *)request
	managedObjectContext:(NSManagedObjectContext *)context
	  sectionNameKeyPath:(NSString *)keyThatSaysWhichSectionEachManagedObjectIsIn
	  		   cacheName:@"MyPhotoCache"]; // careful! on disk and request needs to stay the same
```

Note that the section headers must be in the same order as the rows. Typically first sortDescriptor will be section key header.

Controller has delegate which watches changes to core data and updates table appropriately

##Creating Schema
Once you create core data class with correct entities and relationships, generate subclasses of managed object for the entities.

Use category to add code to a class without subclassing it
