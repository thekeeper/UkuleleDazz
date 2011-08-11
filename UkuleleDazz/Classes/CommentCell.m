//
//  CommentCell.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 2/1/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"

@implementation CommentCell

@synthesize dateText;
@synthesize memberText;
@synthesize itemText;
@synthesize commentText;
@synthesize commentLabelSize;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) )
    {		
		UIView *myContentView = self.contentView;

		memberText = [self newLabelForMainText: NO];
		memberText.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: memberText];
//		[memberText release];
		
		dateText = [self newLabelForMainText: NO];
		dateText.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: dateText];
//		[dateText release];
		
		commentText = [self newLabelForMainText: YES];
		commentText.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview: commentText];
//		[commentText release];
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
//	    backgroundColor = [UIColor clearColor];
//	} else {
//		backgroundColor = [UIColor whiteColor];
//	}
//	
//	dateText.backgroundColor = backgroundColor;
//	dateText.highlighted = selected;
//	dateText.opaque = !selected;
//	
//	memberText.backgroundColor = backgroundColor;
//	memberText.highlighted = selected;
//	memberText.opaque = !selected;
//	
//	commentText.backgroundColor = backgroundColor;
//	commentText.highlighted = selected;
//	commentText.opaque = !selected;
}

- (void)layoutSubviews {
	
#define EDGE_MARGIN_OFFSET 10
#define LABEL_WIDTH 160
	
#define FIRST_ROW_TOP 6
#define SECOND_ROW_TOP 28
	
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
	// Wnen we add editing this illustrates the appropriate pattern
    if (!self.editing) {
		
		CGFloat boundsX = contentRect.origin.x;
		CGFloat dateTextX = contentRect.size.width - EDGE_MARGIN_OFFSET - LABEL_WIDTH;
		CGRect frame;
		
		frame = CGRectMake(boundsX + EDGE_MARGIN_OFFSET, FIRST_ROW_TOP, LABEL_WIDTH, 18);
		memberText.frame = frame;
		
		frame = CGRectMake(dateTextX, FIRST_ROW_TOP, LABEL_WIDTH, 18);
		dateText.frame = frame;
		
		// This is the text of the Comment and has a variable height.
		// We already set the size of the Comment label in cellForRowAtIndexPath, saved as commentLabelSize:
		CGPoint origin = CGPointMake(boundsX + EDGE_MARGIN_OFFSET, SECOND_ROW_TOP);		
		CGSize savedSize = CGSizeMake(commentLabelSize.width, commentLabelSize.height);
		
		frame = CGRectMake(origin.x, origin.y, savedSize.width, savedSize.height);
		commentText.frame = frame;
	}
}

- (Comment *)comment {
    return comment;
}

- (void)setComment:(Comment *)newComment {
	
	if (comment != newComment) {
		[comment release];
		comment = [newComment retain];
		
		memberText.text = comment.memberName;
		dateText.text = comment.date;
		commentText.text = comment.commentText;
		itemText.text = comment.itemId;
	}
	
//	 If something changed that would affect, say, which subviews should be displayed, call:
//	 [self setNeedsLayout];
}

- (void)dealloc {
	[comment release];
	[dateText release]; 
	[memberText release];
	[itemText release];
	[commentText release];
    [super dealloc];
}


@end
