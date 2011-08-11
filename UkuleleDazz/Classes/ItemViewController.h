//
//  ItemViewController.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/29/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DazzItem;

@interface ItemViewController : UIViewController {
	
	// navigation controller
	UINavigationController *navigationController;	
    UITableView *detailTableView;
	
	DazzItem *dazzItem;
}

@property (nonatomic, retain) IBOutlet UITableView *detailTableView;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) DazzItem *dazzItem;

@end
