//
//  RootViewController.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 8/8/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
