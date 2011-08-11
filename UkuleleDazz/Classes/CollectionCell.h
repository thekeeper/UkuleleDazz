//
//  CollectionCell.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 7/2/08.
//  Copyright 2008 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedTypes.h"

@class DazzCollection;@class TestCollection;

@interface CollectionCell : UITableViewCell {
//	CollectionFieldType firstSortType;
//	CollectionFieldType secondSortType;
//	CollectionFieldType thirdSortType;
	
	DazzCollection *dazzCollection;
	UIImageView *imageView;
	
	// Since the content of the cells change depending on the sort order, we will simply call them by their position
	UILabel *topLeftLabel;
	UILabel *topRightLabel;
	UILabel *bottomLeftLabel;
	UILabel *bottomRightLabel;
}

@property (nonatomic, retain) DazzCollection *dazzCollection;
@property (nonatomic, assign) UILabel *topLeftLabel, *topRightLabel, *bottomLeftLabel, *bottomRightLabel;

//- (void)setSortTypes: (CollectionFieldType)firstType secondSortType: (CollectionFieldType)secondType thirdSortType: (CollectionFieldType)thirdType;
	
- (UILabel *)newLabelForMainText:(BOOL)main;

@end

