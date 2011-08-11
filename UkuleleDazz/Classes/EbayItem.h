//
//  EbayItem.h
//  UkuZoo
//
//  Created by Terry Tucker on 1/6/10.
//  Copyright 2010 Hot! Digity Dog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SharedTypes.h"

@class CXMLDocument;
@class CXMLNode;

@interface EbayItem : NSObject {

	NSString *title;
	NSString *itemId;
	NSString *price;
	NSString *bidCount;
}

@end
