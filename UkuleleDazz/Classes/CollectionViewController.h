//
//  CollectionViewController.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/25/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DazzCollection;

@interface CollectionViewController : UIViewController {
	
	// navigation controller
	UINavigationController *navigationController;	
    UITableView *itemTableView;
	
	DazzCollection *dazzCollection;
	
	// This is keeping track of the index into the dazzItems array where each new section starts
	// A section is defined by the firstSortField, such as ItemMaker or ItemSize
	NSMutableArray *sortFieldSectionTitleIndexes;
	
    NSIndexPath *selectedIndexPath;
    
    // To make sure we don't re-request information before the current request has finished
    BOOL respondingToShake;
	
}

@property (nonatomic, retain) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) DazzCollection *dazzCollection;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) NSMutableArray *sortFieldSectionTitleIndexes;
@property (nonatomic) BOOL respondingToShake;

// Returns the next name in the sortField array at the index indicated, this is called using the current section index which should correspond
- (NSString *)sectionNameAtIndex:(NSInteger) index;

// Returns the requested field name for the dazzItem at the supplied index
- (NSString *)itemFieldAtIndex: (NSInteger)index fieldType: (NSInteger)type;

// Fills the sortFiledSectionTitleIndexes array and returns the total count
- (NSInteger)initSectionTitleIndexes;

// Returns the number of items corresponding to this sort field 
- (NSInteger)countOfItemsMatchingCurrentFieldName:(NSInteger)fieldType sectionIndex:(NSInteger)index;

// This will create an empty cell if neccessary
- (void)assignDazzCollection: (DazzCollection *)collection;

// To update a random shake search
- (void)updateDazzCollection:(DazzCollection *)collection;

// This will create an empty cell if neccessary
- (void)clearDazzCollection;

@end
