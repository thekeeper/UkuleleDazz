//
//  UkuleleDazzAppDelegate.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/25/09.
//  Copyright Terry Tucker 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SharedTypes.h"

@class DazzViewController;
@class SearchViewController;
@class CollectionViewController;
@class ItemViewController;
@class CarouselViewController;
@class DazzCollection;
@class DazzItem;
@class Dazz;
@class DSBezelActivityView;
@class Reachability;

//@class TabItemViewController;
//@class EbayItemViewController;
//@class WebViewController;


@interface UkuleleDazzAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    UIWindow *window;
	
	// navigation controller
	UINavigationController *navigationController;
	
	// view controllers
	UIViewController *rootViewController;
	DazzViewController *dazzViewController;
	SearchViewController *searchViewController;
	CollectionViewController *collectionViewController;
	ItemViewController *itemViewController;
	CarouselViewController *carouselViewController;
    //	TabItemViewController *tabItemViewController;
    //	EbayItemViewController *ebayItemViewController;
    //	WebViewController *webViewController;
	
	// buttons
	UIButton *collectionButton;
	UIButton *searchButton; 
	
	// This is the wait indicator 
	UIActivityIndicatorView *activityView;
    
    // Reachability info:
    
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;

	
	// Location info:
//	CLLocation *location;
//	CLLocationManager *locationManager;
//    NSMutableArray *locationMeasurements;
//    CLLocation *bestEffortAtLocation;
    
    // How we get our data
    DataStoreType dataStoreType;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

// view controllers
@property (nonatomic, retain) IBOutlet UIViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DazzViewController *dazzViewController;
@property (nonatomic, retain) IBOutlet SearchViewController *searchViewController;
@property (nonatomic, retain) IBOutlet CollectionViewController *collectionViewController;
@property (nonatomic, retain) IBOutlet ItemViewController *itemViewController;
@property (nonatomic, retain) IBOutlet CarouselViewController *carouselViewController;

//@property (nonatomic, retain) IBOutlet TabItemViewController *tabItemViewController;
//@property (nonatomic, retain) IBOutlet EbayItemViewController *ebayItemViewController;
//@property (nonatomic, retain) IBOutlet WebViewController *webViewController;

// buttons
@property (nonatomic, retain) IBOutlet UIButton *collectionButton;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;

// Location info:
//@property (nonatomic, retain) CLLocation *location;
//@property (nonatomic, retain) CLLocationManager *locationManager;

// Data Store selection
@property (assign, nonatomic) DataStoreType dataStoreType;

// Checks network for connectivity
- (BOOL)connectedToNetwork;
- (void)sendNotConnectedMessage;

// Turns off the energy hog location service
//- (void)stopUpdatingLocation:(NSString *)state;

// Once the connection is made in IB, this can be deleted if it is defined below
- (IBAction)goToSearchView;

//- (void)addProgressIndicator;
//- (void)removeProgressIndicator;

- (void)addActivityIndicator:(UIView *)viewToUse label:(NSString *)message;
- (void)addActivityIndicator:(UIView *)viewToUse label:(NSString *)message images:(NSArray *)images;
- (void)removeActivityIndicator;
- (NSArray *)createSearchAnimationArray;

// These three (along with addProgressIndicator) get the data in a seperate thread while showing a wait rotator
- (void)goToDazzView;
- (void)getDazz;
- (void)pushDazzView: (Dazz *) dazz;

// These three (along with addProgressIndicator) get the data in a seperate thread while showing a wait rotator
- (void)goToSearchView;
- (void)getDazzSearch;
- (void)pushSearchView: (DazzCollection *) dazzCollection;

// These three (along with addProgressIndicator) get the data in a seperate thread while showing a wait rotator
//- (void)goToTabItemView: (DazzItem *) dazzItem;
//- (void)getTabItems: (DazzItem *) dazzItem;
//- (void)pushTabItemView: (DazzItem *) dazzItem;

// These three (along with addProgressIndicator) get the data in a seperate thread while showing a wait rotator
- (void)goToCollectionView: (DazzCollection *) dazzCollection;
- (void)getDazzCollection: (DazzCollection *)dazzCollection;
- (void)pushDazzCollectionView: (DazzCollection *) dazzCollection;

// These three (along with addProgressIndicator) get the data in a seperate thread while showing a wait rotator
- (void)goToDazzItemViewFromSearch: (DazzItem *) dazzItem;
- (void)getdazzItemsFromSearch: (DazzItem *) dazzItem;
//- (void)pushItemView: (DazzCollection *) dazzCollection; We use the same one used by getDazzCollection (from Collections)

// These three (along with addProgressIndicator) get the data in a seperate thread while showing a wait rotator
//- (void)goToEbayItemViewFromSearch: (DazzItem *) dazzItem;
//- (void)getEbayItemsFromSearch: (DazzItem *) dazzItem;
//- (void)pushEbayItemView: (dazDazzCollection *) dazzCollection;

// These three (along with addProgressIndicator) get the data in a seperate thread while showing a wait rotator
- (void)goToDetailView: (DazzItem *) dazzItem;
//- (void)getDazzDetail: (DazzItem *) dazzItem;
- (void)pushDetailView: (DazzItem *) dazzItem;

// These three (along with addProgressIndicator) get the data in a seperate thread while showing a wait rotator
//- (void)goToWebView: (NSString *) uri;
//- (void)getWeb: (NSString *) uri;
//- (void)pushWebView: (NSString *) uri;

// These three (along with addProgressIndicator) get the data in a seperate thread while showing a wait rotator
- (void)goToPhotoView: (NSMutableArray*) pathArray;
- (void)getDazzPhotos: (NSMutableArray*) pathArray;
- (void)pushPhotoView: (NSMutableArray*) pathArray;

@end

