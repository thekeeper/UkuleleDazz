//
//  TabItemViewController.h
//  UkuZoo
//
//  Created by Terry Tucker on 1/2/10.
//  Copyright 2010 Hot! Digity Dog Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionViewController;
@class EbayItemViewController;

@interface TabItemViewController : UIViewController<UITabBarDelegate> {
		
	// navigation controller
	UINavigationController *navigationController;
	CollectionViewController *collectionViewController;
	EbayItemViewController *ebayItemViewController;
	
	IBOutlet UITabBar *itemTabBar;
	
	// Need this somewhere?
	// itemTabBar.delegate = self;
		
}

@property (nonatomic, retain) IBOutlet UITabBar *itemTabBar;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet CollectionViewController *collectionViewController;
@property (nonatomic, retain) IBOutlet EbayItemViewController *ebayItemViewController;

- (void)loadUkuZooItemView;

@end
