//
//  CollectionViewController.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/25/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "CollectionViewController.h"
#import "UkuleleDazzAppDelegate.h"
#import "DazzCollection.h"
#import "DazzItem.h"
#import "ItemCell.h"

#import "TouchXML.h"


@implementation CollectionViewController

@synthesize itemTableView;
@synthesize navigationController;
@synthesize dazzCollection;
@synthesize sortFieldSectionTitleIndexes;
@synthesize selectedIndexPath;
@synthesize respondingToShake;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    // Remove any existing selection.
    [itemTableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    // This is my own flag so we don't restart responses while one is in progress
    [self setRespondingToShake: NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        if ([self respondingToShake] == NO) {
            
            [self setRespondingToShake: YES];
            
            UkuleleDazzAppDelegate *appDelegate = (UkuleleDazzAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate goToDazzItemViewFromSearch:nil];
            
            [self setRespondingToShake: NO];
        }
    }
}

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
	// Note that this method is called before any cell rendering is done.  Therefore the currentItemIndex is not 
	// being incremented.  That means we have to access the dazzItems array using the sortFieldSectionTitleIndexes array
	
	// A section index will be the same index as the sortFieldSectionTitleIndexes index
	// That index will point to the sortField name that we will count the instances of
	NSInteger startIndex = [[sortFieldSectionTitleIndexes objectAtIndex:section] integerValue];
	NSInteger rowCount = [self countOfItemsMatchingCurrentFieldName: [dazzCollection getFirstSortField] sectionIndex: startIndex];
    return rowCount;
}	

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ItemCell *itemCell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
	if (itemCell == nil) {
		itemCell = [[[ItemCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"ItemCell"] autorelease];
        
        [itemCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
	}
	
	// Since this method is called every time the display scrolls (rather than just once in an ordered way) we will have
	// to access the dazzItems array in a random way.  That's ok, we have the technology
	NSInteger startIndex = [[sortFieldSectionTitleIndexes objectAtIndex:indexPath.section] integerValue];
	NSInteger collectionIndex = startIndex + indexPath.row;
	
	DazzItem *dazzItem = [dazzCollection dazzItemAtIndex: collectionIndex];
	
	if ( dazzItem == nil ) {
		itemCell.textLabel.text = @"request out of range";
	}
	else {
		itemCell.dazzItem = dazzItem;
	}
	
	// Set the main sort type which is the section header so that isn't repeated in the cell
	[itemCell setSortTypes: [dazzCollection getFirstSortField]
			secondSortType: [dazzCollection getSecondSortField]
			 thirdSortType: [dazzCollection getThirdSortField]];
	
    [self becomeFirstResponder];

	return itemCell;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    // Return the displayed title for the specified section.
	return [self sectionNameAtIndex:section];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ItemCell *cell = (ItemCell *)[tv cellForRowAtIndexPath:indexPath];
    [self setSelectedIndexPath:indexPath];
	
	UkuleleDazzAppDelegate *appDelegate = (UkuleleDazzAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate goToDetailView: [cell dazzItem]];
 
    // What we SHOULD be doing!
//    NSUInteger  row=[indexPath row];
//    ItemViewController *itemController=[self.controllers        objectAtIndex:row];
//    
//    [appDelegate.navigationController pushViewController:itemController animated:YES];
}

// accessoryTypeForRowWithIndexPath
- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
	ItemCell *cell = (ItemCell *)[tv cellForRowAtIndexPath:indexPath];
	
	UkuleleDazzAppDelegate *appDelegate = (UkuleleDazzAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate goToDetailView: [cell dazzItem]];
}


// This is called by the creator of this view
- (void)assignDazzCollection:(DazzCollection *)collection {
	[self setDazzCollection: collection];
	
	// These should come from user supplied sort info
	[dazzCollection setFirstSortField: ItemMaker];
	[dazzCollection setSecondSortField: ItemSize];
	[dazzCollection setThirdSortField: ItemModel];
	
	if ( [[dazzCollection dazzItems] count] < 1 ) {
		DazzItem *emptyItem = [DazzItem alloc];
		emptyItem.maker = @"";
		emptyItem.size = @"No Items Found";
		emptyItem.model = @"";
		
		[[dazzCollection dazzItems] addObject: emptyItem];
		[emptyItem release];
	}
}

- (void)updateDazzCollection:(DazzCollection *)collection {
    [self setDazzCollection:collection];
    [[self itemTableView] reloadData];
}

- (void)clearDazzCollection {
	// We want to have just one retention
	int retainCount = [dazzCollection retainCount];
	for (int i = 0; i < retainCount - 1; i++) {
		[dazzCollection release];
	}
}

- (NSString *)sectionNameAtIndex: (NSInteger) index {
	
    // Protect access into our array:
	if (index > -1 && index < sortFieldSectionTitleIndexes.count)
	{
		NSNumber *sectionIndex = [sortFieldSectionTitleIndexes objectAtIndex: index];
		
		// Convert to NSInteger:
		NSInteger anInteger = [sectionIndex integerValue];
		
		return [self itemFieldAtIndex: anInteger fieldType: [dazzCollection getFirstSortField]];
	}
	return nil;
}


// Returns the requested field name for the dazzItem at the supplied index
- (NSString *)itemFieldAtIndex: (NSInteger) index fieldType: (NSInteger)type {
	DazzItem *dazzItem = [dazzCollection dazzItemAtIndex:index];
	NSString *fieldText = nil;
	
	switch (type) {
		case ItemModel:
			fieldText = dazzItem.model;
			break;
		case ItemSize:
			fieldText = dazzItem.size;
			break;
		case ItemMaker:
			fieldText = dazzItem.maker;
			break;
		case ItemBrand:
		default:
			fieldText = dazzItem.brand;
			break;
	}
	return fieldText;
}

- (NSInteger)initSectionTitleIndexes {
	
	// This method is wrongly being called twice.  Until I can figure out why, we will have to redo this initialization:
	[dazzCollection zeroItemsIndex];
	
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
	
	for (DazzItem *dazzItem in dazzCollection.dazzItems) {
		
		switch ([dazzCollection getFirstSortField]) {
			case ItemModel:
				currentFieldText = dazzItem.model;
				break;
			case ItemSize:
				currentFieldText = dazzItem.size;
				break;
			case ItemMaker:
				currentFieldText = dazzItem.maker;
				break;
			case ItemBrand:
			default:
				currentFieldText = dazzItem.brand;
		}
		
		if ( [currentFieldText caseInsensitiveCompare: lastFieldText] != NSOrderedSame ) {
			lastFieldText = currentFieldText;
			
			number = [[NSNumber alloc] initWithInt:currentIndex];
			[self.sortFieldSectionTitleIndexes addObject:number];
			[number release];
		}
		currentIndex++;
	}
	
// 	NSLog(@"*********** Total Item Count: %d", [dazzCollection.dazzItems count]);
// 	NSLog(@"*********** Brand Count: %d", sortFieldSectionTitleIndexes.count);
	
	return sortFieldSectionTitleIndexes.count;
}


// This uses the DazzCollection pointer into the dazzItems array.  Whatever dazzItem item it is pointing at now will be
// used for the count.  So there will be at least one.  The methods will count how many consecutive dazzItems
// use that same string for the field type.
-(NSInteger)countOfItemsMatchingCurrentFieldName: (NSInteger)fieldType sectionIndex: (NSInteger)index {
	NSInteger count = 0;
	
	switch (fieldType) {
		case ItemModel:
			count = [dazzCollection countOfItemsMatchingTertiaryName:index];
			break;
		case ItemSize:
			count = [dazzCollection countOfItemsMatchingSecondaryName:index];
			break;
		case ItemMaker:
			count = [dazzCollection countOfItemsMatchingQuadernaryName:index];
			break;
		case ItemBrand:
		default:
			count = [dazzCollection countOfItemsMatchingPrimaryName:index];
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
//    NSLog(@" %s: - Begin", __FUNCTION__);
    self.navigationController = nil;	
    self.itemTableView = nil;
//    NSLog(@" %s: - End", __FUNCTION__);
}


- (void)dealloc {
//    NSLog(@" %s: - Begin", __FUNCTION__);
	[itemTableView release];
    itemTableView.delegate = nil; // Ensures subsequent delegate method calls won't crash
    self.itemTableView = nil;     // Releases if @property (retain)
    
    [navigationController release];
    navigationController = nil;

	[selectedIndexPath release];
    selectedIndexPath = nil;
    
    [super dealloc];
//    NSLog(@" %s: - End", __FUNCTION__);
}


@end
