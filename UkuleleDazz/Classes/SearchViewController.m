//
//  SearchViewController.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/30/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "SearchViewController.h"
#import "SharedTypes.h"
#import "UkuleleDazzAppDelegate.h"
#import "DazzItem.h"
#import "DazzCollection.h"
#import "SearchFieldCell.h"


@implementation SearchViewController

@synthesize navigationController;
@synthesize dazzCollection;
@synthesize masterType;
@synthesize masterValue;
@synthesize primaryItem;
@synthesize secondaryItem;
@synthesize tertiaryItem;
@synthesize quadernaryItem;
@synthesize searchSelection;
@synthesize propertiesControl;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
}

//- (void)viewWillAppear:(BOOL)animated {
//	[super viewWillAppear:animated];
//}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table Delegate and Data Source Methods
// These methods are all part of either the UITableViewDelegate or UITableViewDataSource protocols.


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

// The accessory type is the image displayed on the far right of each table cell. In order for the delegate method
// tableView:accessoryButtonClickedForRowWithIndexPath: to be called, you must return the "Detail Disclosure Button" type.
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellAccessoryDisclosureIndicator;
//}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	SearchFieldCell *searchFieldCell = (SearchFieldCell *)[searchTableView dequeueReusableCellWithIdentifier:@"SearchFieldCell"];
	if (searchFieldCell == nil) {
		// Create a new cell. CGRectZero allows the cell to determine the appropriate size.
		searchFieldCell = [[[SearchFieldCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"SearchFieldCell"] autorelease];
		searchFieldCell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    // Set the background color of the cell to be a light blue
    UIView *viewSelected = [[[UIView alloc] init] autorelease];
    viewSelected.backgroundColor = [UIColor colorWithRed: 0.914f green: 0.937f blue:0.980f alpha:1.0f];
    searchFieldCell.selectedBackgroundView = viewSelected;
	
    switch (indexPath.row) {
            // Brand
        case 0: 
			searchFieldCell.fieldType = ItemBrand;
			searchFieldCell.valueLabel.text = [dazzCollection searchDazzItem].brand;
			break;
            // Maker
        case 1: 
			searchFieldCell.fieldType = ItemMaker;
			searchFieldCell.valueLabel.text = [dazzCollection searchDazzItem].maker;
			break;
            // Type
		case 2:
			searchFieldCell.fieldType = ItemSize;
			searchFieldCell.valueLabel.text = [dazzCollection searchDazzItem].size;
			break;
            // Style
		case 3:
			searchFieldCell.fieldType = ItemModel;
			searchFieldCell.valueLabel.text = [dazzCollection searchDazzItem].model;
			break;
	}
	return searchFieldCell;
}

//- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
- (NSIndexPath *)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger index = -1;
    // Load the right stuff into the Picker
    switch (indexPath.row) {
            // Brand
        case 0: 
            if (masterType == ItemUndefined || masterValue == @"" || masterValue == @"All") {
                masterType = ItemBrand;
            }
            
			[self loadPrimaryList];
            
//            [self showInfoMessage: @"Select Brand:" alignment:UITextAlignmentLeft];
            
			[doItAllPickerView reloadComponent:0];
			
			// Set the picker to the value already in the table cell value field
			if ((index = [[dazzCollection primaryArray] indexOfObject: [dazzCollection searchDazzItem].brand]) != NSNotFound) {
				[doItAllPickerView selectRow: index inComponent: 0 animated: YES];
			}
			else {
				[doItAllPickerView selectRow: 0 inComponent: 0 animated: YES];
			}
			break;
            // Maker
        case 1: 
            if (masterType == ItemUndefined || masterValue == @"" || masterValue == @"All") {
                masterType = ItemMaker;
            }
            
			[self loadSecondaryList];
            
//            [self showInfoMessage: @"Select Maker:" alignment:UITextAlignmentLeft];
            
			[doItAllPickerView reloadComponent:0];
			
			// Set the picker to the value already in the table cell value field
			if ((index = [[dazzCollection secondaryArray] indexOfObject: [dazzCollection searchDazzItem].maker]) != NSNotFound) {
				[doItAllPickerView selectRow: index inComponent: 0 animated: YES];
			}
			else {
				[doItAllPickerView selectRow: 0 inComponent: 0 animated: YES];
			}
			break;
            // Type
		case 2:
			[self loadTertiaryList];
            
//            [self showInfoMessage: @"Select Type:" alignment:UITextAlignmentLeft];
            
			[doItAllPickerView reloadComponent:0];
			
			// Set the picker to the value already in the table cell value field
			if ((index = [[dazzCollection tertiaryArray] indexOfObject: [dazzCollection searchDazzItem].size]) != NSNotFound) {
				[doItAllPickerView selectRow: index inComponent: 0 animated: YES];
			}
			else {
				[doItAllPickerView selectRow: 0 inComponent: 0 animated: YES];
			}
			break;
            // Style
		case 3:
			[self loadQuadernaryList];
            
//            [self showInfoMessage: @"Select Model:" alignment:UITextAlignmentLeft];
            
			[doItAllPickerView reloadComponent:0];
			
			// Set the picker to the value already in the table cell value field
			if ((index = [[dazzCollection quadernaryArray] indexOfObject: [dazzCollection searchDazzItem].model]) != NSNotFound) {
				[doItAllPickerView selectRow: index inComponent: 0 animated: YES];
			}
			else {
				[doItAllPickerView selectRow: 0 inComponent: 0 animated: YES];
			}
			break;
	}
    
//    [searchTableView reloadData];
    
    return nil;
}

//- (NSIndexPath *)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	
//    NSLog(@"didSelectRowAtIndexPath - Row: %d", indexPath.row);
//    
//    switch (indexPath.row) {
//            // Brand
//        case 0: 
//			break;
//            // Maker
//        case 1: 
//			break;
//            // Type
//		case 2:
//			break;
//            // Style
//		case 3:
//			break;
//	}
//    return nil;
//}

#pragma mark Segmented Control methods

-(IBAction) segmentedControlIndexChanged{

    switch (propertiesControl.selectedSegmentIndex) {
        case 0:
            [self activateSelectedProperty:ItemBrand];
            break;
        case 1:
            [self activateSelectedProperty:ItemMaker];
            break;
        case 2:
            [self activateSelectedProperty:ItemSize];
            break;
        case 3:
            [self activateSelectedProperty:ItemModel];
            break;
        default:
            break;
    }
}

#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *value = nil;
	
    // change the appropriate table cell text 
	switch(searchSelection) {
		case ItemBrand:
		case ItemVintage:
		case ItemTitle:
		case ItemMerchant:
		case ItemCost:
		case ItemUndefined:
            
            value = [NSString stringWithFormat:@"%@", [[dazzCollection primaryArray] objectAtIndex:[pickerView selectedRowInComponent:0]]];
            
            if ( ([[[dazzCollection searchDazzItem] brand] isEqualToString:value]) ) {
                return;
            }
            
            [dazzCollection searchDazzItem].brand = value;
            
            if (masterType == ItemBrand) {
                masterValue = value;
                if ( [value isEqualToString:@"All"] ) {
                    masterType = ItemUndefined;
                    masterValue = @"";
                    
                    // Switch masterType to Maker if Maker has a reasonable value
                    if ( !([[[dazzCollection searchDazzItem] maker] isEqualToString:@"All"]) ) {
                        masterType = ItemMaker;
                        masterValue = [dazzCollection searchDazzItem].maker;
                    }
                }
            }
            
            // Clear the non master item values
            [dazzCollection searchDazzItem].size = @"All";
            [dazzCollection searchDazzItem].model = @"All";
           
			break;
		case ItemMaker:
            
            value = [NSString stringWithFormat:@"%@", [[dazzCollection secondaryArray] objectAtIndex:[pickerView selectedRowInComponent:0]]];
            
            if ( ([[[dazzCollection searchDazzItem] maker] isEqualToString:value]) ) {
                return;
            }

            [dazzCollection searchDazzItem].maker = value;
            
            if (masterType == ItemMaker) {
                masterValue = value;
                if ( [value isEqualToString:@"All"] ) {
                    masterType = ItemUndefined;
                    masterValue = @"";
                    
                    // Switch masterType to Brand if Brand has a reasonable value
                    if ( !([[[dazzCollection searchDazzItem] brand] isEqualToString:@"All"]) ) {
                        masterType = ItemBrand;
                        masterValue = [dazzCollection searchDazzItem].brand;
                    }
                }
            }
            
            // Clear the non master item values
            [dazzCollection searchDazzItem].size = @"All";
            [dazzCollection searchDazzItem].model = @"All";
            
			break;
		case ItemSize:
            
            value = [NSString stringWithFormat:@"%@", [[dazzCollection tertiaryArray] objectAtIndex:[pickerView selectedRowInComponent:0]]];
            
            if ( ([[[dazzCollection searchDazzItem] size] isEqualToString:value]) ) {
                return;
            }
            
            [dazzCollection searchDazzItem].size = value;
			break;
		case ItemModel:
            
            value = [NSString stringWithFormat:@"%@", [[dazzCollection quadernaryArray] objectAtIndex:[pickerView selectedRowInComponent:0]]];
            
            if ( ([[[dazzCollection searchDazzItem] model] isEqualToString:value]) ) {
                return;
            }
            
            [dazzCollection searchDazzItem].model = value;
			break;
	}
    
//	noresultLabel.hidden = YES;
	[self setSearchEnable];
	[searchTableView reloadData];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *title = @"";
	switch(searchSelection) {
		case ItemBrand:
		case ItemVintage:
		case ItemTitle:
		case ItemMerchant:
		case ItemCost:
		case ItemUndefined:
			title = [[dazzCollection primaryArray] objectAtIndex:row];
			break;
		case ItemMaker:
			title = [[dazzCollection secondaryArray] objectAtIndex:row];
			break;
		case ItemSize:
			title = [[dazzCollection tertiaryArray] objectAtIndex:row];
			break;
		case ItemModel:
			title = [[dazzCollection quadernaryArray] objectAtIndex:row];
			break;
	}
	
	return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger count = 0;
	switch(searchSelection) {
		case ItemBrand:
		case ItemVintage:
		case ItemTitle:
		case ItemMerchant:
		case ItemCost:
		case ItemUndefined:
			count = [[dazzCollection primaryArray] count];
			break;
		case ItemMaker:
			count = [[dazzCollection secondaryArray] count];
			break;
		case ItemSize:
			count = [[dazzCollection tertiaryArray] count];
			break;
		case ItemModel:
			count = [[dazzCollection quadernaryArray] count];
			break;
	}
	return count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

#pragma mark Some ui prep methods

- (void)setSearchEnable {
	
	ukuZooSearchButton.enabled = YES;
	
	// Don't enable the button unless there is some sort of filter
//	if ([dazzCollection searchDazzItem] != nil) {
//		if ([[dazzCollection searchDazzItem].maker isEqualToString:<#(NSString *)#>: @"All"] &&
//            [[dazzCollection searchDazzItem].brand isEqualToString: @"All"] &&
//			[[dazzCollection searchDazzItem].size isEqualToString: @"All"] && 
//			[[dazzCollection searchDazzItem].model isEqualToString: @"All"] {
//			
//			ukuZooSearchButton.enabled = NO;
//		}
//	}
}

- (void)initializeSearch {
    
	primaryItem    = @"";
	secondaryItem = @"";
	tertiaryItem  = @"";
	quadernaryItem  = @"";
    
    // We are tacitly choosing Brand to be the master item.  We do that to prime the picker with data
    // The dazzCollection init also contains this choice of brand as the default master
    masterType = ItemBrand;
    masterValue = @"";
    
    searchSelection = ItemBrand;
	
	// Disable searchButton until the user selects something
//    ukuZooSearchButton.userInteractionEnabled = NO;
    
    // To select Brand as the first search filter
    [searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
	
    // To clear all selections after returning to the Dazz page
    [searchTableView reloadData];
	
	[doItAllPickerView reloadComponent: 0];
}

// Maker
- (void)loadPrimaryList {
    [dazzCollection loadPrimaryArray: masterType]; //] value: masterValue];
    searchSelection = ItemBrand;
}

// Brand
- (void)loadSecondaryList {	
    [dazzCollection loadSecondaryArray: masterType]; // value: masterValue];
    searchSelection = ItemMaker;
}

// Type (size)
- (void)loadTertiaryList {
    [dazzCollection loadTertiaryArray: masterType]; // value: masterValue];
    searchSelection = ItemSize;
}

// Model
- (void)loadQuadernaryList {
    [dazzCollection loadQuadernaryArray: masterType]; // value: masterValue];
    searchSelection = ItemModel;
}

- (IBAction)searchDazz:(id)sender {
	
	// Until I can figure out how to get the disabled button to show, I'll just prevent the action here:
	if ([dazzCollection searchDazzItem] != nil) {
		if ([[[dazzCollection searchDazzItem] brand] compare: @"All"] == NSOrderedSame &&
            [[[dazzCollection searchDazzItem] maker] compare: @"All"] == NSOrderedSame && 
			[[[dazzCollection searchDazzItem] size] compare: @"All"] == NSOrderedSame && 
			[[[dazzCollection searchDazzItem] model] compare: @"All"] == NSOrderedSame) {
			
            [self showInfoMessage: @"Please select filters to narrow your search" title:@"Too Many Items To Return" buttonText:@"OK, let's move on"];
			
			return;
		}
	}
	
	UkuleleDazzAppDelegate *appDelegate = (UkuleleDazzAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate goToDazzItemViewFromSearch: [dazzCollection searchDazzItem]];
	//	[appDelegate goToTabItemView: [self dazzItem]];
}

- (IBAction)randomSearchDazz:(id)sender {
	
	UkuleleDazzAppDelegate *appDelegate = (UkuleleDazzAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate goToDazzItemViewFromSearch: nil];
}

//- (IBAction)searchEbay:(id)sender {
//	UkuleleDazzAppDelegate *appDelegate = (UkuleleDazzAppDelegate *)[[UIApplication sharedApplication] delegate];
//	[appDelegate goToEbayItemViewFromSearch: [dazzCollection searchDazzItem]];
//}

#pragma mark The web service calls for search params

- (void) activateSelectedProperty:(ItemFieldType)type {
	NSInteger index = -1;    
    switch (type) {
        case ItemBrand:
            if (masterType == ItemUndefined || masterValue == @"" || masterValue == @"All") {
                masterType = ItemBrand;
            }
            
			[self loadPrimaryList];

			[doItAllPickerView reloadComponent:0];
			
			// Set the picker to the value already in the table cell value field
			if ((index = [[dazzCollection primaryArray] indexOfObject: [dazzCollection searchDazzItem].brand]) != NSNotFound) {
				[doItAllPickerView selectRow: index inComponent: 0 animated: YES];
			}
			else {
				[doItAllPickerView selectRow: 0 inComponent: 0 animated: YES];
			}
            break;
        case ItemMaker: 
            if (masterType == ItemUndefined || masterValue == @"" || masterValue == @"All") {
                masterType = ItemMaker;
            }
            
			[self loadSecondaryList];
            
			[doItAllPickerView reloadComponent:0];
			
			// Set the picker to the value already in the table cell value field
			if ((index = [[dazzCollection secondaryArray] indexOfObject: [dazzCollection searchDazzItem].maker]) != NSNotFound) {
				[doItAllPickerView selectRow: index inComponent: 0 animated: YES];
			}
			else {
				[doItAllPickerView selectRow: 0 inComponent: 0 animated: YES];
			}
			break;
            // Type
		case ItemSize:
			[self loadTertiaryList];
            
			[doItAllPickerView reloadComponent:0];
			
			// Set the picker to the value already in the table cell value field
			if ((index = [[dazzCollection tertiaryArray] indexOfObject: [dazzCollection searchDazzItem].size]) != NSNotFound) {
				[doItAllPickerView selectRow: index inComponent: 0 animated: YES];
			}
			else {
				[doItAllPickerView selectRow: 0 inComponent: 0 animated: YES];
			}
			break;
            // Style
		case ItemModel:
			[self loadQuadernaryList];
            
			[doItAllPickerView reloadComponent:0];
			
			// Set the picker to the value already in the table cell value field
			if ((index = [[dazzCollection quadernaryArray] indexOfObject: [dazzCollection searchDazzItem].model]) != NSNotFound) {
				[doItAllPickerView selectRow: index inComponent: 0 animated: YES];
			}
			else {
				[doItAllPickerView selectRow: 0 inComponent: 0 animated: YES];
			}
            
        default:
            break;
    }
}

- (void)showInfoMessage: (NSString *)message title:(NSString *)title buttonText:(NSString *)button {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title message: message delegate: self cancelButtonTitle: button  otherButtonTitles: nil];
    [alert show];
    [alert release];
}

//- (void)showInfoMessage: (NSString *)text alignment:(UITextAlignment)align {
//    noresultLabel.text = text;
//    noresultLabel.textAlignment = align;
//    noresultLabel.hidden = NO;
//}
//
//- (void)hideInfoMessage {
//    noresultLabel.hidden = YES;
//}


// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size
{
	//	CGFloat kToolbarHeight = 0.0;
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(	0.0,
								   screenRect.size.height - size.height,
								   size.width,
								   size.height);
	return pickerRect;
}

- (ItemFieldType)getPickerViewActiveFieldType {
    
    ItemFieldType selectedType = ItemBrand;
    
    NSInteger selectedIndex = [[self propertiesControl] selectedSegmentIndex];
    
    switch (selectedIndex) {
        case 0:
            selectedType = ItemBrand;
            break;
        case 1:
            selectedType = ItemMaker;
            break;
        case 2:
            selectedType = ItemSize;
            break;
        case 3:
            selectedType = ItemModel;
            break;            
        default:
            selectedType = ItemBrand;
            break;
    }
    
    // If Master is selected use that.  If anything else is selected use ItemBrand as default
    ItemFieldType type = (selectedIndex == 1) ? selectedType : ItemBrand;
    
    return type;
}

- (void)dealloc {
    [super dealloc];
}


@end
