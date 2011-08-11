//
//  CommentCell.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 2/1/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;


@interface CommentCell : UITableViewCell {
	// These are the actual text from the db.  We won't have any label for them like we do the item detail
	UILabel *dateText;
	UILabel *memberText;
	UILabel *itemText;
	UILabel *commentText;
    
	Comment *comment;
    
	// Wish I didn't need this
	CGSize commentLabelSize;
}

@property (nonatomic, retain) Comment *comment;
@property (nonatomic, assign) UILabel *dateText, *memberText, *itemText, *commentText;
@property (assign, nonatomic) CGSize commentLabelSize;

- (UILabel *)newLabelForMainText:(BOOL)main;

@end
