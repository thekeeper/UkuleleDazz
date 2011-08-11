//
//  PhotoViewController.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 7/19/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoViewController : UIViewController <UIScrollViewDelegate> {
    
    UIScrollView *imageScrollView;
    UIImageView *imageView;
    UIImage *image;
}

@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;

- (id)initWithImage:(UIImage *)firstImage;
- (void) updateImage:(UIImage *)newImage;

@end
