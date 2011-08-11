//
//  NotesCell.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 2/1/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NotesCell : UITableViewCell {
	
	// These help display the text from the db
	NSString *notesText;
	UILabel *notesLabel;
	
	// Wish I didn't need this
	CGSize labelSize;
}

@property (nonatomic, assign) NSString *notesText;
@property (nonatomic, assign) UILabel *notesLabel;
@property (assign, nonatomic) CGSize labelSize;

- (UILabel *)newLabelForMainText:(BOOL)main;

@end
