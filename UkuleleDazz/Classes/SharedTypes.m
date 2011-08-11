//
//  SharedTypes.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 7/4/08.
//  Copyright 2008 Terry Tucker. All rights reserved.
//

#import "SharedTypes.h"


@implementation SharedTypes

+ (NSString *)getSortFieldClassName:(ItemFieldType)itemSortField {
	
	NSString *fieldName = nil;
	
	switch (itemSortField)
	{
		case ItemBrand: fieldName = @"Brand"; break;
		case ItemMaker: fieldName = @"Maker"; break;
		case ItemSize: fieldName = @"Size"; break;
		case ItemModel: fieldName = @"Model"; break;
		case ItemVintage: fieldName = @"Vintage"; break;
		case ItemTitle: fieldName = @"Title"; break;
		case ItemCost: fieldName = @"Cost"; break;
		case ItemMerchant: fieldName = @"Merchant"; break;
	}
	
	return fieldName;
}

+ (NSString *)getSortFieldDBName:(ItemFieldType)itemSortField {
	
	NSString *fieldName = nil;
	
	switch (itemSortField)
	{
		case ItemBrand: fieldName = @"U_Brand"; break;
		case ItemMaker: fieldName = @"U_Maker"; break;
		case ItemSize: fieldName = @"U_Size"; break;
		case ItemModel: fieldName = @"U_Model"; break;
	}
	
	return fieldName;
}

@end

