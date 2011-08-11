//
//  EbayItemViewController.h
//  UkuZoo
//
//  Created by Terry Tucker on 1/5/10.
//  Copyright 2010 Hot! Digity Dog Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZooCollection;

@interface EbayItemViewController : UIViewController {
	
	// navigation controller
	UINavigationController *navigationController;
	
    IBOutlet UITableView *itemTableView;
	
	ZooCollection *zooCollection;
	
	// This is keeping track of the index into the zooItems array where each new section starts
	// A section is defined by the firstSortField, such as ItemMaker or ItemSize
	NSMutableArray *sortFieldSectionTitleIndexes;
	
    NSIndexPath *selectedIndexPath;
	
}

@property (nonatomic, retain) IBOutlet UITableView *itemTableView;

// navigation controller
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) ZooCollection *zooCollection;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) NSMutableArray *sortFieldSectionTitleIndexes;

// Returns the next name in the sortField array at the index indicated, this is called using the current section index which should correspond
- (NSString *)sectionNameAtIndex:(NSInteger) index;

// Returns the requested field name for the zooItem at the supplied index
- (NSString *)itemFieldAtIndex: (NSInteger)index fieldType: (NSInteger)type;

// Fills the sortFiledSectionTitleIndexes array and returns the total count
- (NSInteger)initSectionTitleIndexes;

// Returns the number of items corresponding to this sort field 
- (NSInteger)countOfItemsMatchingCurrentFieldName:(NSInteger)fieldType sectionIndex:(NSInteger)index;

// This will create an empty cell if neccessary
- (void)assignZooCollection: (ZooCollection *)collection;

// This will create an empty cell if neccessary
- (void)clearZooCollection;

@end
