//
//  SearchFieldCell.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 3/21/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedTypes.h"

@interface SearchFieldCell : UITableViewCell {
	ItemFieldType fieldType;
	
	// The name of the field
	UILabel *nameLabel;
	// The selected value
	UILabel *valueLabel;
}

@property (assign, nonatomic) ItemFieldType fieldType;
@property (nonatomic, assign) UILabel *nameLabel;
@property (nonatomic, assign) UILabel *valueLabel;

- (UILabel *)newLabelForMainText:(BOOL)main;

@end
