//
//  EbayItemViewController.m
//  UkuZoo
//
//  Created by Terry Tucker on 1/5/10.
//  Copyright 2010 Hot! Digity Dog Software. All rights reserved.
//

#import "EbayItemViewController.h"
#import "UkuZooAppDelegate.h"
#import "ZooCollection.h"
#import "EbayItem.h"
#import "EbayItemCell.h"

#import "TouchXML.h"

@implementation EbayItemViewController

@synthesize itemTableView;
@synthesize navigationController;
@synthesize zooCollection;
@synthesize sortFieldSectionTitleIndexes;
@synthesize selectedIndexPath;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ( (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) ) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.itemTableView reloadData];
	[super viewWillAppear:animated];
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
	
	NSInteger count = [self initSectionTitleIndexes];
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Note that this method is called before any cell rendering is done.  Therefore the currentUkulelesIndex is not 
	// being incremented.  That means we have to access the zooItems array using the sortFieldSectionTitleIndexes array
	
	// A section index will be the same index as the sortFieldSectionTitleIndexes index
	// That index will point to the sortField name that we will count the instances of
	NSInteger startIndex = [[sortFieldSectionTitleIndexes objectAtIndex:section] integerValue];
	NSInteger rowCount = [self countOfItemsMatchingCurrentFieldName: [zooCollection getFirstSortField] sectionIndex: startIndex];
    return rowCount;
}	

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	EbayItemCell *itemCell = (EbayItemCell *)[tableView dequeueReusableCellWithIdentifier:@"EbayItemCell"];
//	if (itemCell == nil) {
//		itemCell = [[[EbayItemCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"EbayItemCell"] autorelease];
//		
//		UIButton* accessoryButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
//		itemCell.editingAccessoryType = UITableViewCellAccessoryNone;
//		itemCell.accessoryView = accessoryButton;
//	}
//	
//	// Since this method is called every time the display scrolls (rather than just once in an ordered way) we will have
//	// to access the zooItems array in a random way.  That's ok, we have the technology :-)
//	// ZooItem *zooItem = (ZooItem *)[zooCollection getNextUkulele];
//	NSInteger startIndex = [[sortFieldSectionTitleIndexes objectAtIndex:indexPath.section] integerValue];
//	NSInteger collectionIndex = startIndex + indexPath.row;
//	
//	EbayItem *ebayItem = [zooCollection ebayItemAtIndex: collectionIndex];
//	
//	if ( ebayItem == nil ) {
//		itemCell.textLabel.text = @"request out of range";
//	}
//	else {
//		itemCell.ebayItem = ebayItem;
//	}
//	
//	// Set the main sort type which is the section header so that isn't repeated in the cell
//	[itemCell setSortTypes: [zooCollection getFirstSortField]
//			secondSortType: [zooCollection getSecondSortField]
//			 thirdSortType: [zooCollection getThirdSortField]];
	
	return itemCell;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    // Return the displayed title for the specified section.
	return [self sectionNameAtIndex:section];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	EbayItemCell *cell = (EbayItemCell *)[tv cellForRowAtIndexPath:indexPath];
    
    // Send user to ebay on Safari page with appId so we can collect a ton of affiliate money
	
//	UkuZooAppDelegate *appDelegate = (UkuZooAppDelegate *)[[UIApplication sharedApplication] delegate];
//	[appDelegate goToEbayDetailView: [cell ebayItem]];
}


// This is called by the creator of this view
- (void)assignZooCollection:(ZooCollection *)collection {
	[self setZooCollection: collection];
	
	// These should come from user supplied sort info
	[zooCollection setFirstSortField: ItemMaker];
	[zooCollection setSecondSortField: ItemSize];
	[zooCollection setThirdSortField: ItemModel];
	
	if ( [[zooCollection zooItems] count] < 1 ) {
//		EbayItem *emptyItem = [EbayItem alloc];
//		emptyItem.maker = @"";
//		emptyItem.size = @"No Items Found";
//		emptyItem.model = @"";
//		
//		[[zooCollection zooItems] addObject: emptyItem];
//		[emptyItem release];
	}
}

- (void)clearZooCollection {
	// We want to have just one retention
	int retainCount = [zooCollection retainCount];
	for (int i = 0; i < retainCount - 1; i++) {
		[zooCollection release];
	}
}

- (NSString *)sectionNameAtIndex: (NSInteger) index {
	
    // Protect access into our array:
	if (index > -1 && index < sortFieldSectionTitleIndexes.count)
	{
		NSNumber *sectionIndex = [sortFieldSectionTitleIndexes objectAtIndex: index];
		
		// Convert to NSInteger:
		NSInteger anInteger = [sectionIndex integerValue];
		
		return [self itemFieldAtIndex: anInteger fieldType: [zooCollection getFirstSortField]];
	}
	return nil;
}


// Returns the requested field name for the zooItem at the supplied index
- (NSString *)itemFieldAtIndex: (NSInteger) index fieldType: (NSInteger)type {
	NSString *fieldText = nil;
//	EbayItem *ebayItem = [zooCollection ebayItemAtIndex:index];
//	
//	switch (type) {
//		case ItemModel:
//			fieldText = ebayItem.model;
//			break;
//		case ItemSize:
//			fieldText = ebayItem.size;
//			break;
//		case ItemMaker:
//			fieldText = ebayItem.maker;
//			break;
//		case ItemBrand:
//		default:
//			fieldText = ebayItem.brand;
//			break;
//	}
	return fieldText;
}

- (NSInteger)initSectionTitleIndexes {
	
	// This method is wrongly being called twice.  Until I can figure out why, we will have to redo this initialization:
	[zooCollection zeroItemsIndex];
	
	NSString *lastFieldText = @"";	
	NSString *currentFieldText = @"";	
	
	// Initialize the sort info for the view ordering, be sure we are working with an empty array
	[sortFieldSectionTitleIndexes release];
	sortFieldSectionTitleIndexes = nil;
	NSMutableArray *sortArray = [[NSMutableArray alloc] init];
	self.sortFieldSectionTitleIndexes = sortArray;
	[sortArray release];
	
	// There's probably some way I could get the index via the enumerator, but I don't know how
	int currentIndex = 0;
	NSNumber *number;
	
	for (EbayItem *ebayItem in zooCollection.ebayItems) {
		
//		switch ([zooCollection getFirstSortField]) {
//			case ItemModel:
//				currentFieldText = ebayItem.model;
//				break;
//			case ItemSize:
//				currentFieldText = ebayItem.size;
//				break;
//			case ItemMaker:
//				currentFieldText = ebayItem.maker;
//				break;
//			case ItemBrand:
//			default:
//				currentFieldText = ebayItem.brand;
//				break;
//				
//		}
		
		if ( [currentFieldText caseInsensitiveCompare: lastFieldText] != NSOrderedSame ) {
			lastFieldText = currentFieldText;
			
			number = [[NSNumber alloc] initWithInt:currentIndex];
			[self.sortFieldSectionTitleIndexes addObject:number];
			[number release];
		}
		currentIndex++;
	}
	
 	NSLog(@"*********** Total Item Count: %d", [zooCollection.ebayItems count]);
 	NSLog(@"*********** Maker Count: %d", sortFieldSectionTitleIndexes.count);
	
	return sortFieldSectionTitleIndexes.count;
}


// This uses the ZooCollection pointer into the ebayItems array.  Whatever ebayItem item it is pointing at now will be
// used for the count.  So there will be at least one.  The methods will count how many consecutive ebayItems
// use that same string for the field type.
-(NSInteger)countOfItemsMatchingCurrentFieldName: (NSInteger)fieldType sectionIndex: (NSInteger)index {
	NSInteger count = 0;
	
	switch (fieldType) {
		case ItemModel:
			count = [zooCollection countOfItemsMatchingTertiaryName:index];
			break;
		case ItemSize:
			count = [zooCollection countOfItemsMatchingSecondaryName:index];
			break;
		case ItemMaker:
		default:
			count = [zooCollection countOfItemsMatchingQuadernaryName:index];
			break;
	}
	return count;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
