//
//  DazzViewController.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/25/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DazzCollection.h"

@class CXMLDocument;
@class Dazz;

@interface DazzViewController : UIViewController {
	
	// navigation controller
	UINavigationController *navigationController;

    UITableView *collectionTableView;
	
    Dazz* dazz;
    
//    NSMutableArray *dazzCollections;
//	CXMLDocument *doc;
//	NSArray *itemNodes;
	
	// This is the wait indicator 
	UIActivityIndicatorView *activityView;
	
	// This is keeping track of the index into the dazzItems array where each new section starts
	// A section is defined by the firstSortField, such as ItemMaker or ItemSize
	NSMutableArray *sortFieldSectionTitleIndexes;
	
    NSIndexPath *selectedIndexPath;
}

@property (nonatomic, retain) IBOutlet UITableView *collectionTableView;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) Dazz *dazz;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@end
