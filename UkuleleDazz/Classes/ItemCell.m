//
//  ItemCell.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 1/1/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//
// The ItemCell is to display one item in a collection

#import "ItemCell.h"

// This is here for access to the sort info
#import "DazzItem.h"
#import "UkuleleDazzAppDelegate.h"

@implementation ItemCell

@synthesize dazzItem;
@synthesize topLeftLabel, topRightLabel, bottomLeftLabel, bottomRightLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ( (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier  ]) ) {
		
		// Create label views to contain the various pieces of text that make up the cell.
		// Add these as subviews of the contentView.
		
		UIView *myContentView = self.contentView;
		
		topLeftLabel = [self newLabelForMainText:YES];
		topLeftLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview: topLeftLabel];
		[topLeftLabel release];
		
		bottomLeftLabel = [self newLabelForMainText:NO];
		bottomLeftLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview: bottomLeftLabel];
		[bottomLeftLabel release];
		
		topRightLabel = [self newLabelForMainText:YES];
		topRightLabel.textAlignment = UITextAlignmentRight;
		[myContentView addSubview: topRightLabel];
		[topRightLabel release];
		
		bottomRightLabel = [self newLabelForMainText:NO];
		bottomRightLabel.textAlignment = UITextAlignmentRight;
		[myContentView addSubview: bottomRightLabel];
		[bottomRightLabel release];
		
		// Add an image view to display a picture
		UIImage *thumbnailImage = [[UIImage imageNamed:@"DefaultThumbnailImage.png"] retain];
		imageView = [[UIImageView alloc] initWithImage: thumbnailImage];
		
		[myContentView addSubview:imageView];

		[thumbnailImage release];
		[imageView release];
	}
	return self;
}

- (UILabel *)newLabelForMainText:(BOOL)main {
	/*
	 Create and configure a label view for main or secondary text.
	 Use a default frame as the views will be laid out in layoutSubviews
	 */
	
	/*
	 Colors for the main text and secondary text, in selected and unselected forms
	 When the cell is (un)selected, the labels' highlighted flag will be set acordingly
	 (see setSelected:animated:).
	 Set the background color to clear so highlighting shows correctly
	 */
	UIColor *primaryColor, *selectedColor;
	UIFont *font;
	
	if (main) {
		primaryColor = [UIColor blackColor];
		selectedColor = [UIColor whiteColor];
		font = [UIFont systemFontOfSize: 14];
	} else {
		primaryColor = [UIColor darkGrayColor];
		selectedColor = [UIColor lightGrayColor];
		font = [UIFont systemFontOfSize: 12];
	}		
	// Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults. 
	// To show selection properly, however, the views need to be transparent (so that the selection color shows through).  
	// This is handled in setSelected:animated:.
	
	UILabel *newLabel = [[UILabel alloc] initWithFrame: CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	// Views are drawn most efficiently when they are opaque and do not have a clear background, 
	// so in newLabelForMainText: the labels are made opaque and given a white background.  
	//To show selection properly, however, the views need to be transparent (so that the selection color shows through).  
	
	[super setSelected:selected animated:animated];
	
	UIColor *backgroundColor = nil;
	
	// These are for testing
	//	UIColor *backgroundColor1 = nil;
	//	UIColor *backgroundColor2 = nil;
	//	UIColor *backgroundColor3 = nil;
	//	UIColor *backgroundColor4 = nil;
	if (selected) {
	    backgroundColor = [UIColor clearColor];
	} else {
		backgroundColor = [UIColor whiteColor];
		//		backgroundColor1 = [UIColor lightGrayColor];
		//		backgroundColor2 = [UIColor greenColor];
		//		backgroundColor3 = [UIColor yellowColor];
		//		backgroundColor4 = [UIColor grayColor];
	}
	
	topLeftLabel.backgroundColor = backgroundColor;
	topLeftLabel.highlighted = selected;
	topLeftLabel.opaque = !selected;
	
	topRightLabel.backgroundColor = backgroundColor;
	topRightLabel.highlighted = selected;
	topRightLabel.opaque = !selected;
	
	bottomLeftLabel.backgroundColor = backgroundColor;
	bottomLeftLabel.highlighted = selected;
	bottomLeftLabel.opaque = !selected;
	
	bottomRightLabel.backgroundColor = backgroundColor;
	bottomRightLabel.highlighted = selected;
	bottomRightLabel.opaque = !selected;
}


- (void)dealloc {
	[dazzItem dealloc];
	[super dealloc];
}

- (void)layoutSubviews {
	
#define LEFT_COLUMN_OFFSET 70
#define LEFT_COLUMN_WIDTH 90
	
#define MIDDLE_COLUMN_OFFSET 160
#define MIDDLE_COLUMN_WIDTH 110
	
//#define RIGHT_COLUMN_OFFSET 270
	
#define UPPER_ROW_TOP 6
#define LOWER_ROW_TOP 28
	
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		
		frame = CGRectMake(boundsX + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, LEFT_COLUMN_WIDTH, 18);
		topLeftLabel.frame = frame;
		
		frame = CGRectMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP, LEFT_COLUMN_WIDTH, 14);
		bottomLeftLabel.frame = frame;
		
		frame = CGRectMake(boundsX + MIDDLE_COLUMN_OFFSET, UPPER_ROW_TOP, 90, 18);
		topRightLabel.frame = frame;
		
		frame = CGRectMake(boundsX + MIDDLE_COLUMN_OFFSET, LOWER_ROW_TOP, 90, 14);
		bottomRightLabel.frame = frame;
		
		frame = [imageView frame];
		frame.origin.x = boundsX + 10;
		frame.origin.y = UPPER_ROW_TOP - 2;
		frame.size.height = 35;
		frame.size.width = 43;
 		imageView.frame = frame;
	}
}

- (void)setDazzItem:(DazzItem *)newDazzItem {
	
	if (dazzItem != newDazzItem) {
		[dazzItem release];
		dazzItem = [newDazzItem retain];
	}	
	
	// Update values in subviews
	
	switch (firstSortType) {
		case ItemModel:
			topLeftLabel.text = dazzItem.brand;
			bottomLeftLabel.text = dazzItem.maker;
			topRightLabel.text = dazzItem.size;
			bottomRightLabel.text = dazzItem.vintage;
			break;
		case ItemSize:
			topLeftLabel.text = dazzItem.brand;
			bottomLeftLabel.text = dazzItem.maker;
			topRightLabel.text = dazzItem.model;
			bottomRightLabel.text = dazzItem.vintage;
			break;
		case ItemMaker:
			topLeftLabel.text = dazzItem.brand;
            bottomLeftLabel.text = dazzItem.model;
			topRightLabel.text = dazzItem.size;
			bottomRightLabel.text = dazzItem.vintage;
			break;
		case ItemBrand:
		default:
			topLeftLabel.text = dazzItem.maker;
            bottomLeftLabel.text = dazzItem.model;
			topRightLabel.text = dazzItem.size;
			bottomRightLabel.text = dazzItem.vintage;
			break;
	}
	
    if (dazzItem.thumbnailImage) {
        imageView.image = dazzItem.thumbnailImage;
    }
	
	/*
	 If something changed that would affect, say, which subviews should be displayed, call:
	 [self setNeedsLayout];
	 */
}

- (void)setSortTypes: (ItemFieldType)firstType 
      secondSortType: (ItemFieldType)secondType 
	   thirdSortType: (ItemFieldType)thirdType {
	
	firstSortType = firstType;
	secondSortType = secondType;
	thirdSortType = thirdType;
}

@end
