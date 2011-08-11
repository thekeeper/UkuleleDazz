//
//  SearchFieldCell.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 3/21/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "SearchFieldCell.h"


@implementation SearchFieldCell

@synthesize nameLabel;
@synthesize valueLabel;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) )
    {
//        [self setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // Add these as subviews of the contentView.
		
		UIView *myContentView = self.contentView;
		
		nameLabel = [self newLabelForMainText: NO];
		nameLabel.textAlignment = UITextAlignmentLeft;
		nameLabel.text = @"";
		[myContentView addSubview: nameLabel];
		[nameLabel release];
		
		valueLabel = [self newLabelForMainText: YES];
		valueLabel.textAlignment = UITextAlignmentLeft;
		valueLabel.text = @"";
		[myContentView addSubview: valueLabel];
		[valueLabel release];
    }
    return self;
}

- (UILabel *)newLabelForMainText:(BOOL)main {
//	 Colors for the main text and secondary text, in selected and unselected forms
//	 When the cell is (un)selected, the labels' highlighted flag will be set acordingly
//	 (see setSelected:animated:).
//	 Set the background color to clear so highlighting shows correctly

	UIColor *primaryColor, *selectedColor;
	UIFont *font;
	
	if (main) {
		primaryColor = [UIColor blackColor];
		selectedColor = [UIColor blackColor]; //[UIColor whiteColor];
		font = [UIFont systemFontOfSize: 18];
	} else {
		primaryColor = [UIColor darkGrayColor];
		selectedColor = [UIColor darkGrayColor];
		font = [UIFont systemFontOfSize: 18];
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
	// To show selection properly, however, the views need to be transparent (so that the selection color shows through).  
	
	[super setSelected:selected animated:animated];
	
	UIColor *backgroundColor = nil;
	
	if (selected) {
	    backgroundColor = [UIColor clearColor];
	} else {
		backgroundColor = [UIColor whiteColor];
	}
	
	nameLabel.backgroundColor = backgroundColor;
	nameLabel.highlighted = selected;
	nameLabel.opaque = !selected;
	
	valueLabel.backgroundColor = backgroundColor;
	valueLabel.highlighted = selected;
	valueLabel.opaque = !selected;
}

- (void)layoutSubviews {
	
#define NAME_COLUMN_OFFSET 6
#define NAME_COLUMN_WIDTH 90
	
#define VALUE_COLUMN_OFFSET 100
#define VALUE_COLUMN_WIDTH 200
	
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		
		frame = CGRectMake(boundsX + NAME_COLUMN_OFFSET, 6, NAME_COLUMN_WIDTH, 22);
		nameLabel.frame = frame;
		
		frame = CGRectMake(boundsX + VALUE_COLUMN_OFFSET, 6, VALUE_COLUMN_WIDTH, 22);
		valueLabel.frame = frame;
	}
}

- (ItemFieldType) fieldType {
	return fieldType;
}

- (void) setFieldType: (ItemFieldType)type {
	fieldType = type;
	
	switch (fieldType) {
		case ItemBrand:
			nameLabel.text = @"Brand:";
			break;
		case ItemMaker:
			nameLabel.text = @"Maker:";
			break;
		case ItemSize:
			nameLabel.text = @"Type:";
			break;
		case ItemModel:
			nameLabel.text = @"Model:";
			break;
		case ItemVintage:
			nameLabel.text = @"Date:";
			break;
		case ItemMerchant:
			nameLabel.text = @"Merchant:";
			break;
		case ItemTitle:
			nameLabel.text = @"Title:";
			break;
		case ItemCost:
			nameLabel.text = @"Cost:";
			break;
	}
}

- (void)dealloc {
    [super dealloc];
}

@end
