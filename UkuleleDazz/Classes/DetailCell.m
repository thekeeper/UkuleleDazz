//
//  DetailCell.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 1/25/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "DetailCell.h"
#import "UkuleleDazzAppDelegate.h"
#import "DazzItem.h"
#import "SharedConversions.h"

@implementation DetailCell

// For the image at the top:
@synthesize image;
@synthesize imageSize;

@synthesize dazzItem;

@synthesize itemNoLabel;
@synthesize lineLabel;
@synthesize firstLabel;
@synthesize secondLabel;
@synthesize thirdLabel;
@synthesize fourthLabel;
@synthesize fifthLabel;
@synthesize sixthLabel;

@synthesize itemNoText;
@synthesize firstText;
@synthesize secondText;
@synthesize thirdText;
@synthesize fourthText;
@synthesize fifthText;
@synthesize sixthText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ( (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier  ]) ) {
		
		// Add these as subviews of the contentView.		
		UIView *myContentView = self.contentView;
		
        // Make the image at the top a button to launch the image carousel
        
        // Make this into a button
		UIImage *detailImage = [[UIImage imageNamed:@"DefaultDetailImage.png"] retain];
        imageButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, detailImage.size.width, detailImage.size.height)] autorelease];
        [imageButton setBackgroundImage:detailImage forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(showPhotos:) forControlEvents:UIControlEventTouchUpInside];
        [myContentView addSubview:imageButton];

		// For the image at the top:
//		UIImage *detailImage = [[UIImage imageNamed:@"DefaultDetailImage.png"] retain];
//		imageView = [[UIImageView alloc] initWithImage: detailImage];
//		[myContentView addSubview:imageView];
		
		[detailImage release];
//		[imageView release];

		// Create label views to contain the various pieces of text description below the image.	
        
		lineLabel = [self newLabelForMainText:NO];
		lineLabel.textAlignment = UITextAlignmentLeft;
        lineLabel.backgroundColor = [UIColor colorWithWhite: 0.9f alpha:1.0f];
		[myContentView addSubview: lineLabel];
		[lineLabel release];
		
		itemNoLabel = [self newLabelForMainText:NO];
		itemNoLabel.textAlignment = UITextAlignmentLeft;
		itemNoLabel.text = @"Item No.";
		[myContentView addSubview: itemNoLabel];
		[itemNoLabel release];
		
		firstLabel = [self newLabelForMainText:NO];
		firstLabel.textAlignment = UITextAlignmentLeft;
		firstLabel.text = @"Brand";
		[myContentView addSubview: firstLabel];
		[firstLabel release];
		
		secondLabel = [self newLabelForMainText:NO];
		secondLabel.textAlignment = UITextAlignmentLeft;
		secondLabel.text = @"Maker";
		[myContentView addSubview: secondLabel];
		[secondLabel release];
		
		thirdLabel = [self newLabelForMainText:NO];
		thirdLabel.textAlignment = UITextAlignmentLeft;
		thirdLabel.text = @"Type";
		[myContentView addSubview: thirdLabel];
		[thirdLabel release];
		
		fourthLabel = [self newLabelForMainText:NO];
		fourthLabel.textAlignment = UITextAlignmentLeft;
		fourthLabel.text = @"Model";
		[myContentView addSubview: fourthLabel];
		[fourthLabel release];
		
		fifthLabel = [self newLabelForMainText:NO];
		fifthLabel.textAlignment = UITextAlignmentLeft;
		fifthLabel.text = @"Date";
		[myContentView addSubview: fifthLabel];
		[fifthLabel release];
		
		sixthLabel = [self newLabelForMainText:NO];
		sixthLabel.textAlignment = UITextAlignmentLeft;
		sixthLabel.text = @"Condition";
		[myContentView addSubview: sixthLabel];
		[sixthLabel release];
		
		// The content:
		
		itemNoText = [self newLabelForMainText:YES];
		itemNoText.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: itemNoText];
		[itemNoText release];
		
		firstText = [self newLabelForMainText:YES];
		firstText.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: firstText];
		[firstText release];
		
		secondText = [self newLabelForMainText:YES];
		secondText.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: secondText];
		[secondText release];
		
		thirdText = [self newLabelForMainText:YES];
		thirdText.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: thirdText];
		[thirdText release];
		
		fourthText = [self newLabelForMainText:YES];
		fourthText.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: fourthText];
		[fourthText release];
		
		fifthText = [self newLabelForMainText:YES];
		fifthText.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: fifthText];
		[fifthText release];
		
		sixthText = [self newLabelForMainText:YES];
		sixthText.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: sixthText];
		[sixthText release];
		
	}
	return self;
}

- (UILabel *)newLabelForMainText:(BOOL)main {
	 //Create and configure a label view for main or secondary text.
	 //Use a default frame as the views will be laid out in layoutSubviews

	 //Colors for the main text and secondary text, in selected and unselected forms
	 //When the cell is (un)selected, the labels' highlighted flag will be set acordingly
	 //(see setSelected:animated:).
	 //Set the background color to clear so highlighting shows correctly

	UIColor *primaryColor, *selectedColor;
	UIFont *font;
	
	if (main) {
		primaryColor = [UIColor blackColor];
		selectedColor = [UIColor whiteColor];
		font = [UIFont systemFontOfSize: 14];
	} else {
		primaryColor = [UIColor darkGrayColor];
		selectedColor = [UIColor lightGrayColor];
		font = [UIFont systemFontOfSize: 14];
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
//	// Views are drawn most efficiently when they are opaque and do not have a clear background, 
//	// so in newLabelForMainText: the labels are made opaque and given a white background.  
//	//To show selection properly, however, the views need to be transparent (so that the selection color shows through).  
//	
//	[super setSelected:selected animated:animated];
//	
//	UIColor *backgroundColor = nil;
//	
//	if (selected) {
//		// Until there is editing ability, I will keep the color white so the blue selection color does not show through
//	    backgroundColor = [UIColor whiteColor];
//	} else {
//		backgroundColor = [UIColor whiteColor];
//	}
//	
//	lineLabel.backgroundColor = [UIColor lightGrayColor];
//	lineLabel.highlighted = selected;
//	lineLabel.opaque = !selected;
//	
//	firstLabel.backgroundColor = backgroundColor;
//	firstLabel.highlighted = selected;
//	firstLabel.opaque = !selected;
//	
//	secondLabel.backgroundColor = backgroundColor;
//	secondLabel.highlighted = selected;
//	secondLabel.opaque = !selected;
//	
//	thirdLabel.backgroundColor = backgroundColor;
//	thirdLabel.highlighted = selected;
//	thirdLabel.opaque = !selected;
//	
//	fourthLabel.backgroundColor = backgroundColor;
//	fourthLabel.highlighted = selected;
//	fourthLabel.opaque = !selected;
//	
//	fifthLabel.backgroundColor = backgroundColor;
//	fifthLabel.highlighted = selected;
//	fifthLabel.opaque = !selected;
//	
//	// The actual data fields
//	
//	firstText.backgroundColor = backgroundColor;
//	firstText.highlighted = selected;
//	firstText.opaque = !selected;
//	
//	secondText.backgroundColor = backgroundColor;
//	secondText.highlighted = selected;
//	secondText.opaque = !selected;
//	
//	thirdText.backgroundColor = backgroundColor;
//	thirdText.highlighted = selected;
//	thirdText.opaque = !selected;
//	
//	fourthText.backgroundColor = backgroundColor;
//	fourthText.highlighted = selected;
//	fourthText.opaque = !selected;
//	
//	fifthText.backgroundColor = backgroundColor;
//	fifthText.highlighted = selected;
//	fifthText.opaque = !selected;
}


- (void)layoutSubviews {
	
#define EDGE_MARGIN_OFFSET 10
#define LABEL_WIDTH 80
#define TEXT_OFFSET 80
	
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
	// Editing is not allowed now, but this illustrates the appropriate pattern
    if (!self.editing) {
		
		CGFloat boundsX = contentRect.origin.x;
		CGFloat boundsWidth = contentRect.size.width;
		
		// ----  Layout the ImageView:
		
		CGSize frameSize = [SharedConversions getSizeForImageView: image];
		CGFloat originX = boundsX + (contentRect.size.width - frameSize.width) / 2;
		
		CGRect frame;
		frame = [imageButton frame];
		frame.origin.x = originX;
		frame.origin.y = VERTICAL_IMAGE_MARGIN;
		frame.size.height = frameSize.height;
		frame.size.width = frameSize.width;
		
		imageButton.frame = frame;
        [imageButton setBackgroundImage:image forState:UIControlStateNormal];
 

        // ---- Layout the Item No: field

		CGFloat labelStartY = VERTICAL_IMAGE_MARGIN + frameSize.height + VERTICAL_IMAGE_MARGIN;

		// ----  Draw the "line" separator
		
		frame = CGRectMake(boundsX + EDGE_MARGIN_OFFSET, labelStartY, boundsWidth - 2 * EDGE_MARGIN_OFFSET, 1);
		lineLabel.frame = frame;
		
		// Increment our labelStartY to account for the height of the label we just drew
		labelStartY += 1;
		// This is the usable width for the rest of the content
		boundsWidth -= EDGE_MARGIN_OFFSET * 2;
		
		// ----  Layout the information View
		
		
		CGFloat yOffset = VERTICAL_TEXT_MARGIN;
		frame = CGRectMake(boundsX + EDGE_MARGIN_OFFSET, labelStartY + yOffset, LABEL_WIDTH, 18);
		itemNoLabel.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + EDGE_MARGIN_OFFSET, labelStartY + yOffset, LABEL_WIDTH, 18);
		firstLabel.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + EDGE_MARGIN_OFFSET, labelStartY + yOffset, LABEL_WIDTH, 18);
		secondLabel.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + EDGE_MARGIN_OFFSET, labelStartY + yOffset, LABEL_WIDTH, 18);
		thirdLabel.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + EDGE_MARGIN_OFFSET, labelStartY + yOffset, LABEL_WIDTH, 18);
		fourthLabel.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + EDGE_MARGIN_OFFSET, labelStartY + yOffset, LABEL_WIDTH, 18);
		fifthLabel.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + EDGE_MARGIN_OFFSET, labelStartY + yOffset, LABEL_WIDTH, 18);
		sixthLabel.frame = frame;
		
		// Now do the db info part:
		
		yOffset = VERTICAL_TEXT_MARGIN;
		frame = CGRectMake(boundsX + TEXT_OFFSET, labelStartY + yOffset, boundsWidth - TEXT_OFFSET, 18);
		itemNoText.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + TEXT_OFFSET, labelStartY + yOffset, boundsWidth - TEXT_OFFSET, 18);
		firstText.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + TEXT_OFFSET, labelStartY + yOffset, boundsWidth - TEXT_OFFSET, 18);
		secondText.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + TEXT_OFFSET, labelStartY + yOffset, boundsWidth - TEXT_OFFSET, 18);
		thirdText.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + TEXT_OFFSET, labelStartY + yOffset, boundsWidth - TEXT_OFFSET, 18);
		fourthText.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + TEXT_OFFSET, labelStartY + yOffset, boundsWidth - TEXT_OFFSET, 18);
		fifthText.frame = frame;
		
        yOffset += ROW_SPACE;
		frame = CGRectMake(boundsX + TEXT_OFFSET, labelStartY + yOffset, boundsWidth - TEXT_OFFSET, 18);
		sixthText.frame = frame;
	}
}

- (void)setDazzItem:(DazzItem *)newDazzItem {
	
	if (dazzItem != newDazzItem) {
		[dazzItem release];
		dazzItem = [newDazzItem retain];
	}
	
	image = dazzItem.detailImage;
	
    itemNoText.text = dazzItem.itemId;
	firstText.text = dazzItem.brand;
	secondText.text = dazzItem.maker;
	thirdText.text = dazzItem.size;
	fourthText.text = dazzItem.model;
	fifthText.text = dazzItem.vintage;
	sixthText.text = dazzItem.condition;
	
	/*
	 If something changed that would affect, say, which subviews should be displayed, call:
	 [self setNeedsLayout];
	 */
}

- (void)showPhotos:(UIButton *)sender {
	UkuleleDazzAppDelegate *appDelegate = (UkuleleDazzAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate goToPhotoView: [self dazzItem].imagePaths];
}

- (void)dealloc {
	[dazzItem dealloc];
	[super dealloc];
}

@end
