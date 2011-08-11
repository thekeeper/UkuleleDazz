//
//  CollectionCell.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 7/2/08.
//  Copyright 2008 Terry Tucker. All rights reserved.
//
// The CollectionCell is to display one collection in the collection list

#import "CollectionCell.h"
#import "DazzItem.h"
#import "DazzCollection.h"
#import "UkuleleDazzAppDelegate.h"

@implementation CollectionCell

@synthesize topLeftLabel, topRightLabel, bottomLeftLabel, bottomRightLabel;
@synthesize dazzCollection;

//- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
//	if (self = [super initWithFrame:frame initWithStyle:UITableViewStylePlain ]) {
		
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ( (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier  ]) ) {
		// Create label views to contain the various pieces of text that make up the cell.
		// Add these as subviews of the contentView.
		
		UIView *myContentView = self.contentView;
		
		topLeftLabel = [self newLabelForMainText:YES];
		topLeftLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview: topLeftLabel];
		[topLeftLabel release];
		
		topRightLabel = [self newLabelForMainText:NO];
		topRightLabel.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: topRightLabel];
		[topRightLabel release];
		
		bottomLeftLabel = [self newLabelForMainText:NO];
		bottomLeftLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview: bottomLeftLabel];
		[bottomLeftLabel release];
		
		// ********************
//		CGRect newFrame = CGRectMake(0.0, 0.0, 10.0, 10.0);
//		imageView.frame = newFrame;
		// ********************
		
		[myContentView addSubview:imageView];
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
		font = [UIFont systemFontOfSize: 18];
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
}


- (void)dealloc {
	[dazzCollection release];
	[super dealloc];
}


- (void)layoutSubviews {
	
#define UPPER_ROW_OFFSET 10
#define UPPER_ROW_WIDTH 250
	
#define LEFT_COLUMN_OFFSET 70
#define LEFT_COLUMN_WIDTH 90
	
#define MIDDLE_COLUMN_OFFSET 160
#define MIDDLE_COLUMN_WIDTH 110
	
#define RIGHT_COLUMN_OFFSET 250 //270
	
#define UPPER_ROW_TOP 6
#define LOWER_ROW_TOP 28
	
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
	// We don't have an edit mode now, but would like to later
    if (!self.editing) {
		
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		
		frame = CGRectMake(boundsX + UPPER_ROW_OFFSET, UPPER_ROW_TOP, UPPER_ROW_WIDTH, 18);
		topLeftLabel.frame = frame;
		
		frame = CGRectMake(boundsX + RIGHT_COLUMN_OFFSET, UPPER_ROW_TOP, UPPER_ROW_WIDTH, 18);
		topRightLabel.frame = frame;
		
		frame = CGRectMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP, LEFT_COLUMN_WIDTH, 14);
		bottomLeftLabel.frame = frame;
		
		frame = [imageView frame];
		frame.origin.x = boundsX + 10; //RIGHT_COLUMN_OFFSET;
		frame.origin.y = UPPER_ROW_TOP;
		frame.size.height = 30;
		frame.size.width = 38;
 		imageView.frame = frame;
	}
}

- (void)setDazzCollection:(DazzCollection *)newDazzCollection {
	
	if (dazzCollection != newDazzCollection) {
		dazzCollection = [newDazzCollection retain];
	}	

	topLeftLabel.text = [dazzCollection name];
	topRightLabel.text = [NSString stringWithFormat: @"(%@)", [dazzCollection itemCount]];
    
    bottomLeftLabel.text = @"";
    if (dazzCollection.privateName == NO) {
        bottomLeftLabel.text = [dazzCollection collector] ;
    }
	
	/*
	 If something changed that would affect, say, which subviews should be displayed, call:
	 [self setNeedsLayout];
	 */
}

//- (void)setSortTypes: (CollectionFieldType)firstType 
//      secondSortType: (CollectionFieldType)secondType 
//	   thirdSortType: (CollectionFieldType)thirdType {
//	
//	firstSortType = firstType;
//	secondSortType = secondType;
//	thirdSortType = thirdType;
//}

@end
