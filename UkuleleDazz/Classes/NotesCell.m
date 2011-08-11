//
//  NotesCell.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 2/1/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "NotesCell.h"
#import "SharedConversions.h"


@implementation NotesCell

@synthesize notesLabel;
@synthesize labelSize;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ( (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier  ]) ) {
		
		UIView *myContentView = self.contentView;
		
		notesLabel = [self newLabelForMainText:YES];
		notesLabel.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: notesLabel];
		[notesLabel release];
		
    }
    return self;
}

- (UILabel *)newLabelForMainText:(BOOL)main {
	UIColor *primaryColor, *selectedColor;
	UIFont *font;
	
	if (main) {
		primaryColor = [UIColor blackColor];
		selectedColor = [UIColor whiteColor];
		font = [UIFont systemFontOfSize: 14.0f];
	} else {
		primaryColor = [UIColor darkGrayColor];
		selectedColor = [UIColor lightGrayColor];
		font = [UIFont systemFontOfSize: 14.0f];
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
	newLabel.numberOfLines = 0;
	
	return newLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//
//    [super setSelected:selected animated:animated];
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
//	notesLabel.backgroundColor = backgroundColor;
//	notesLabel.highlighted = selected;
//	notesLabel.opaque = !selected;
}

- (void)layoutSubviews {
	
#define EDGE_MARGIN_OFFSET 10
#define LABEL_WIDTH 80
	
#define FIRST_ROW_TOP 6
	
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
		// We already set the size of the label in cellForRowAtIndexPath:
		CGFloat boundsX = contentRect.origin.x;
		
		CGPoint origin = CGPointMake(boundsX + EDGE_MARGIN_OFFSET, FIRST_ROW_TOP);		
		CGSize savedSize = CGSizeMake(labelSize.width, labelSize.height);
		
		CGRect frame = CGRectMake(origin.x, origin.y, savedSize.width, savedSize.height);
		notesLabel.frame = frame;
	}
}

- (NSString *)notesText {
    return notesText;
}

- (void)setNotesText:(NSString *)aString {
    if ((!notesText && !aString) || (notesText && aString && [notesText isEqualToString:aString])) return;
    [notesText release];
    notesText = [aString copy];
	notesLabel.text = notesText;
}

- (void)dealloc {
	[notesLabel release];
	[super dealloc];
}


@end
