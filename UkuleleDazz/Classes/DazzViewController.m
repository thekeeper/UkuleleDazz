//
//  DazzViewController.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/25/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "DazzViewController.h"
#import "UkuleleDazzAppDelegate.h"
#import "CollectionCell.h"
#import "Dazz.h"

@implementation DazzViewController

@synthesize collectionTableView;
@synthesize navigationController;
@synthesize dazz;
@synthesize selectedIndexPath;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ( (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) ) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    // Remove any existing selection.
    [collectionTableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[dazz dazzCollections] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CollectionCell *collectionCell = (CollectionCell *)[tableView dequeueReusableCellWithIdentifier:@"CollectionCell"];
	if (collectionCell == nil) {
		collectionCell = [[[CollectionCell alloc] initWithStyle: UITableViewStylePlain reuseIdentifier: @"CollectionCell"] autorelease];
//		UIButton* accessoryButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
		collectionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//		collectionCell.accessoryView = accessoryButton;
	}
	
	// Since this method is called every time the display scrolls (rather than just once in an ordered way) we will have
	// to access the dazzCollections array in a random way.
	NSInteger startIndex = [[sortFieldSectionTitleIndexes objectAtIndex:indexPath.section] integerValue];
	NSInteger collectionIndex = startIndex + indexPath.row;
	
	DazzCollection *dazzCollection = (DazzCollection *)[[dazz dazzCollections] objectAtIndex:collectionIndex];
	
	if ( dazzCollection == nil ) {
		collectionCell.textLabel.text = @"request out of range";
	}
	else {
		collectionCell.dazzCollection = dazzCollection;
	}
	
	// Set the main sort type which is the section header, so that isn't repeated in the cell
	//	[collectionCell setSortTypes: //[dazzCollection getFirstSortField]
	//		          secondSortType: //[dazzCollection getSecondSortField]
	//		           thirdSortType: //[dazzCollection getThirdSortField]];
	
	return collectionCell; //[collectionCell retain];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     ItemViewController *itemViewController = [[ItemViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:itemViewController animated:YES];
     [itemViewController release];
     */
    
    [self setSelectedIndexPath:indexPath];

	CollectionCell *cell = (CollectionCell *)[tv cellForRowAtIndexPath:indexPath];
	
	UkuleleDazzAppDelegate *appDelegate = (UkuleleDazzAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate goToCollectionView: [cell dazzCollection]];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.collectionTableView = nil;
    self.navigationController = nil;
}

- (void)dealloc {
    [collectionTableView release];
    collectionTableView.delegate = nil; // Ensures subsequent delegate method calls won't crash
    collectionTableView = nil;     // Releases if @property (retain)

    [navigationController release];   
    navigationController = nil;
    
    [dazz release];
    dazz = nil;
    
	[selectedIndexPath release];
    selectedIndexPath = nil;

    [super dealloc];
}


@end
