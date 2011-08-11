//
//  ImageCell.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 2/14/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageCell : UITableViewCell {
	
	UIImageView *imageView;
	UIImage *image;
	CGSize imageSize;
	
	// So we can set it to clear
    UIColor *cellColor;
}

@property (assign, nonatomic) CGSize imageSize;
@property(nonatomic,retain) UIImage  *image;

	// These two are used to set the background of the cell to clear.
- (void) setCellColor: (UIColor*)color;
- (void) colorAllSubviews: (UIView*)ownerView backgroundColor: (UIColor*)color ;

@end
