//
//  CarouselViewController.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 7/8/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import "CarouselViewController.h"
#import "SharedConversions.h"
#import "UkuleleDazzAppDelegate.h"
#import "PhotoViewController.h"

//#define NUMBER_OF_ITEMS 20
#define ITEM_SPACING 210
#define USE_BUTTONS NO


@interface CarouselViewController () <UIActionSheetDelegate>

@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, retain) NSMutableArray *items;

@end


@implementation CarouselViewController

@synthesize carousel;
@synthesize navItem;
@synthesize wrap;
@synthesize items;
@synthesize photoViewController;

- (UIImage *)initImageForView:(NSString *)fullPath {
	
	NSURL *url = [NSURL URLWithString: fullPath];
	NSData *imageData = [NSData dataWithContentsOfURL: url];
	UIImage *newImage = [[UIImage alloc] initWithData: imageData];
    
//    NSLog(@"Normal: newImage.width = %f, newImage.height = %f", newImage.size.width, newImage.size.height);
    
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) {
        CGImageRef ref = [newImage CGImage];
        [newImage initWithCGImage:ref scale:2.0 orientation:UIImageOrientationUp];
        
//        NSLog(@"Retina: newImage.width = %f, newImage.height = %f", newImage.size.width, newImage.size.height);

    }
    
	return newImage;
}

- (void)dealloc
{
    [carousel release];
    carousel.delegate = nil; // Ensures subsequent delegate method calls won't crash
    carousel = nil;     // Releases if @property (retain)
    
    [navItem release];
    navItem = nil;
    
    [photoViewController release];
    photoViewController = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    wrap = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
    self.navItem = nil;
    self.photoViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}

- (IBAction)switchCarouselType
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Carousel Type"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Linear", @"Rotary", @"Inverted Rotary", @"Cylinder", @"Inverted Cylinder", @"CoverFlow", @"Custom", nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (IBAction)toggleWrap
{
    wrap = !wrap;
    navItem.rightBarButtonItem.title = wrap? @"Wrap: ON": @"Wrap: OFF";
    [carousel reloadData];
}

- (IBAction)insertItem
{
    NSInteger index = carousel.currentItemIndex;
    [items insertObject:[NSNumber numberWithInt:carousel.numberOfItems] atIndex:index];
    [carousel insertItemAtIndex:index animated:YES];
}

- (IBAction)removeItem
{
    if (carousel.numberOfItems > 0)
    {
        NSInteger index = carousel.currentItemIndex;
        [carousel removeItemAtIndex:index animated:YES];
        [items removeObjectAtIndex:index];
    }
}

#pragma mark -
#pragma mark UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //restore view opacities to normal
	NSArray *allViews = [carousel.itemViews arrayByAddingObjectsFromArray:carousel.placeholderViews];
    for (UIView *view in allViews)
    {
        view.alpha = 1.0;
    }
    
    carousel.type = buttonIndex;
    navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    // Scale the image for this view, but keep the original
    UIImage *savedImage = (UIImage *)[items objectAtIndex: index];
    
    UIImage *smallImage = [[UIImage alloc] initWithCGImage: savedImage.CGImage scale:2.0f orientation: UIImageOrientationUp];
    
    // Make this into a button
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, smallImage.size.width, smallImage.size.height)] autorelease];
    [button setBackgroundImage:smallImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed if wrapping is disabled
	return 2;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index
{
	//create a placeholder view
	UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]] autorelease];
	UILabel *label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
	label.text = (index == 0)? @"[": @"]";
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [label.font fontWithSize:50];
	[view addSubview:label];
	return view;
}

- (float)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(float)offset
{
    //implement 'flip3D' style carousel
    
    //set opacity based on distance from camera
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    //do 3d transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return wrap;
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
//	NSLog(@"Carousel will begin dragging");
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
//	NSLog(@"Carousel did end dragging and %@ decelerate", decelerate? @"will": @"won't");
}

- (void)carouselWillBeginDecelerating:(iCarousel *)carousel
{
//	NSLog(@"Carousel will begin decelerating");
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
//	NSLog(@"Carousel did end decelerating");
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
//	NSLog(@"Carousel will begin scrolling");
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
//	NSLog(@"Carousel did end scrolling");
}

- (void)carousel:(iCarousel *)_carousel didSelectItemAtIndex:(NSInteger)index
{
    
    // I should get this mechanism to work and ditch the button method
//	if (index == carousel.currentItemIndex)
//	{
//		//note, this will only ever happen if USE_BUTTONS == NO
//		//otherwise the button intercepts the tap event
//		NSLog(@"Selected current item");
//	}
//	else
//	{
//		NSLog(@"Selected item number %i", index);
//	}
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
    // When a carousel image is tapped it will invoke this method
    // This method loads an image view that can be pinched, zoomed, and zoomed to fit, to see the full size of the picture
    NSInteger index = [carousel.itemViews indexOfObject:sender];
    UIImage *savedImage = (UIImage *)[items objectAtIndex: index];
    
    if (photoViewController == nil) {

        // This initWithImage doesn't init with the image
        PhotoViewController *viewController = [[PhotoViewController alloc] initWithImage:savedImage];
        
        self.photoViewController = viewController;
        [viewController release];
    }
    else {
        // When the photoViewController gets created, above, its viewDidLoad will set the image and the scroll params
        // Second time through we have to do it here
        [photoViewController updateImage: savedImage];
    }
    
    UkuleleDazzAppDelegate *appDelegate = (UkuleleDazzAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController pushViewController:photoViewController animated:YES];
}

// This will save the path array and return when the first image is loaded
- (void)initImages:(NSMutableArray *)array { 
    // Initialize the photo set
    self.items = [[NSMutableArray alloc] initWithCapacity: array.count];
    for (int i = 0; i < array.count; i++) {
        NSString *imageFileName = [array objectAtIndex: i];
        if ( ![imageFileName isKindOfClass: [NSNull class]]) {
            NSString *fullPath = [SharedConversions fullPathForImage: imageFileName];
            
            UIImage *image = [self initImageForView: fullPath];

            if (image != nil) {
                [[self items] addObject: image];
            }
        }
    }
}


@end
