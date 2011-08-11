//
//  CarouselViewController.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 7/8/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@class DazzItem;
@class PhotoViewController;

@interface CarouselViewController : UIViewController <iCarouselDataSource, iCarouselDelegate> {
    PhotoViewController *photoViewController;
}

@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (nonatomic, retain) IBOutlet PhotoViewController *photoViewController;


- (IBAction)switchCarouselType;
- (IBAction)toggleWrap; 
- (IBAction)insertItem;
- (IBAction)removeItem;

- (void)initImages:(NSMutableArray *)array;
- (UIImage *)initImageForView:(NSString *)fullPath;

@end
