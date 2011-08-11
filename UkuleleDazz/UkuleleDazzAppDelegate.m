//
//  UkuleleDazzAppDelegate.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/25/09.
//  Copyright Terry Tucker 2009. All rights reserved.
//

#import "UkuleleDazzAppDelegate.h"
#import "DazzViewController.h"
#import "CollectionViewController.h"
#import "ItemViewController.h"
#import "SearchViewController.h"
#import "CarouselViewController.h"
#import "Dazz.h"
#import "DSActivityView.h"

#include <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>


@interface UkuleleDazzAppDelegate (UtilityMethods)
- (void)showReachabilityMessage:(NSString *)message;
- (void) updateInterfaceWithReachability: (Reachability*) curReach;
@end


@implementation UkuleleDazzAppDelegate

@synthesize window;
@synthesize navigationController;

// view controllers
@synthesize rootViewController;
@synthesize dazzViewController;
@synthesize searchViewController;
@synthesize collectionViewController;
@synthesize itemViewController;
@synthesize carouselViewController;
//@synthesize tabItemViewController;
//@synthesize ebayItemViewController;
//@synthesize webViewController;

// buttons
@synthesize collectionButton;
@synthesize searchButton;

// Location services
//@synthesize location;
//@synthesize locationManager;
//@synthesize locationMeasurements;
//@synthesize bestEffortAtLocation;

// Data Store Selection
@synthesize dataStoreType;

//- (void)applicationDidFinishLaunching:(UIApplication *)application {    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.applicationSupportsShakeToEdit = YES;
	
	// navigation controller
	[window addSubview:[navigationController view]];

    ////////////////////////////////////////////////////////////////
    //
    // Set up location services
    
//    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
//    locationManager.delegate = self;
//    // This is the most important property to set for the manager. It ultimately determines how the manager will
//    // attempt to acquire location and thus, the amount of power that will be consumed.
//    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
//	
//    // Once configured, the location manager must be "started".
//	// It will only be run once each time this controller is pushed.  
//    // It will be turned off in didUpdateToLocation
//    [locationManager startUpdatingLocation];
	
    [window makeKeyAndVisible];
     
    return YES;
}

#pragma mark Location Manager Interactions 

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    
//	self.location = newLocation;
//	
//	// test the measurement to see if it meets the desired accuracy
//	//
//	// IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
//	// accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
//	// acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
//	//
//	if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
//		// we have a measurement that meets our requirements, so we can stop updating the location
//		// 
//		// IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
//		//
//		[self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
//		// we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
//		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
//	}
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    // The location "unknown" error simply means the manager is currently unable to get the location.
//    // We can ignore this error for the scenario of getting a single location fix, because 
//    // we already have a timeout that will stop the location manager to save power.
//    if ([error code] != kCLErrorLocationUnknown) {
//        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
//    }
//}
//
//- (void)stopUpdatingLocation:(NSString *)state {
//    [locationManager stopUpdatingLocation];
//    locationManager.delegate = nil;
//}


// ****************                           ******************** //
// ****************  Dazz View (Collections)   ******************** //
// ****************                           ******************** //


- (IBAction)goToDazzView {

    // Always check for network before each action that requires network access
    if (![self connectedToNetwork]) {
        [self sendNotConnectedMessage];
        return;
    }
    
    if (![DSActivityView currentActivityView]) {
		navigationController.view.userInteractionEnabled = NO;
        [self addActivityIndicator:[self.rootViewController view] label:@"Loading collections..."];
		[self performSelectorInBackground: @selector(getDazz) withObject: nil];
	}
}

// This is run in a separate thread from the Main thread
- (void)getDazz {
    NSAutoreleasePool * pool;
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
    
    // Get all collections and any other general dazz info 
    Dazz *dazz = [[Dazz alloc] initWithJson];
    
    [self performSelectorOnMainThread: @selector(pushDazzView:) withObject: dazz waitUntilDone: NO];
	
    NSLog(@" %s: - started calling removeActivityIndicator", __FUNCTION__);
	[self removeActivityIndicator];
    NSLog(@" %s: - finished calling removeActivityIndicator", __FUNCTION__);
    [pool drain];
    NSLog(@" %s: - finished calling [pool drain]", __FUNCTION__);
}

- (void)pushDazzView: (Dazz *) dazz {
    
    // Set the item controller's dazz obejct to the one populated by getDazz
	dazzViewController.dazz = dazz;

    [self.navigationController pushViewController:dazzViewController animated:YES];

	// Free up the UI that was disabled until the new view data could be fetched
	navigationController.view.userInteractionEnabled = YES;
}


// ****************                           ******************** //
// ****************        Search View        ******************** //
// ****************                           ******************** //


- (IBAction)goToSearchView {
    
    // Always check for network before each action that requires network access
    if (![self connectedToNetwork]) {
        [self sendNotConnectedMessage];
        return;
    }

//	if (![activityView isAnimating]) {
	if (![DSActivityView currentActivityView]) {
		navigationController.view.userInteractionEnabled = NO;
        [self addActivityIndicator:[self.rootViewController view] label:@"Loading search..."];
		[self performSelectorInBackground: @selector(getDazzSearch) withObject: nil];
	}
}

// This is run in a separate thread from the Main thread
- (void)getDazzSearch {
    NSAutoreleasePool * pool;
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
    
    // Get all collections and any other general dazz info 
    DazzCollection *dazzCollection = [[DazzCollection alloc] initSearchWithJson];

    // This will initialize the picker control with the data we just acquired in the dazzCollection init
    [searchViewController initializeSearch];
	
    [self performSelectorOnMainThread: @selector(pushSearchView:) withObject: dazzCollection waitUntilDone: NO];
	
    NSLog(@" %s: - started calling removeActivityIndicator", __FUNCTION__);
	[self removeActivityIndicator];
    NSLog(@" %s: - finished calling removeActivityIndicator", __FUNCTION__);
    [pool drain];
    NSLog(@" %s: - finished calling [pool drain]", __FUNCTION__);
}

- (void)pushSearchView: (DazzCollection *) dazzCollection {
    
    // Set the item controller's dazz obejct to the one populated by getDazz
	searchViewController.dazzCollection = dazzCollection;
    
    [self.navigationController pushViewController:searchViewController animated:YES];
	
	// Free up the UI that was disabled until the new view data could be fetched
	navigationController.view.userInteractionEnabled = YES;
}


// ****************                             ******************** //
// ****************        Collection View      ******************** //
// ****************      (from Collections)     ******************** //


- (void)goToCollectionView: (DazzCollection*) dazzCollection {
    
    // Always check for network before each action that requires network access
    if (![self connectedToNetwork]) {
        [self sendNotConnectedMessage];
        return;
    }

    // Create the detail view lazily
//    if (CollectionViewController == nil) {
//        collectionViewController *viewController = [[CollectionViewController alloc] initWithNibName:@"ItemView" bundle:nil];
//        self.collectionViewController = viewController;
//        [viewController release];
//    }
	
	if (![DSActivityView currentActivityView]) {
		navigationController.view.userInteractionEnabled = NO;
        [self addActivityIndicator:[self.dazzViewController view] label:@"Loading items..."];
		[self performSelectorInBackground: @selector(getDazzCollection:) withObject: dazzCollection];
	}
}

// This is run in a separate thread from the Main thread
- (void)getDazzCollection:(DazzCollection *)dazzCollection {
    NSAutoreleasePool * pool;
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	// We do a hydrate here because the collection has already been created with just a few items of information
	// This will add the rest of the content.
	[dazzCollection hydrateFromJson];
	
    [self performSelectorOnMainThread: @selector(pushDazzCollectionView:) withObject: dazzCollection waitUntilDone: NO];
	
    NSLog(@" %s: - started calling removeActivityIndicator", __FUNCTION__);
	[self removeActivityIndicator];
    NSLog(@" %s: - finished calling removeActivityIndicator", __FUNCTION__);
    [pool drain];
    NSLog(@" %s: - finished calling [pool drain]", __FUNCTION__);
}

// ****************                            ******************** //
// ****************       Dazz Item View        ******************** //
// ****************       (from Search)        ******************** //


- (void)goToDazzItemViewFromSearch: (DazzItem *) dazzItem {
    
    // Always check for network before each action that requires network access
    if (![self connectedToNetwork]) {
        [self sendNotConnectedMessage];
        return;
    }

    navigationController.view.userInteractionEnabled = NO;
    NSArray *images = [self createSearchAnimationArray];
    
    // The shake event could be calling this from the Collection View, so we must test...
    if ([[self.navigationController visibleViewController] isKindOfClass:[SearchViewController class]] ) {
        [self addActivityIndicator:[self.searchViewController view] label:@"Searching..." images:images];
    }
    else {
        [self addActivityIndicator:[self.collectionViewController view] label:@"Searching..." images:images];
    }
    
    [self performSelectorInBackground: @selector(getdazzItemsFromSearch:) withObject: dazzItem];
}

// This is run in a separate thread from the Main thread
- (void)getdazzItemsFromSearch: (DazzItem *) dazzItem {
    NSAutoreleasePool * pool;
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
    DazzCollection *dazzCollection = nil;
    
    // If nil, this will be a random search
    if (dazzItem == nil) {
        dazzCollection = [[DazzCollection alloc] hydrateWithRandomSearchItemJson: 10];
        
        // This can only be ItemBrad, ItemMaker, or ItemUndefined
        ItemFieldType type = [searchViewController masterType];
        
        // If undefined, see what the user has as the active button for the picker
        if (type == ItemUndefined) {
            type = [searchViewController getPickerViewActiveFieldType];
            
            // If it is either Brand or Maker, use it, otherwise default to Brand
            if ( !(type == ItemBrand || type == ItemMaker) ) {
                type = ItemBrand;
            }
        }
        [dazzCollection orderItemsByType: type];
    }
    else {
        // hydrate will use dazzItem as the template for the search
        dazzCollection = [[DazzCollection alloc] hydrateWithSearchItemJson: dazzItem];
    }

    if (dazzCollection.dazzItems.count == 0) {
        [searchViewController showInfoMessage: @"This search could not match the properties you chose with anything in the database" title:@"No results" buttonText: @"Ok, I'll try again"];
        
        // Free up the UI that was disabled until the new view data could be fetched
        navigationController.view.userInteractionEnabled = YES;
    }
    else {
        
        [self performSelectorOnMainThread: @selector(pushDazzCollectionView:) withObject: dazzCollection waitUntilDone: NO];
    }
	
    NSLog(@" %s: - started calling removeActivityIndicator", __FUNCTION__);
	[self removeActivityIndicator];
    NSLog(@" %s: - finished calling removeActivityIndicator", __FUNCTION__);
    [pool drain];
    NSLog(@" %s: - finished calling [pool drain]", __FUNCTION__);
}

- (void)pushDazzCollectionView: (DazzCollection *)dazzCollection {
	
    // Set the item controller's collection to the currently-selected dazzCollection.
	collectionViewController.dazzCollection = dazzCollection;
	
    // "Push" the detail view on to the navigation controller's stack if it hasn't been pushed already.
    if (![[self.navigationController visibleViewController] isKindOfClass:[CollectionViewController class]] ) {
        NSLog(@" %s: - calling pushViewController", __FUNCTION__);
        [self.navigationController pushViewController: collectionViewController animated:YES];
        NSLog(@" %s: - finished calling pushViewController", __FUNCTION__);
        [[collectionViewController itemTableView] reloadData];
    }
    else {
        // Update the collection in the table
        [collectionViewController updateDazzCollection:dazzCollection];
    }
    
          
    // Free up the UI that was disabled until the new view data could be fetched
	navigationController.view.userInteractionEnabled = YES;
}

// ****************                           ******************** //
// ****************      Dazz Detail View      ******************** //
// ****************                           ******************** //


- (void)goToDetailView: (DazzItem*) dazzItem {
    
    // Always check for network before each action that requires network access
    if (![self connectedToNetwork]) {
        [self sendNotConnectedMessage];
        return;
    }

    // Create the detail view lazily
    if (itemViewController == nil) {
        ItemViewController *viewController = [[ItemViewController alloc] initWithNibName:@"DetailView" bundle:nil];
        self.itemViewController = viewController;
        [viewController release];
    }
	
	if (![DSActivityView currentActivityView]) {
		navigationController.view.userInteractionEnabled = NO;
        [self addActivityIndicator:[self.collectionViewController view] label:@"Loading detail..."];
		[self performSelectorInBackground: @selector(getDazzDetails:) withObject: dazzItem];
	}
}

// This is run in a separate thread from the Main thread
- (void)getDazzDetails: (DazzItem*) dazzItem {
    NSAutoreleasePool * pool;
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	// We do a hydrate here because the item has already been created with just a few items of information
	[dazzItem hydrateFromJson];
	
    NSLog(@" %s: - calling pushViewController", __FUNCTION__);
    [self performSelectorOnMainThread: @selector(pushDetailView:) withObject: dazzItem waitUntilDone: NO];
    NSLog(@" %s: - finished calling pushViewController", __FUNCTION__);
	
    NSLog(@" %s: - started calling removeActivityIndicator", __FUNCTION__);
	[self removeActivityIndicator];
    NSLog(@" %s: - finished calling removeActivityIndicator", __FUNCTION__);
    [pool drain];
    NSLog(@" %s: - finished calling [pool drain]", __FUNCTION__);
}

- (void)pushDetailView: (DazzItem*) dazzItem {
    // Set the item controller's collection to the currently-selected dazzCollection.
	itemViewController.dazzItem = dazzItem;
	
    // "Push" the detail view on to the navigation controller's stack.
    [self.navigationController pushViewController: itemViewController animated:YES];
	
	// Free up the UI that was disabled until the new view data could be fetched
	navigationController.view.userInteractionEnabled = YES;
}


// ****************                           ******************** //
// ****************        Photo View         ******************** //
// ****************                           ******************** //


- (void)goToPhotoView: (NSMutableArray*) pathArray {
    
    // Always check for network before each action that requires network access
    if (![self connectedToNetwork]) {
        [self sendNotConnectedMessage];
        return;
    }
	
	if (![DSActivityView currentActivityView]) {
		navigationController.view.userInteractionEnabled = NO;
        [self addActivityIndicator:[self.itemViewController view] label:@"Loading photos..."];
		[self performSelectorInBackground: @selector(getDazzPhotos:) withObject: pathArray];
	}
}

// This is run in a separate thread from the Main thread
- (void)getDazzPhotos: (NSMutableArray*) pathArray {
    NSAutoreleasePool * pool;
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	// All this does right now is set the path array in the controller
    carouselViewController = [[CarouselViewController alloc] initWithNibName:@"CarouselView" bundle:nil];
	[carouselViewController initImages: pathArray];
	
    [self performSelectorOnMainThread: @selector(pushPhotoView:) withObject: pathArray waitUntilDone: NO];
	
	[self removeActivityIndicator];
    [pool drain];
}

- (void)pushPhotoView: (NSMutableArray*) pathArray {
    // "Push" the image view on to the navigation controller's stack.
    [self.navigationController pushViewController: carouselViewController animated:YES];
	
	// Free up the UI that was disabled until the new view data could be fetched
	navigationController.view.userInteractionEnabled = YES;
}


// ****************  Stuff to implement later ******************* //


// ****************                           ******************** //
// ****************      Tab Item View        ******************** //
// ****************                           ******************** //


//- (void)goToTabItemView: (DazzItem *) dazzItem {
//	
//	if (![activityView isAnimating]) {
//		navigationController.view.userInteractionEnabled = NO;
//		[self addProgressIndicator];
//		[self performSelectorInBackground: @selector(getTabItems:) withObject: dazzItem];
//	}	
//}
//
//- (void)getTabItems:(DazzItem *) dazzItem {
//    NSAutoreleasePool * pool;
//    pool = [[NSAutoreleasePool alloc] init];
//    assert(pool != nil);
//	
//	// hydrate will use dazzItem as the template for the search
//	DazzCollection *dazzCollection = [DazzCollection alloc];
//	[dazzCollection hydrateFromDazzSearchJson: dazzItem];
//	
//    [self performSelectorOnMainThread: @selector(pushTabItemView:) withObject: dazzCollection waitUntilDone: NO];
//	
//    [pool drain];
//	[self removeProgressIndicator];
//	
//	//	[activityView stopAnimating]; 
//	//	[activityView release];
//}
//
//- (void)pushTabItemView: (DazzItem *) dazzItem {
//	// "Push" the detail view on to the navigation controller's stack.
//    [self.navigationController pushViewController: (UIViewController*)tabItemViewController animated:YES];
//	
//	// Free up the UI that was disabled until the new view data could be fetched
//	navigationController.view.userInteractionEnabled = YES;
//}	


// ****************                          ******************** //
// ****************      AMP Item View       ******************** //
// ****************      (from Search)       ******************** //


// - (void)goToAmpItemViewFromSearch: (DazzItem *) dazzItem {
// 
// if (![activityView isAnimating]) {
// navigationController.view.userInteractionEnabled = NO;
// [self addProgressIndicator];
// [self performSelectorInBackground: @selector(getAmpItemsFromSearch:) withObject: dazzItem];
// }
// }
// 
// // This is run in a separate thread from the Main thread
// - (void)getAmpItemsFromSearch: (DazzItem *) dazzItem {
// NSAutoreleasePool * pool;
// pool = [[NSAutoreleasePool alloc] init];
// assert(pool != nil);
// 
// // hydrate will use dazzItem as the template for the search
// DazzCollection *dazzCollection = [DazzCollection alloc];
// [dazzCollection hydrateFromAmpSearch: (DazzItem*)dazzItem];
// 
// [self performSelectorOnMainThread: @selector(pushAmpItemView:) withObject: dazzCollection waitUntilDone: NO];
// 
// [pool drain];
// [self removeProgressIndicator];
// }
// 
// - (void)pushAmpItemView: (DazzCollection *)dazzCollection {
// 
// // Set the item controller's collection to the currently-selected dazzCollection.
// ampItemViewController.dazzCollection = dazzCollection;
// //	[dazzCollection release];
// 
// // "Push" the detail view on to the navigation controller's stack.
// [self.navigationController pushViewController: ampItemViewController animated:YES];
// 
// // Free up the UI that was disabled until the new view data could be fetched
// navigationController.view.userInteractionEnabled = YES;
// }



// ****************                           ******************** //
// ****************      Ebay Item View       ******************** //
// ****************      (from Search)        ******************** //


//- (void)goToEbayItemViewFromSearch: (DazzItem *) dazzItem {
//	
//	UIAlertView *noWorkee = [[UIAlertView alloc] initWithTitle: @"Under Construction" message: @"Sorry, this button no workee" delegate: self cancelButtonTitle: @"OK, let's move on"  otherButtonTitles: nil];
//	[noWorkee show];
//	[noWorkee release];
//							 
//							 //	if (![activityView isAnimating]) {
////		navigationController.view.userInteractionEnabled = NO;
////		[self addProgressIndicator];
////		[self performSelectorInBackground: @selector(getEbayItemsFromSearch:) withObject: dazzItem];
////	}
//}
//
//// This is run in a separate thread from the Main thread
//- (void)getEbayItemsFromSearch: (DazzItem *) dazzItem {
////    NSAutoreleasePool * pool;
////    pool = [[NSAutoreleasePool alloc] init];
////    assert(pool != nil);
////	
////	// hydrate will use dazzItem as the template for the search
////	DazzCollection *dazzCollection = [DazzCollection alloc];
////	[dazzCollection  hydrateFromEbaySearchXml: dazzItem];
////	
////    [self performSelectorOnMainThread: @selector(pushEbayItemView:) withObject: dazzCollection waitUntilDone: NO];
////	
////    [pool drain];
////	[self removeProgressIndicator];
//}
//
//- (void)pushEbayItemView: (DazzCollection *)dazzCollection {
//	
//    // Set the item controller's collection to the currently-selected dazzCollection.
//	ebayItemViewController.dazzCollection = dazzCollection;
//	
//    // "Push" the detail view on to the navigation controller's stack.
//    [self.navigationController pushViewController: ebayItemViewController animated:YES];
//	
//	// Free up the UI that was disabled until the new view data could be fetched
//	navigationController.view.userInteractionEnabled = YES;
//}


// ****************                           ******************** //
// ****************         Web View          ******************** //
// ****************                           ******************** //


//- (void)goToWebView: (NSString *) uri {
//	
//	if (![activityView isAnimating]) {
//		navigationController.view.userInteractionEnabled = NO;
//		[self addProgressIndicator];
//		[self performSelectorInBackground: @selector(getWeb:) withObject: uri];
//	}
//}
//
//// This is run in a separate thread from the Main thread
//- (void)getWeb: (NSString *) uri {
//    NSAutoreleasePool * pool;
//    pool = [[NSAutoreleasePool alloc] init];
//    assert(pool != nil);
//
//	[webViewController initWithUri: uri];
//	
//    [self performSelectorOnMainThread: @selector(pushWebView:) withObject: uri waitUntilDone: NO];
//	
//    [pool drain];
//	
//	// I tried putting this in the webviewcontroller viewdidload, but that sometimes doesn't get called and creates badness
////	[self removeProgressIndicator];
//}
//
//- (void)pushWebView: (NSString *) uri {
//    // Set the item controller's collection to the currently-selected dazzCollection.
//	webViewController.startUri = uri;
//	
//    // "Push" the detail view on to the navigation controller's stack.
//    [self.navigationController pushViewController: webViewController animated:YES];
//	
//	// Free up the UI that was disabled until the new view data could be fetched
//	navigationController.view.userInteractionEnabled = YES;
//}



//
// ****************     Used by all views     ******************* //
//

- (void)addActivityIndicator:(UIView *)viewToUse label:(NSString *)label {
	
    [self addActivityIndicator:viewToUse label:label images:nil];
}

- (void)addActivityIndicator:(UIView *)viewToUse label:(NSString *)label images:(NSArray *)images {

    NSLog(@"Starting %s: currentActivityView retainCount: %u", __FUNCTION__, [DSActivityView currentActivityView].retainCount);

//    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    [DSBezelActivityView newActivityViewForView:viewToUse withLabel:label width:0 withImages:images];
    [DSActivityView currentActivityView].showNetworkActivityIndicator = YES;
	
//	[apool release];

    NSLog(@"Ending %s: currentActivityView retainCount: %u", __FUNCTION__, [DSActivityView currentActivityView].retainCount);
}

- (void)removeActivityIndicator {
    
    NSLog(@"Starting %s: currentActivityView retainCount: %u", __FUNCTION__, [DSActivityView currentActivityView].retainCount);
    
    [DSActivityView currentActivityView].showNetworkActivityIndicator = NO;
    [DSBezelActivityView removeViewAnimated:YES];

    NSLog(@"Ending %s: currentActivityView retainCount: %u", __FUNCTION__, [DSActivityView currentActivityView].retainCount);
}

//- (void)addProgressIndicator {
//	// This was provided from another example, but I haven't seen it work (not that it doesn't)	
//	NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
//	
//	[activityView startAnimating]; 
//	
//	[apool release];
//}
//
//- (void)removeProgressIndicator {
//	[activityView stopAnimating]; 
//}

- (NSArray *)createSearchAnimationArray {
    NSArray *images = [NSArray arrayWithObjects:
                       [UIImage imageNamed: @"flash_0.png"],
                       [UIImage imageNamed: @"flash_1.png"],
                       [UIImage imageNamed: @"flash_2.png"],
                       [UIImage imageNamed: @"flash_3.png"],
                       [UIImage imageNamed: @"flash_4.png"],
                       [UIImage imageNamed: @"flash_5.png"],
                       [UIImage imageNamed: @"flash_6.png"],
                       [UIImage imageNamed: @"flash_7.png"],
                       [UIImage imageNamed: @"flash_8.png"],
                       [UIImage imageNamed: @"flash_9.png"],
                       [UIImage imageNamed: @"flash_10.png"],
                       [UIImage imageNamed: @"flash_11.png"],
                       [UIImage imageNamed: @"flash_12.png"],
                       [UIImage imageNamed: @"flash_13.png"],
                       [UIImage imageNamed: @"flash_14.png"],
                       [UIImage imageNamed: @"flash_15.png"],
                       [UIImage imageNamed: @"flash_16.png"],
                       [UIImage imageNamed: @"flash_17.png"],
                       [UIImage imageNamed: @"flash_18.png"],
                       [UIImage imageNamed: @"flash_19.png"],
                       [UIImage imageNamed: @"flash_20.png"],
                       [UIImage imageNamed: @"flash_11.png"],
                       [UIImage imageNamed: @"flash_12.png"],
                       [UIImage imageNamed: @"flash_13.png"],
                       [UIImage imageNamed: @"flash_15.png"],
                       [UIImage imageNamed: @"flash_16.png"],
                       [UIImage imageNamed: @"flash_17.png"],
                       [UIImage imageNamed: @"flash_18.png"],
                       [UIImage imageNamed: @"flash_19.png"],
                       [UIImage imageNamed: @"flash_20.png"],
                       [UIImage imageNamed: @"flash_21.png"],
                       [UIImage imageNamed: @"flash_22.png"],
                       [UIImage imageNamed: @"flash_23.png"],
                       [UIImage imageNamed: @"flash_24.png"],
                       [UIImage imageNamed: @"flash_25.png"],
                       [UIImage imageNamed: @"flash_26.png"],
                       [UIImage imageNamed: @"flash_27.png"],
                       [UIImage imageNamed: @"flash_28.png"],
                       [UIImage imageNamed: @"flash_29.png"],
                       [UIImage imageNamed: @"flash_30.png"],
                       [UIImage imageNamed: @"flash_31.png"],
                       [UIImage imageNamed: @"flash_32.png"],
                       [UIImage imageNamed: @"flash_33.png"],
                       [UIImage imageNamed: @"flash_35.png"],
                       [UIImage imageNamed: @"flash_36.png"],
                       [UIImage imageNamed: @"flash_37.png"],
                       [UIImage imageNamed: @"flash_38.png"],
                       [UIImage imageNamed: @"flash_39.png"],
                       [UIImage imageNamed: @"flash_40.png"],
                       nil];
    
    return images;
}

// The reachability query
- (BOOL)connectedToNetwork  {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return 0;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    //below suggested by Ariel
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    NSURL *testURL = [NSURL URLWithString:@"http://www.ukuzoo.com/"]; //comment by friendlydeveloper: maybe use www.google.com
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    //NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:nil]; //suggested by Ariel
    NSURLConnection *testConnection = [[[NSURLConnection alloc] initWithRequest:testRequest delegate:nil] autorelease]; //modified by friendlydeveloper
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

- (void)sendNotConnectedMessage {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Network Error" message: @"There is no network avaliable.  This app requires a network connection.  Please try again later" delegate: self cancelButtonTitle: @"ok"  otherButtonTitles: nil];
    [alert show];
    [alert release];    
}

- (void)dealloc {
    [window release];
    
	[navigationController release];
	[rootViewController release];
    [dazzViewController release];
	[searchViewController release];
	[collectionViewController release];
	[carouselViewController release];
	[itemViewController release];
    
    //	[activityView release];
    //	[collectionViewController release];
    //	[webViewController release];
    //	[ebayItemViewController release];

//    [location release];
//    [locationManager release];
    
//    [locationMeasurements release];
//    [bestEffortAtLocation release];
    
    
	[super dealloc];
}

@end
