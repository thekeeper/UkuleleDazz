//
//  SharedTypes.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 7/4/08.
//  Copyright 2008 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageResizing.h"

typedef enum {ItemBrand, ItemMaker, ItemSize, ItemModel, ItemVintage, ItemMerchant, ItemTitle, ItemCost, ItemUndefined} ItemFieldType;
typedef enum {SelectingBrand, SelectingType, SelectingStyle} SearchSelection;

typedef enum {WebXml, WebJson, SdbXml, SdbJson, LocalSql} DataStoreType;

@interface SharedTypes : NSObject {

}

+ (NSString *)getSortFieldClassName:(ItemFieldType)itemSortField;

+ (NSString *)getSortFieldDBName:(ItemFieldType)itemSortField;

@end
