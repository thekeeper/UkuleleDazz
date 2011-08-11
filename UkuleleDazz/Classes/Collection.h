//
//  Collection.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 4/7/11.
//  Copyright (c) 2011 Terry Tucker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Collection : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * collector;
@property (nonatomic, retain) NSString * collectionId;
@property (nonatomic, retain) NSString * itemCount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) id dazzItems;
@property (nonatomic, retain) id ebayItems;
@property (nonatomic, retain) NSDate * modificationDate;

@end
