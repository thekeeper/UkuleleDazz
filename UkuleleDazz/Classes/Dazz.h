//
//  Dazz.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 6/22/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DazzObject.h"

@interface Dazz : DazzObject {
    	
    NSMutableArray *dazzCollections;
	CXMLDocument *doc;
	NSArray *itemNodes;
}

@property (nonatomic, retain) NSMutableArray *dazzCollections;

@end
