//
//  SearchViewController.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/30/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedTypes.h"
#import "TouchXML.h"

@class DazzItem;
@class DazzCollection;

@interface SearchViewController : UIViewController {
	
	// navigation controller
	UINavigationController *navigationController;
	
	IBOutlet UIWindow     *window;
	IBOutlet UITableView  *searchTableView;
	IBOutlet UIPickerView *doItAllPickerView;
	IBOutlet UIButton     *ukuZooSearchButton;
	IBOutlet UIButton     *ampSearchButton;
	IBOutlet UIButton     *ebaySearchButton;
	IBOutlet UILabel      *noresultLabel;
    IBOutlet UISegmentedControl *propertiesControl;
	
	ItemFieldType         masterType;
	NSString              *masterValue;

	NSString              *primaryItem;
	NSString              *secondaryItem;
	NSString              *tertiaryItem;
	NSString              *quadernaryItem;
	
	// This helps populate the controls and holds the final list of items 
    DazzCollection         *dazzCollection;
	
	// This tracks which thing we are selecting Brand, Type, Style...
	ItemFieldType          searchSelection;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

// The DazzCollection does ws calls and stores final list
@property (nonatomic, retain) DazzCollection *dazzCollection;

// This tracks which property, Brand or Maker, that we are using to filter all other lists in the picker
@property (assign, nonatomic) ItemFieldType masterType;

@property (assign, nonatomic) ItemFieldType searchSelection;

@property (nonatomic, retain) UISegmentedControl *propertiesControl;

// Master item will be either brand or maker. Collectors will be focused on maker, but others will focus on brand.
// The first of the two to be selected will become the master.
// That choice will be set to nothing when the controller returns to the Dazz page.
// Other items will have to refresh if the currently selected master item does not match what is stored in dazzItem
@property (copy, nonatomic) NSString *masterValue;
@property (copy, nonatomic) NSString *primaryItem;
@property (copy, nonatomic) NSString *secondaryItem;
@property (copy, nonatomic) NSString *tertiaryItem;
@property (copy, nonatomic) NSString *quadernaryItem;

- (void) activateSelectedProperty:(ItemFieldType)type;

- (CGRect)pickerFrameWithSize:(CGSize)size;

- (IBAction)searchDazz:(id)sender;
- (IBAction)randomSearchDazz:(id)sender;
- (IBAction) segmentedControlIndexChanged;

//- (IBAction)searchEbay:(id)sender;
- (void)initializeSearch;
- (void)loadPrimaryList;
- (void)loadSecondaryList;
- (void)loadTertiaryList;
- (void)loadQuadernaryList;

- (void)setSearchEnable;
//- (void)hideInfoMessage;
//- (void)showInfoMessage: (NSString *)text alignment:(UITextAlignment)align;
- (void)showInfoMessage: (NSString *)message title:(NSString *)title buttonText:(NSString *)button;

- (ItemFieldType)getPickerViewActiveFieldType;

@end
