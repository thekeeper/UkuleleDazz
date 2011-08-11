//
//  DazzObject.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 6/19/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"
#import "TouchJson.h"

@class DazzItem;

@interface DazzObject : NSObject {
    
    // Internal state variables. Hydrated tracks whether attribute data is in the object or the datastore.
    BOOL hydrated;
    // Dirty tracks whether there are in-memory changes to data which have not been written to the datastore.
    BOOL dirty;

}

@property(nonatomic) BOOL hydrated;
@property(nonatomic) BOOL dirty;

// Not every subclass needs all of these, but the ones that are used must be customized in the subclass

// These two get info from web service calls
- (id)initWithXml;
- (id)initWithJson;

- (id)initWithXmlNode:(CXMLNode *)node;
- (id)initWithJsonString:(NSString *) json;
- (id)initWithDictionary:(NSDictionary *) dictionary;

// Brings the rest of the object data into memory. If already in memory, no action is taken (harmless no-op).
- (void)hydrateFromXml;
- (void)hydrateFromJson;
- (void)hydrateFromSql;

// These two build a hydrated object from a search of UkuZoo
- (void)hydrateFromZooSearchXml: (DazzItem*) dazzItem;
- (void)hydrateFromZooSearchJson: (DazzItem*) dazzItem;

// Can ebay searches have a detail view?  Can the collection
// do a hydrate, or is an init from ebay enough?

// Flush all but the bare essentials
- (void)dehydrateToWeb;
- (void)dehydrateToSql;

// Mark the object as deleted in the website. In memory deletion to follow...
- (void)deleteFromWeb;
// Mark the object as deleted in the local database. In memory deletion to follow...
- (void)deleteFromSql;

// These should work for everybody, but the error handler could be subclassed for more detail
- (NSString *)jsonFromURLString:(NSString *)urlString targetObject:(NSString *)target isArray:(BOOL)array;
- (void)handleError:(NSError *)error errorLocation:(NSString *)location;

// This one must be implemented by the subclass
- (NSString *)jsonCleanup:(NSString *)resultString targetObject:(NSString *)target;

// This is used to convert a single json object into an array of one
- (NSString *)jsonObjectToArray:(NSString *)resultString targetObject:(NSString *)target;
@end
