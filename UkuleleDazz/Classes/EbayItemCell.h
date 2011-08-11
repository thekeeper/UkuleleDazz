//
//  EbayItemCell.h
//  UkuZoo
//
//  Created by Terry Tucker on 1/5/10.
//  Copyright 2010 Hot! Digity Dog Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedTypes.h"

@class EbayItem;

@interface EbayItemCell : UITableViewCell {
	ItemFieldType firstSortType;
	ItemFieldType secondSortType;
	ItemFieldType thirdSortType;
	EbayItem *ebayItem;
	UIImageView *imageView;
	
	// Since the content of the cells change depending on the sort order, we will simply call them by their position
	UILabel *topLeftLabel;
	UILabel *topRightLabel;
	UILabel *bottomLeftLabel;
	UILabel *bottomRightLabel;
}

@property (nonatomic, retain) EbayItem *ebayItem;
@property (nonatomic, assign) UILabel *topLeftLabel, *topRightLabel, *bottomLeftLabel, *bottomRightLabel;

- (void)setSortTypes: (ItemFieldType)firstType secondSortType: (ItemFieldType)secondType thirdSortType: (ItemFieldType)thirdType;

- (UILabel *)newLabelForMainText:(BOOL)main;

@end
