 //
//  PhotoViewController.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 7/19/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import "PhotoViewController.h"


#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

@interface PhotoViewController (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end


@implementation PhotoViewController

@synthesize image;
@synthesize imageScrollView;
@synthesize imageView;

- (id)initWithImage:(UIImage *)firstImage {
	
    [self.imageView setImage:firstImage];

    // loading the nib here
    if ( (self = [super initWithNibName:@"PhotoView" bundle:nil]) ) {
		[self setImage: firstImage];
	}
	
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.imageView setUserInteractionEnabled:YES];
        [self.imageView setMultipleTouchEnabled:YES];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/*
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.imageView setImage: self.image];
        
    // set the tag for the image view
    [imageView setTag:ZOOM_VIEW_TAG];
    
    // add gesture recognizers to the image view
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    [imageView addGestureRecognizer:singleTap];
    [imageView addGestureRecognizer:doubleTap];
    [imageView addGestureRecognizer:twoFingerTap];
    
    [singleTap release];
    [doubleTap release];
    [twoFingerTap release];
    
    // Set the scrollview frame to act below the toolbar
    CGRect scrollFrame = imageScrollView.frame;
    scrollFrame.size.height = scrollFrame.size.height - 44; //toolbar.frame.size.height;
    imageScrollView.frame = scrollFrame;
    
    // calculate minimum scale to perfectly fit largest dimension, and begin at that scale
    CGSize imageScrollViewSize = [imageScrollView frame].size;
    CGSize imageSize = [imageView image].size;
    
    float minimumWidthScale = imageScrollViewSize.width  / imageSize.width;
    float minimumHeightScale = imageScrollViewSize.height  / imageSize.height;
    float minimumScale = (minimumWidthScale < minimumHeightScale) ? minimumWidthScale : minimumHeightScale;
    
    [imageScrollView setMinimumZoomScale:minimumScale];
    [imageScrollView setZoomScale:minimumScale];
}

//- (void)loadView {
//    [super loadView];
//    
//    // set the tag for the image view
//    [imageView setTag:ZOOM_VIEW_TAG];
//    
//    // add gesture recognizers to the image view
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
//    
//    [doubleTap setNumberOfTapsRequired:2];
//    [twoFingerTap setNumberOfTouchesRequired:2];
//    
//    [imageView addGestureRecognizer:singleTap];
//    [imageView addGestureRecognizer:doubleTap];
//    [imageView addGestureRecognizer:twoFingerTap];
//    
//    [singleTap release];
//    [doubleTap release];
//    [twoFingerTap release];
//    
//    
//    // calculate minimum scale to perfectly fit largest dimension, and begin at that scale
//    float minimumWidthScale = [imageScrollView frame].size.width  / [imageView frame].size.width;
//    float minimumHeightScale = [imageScrollView frame].size.height  / [imageView frame].size.height;
//    float minimumScale = (minimumWidthScale < minimumHeightScale) ? minimumWidthScale : minimumHeightScale;
//
//    [imageScrollView setMinimumZoomScale:minimumScale];
//    [imageScrollView setZoomScale:minimumScale];
//}


- (void)viewDidUnload {
	self.imageScrollView = nil;
	self.imageView = nil;
}


- (void)dealloc {
    [imageScrollView release];
	[imageView release];
    [super dealloc];
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [imageScrollView viewWithTag:ZOOM_VIEW_TAG];
}


//-************************************** NOTE **************************************
//-* The following delegate method works around a known bug in zoomToRect:animated: *
//-* In the next release after 3.0 this workaround will no longer be necessary      *
//-**********************************************************************************

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}


#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // double tap zooms in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
*/

- (void) updateImage:(UIImage *)newImage {
    
    [self.imageView setImage: newImage];

    CGSize imageSize = [[imageView image] size];
    CGSize viewSize = imageScrollView.bounds.size;
    float widthRatio = viewSize.width / imageSize.width;
    float heightRatio = viewSize.height / imageSize.height;
    float minZoomRatio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    
    imageScrollView.minimumZoomScale = 1.0; //minZoomRatio; newImage.scale; //
    imageScrollView.maximumZoomScale = newImage.scale / minZoomRatio; //1 / minZoomRatio;
    imageScrollView.zoomScale = 1.0; //minZoomRatio;
    imageScrollView.contentSize = CGSizeMake(imageSize.width, imageSize.height);
    imageScrollView.delegate=self;
    
//    NSLog(@"imageSize.x = %f, imageSize.y = %f, viewSize.x = %f, viewSize.y = %f",
//          imageSize.width,
//          imageSize.height,
//          viewSize.width,
//          viewSize.height);
//          
//    NSLog(@"imageScrollView: minimumZoomScale=%f maximumZoomScale=%f zoomScale=%f contentSize=(%f,%f)",           
//          imageScrollView.minimumZoomScale,
//          imageScrollView.maximumZoomScale,
//          imageScrollView.zoomScale,
//          imageScrollView.contentSize.width,
//          imageScrollView.contentSize.height);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateImage: self.image];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || 
            interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - Gesture handlers

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (CGRect)zoomRectForScrollView:(UIScrollView *)theScrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    // Call this in response to a single tap event.  The center point should center in the view.
    // The scale will have to be calculated, but make it result in the native size of the image.
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = theScrollView.frame.size.height / scale;
    zoomRect.size.width  = theScrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Cancel any pending handleSingleTap messages.
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(handleSingleTap)
                                               object:nil];
    
    // Update the touch state.
    if ([[event touchesForView:self] count] > 1)
        multipleTouches = YES;
    if ([[event touchesForView:self] count] > 2)
        twoFingerTapIsPossible = NO;
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self] count]);
    
    // first check for plain single/double tap, which is only possible if we haven't seen multiple touches
    if (!multipleTouches) {
        UITouch *touch = [touches anyObject];
        tapLocation = [touch locationInView:self];
        
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(handleSingleTap)
                       withObject:nil
                       afterDelay:DOUBLE_TAP_DELAY];
        } else if([touch tapCount] == 2) {
            [self handleDoubleTap];
        }
    }
    
    // Check for a 2-finger tap if there have been multiple touches
    // and haven't that situation has not been ruled out
    else if (multipleTouches && twoFingerTapIsPossible) {
        
        // case 1: this is the end of both touches at once
        if ([touches count] == 2 && allTouchesEnded) {
            int i = 0;
            int tapCounts[2];
            CGPoint tapLocations[2];
            for (UITouch *touch in touches) {
                tapCounts[i] = [touch tapCount];
                tapLocations[i] = [touch locationInView:self];
                i++;
            }
            if (tapCounts[0] == 1 && tapCounts[1] == 1) {
                // it's a two-finger tap if they're both single taps
                tapLocation = midpointBetweenPoints(tapLocations[0],
                                                    tapLocations[1]);
                [self handleTwoFingerTap];
            }
        }
        
        // Case 2: this is the end of one touch, and the other hasn't ended yet
        else if ([touches count] == 1 && !allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // If touch is a single tap, store its location
                // so it can be averaged with the second touch location
                tapLocation = [touch locationInView:self];
            } else {
                twoFingerTapIsPossible = NO;
            }
        }
        
        // Case 3: this is the end of the second of the two touches
        else if ([touches count] == 1 && allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if the last touch up is a single tap, this was a 2-finger tap
                tapLocation = midpointBetweenPoints(tapLocation,
                                                    [touch locationInView:self]);
                [self handleTwoFingerTap];
            }
        }
    }
    
    // if all touches are up, reset touch monitoring state
    if (allTouchesEnded) {
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    twoFingerTapIsPossible = YES;
    multipleTouches = NO;
}
*/

@end
