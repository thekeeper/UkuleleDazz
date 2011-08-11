//
//  DazzCollection.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/28/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedTypes.h"
#import "DazzObject.h"

@class DazzItem;
//@class EbayItem;

@interface DazzCollection : DazzObject {
    
    // Sort field for sorting dazzItem listing.
    ItemFieldType firstSortField;
    ItemFieldType secondSortField;
    ItemFieldType thirdSortField;

	// Attributes.
	NSString *collector;
    NSString *collectionId;
    NSString *name;
    NSString *notes;
    NSString *privacy;
    BOOL      privateName;
	NSDate   *date;
    NSString *itemCount;
	NSMutableArray *dazzItems;
	NSMutableArray *ebayItems;
	
    // Search related objects
	NSMutableArray		  *primaryArray;
	NSMutableArray		  *secondaryArray;
	NSMutableArray		  *tertiaryArray;
	NSMutableArray		  *quadernaryArray;
	
	NSInteger currentItemsIndex;
        
	// We store our search params here
    DazzItem *searchDazzItem;
}

@property (copy) NSString *collector;
@property (copy) NSString *collectionId;
@property (copy) NSString *itemCount;
@property (copy) NSString *name;
@property (copy) NSString *notes;
@property (copy) NSString *privacy;
@property (nonatomic) BOOL privateName;
@property (retain) NSDate *date;
@property (nonatomic, retain) NSMutableArray *dazzItems;
@property (nonatomic, retain) NSMutableArray *ebayItems;

// Search related objects ---

// This tracks which property, Brand or Maker, that we are using to filter all other lists in the picker
//@property (assign, nonatomic) ItemFieldType masterType;
// Master item will be either brand or maker. Collectors will be focused on maker, but others will focus on brand.
// The first of the two to be selected will become the master.
// That choice will be set to nothing when the controller returns to the Dazz page.
// Other items will have to refresh if the currently selected master item does not match what is stored in dazzItem
//@property (copy, nonatomic) NSString *masterValue;

@property (nonatomic, retain) NSMutableArray *primaryArray;
@property (nonatomic, retain) NSMutableArray *secondaryArray;
@property (nonatomic, retain) NSMutableArray *tertiaryArray;
@property (nonatomic, retain) NSMutableArray *quadernaryArray;

// The DazzItem is used to store the search properties
@property (nonatomic, retain) DazzItem *searchDazzItem;

// The Search Helpers:
// This is a helper for the search view which will create a dazzCollection
- (id) initSearchWithJson;
- (id) hydrateWithSearchItemJson: (DazzItem *) dazzItem;
- (id) hydrateWithRandomSearchItemJson: (NSInteger) count;

- (void)loadPrimaryArray: (ItemFieldType)type; // value: (NSString *) value;
- (void)loadSecondaryArray: (ItemFieldType)type; // value: (NSString *) value;
- (void)loadTertiaryArray: (ItemFieldType)type; // value: (NSString *) value;
- (void)loadQuadernaryArray: (ItemFieldType)type; // value: (NSString *) value;

- (NSArray *)createAttributeArrayJson: (NSString *) attributeName dbName:(NSString *) dbName masterType:(ItemFieldType)masterType;
//- (void) createMasterListJson;
//- (void) createSecondaryListJson;
//- (void) createTertiaryListJson;
//- (void) createQuadernaryListJson;

// The Xml versions
- (id) initSearchWithXml;
- (void) createMasterListXml;
- (void) createSecondaryListXml;
- (void) createTertiaryListXml;
- (NSMutableArray *) runSearchListQueryXml: (NSString *)escapedUrl nodePath: (NSString *)path;
//- (NSMutableArray *) runSearchListQueryJson: (NSString *)escapedUrl nodePath: (NSString *)path;

//
- (void) zeroItemsIndex;

// This orders the itemArray by the field type chosen.  It is used for the random search where no sort order is included in the query
// It will be decided by which of the two Master types have been selected, either Brand or Maker
- (void) orderItemsByType:(ItemFieldType)type;

// Returns the dazzItem for the current cell 
- (DazzItem *) getNextItem;

// Returns the dazzItem at the supplied index
- (DazzItem *) dazzItemAtIndex:(NSInteger) index;

// Returns the dazzItem at the supplied index
//- (EbayItem *) ebayItemAtIndex:(NSInteger) index;

// These three will count for the different DazzItem sort fields. If we decide to allow sorting on other fields, we will add more 
- (NSInteger) countOfItemsMatchingPrimaryName:(NSInteger)index;
- (NSInteger) countOfItemsMatchingSecondaryName:(NSInteger)index;
- (NSInteger) countOfItemsMatchingTertiaryName:(NSInteger)index;
- (NSInteger) countOfItemsMatchingQuadernaryName:(NSInteger)index;

- (ItemFieldType) getFirstSortField;
- (ItemFieldType) getSecondSortField;
- (ItemFieldType) getThirdSortField;

- (void) setFirstSortField: (ItemFieldType)type;
- (void) setSecondSortField: (ItemFieldType)type;
- (void) setThirdSortField: (ItemFieldType)type;


@end
