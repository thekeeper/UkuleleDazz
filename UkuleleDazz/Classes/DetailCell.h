//
//  DetailCell.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 1/25/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedTypes.h"

#define PROPERTY_COUNT 7
#define VERTICAL_TEXT_MARGIN 5
#define VERTICAL_IMAGE_MARGIN 8
#define ROW_SPACE 22

@class DazzItem;

@interface DetailCell : UITableViewCell {

	// For the image at the top:
//	UIImageView *imageView;
    UIButton * imageButton;
	UIImage *image;
	CGSize imageSize;
	
	DazzItem *dazzItem;
	
	// This is a label that will be used as a line (?!)
	UILabel *lineLabel;
	
	// These are the static labels
    UILabel *itemNoLabel;
	UILabel *firstLabel;
	UILabel *secondLabel;
	UILabel *thirdLabel;
	UILabel *fourthLabel;
	UILabel *fifthLabel;
	UILabel *sixthLabel;
	
	// These are the text from the db that pair with the static labels
    UILabel *itemNoText;
	UILabel *firstText;
	UILabel *secondText;
	UILabel *thirdText;
	UILabel *fourthText;
	UILabel *fifthText;
    UILabel *sixthText;
}

// For the image at the top:
@property (assign, nonatomic) CGSize imageSize;
@property(nonatomic,retain) UIImage  *image;

@property (nonatomic, retain) DazzItem *dazzItem;
@property (nonatomic, assign) UILabel *lineLabel;
@property (nonatomic, assign) UILabel *itemNoLabel, *firstLabel, *secondLabel, *thirdLabel, *fourthLabel, *fifthLabel, *sixthLabel;
@property (nonatomic, assign) UILabel *itemNoText, *firstText, *secondText, *thirdText, *fourthText, *fifthText, *sixthText;

- (UILabel *)newLabelForMainText:(BOOL)main;
- (void)showPhotos:(UIButton *)sender;

@end
