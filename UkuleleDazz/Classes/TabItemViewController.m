//
//  TabItemViewController.m
//  UkuZoo
//
//  Created by Terry Tucker on 1/2/10.
//  Copyright 2010 Hot! Digity Dog Software. All rights reserved.
//

#import "TabItemViewController.h"
#import "CollectionViewController.h"
//#import "AmpItemViewController.h"
#import "EbayItemViewController.h"

@implementation TabItemViewController

@synthesize itemTabBar;
@synthesize navigationController;	
@synthesize collectionViewController;
@synthesize ebayItemViewController;

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
	
	itemTabBar.delegate = self;
    itemTabBar.selectedItem = [itemTabBar.items objectAtIndex:0];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadUkuZooItemView];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"item tag: %d", item.tag);
	
    if (item.tag == 1) {
        if(collectionViewController) {
            [self.view bringSubviewToFront:collectionViewController.view];
        }
        else {
            [self loadUkuZooItemView];    
        }
   }
    else if (item.tag == 2) {
        if(collectionViewController) {
            [self.view bringSubviewToFront:collectionViewController.view];
        }
        else {
            [self loadUkuZooItemView];    
        }
    }
    else { // Tag = 0
        if(collectionViewController) {
            [self.view bringSubviewToFront:collectionViewController.view];
        }
        else {
            [self loadUkuZooItemView];    
        }
    }	
}

/*
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"item tag: %d", item.tag);
	
    if (item.tag == 1) {
        if(ebayItemViewController) {
			[self.view bringSubviewToFront:ebayItemViewController.view];
		}
		else {
			[self loadEbayView];
		}		
    }
    else if (item.tag == 2) {
        if(ampItemViewController) {
            [self.view bringSubviewToFront:ampItemViewController.view];
        }
        else {
            [self loadAmpView];    
        }
    }
    else { // Tag = 0
        if(collectionViewController) {
            [self.view bringSubviewToFront:collectionViewController.view];
        }
        else {
            [self loadUkuZooItemView];    
        }
    }	
}
*/

- (void)loadUkuZooItemView {
    NSLog (@"Loading the UkuZoo Item View");
    collectionViewController = [[CollectionViewController alloc] initWithNibName:@"ItemView" bundle:nil];
	
    [self.view addSubview:collectionViewController.view];
//    [ukuzooItemViewController setTrailDetails: zooItem];
}

/*
- (void)loadAmpItemView {
    NSLog (@"Loading the AMP Item View");
    ampItemViewController = [[AmpItemViewController alloc] initWithNibName:@"AmpItemView" bundle:nil];
	
    [self.view addSubview:ampItemViewController.view];
//    [ampItemViewController setDetails: zooItem];
}

- (void)loadEbayItemView {
    NSLog (@"Loading the ebay Item View");
    ebayItemViewController = [[EbayItemViewController alloc] initWithNibName:@"EbayItemView" bundle:nil];
    [self.view addSubview:ebayItemViewController.view];
}*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
