//
//  DazzCollection.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/28/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "DazzCollection.h"
#import "DazzItem.h"
#import "EbayItem.h"
#import "SharedConversions.h"
#import "TouchXML.h"

@implementation DazzCollection

@synthesize searchDazzItem;
@synthesize collector;
@synthesize collectionId;
@synthesize name;
@synthesize privacy;
@synthesize privateName;
@synthesize date;
@synthesize itemCount;
@synthesize notes;
@synthesize dazzItems;
@synthesize ebayItems;
//@synthesize masterType;
//@synthesize masterValue;
@synthesize primaryArray;
@synthesize secondaryArray;
@synthesize tertiaryArray;
@synthesize quadernaryArray;


-(id)init
{
    if ((self = [super init]))
    {		
		self.collector = @"Keeper";
    }
    return self;
}

- (id)initSearchWithJson {
    if ( (self = [super init]) ) {
        self.collector = @"DazzSearch";

        searchDazzItem = [DazzItem alloc];
        searchDazzItem.brand = @"All";
        searchDazzItem.maker = @"All";
        searchDazzItem.size  = @"All";
        searchDazzItem.model = @"All";

        [self loadPrimaryArray: ItemBrand];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
   
    NSObject *obj = [dictionary objectForKey:@"CollectionId"];
    if (obj == [NSNull null])
        self.collectionId = @"";
    else
        self.collectionId = (NSString *) obj;
    
    obj = [dictionary objectForKey:@"CollectionName"];
    if (obj == [NSNull null])
        self.name = @"";
    else
        self.name = (NSString *) obj;
    
	obj = [dictionary objectForKey:@"OwnerName"];
    if (obj == [NSNull null])
        self.collector = @"";
    else
        self.collector = (NSString *) obj;
    
    obj = [dictionary objectForKey:@"ItemCount"];
    if (obj == [NSNull null])
        self.itemCount = @"";
    else
        self.itemCount = (NSString *) obj;
    
    obj = [dictionary objectForKey: @"Notes"];
    if (obj == [NSNull null])
        self.notes = @"";
    else
        self.notes = (NSString *) obj;
    
    obj = [dictionary objectForKey: @"Date"];
    if (obj == [NSNull null])
        [self.date initWithTimeIntervalSinceNow:0];
    else {
        NSString *dateString = (NSString *)obj;
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];        
        self.date = [dateFormatter dateFromString:dateString];
    }
    
    obj = [dictionary objectForKey: @"Private"];
    if (obj == [NSNull null])
        self.privacy = @"";
    else
        self.privacy = (NSString *) obj;
    
    // Now, set the privateName field according to the privacy flags
    self.privateName = NO;
    if ( [privacy isEqualToString:@"0"] || [privacy isEqualToString:@"1"] ) {
        privateName = YES;
    }

    [self setFirstSortField: ItemBrand];
    [self setSecondSortField:  ItemSize];
    [self setThirdSortField: ItemModel];	
    
    return self;
}

#pragma mark Web Services access methods

- (id) hydrateWithRandomSearchItemJson: (NSInteger) count {
    
	NSString *urlString = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetRandomItemsJson?count=%d", count];
    
    NSString *resultString = [self jsonFromURLString:urlString targetObject:@"Ukulele" isArray: YES];
    
    NSData *jsonData = [[resultString dataUsingEncoding:NSUTF32BigEndianStringEncoding] retain ];
    
    // Parse JSON results with TouchJSON.  It converts it into a dictionary.
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
    
    // Search will often return a nil object for resultsDictionary, so we don't want to display this message
    //    [self handleError:error errorLocation:@"DazzCollection: hydrateWithSearchItemJson"];	
	
    if (dazzItems == nil) {
		dazzItems = [[NSMutableArray alloc] init];
	}
    
	[dazzItems removeAllObjects];
    
    id obj = (NSArray *)[resultsDictionary objectForKey:@"Ukulele"];
    
    // First test is whether there is anything at all returned
    if (obj) {
        // The next test is to determine the type of object returned.
        // When there is only one item in the collection, we get a dictionary rather than an array of dictionaries
        if ([obj isKindOfClass:[NSDictionary class]]) {
            DazzItem *dazzItem = [[DazzItem alloc] initWithDictionary: obj];
            [dazzItems addObject: dazzItem];
        } else {
            for (NSDictionary *collectionDictionary in obj) {
                DazzItem *dazzItem = [[DazzItem alloc] initWithDictionary: collectionDictionary];
                [dazzItems addObject: dazzItem];
            }    
        }
    }
    
    [jsonData release];
    
    return self;
}

- (id)hydrateWithSearchItemJson: (DazzItem *) dazzItem {
	
	NSString *firstWhere = dazzItem.brand;
	if ([firstWhere compare: @"All"] == NSOrderedSame) {
		firstWhere = @"";
	}
	firstWhere = [SharedConversions escapeUrlParam: firstWhere];
	
	NSString *secondWhere = dazzItem.maker;
	if ([secondWhere compare: @"All"] == NSOrderedSame) {
		secondWhere = @"";
	}
	secondWhere = [SharedConversions escapeUrlParam: secondWhere];
	
	NSString *thirdWhere = dazzItem.size;
	if ([thirdWhere compare: @"All"] == NSOrderedSame) {
		thirdWhere = @"";
	}
	thirdWhere = [SharedConversions escapeUrlParam: thirdWhere];
	
	NSString *fourthWhere = dazzItem.model;
	if ([fourthWhere compare: @"All"] == NSOrderedSame) {
		fourthWhere = @"";
	}
	fourthWhere = [SharedConversions escapeUrlParam: fourthWhere];
	
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetItemsFromSearchStandardSortJson?"];
	NSString *whereQuery = [NSString stringWithFormat: @"firstWhere=%@&secondWhere=%@&thirdWhere=%@&fourthWhere=%@", 
							firstWhere,
							secondWhere,
							thirdWhere,
							fourthWhere];
	
	NSString *withSoundQuery = [NSString stringWithFormat: @"&withSound=%@", @"false"];
	
	NSString *forSaleQuery = [NSString stringWithFormat: @"&forSale=%@", @"false"];
	
	//	NSString *sortQuery = [NSString stringWithFormat: @"&firstSort=%@&secondSort=%@&thirdSort=%@", firstSortText, secondSortText, thirdSortText];	
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat:	@"%@%@%@%@",
						   urlText,
						   whereQuery,
						   withSoundQuery,
                           forSaleQuery];
    
    NSString *resultString = [self jsonFromURLString:urlString targetObject:@"Ukulele" isArray: YES];
    
    NSData *jsonData = [[resultString dataUsingEncoding:NSUTF32BigEndianStringEncoding] retain ];
    
    // Parse JSON results with TouchJSON.  It converts it into a dictionary.
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
    
    // Search will often return a nil object for resultsDictionary, so we don't want to display this message
//    [self handleError:error errorLocation:@"DazzCollection: hydrateWithSearchItemJson"];	
	
    if (dazzItems == nil) {
		dazzItems = [[NSMutableArray alloc] init];
	}
    
	[dazzItems removeAllObjects];
    
    id obj = (NSArray *)[resultsDictionary objectForKey:@"Ukulele"];
    
    // First test is whether there is anything at all returned
    if (obj) {
        // The next test is to determine the type of object returned.
        // When there is only one item in the collection, we get a dictionary rather than an array of dictionaries
        if ([obj isKindOfClass:[NSDictionary class]]) {
            DazzItem *dazzItem = [[DazzItem alloc] initWithDictionary: obj];
            [dazzItems addObject: dazzItem];
        } else {
            for (NSDictionary *collectionDictionary in obj) {
                DazzItem *dazzItem = [[DazzItem alloc] initWithDictionary: collectionDictionary];
                [dazzItems addObject: dazzItem];
            }    
        }
    }
    
    [jsonData release];
   
    return self;
}

// Does web service call to get data in json format
- (void)hydrateFromJson {
	
    // Check if action is necessary.
    if (hydrated) return;	
    
    /////////////////////////////////////////////////////////////////////////////////
	//
	// Get the collection items from the web service
	//
	
	// First, set up the strings that will be concatenated to form the query url:
	//
	NSString *firstSortText = [SharedTypes getSortFieldDBName:firstSortField];
	NSString *secondSortText = [SharedTypes getSortFieldDBName:secondSortField];
	NSString *thirdSortText = [SharedTypes getSortFieldDBName:thirdSortField];
	NSString *fourthSortText = @"U_Date";
	
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/"
                         @"GetCollectionItemBasicsJson?"];
	NSString *firstSortQuery = [NSString stringWithFormat: @"&firstSort=%@", firstSortText];
	NSString *secondSortQuery = [NSString stringWithFormat: @"&secondSort=%@", secondSortText];
	NSString *thirdSortQuery = [NSString stringWithFormat: @"&thirdSort=%@", thirdSortText];	
	NSString *fourthSortQuery = [NSString stringWithFormat: @"&fourthSort=%@", fourthSortText];	
	NSString *idQuery = [NSString stringWithFormat: @"id=%@", collectionId];
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat:	@"%@%@%@%@%@%@",
						   urlText,
						   idQuery,
						   firstSortQuery,
						   secondSortQuery,
						   thirdSortQuery,
                           fourthSortQuery];
    
    NSString *resultString = [self jsonFromURLString:urlString targetObject:@"Ukulele" isArray: YES];

    NSData *jsonData = [[resultString dataUsingEncoding:NSUTF32BigEndianStringEncoding] retain ];
    
    // Parse JSON results with TouchJSON.  It converts it into a dictionary.
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
    [self handleError:error errorLocation:@"DazzCollection: hydrateFromJson"];	
	
    if (dazzItems == nil) {
		dazzItems = [[NSMutableArray alloc] init];
	}
    
	[dazzItems removeAllObjects];
    
    // When there is only one item in the collection, we get a dictionary rather than an array of dictionaries.
    id obj = (NSArray *)[resultsDictionary objectForKey:@"Ukulele"];
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        DazzItem *dazzItem = [[DazzItem alloc] initWithDictionary: obj];
        [dazzItems addObject: dazzItem];
    } else {
        // Sort here?  Only if random search?
        // NSArray sortedArray = [self sortArray: obj byType:(ItemType)ItemBrand];
        
        for (NSDictionary *collectionDictionary in obj) {
            DazzItem *dazzItem = [[DazzItem alloc] initWithDictionary: collectionDictionary];
            [dazzItems addObject: dazzItem];
        }    
    }
    
    [jsonData release];
}

// We need this when we get a database stored on the phone
- (void)hydrateFromDazzSearchSql: (DazzItem*) dazzItem { 
}

// Flushes all but the primary key and name out to the database.
- (void)dehydrateToWeb {
    if (dirty) {
		// Clear out all unnecessary objects
        // Update the object state with respect to unwritten changes.
        dirty = NO;
    }
	//    // Release member variables to reclaim memory. Set to nil to avoid over-releasing them 
	//    // if dehydrate is called multiple times.
	//    [owner release];
	//    owner = nil;
	//    [data release];
	//    data = nil;
	
	// Iterate over the dazzItems array and dehydrate each one (unless it's getting its own dehydrate command?)
	//    for (NSString *element in dazzItems) {
	//		NSLog(@"element: %@", element);		
	//	}
	
	// Update the object state with respect to hydration.
	//    hydrated = NO;
}

// Flushes all but the primary key and name out to the database.
- (void)dehydrateToSql {
    if (dirty) {
		// Clear out all unnecessary objects
        // Update the object state with respect to unwritten changes.
        dirty = NO;
    }
	//    // Release member variables to reclaim memory. Set to nil to avoid over-releasing them 
	//    // if dehydrate is called multiple times.
	//    [owner release];
	//    owner = nil;
	//    [data release];
	//    data = nil;
	
	// Iterate over the dazzItems array and dehydrate each one (unless it's getting its own dehydrate command?)
	//    for (NSString *element in dazzItems) {
	//		NSLog(@"element: %@", element);		
	//	}
	
	// Update the object state with respect to hydration.
	//    hydrated = NO;
}

// ***********
// ***********   Search Helpers   ********** //
// ***********

- (void)loadPrimaryArray: (ItemFieldType)masterType { //value: (NSString *) value {
    
    id obj = [self createAttributeArrayJson: @"Brand" dbName:[SharedTypes getSortFieldDBName: ItemBrand] masterType:masterType];
    
    // First test is whether there is anything at all returned
    if (obj) {
        // The next test is to determine the type of object returned.
        // When there is only one item we get a string rather than an array of strings
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *itemArray = (NSArray *)obj;
            primaryArray = [[NSMutableArray alloc] initWithCapacity: itemArray.count + 1];
            [primaryArray insertObject: @"All" atIndex: 0];
            [primaryArray addObjectsFromArray: itemArray];
        } else {
            primaryArray = [[NSMutableArray alloc] initWithCapacity: 2];
            [primaryArray insertObject: @"All" atIndex: 0];
            [primaryArray insertObject:obj atIndex: 1];  
        }
    }
    else {
        primaryArray = [[NSMutableArray alloc] initWithCapacity: 0];
    }
}

- (void)loadSecondaryArray: (ItemFieldType)masterType { //value: (NSString *) value {
	
//	// If the primary item hasn't changed, don't reload the array
//	if ( [[searchDazzItem maker] compare: primaryItem] != NSOrderedSame ) {
        
    if ( secondaryArray != nil) {
        [secondaryArray removeAllObjects];
    }
    
    id obj = [self createAttributeArrayJson: @"Maker" dbName:[SharedTypes getSortFieldDBName: ItemMaker] masterType:masterType];
    
    // First test is whether there is anything at all returned
    if (obj) {
        // The next test is to determine the type of object returned.
        // When there is only one item we get a string rather than an array of strings
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *itemArray = (NSArray *)obj;
            secondaryArray = [[NSMutableArray alloc] initWithCapacity: itemArray.count + 1];
            [secondaryArray insertObject: @"All" atIndex: 0];
            [secondaryArray addObjectsFromArray: itemArray];
        } else {
            secondaryArray = [[NSMutableArray alloc] initWithCapacity: 2];
            [secondaryArray insertObject: @"All" atIndex: 0];
            [secondaryArray insertObject:obj atIndex: 1];
        }
    }
    else {
        secondaryArray = [[NSMutableArray alloc] initWithCapacity: 0];
    }
        
//        NSArray *itemArray = [self createAttributeArrayJson: @"Maker" dbName:[SharedTypes getSortFieldDBName: ItemMaker] masterType:masterType];
//        
//        secondaryArray = [[NSMutableArray alloc] initWithCapacity: itemArray.count + 1];
//        [secondaryArray insertObject: @"All" atIndex: 0];
//        [secondaryArray addObjectsFromArray: itemArray];
//	}
    
}

- (void)loadTertiaryArray: (ItemFieldType)masterType { //value: (NSString *) value {
	
//	// If the primary item hasn't changed, don't reload the array
//	if ( [[searchDazzItem maker] compare: primaryItem] != NSOrderedSame ) {
        
        if ( tertiaryArray != nil) {
            [tertiaryArray removeAllObjects];
        }
        
//        NSArray *itemArray = [self createAttributeArrayJson: @"Size" dbName:[SharedTypes getSortFieldDBName: ItemSize] masterType:masterType];

    
    id obj = [self createAttributeArrayJson: @"Size" dbName:[SharedTypes getSortFieldDBName: ItemSize] masterType:masterType];

    // First test is whether there is anything at all returned
    if (obj) {
        // The next test is to determine the type of object returned.
        // When there is only one item we get a string rather than an array of strings
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *itemArray = (NSArray *)obj;
            tertiaryArray = [[NSMutableArray alloc] initWithCapacity: itemArray.count + 1];
            [tertiaryArray insertObject: @"All" atIndex: 0];
            [tertiaryArray addObjectsFromArray: itemArray];
        } else {
            tertiaryArray = [[NSMutableArray alloc] initWithCapacity: 2];
            [tertiaryArray insertObject: @"All" atIndex: 0];
            [tertiaryArray insertObject:obj atIndex: 1];
        }
    }
    else {
        tertiaryArray = [[NSMutableArray alloc] initWithCapacity: 0];
    }    
}

- (void)loadQuadernaryArray: (ItemFieldType)masterType { //value: (NSString *) value {
	
//	// If the primary item hasn't changed, don't reload the array
//	if ( [[searchDazzItem maker] compare: primaryItem] != NSOrderedSame ) {
        
        if ( quadernaryArray != nil) {
            [quadernaryArray removeAllObjects];
        }
    
    id obj = [self createAttributeArrayJson: @"Model" dbName:[SharedTypes getSortFieldDBName: ItemModel] masterType:masterType];
    
    // First test is whether there is anything at all returned
    if (obj) {
        // The next test is to determine the type of object returned.
        // When there is only one item we get a string rather than an array of strings
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *itemArray = (NSArray *)obj;
            quadernaryArray = [[NSMutableArray alloc] initWithCapacity: itemArray.count + 1];
            [quadernaryArray insertObject: @"All" atIndex: 0];
            [quadernaryArray addObjectsFromArray: itemArray];
        } else {
            quadernaryArray = [[NSMutableArray alloc] initWithCapacity: 2];
            [quadernaryArray insertObject: @"All" atIndex: 0];
            [quadernaryArray insertObject:obj atIndex: 1];
        }
    }
    else {
        quadernaryArray = [[NSMutableArray alloc] initWithCapacity: 0];
    }
        
//        NSArray *itemArray = [self createAttributeArrayJson: @"Model" dbName:[SharedTypes getSortFieldDBName: ItemModel] masterType:masterType];
//        
//        quadernaryArray = [[NSMutableArray alloc] initWithCapacity: itemArray.count + 1];
//        [quadernaryArray insertObject: @"All" atIndex: 0];
//        [quadernaryArray addObjectsFromArray: itemArray];
//	}
    
}

// The Master is the one field that must be selected first, that the other lists depend on
- (NSArray *)createAttributeArrayJson: (NSString *) attributeName dbName:(NSString *) dbName masterType:(ItemFieldType)masterType {
    
    // See if there is a master item to filter on
    // And determine if this request is for the master item list
    NSString *masterDbName = [SharedTypes getSortFieldDBName:masterType];
    NSString *masterValue = @"";
    BOOL isMaster = NO;
    if (masterType == ItemBrand) {
        masterValue = searchDazzItem.brand;
        if ([attributeName isEqualToString: @"Brand"]) {
            isMaster = YES;
        }
    }
    else if (masterType == ItemMaker) {
        masterValue = searchDazzItem.maker;
        if ([attributeName isEqualToString: @"Maker"]) {
            isMaster = YES;
        }
    }
    
    NSString *urlText = nil;
    NSString *queryText = nil;
    
    // If masterValue is "All", then it isn't really defined, so we will not do a search with a where filter
	if ( isMaster || masterType == ItemUndefined || [masterValue isEqualToString: @"All"] ) {
        urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntriesJson?"];
        queryText = [NSString stringWithFormat: @"fieldName=%@", dbName];
    }
    else {
        urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntriesWhereJson?"];
        
        // Escape masterValue to get rid of ampersands
        NSString *escapedValue = [SharedConversions escapeUrlParam:masterValue];
        queryText = [NSString stringWithFormat: @"fieldName=%@&whereField=%@&whereName=%@", dbName, masterDbName, escapedValue];
    }
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat: @"%@%@", urlText, queryText];
    
    NSString *resultString = [self jsonFromURLString:urlString targetObject:attributeName isArray: YES];
    
    if (resultString.length < 1) {
        return [[NSArray alloc] init];
    }
    
    NSData *jsonData = [[resultString dataUsingEncoding:NSUTF32BigEndianStringEncoding] retain ];
    
    // Parse JSON results with TouchJSON.  It converts it into a dictionary.
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
    [self handleError:error errorLocation:@"DazzCollection: createAttributeListJson"];
    
    // There is only one object at this level, not an array
    NSArray *itemArray = [resultsDictionary objectForKey:attributeName];
	
    [jsonData release];
    
    return itemArray;
}

//// The Master is the one field that must be selected first, that the other lists depend on
//- (void)createMasterListJson {
//	
//	// We only want to load this once since it is a master list, not dependent on any other selections
//	if ([primaryArray count] > 0 ) {
//		return;
//	}
//	
//	NSString *fieldName = [SharedTypes getSortFieldDBName: ItemBrand];
//	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntriesJson?"];
//	
//	// Build the entire request string:
//	NSString *urlString = [NSString stringWithFormat: @"%@fieldName=%@", urlText, fieldName];
//    
//    NSString *resultString = [self jsonFromURLString:urlString targetObject:@"Brand" isArray: YES];
//    
//    if (resultString.length < 1) {
//        return;
//    }
//    
//    NSData *jsonData = [[resultString dataUsingEncoding:NSUTF32BigEndianStringEncoding] retain ];
//    
//    // Parse JSON results with TouchJSON.  It converts it into a dictionary.
//    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
//    NSError *error = nil;
//    NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
//    [self handleError:error errorLocation:@"DazzCollection: createMasterListJson"];
//    
//    // There is only one object at this level, not an array
//    NSArray *itemArray = [resultsDictionary objectForKey:@"Brand"];
//    
//    primaryArray = [[NSMutableArray alloc] initWithCapacity: itemArray.count + 1];
//    [self.primaryArray insertObject: @"All" atIndex: 0];
//    [self.primaryArray addObjectsFromArray: itemArray];
//   
//    [jsonData release];
//}
//
//- (void)createSecondaryListXml {
//	
//	NSString *fieldName = [SharedTypes getSortFieldDBName: ItemSize];
//	NSString *whereField = @"";
//	NSString *urlText = @"";
//	NSString *urlString = @"";
//	
//	// If the field name is "All Brands" we will do a get of everything
//	if ( [searchDazzItem.brand compare: @"All"] == NSOrderedSame ) {
//		urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntriesJson?"];
//		
//		// Build the entire request string:
//		urlString = [NSString stringWithFormat: @"%@fieldName=%@", urlText, fieldName];
//	}
//	// Else we do a get with the master item filter
//	else {		
//		whereField = [SharedTypes getSortFieldDBName: ItemMaker];
//		urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntriesWhereJson?"];
//		
//		// Build the entire request string:
//		urlString = [NSString stringWithFormat: @"%@fieldName=%@&whereField=%@&whereName=%@", urlText, fieldName, whereField, searchDazzItem.brand];
//	}
//	
//	// Encode spaces, quotes, etc
//	NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//	
//	NSString *xPath = @"FieldEntries/Size";
//	// This will populate the itemNodes member with the CXMLNodes from the xml
//	self.secondaryArray = [self runSearchListQueryJson: escapedUrl nodePath: xPath];
//	
//	[self.secondaryArray insertObject: @"All" atIndex: 0];
//}
//
//- (void)createTertiaryListXml { // : (NSString *)masterText secondaryItem: (NSString *)secondary {
//	
//	NSString *fieldName = [SharedTypes getSortFieldDBName: ItemModel];
//	NSString *whereField = @"";
//	NSString *urlText = @"";
//	NSString *urlString = @"";
//	
//	// If the field name is "All" we will do a get of everything
//	if ( [searchDazzItem.brand compare: @"All"] == NSOrderedSame ) {
//		urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntriesJson?"];
//		
//		// Build the entire request string:
//		urlString = [NSString stringWithFormat: @"%@fieldName=%@", urlText, fieldName];
//	}
//	// Else we do a get with the master item filter
//	else {		
//		whereField = [SharedTypes getSortFieldDBName: ItemMaker];
//		urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntriesWhereJson?"];
//		
//		// Build the entire request string:
//		urlString = [NSString stringWithFormat: @"%@fieldName=%@&whereField=%@&whereName=%@", urlText, fieldName, whereField, searchDazzItem.brand];
//	}
//	
//	// Encode spaces, quotes, etc
//	NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//	
//	NSString *xPath = @"FieldEntries/Model";
//	// This will populate the itemNodes member with the CXMLNodes from the xml
//	self.tertiaryArray = [self runSearchListQueryJson: escapedUrl nodePath: xPath];
//	
//	[self.tertiaryArray insertObject: @"All" atIndex: 0];
//}
//
//- (void)createQuadernaryListXml {
//    
//}
//
//- (NSMutableArray *)runSearchListQueryJson: (NSString *)escapedUrl nodePath: (NSString *)path {
//	// This is the array we will return - empty or not!
//	NSMutableArray *itemArray = [[NSMutableArray alloc] init];
//	//	self.imagePaths = nodeArray;
//	//	[nodeArray release];
//	
//	NSError *error = nil;
//	
//	NSURL *url = [NSURL URLWithString: escapedUrl];
//	NSURLRequest *urlRequest = [NSURLRequest requestWithURL: url cachePolicy: NSURLRequestReturnCacheDataElseLoad timeoutInterval: 30];
//	
//	// Fetch response
//	NSData *urlData;
//	NSURLResponse *response;
//	urlData =[NSURLConnection sendSynchronousRequest: urlRequest returningResponse: &response error: &error];
//	
//	if (!urlData) {
//		NSLog(@"********** runSearchListQuery: urlData is nil!!!"); //, doc);
//	}
//	
//	// Parse response
//    //	CXMLDocument *doc = [[CXMLDocument alloc] init];	
//    //	CXMLDocument *doc = [CXMLDocument alloc];	
//	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:urlData
//									               options:0
//									                 error:&error];
//	if (!doc) {
//		NSLog(@"********** runSearchListQuery: doc is nil!!!"); //, doc);
//	}
//	
//	// Get the nodes for the particular search param
//    //	NSArray *itemNodes = [[NSArray alloc] init];		
//	NSArray *itemNodes = [[doc nodesForXPath: path error:&error] retain];
//	
//	if (!itemNodes) {
//		NSLog(@"********** runSearchListQuery: nodeArray is nil!!!");
//	}
//	
//	// Add the nodes the the return array
//	NSInteger nodeCount = [itemNodes count];
//	
//	for (int i = 0; i < nodeCount; i++) {
//		CXMLNode *childNode = [itemNodes objectAtIndex: i];
//		NSString *path = [[NSString alloc] initWithString: [childNode stringValue]];
//		
//		[itemArray addObject: path];
//		[path release];
//	}
//	
//	[doc release];
//	[itemNodes release];
//	
//	return [itemArray autorelease];
//}

// ******* Ebay Methods:

// Do ebay search based on attributs of dazzItem
- (void)hydrateFromEbaySearch: (DazzItem*) dazzItem {
	
	////////////////////////////////////////////////////////////////////////////////
	//
	// Get the collection items from the web service
	//
	
	// First, set up the strings that will be concatenated to form the query url:
	//
	//	NSString *firstSortText = [SharedTypes getSortFieldDBName: ItemMaker];
	//	NSString *secondSortText = [SharedTypes getSortFieldDBName: ItemSize];
	//	NSString *thirdSortText = [SharedTypes getSortFieldDBName: ItemModel];
	
	NSString *firstWhere = dazzItem.maker;
	if ([firstWhere compare: @"All"] == NSOrderedSame) {
		firstWhere = @"";
	}
	firstWhere = [SharedConversions escapeUrlParam: firstWhere];
	
	NSString *secondWhere = dazzItem.brand;
	if ([secondWhere compare: @"All"] == NSOrderedSame) {
		secondWhere = @"";
	}
	secondWhere = [SharedConversions escapeUrlParam: firstWhere];
	
	NSString *thirdWhere = dazzItem.size;
	if ([thirdWhere compare: @"All"] == NSOrderedSame) {
		thirdWhere = @"";
	}
	thirdWhere = [SharedConversions escapeUrlParam: thirdWhere];
    
	NSString *fourthWhere = dazzItem.model;
	if ([fourthWhere compare: @"All"] == NSOrderedSame) {
		fourthWhere = @"";
	}
	fourthWhere = [SharedConversions escapeUrlParam: fourthWhere];
	
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetItemsFromSearchStandardSort?"];
	NSString *whereQuery = [NSString stringWithFormat: @"firstWhere=%@&secondWhere=%@&thirdWhere=%@&fourthWhere=%@", 
							firstWhere,
							secondWhere,
							thirdWhere,
							fourthWhere];
	
	NSString *withSoundQuery = [NSString stringWithFormat: @"&withSound=%@", @"false"];
	
	//	NSString *sortQuery = [NSString stringWithFormat: @"&firstSort=%@&secondSort=%@&thirdSort=%@", firstSortText, secondSortText, thirdSortText];	
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat:	@"%@%@%@",
						   urlText,
						   whereQuery,
						   withSoundQuery];
	
	// Encode spaces, quotes, etc
	//	NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	///////////////////////////////
	// Get the Ukuleles:
	
	NSURL *url = [NSURL URLWithString: urlString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL: url cachePolicy: NSURLRequestReturnCacheDataElseLoad timeoutInterval: 30];
	
	// Fetch response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData =[NSURLConnection sendSynchronousRequest: urlRequest returningResponse: &response error: &error];
	
	if (!urlData) {
		NSLog(@"********** hydrateFromWebSearch: urlData is nil!!!"); //, doc);
		return;
	}
	
	// Parse response
	//	CXMLDocument *doc = [[CXMLDocument alloc] init];	
    //	CXMLDocument *doc = [CXMLDocument alloc];	
	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:urlData
									               options:0
									                 error:&error];
	if (!doc) {
		NSLog(@"********** hydrateFromWebSearch: doc is nil!!!"); //, doc);
		return;
	}
	
	//	NSArray *itemNodes = [[NSArray alloc] init];		
    //	NSArray *itemNodes = [NSArray alloc];		
	NSArray *itemNodes = [[doc nodesForXPath:@"Ukuleles/Ukulele" error:&error] retain];
	
	if (!itemNodes) {
		NSLog(@"********** hydrateFromWebSearch: itemNodes is nil!!!"); //, doc);
		return;
	}
	
	if (dazzItems == nil) {
		dazzItems = [[NSMutableArray alloc] init];
	}
	
	int nodeCount = [itemNodes count];
	int count = (nodeCount < 50) ? nodeCount : 50;
	
	for ( int i = 0; i < count; i++) {
		CXMLNode *node = [itemNodes objectAtIndex: i];
		
		DazzItem *dazzItem = [DazzItem alloc];
		//		[dazzItems addObject: [dazzItem initWithXmlNode:node]];
		//		[dazzItem release];
		
		[dazzItem initWithXmlNode:node];
		[dazzItems addObject: [dazzItem retain]];
		[dazzItem release];
	}
	
	[doc release];
	[itemNodes release];
	
	// Update object state with respect to hydration.
	hydrated = YES;
}

// ******* XML Methods:


- (id)initSearchWithXml {
    if ( (self = [super init]) ) {
        self.collector = @"DazzSearch";
        
        searchDazzItem = [DazzItem alloc];
        searchDazzItem.brand = @"All";
        searchDazzItem.maker = @"All";
        searchDazzItem.size  = @"All";
        searchDazzItem.model = @"All";
        
        [self createMasterListXml];
    }
    
    return self;
}

- (id)initWithXmlNode:(CXMLNode *)node {
    
	CXMLNode *childNode;
	NSInteger nodeCount = 0;
	NSError *error = nil;
    
	//	NSArray *itemNodes = [[NSArray alloc] init];		
    //	NSArray *itemNodes = [NSArray alloc];		
	
	// 1. ID
	NSArray *itemNodes = [node nodesForXPath:@"CollectionId" error:&error];
	nodeCount = [itemNodes count];
	if (nodeCount > 0) {
		childNode = [itemNodes objectAtIndex:0];
		self.collectionId = [childNode stringValue];
	}
	else {
		self.collectionId = @"0";
	}
	
	// 2. Owner Name
	itemNodes = [node nodesForXPath:@"OwnerName" error:&error];
	nodeCount = [itemNodes count];
	if (nodeCount > 0) {
		childNode = [itemNodes objectAtIndex:0];
		self.collector = [childNode stringValue];
	}
	else {
		self.collector = @"Unknown";
	}	
	
	// 3. Collection Name
	itemNodes = [node nodesForXPath:@"CollectionName" error:&error];
	nodeCount = [itemNodes count];
	if (nodeCount > 0) {
		childNode = [itemNodes objectAtIndex:0];
		self.name = [childNode stringValue];
	}
	else {
		self.name = @"Unkown";
	}
	
	// 4. Item Count
	itemNodes = [node nodesForXPath:@"ItemCount" error:&error];
	nodeCount = [itemNodes count];
	if (nodeCount > 0) {
		childNode = [itemNodes objectAtIndex:0];
		self.itemCount = [childNode stringValue];
	}
	else {
		self.itemCount = @"0";
	}
	
	// TODO - !
	// 5. Date (@"UpdateDate")
	// 6. Notes
	
	return self;
}

// Calls web service to get data in xml format
// This is hydrating of the collectible item from the collection point of view
// From the detail view there is much more information
- (void)hydrateFromXml {
    
    // Check if action is necessary.
    if (hydrated) return;
	/////////////////////////////////////////////////////////////////////////////////
	//
	// Get the collection items from the web service
	//
	
	// First, set up the strings that will be concatenated to form the query url:
	//
	NSString *firstSortText = [SharedTypes getSortFieldDBName:firstSortField];
	NSString *secondSortText = [SharedTypes getSortFieldDBName:secondSortField];
	NSString *thirdSortText = [SharedTypes getSortFieldDBName:thirdSortField];
	
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/"
                         @"GetCollectionItemBasics?"];
	NSString *firstSortQuery = [NSString stringWithFormat: @"&firstSort=%@", firstSortText];
	NSString *secondSortQuery = [NSString stringWithFormat: @"&secondSort=%@", secondSortText];
	NSString *thirdSortQuery = [NSString stringWithFormat: @"&thirdSort=%@", thirdSortText];	
	NSString *idQuery = [NSString stringWithFormat: @"id=%@", collectionId];
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat:	@"%@%@%@%@%@",
						   urlText,
						   idQuery,
						   firstSortQuery,
						   secondSortQuery,
						   thirdSortQuery];
	
	///////////////////////////////
	// Get the Ukuleles:
	
	if (dazzItems == nil) {
		dazzItems = [[NSMutableArray alloc] init];
	}
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	
	// Fetch response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	if (!urlData) {
		NSLog(@"********** urlData is nil!!!"); //, doc);
		return;
	}
	
	// Parse response
	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:urlData
												   options:0
									                 error:&error];
	if (!doc) {
		NSLog(@"********** doc is nil!!!"); //, doc);
		return;
	}
	
	//	NSArray *itemNodes = [[NSArray alloc] init];		
    //	NSArray *itemNodes = [NSArray alloc];		
	NSArray *itemNodes = [[doc nodesForXPath:@"Ukuleles/Ukulele" error:&error] retain];
	
	if (!itemNodes) {
		NSLog(@"********** itemNodes is nil!!!");
		return;
	}
	
	int count = [itemNodes count];
	
	for ( int i = 0; i < count; i++) {
		CXMLNode *node = [itemNodes objectAtIndex: i];
		
		DazzItem *dazzItem = [[DazzItem alloc] initWithXmlNode: node];
		[dazzItems addObject: [dazzItem retain]];		
		[dazzItem release];
	}
	
	[itemNodes release];
	[doc release];
	
    // Update object state with respect to hydration.
    hydrated = YES;
}

// For any Search collection, this is the only time the dazzItems are requested
- (void)hydrateFromDazzSearchXml: (DazzItem*) dazzItem {
	
	////////////////////////////////////////////////////////////////////////////////
	//
	// Get the collection items from the web service
	//
	
	// First, set up the strings that will be concatenated to form the query url:
	//
	//	NSString *firstSortText = [SharedTypes getSortFieldDBName: ItemBrand];
	//	NSString *secondSortText = [SharedTypes getSortFieldDBName: ItemSize];
	//	NSString *thirdSortText = [SharedTypes getSortFieldDBName: ItemModel];
	
	NSString *firstWhere = dazzItem.maker;
	if ([firstWhere compare: @"All"] == NSOrderedSame) {
		firstWhere = @"";
	}
	firstWhere = [SharedConversions escapeUrlParam: firstWhere];
	
	NSString *secondWhere = dazzItem.brand;
	if ([secondWhere compare: @"All"] == NSOrderedSame) {
		secondWhere = @"";
	}
	secondWhere = [SharedConversions escapeUrlParam: firstWhere];
	
	NSString *thirdWhere = dazzItem.size;
	if ([thirdWhere compare: @"All"] == NSOrderedSame) {
		thirdWhere = @"";
	}
	thirdWhere = [SharedConversions escapeUrlParam: thirdWhere];
	
	NSString *fourthWhere = dazzItem.model;
	if ([fourthWhere compare: @"All"] == NSOrderedSame) {
		fourthWhere = @"";
	}
	fourthWhere = [SharedConversions escapeUrlParam: fourthWhere];
	
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetItemsFromSearchStandardSort?"];
	NSString *whereQuery = [NSString stringWithFormat: @"firstWhere=%@&secondWhere=%@&thirdWhere=%@&fourthWhere=%@", 
							firstWhere,
							secondWhere,
							thirdWhere,
							fourthWhere];
	
	NSString *withSoundQuery = [NSString stringWithFormat: @"&withSound=%@", @"false"];
	
	//	NSString *sortQuery = [NSString stringWithFormat: @"&firstSort=%@&secondSort=%@&thirdSort=%@", firstSortText, secondSortText, thirdSortText];	
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat:	@"%@%@%@",
						   urlText,
						   whereQuery,
						   withSoundQuery];
	
	// Encode spaces, quotes, etc
	//	NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	///////////////////////////////
	// Get the Ukuleles:
	
	NSURL *url = [NSURL URLWithString: urlString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL: url cachePolicy: NSURLRequestReturnCacheDataElseLoad timeoutInterval: 30];
	
	// Fetch response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData =[NSURLConnection sendSynchronousRequest: urlRequest returningResponse: &response error: &error];
	
	if (!urlData) {
		NSLog(@"********** hydrateFromWebSearch: urlData is nil!!!"); //, doc);
		return;
	}
	
	// Parse response
	//	CXMLDocument *doc = [[CXMLDocument alloc] init];	
    //	CXMLDocument *doc = [CXMLDocument alloc];	
	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:urlData
												   options:0
									                 error:&error];
	if (!doc) {
		NSLog(@"********** hydrateFromWebSearch: doc is nil!!!"); //, doc);
		return;
	}
	
	//	NSArray *itemNodes = [[NSArray alloc] init];		
    //	NSArray *itemNodes = [NSArray alloc];		
	NSArray *itemNodes = [[doc nodesForXPath:@"Ukuleles/Ukulele" error:&error] retain];
	
	if (!itemNodes) {
		NSLog(@"********** hydrateFromWebSearch: itemNodes is nil!!!"); //, doc);
		return;
	}
    
	if (dazzItems == nil) {
		dazzItems = [[NSMutableArray alloc] init];
	}
    
	int nodeCount = [itemNodes count];
	int count = (nodeCount < 50) ? nodeCount : 50;
	
	for ( int i = 0; i < count; i++) {
		CXMLNode *node = [itemNodes objectAtIndex: i];
		
		DazzItem *dazzItem = [DazzItem alloc];
		//		[dazzItems addObject: [dazzItem initWithXmlNode:node]];
		//		[dazzItem release];
		
		[dazzItem initWithXmlNode:node];
		[dazzItems addObject: [dazzItem retain]];
		[dazzItem release];
	}
	
	[doc release];
	[itemNodes release];
	
	// Update object state with respect to hydration.
	hydrated = YES;
}

// The Master is the one field that must be selected first, that the other lists depend on
- (void)createMasterListXml {
	
	// We only want to load this once since it is a master list, not dependent on any other selections
	if ([primaryArray count] > 0 ) {
		return;
	}
	
	NSString *fieldName = [SharedTypes getSortFieldDBName: ItemBrand];
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntries?"];
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat: @"%@fieldName=%@", urlText, fieldName];
	
	// Encode spaces, quotes, etc
	NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	NSString *xPath = @"FieldEntries/Brand";
	// This will populate the itemNodes member with the CXMLNodes from the xml
	self.primaryArray = [self runSearchListQueryXml: escapedUrl nodePath: xPath];
	
	[self.primaryArray insertObject: @"All" atIndex: 0];
}

- (void)createSecondaryListXml {
	
	NSString *fieldName = [SharedTypes getSortFieldDBName: ItemSize];
	NSString *whereField = @"";
	NSString *urlText = @"";
	NSString *urlString = @"";
	
	// If the field name is "All" we will do a get of everything
	if ( [searchDazzItem.brand compare: @"All"] == NSOrderedSame ) {
		urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntries?"];
		
		// Build the entire request string:
		urlString = [NSString stringWithFormat: @"%@fieldName=%@", urlText, fieldName];
	}
	// Else we do a get with the master item filter
	else {		
		whereField = [SharedTypes getSortFieldDBName: ItemMaker];
		urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntriesWhere?"];
		
		// Build the entire request string:
		urlString = [NSString stringWithFormat: @"%@fieldName=%@&whereField=%@&whereName=%@", urlText, fieldName, whereField, searchDazzItem.brand];
	}
	
	// Encode spaces, quotes, etc
	NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	NSString *xPath = @"FieldEntries/Size";
	// This will populate the itemNodes member with the CXMLNodes from the xml
	self.secondaryArray = [self runSearchListQueryXml: escapedUrl nodePath: xPath];
	
	[self.secondaryArray insertObject: @"All" atIndex: 0];
}

- (void)createTertiaryListXml { // : (NSString *)masterText secondaryItem: (NSString *)secondary {
//	
//	// If the master item hasn't changed, don't reload the array
//	if ( [[dazzItem brand] compare: primaryItem] == NSOrderedSame ) {
//		return;
//	}
	
	NSString *fieldName = [SharedTypes getSortFieldDBName: ItemModel];
	NSString *whereField = @"";
	NSString *urlText = @"";
	NSString *urlString = @"";
	
	// If the field name is "All" we will do a get of everything
	if ( [searchDazzItem.brand compare: @"All"] == NSOrderedSame ) {
		urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntries?"];
		
		// Build the entire request string:
		urlString = [NSString stringWithFormat: @"%@fieldName=%@", urlText, fieldName];
	}
	// Else we do a get with the master item filter
	else {		
		whereField = [SharedTypes getSortFieldDBName: ItemMaker];
		urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/GetUniqueItemFieldEntriesWhere?"];
		
		// Build the entire request string:
		urlString = [NSString stringWithFormat: @"%@fieldName=%@&whereField=%@&whereName=%@", urlText, fieldName, whereField, searchDazzItem.brand];
	}
	
	// Encode spaces, quotes, etc
	NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	NSString *xPath = @"FieldEntries/Model";
	// This will populate the itemNodes member with the CXMLNodes from the xml
	self.tertiaryArray = [self runSearchListQueryXml: escapedUrl nodePath: xPath];
	
	[self.tertiaryArray insertObject: @"All" atIndex: 0];
}

- (NSMutableArray *)runSearchListQueryXml: (NSString *)escapedUrl nodePath: (NSString *)path {
	// This is the array we will return - empty or not!
	NSMutableArray *itemArray = [[NSMutableArray alloc] init];
	//	self.imagePaths = nodeArray;
	//	[nodeArray release];
	
	NSError *error = nil;
	
	NSURL *url = [NSURL URLWithString: escapedUrl];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL: url cachePolicy: NSURLRequestReturnCacheDataElseLoad timeoutInterval: 30];
	
	// Fetch response
	NSData *urlData;
	NSURLResponse *response;
	urlData =[NSURLConnection sendSynchronousRequest: urlRequest returningResponse: &response error: &error];
	
	if (!urlData) {
		NSLog(@"********** runSearchListQuery: urlData is nil!!!"); //, doc);
	}
	
	// Parse response
    //	CXMLDocument *doc = [[CXMLDocument alloc] init];	
    //	CXMLDocument *doc = [CXMLDocument alloc];	
	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:urlData
									               options:0
									                 error:&error];
	if (!doc) {
		NSLog(@"********** runSearchListQuery: doc is nil!!!"); //, doc);
	}
	
	// Get the nodes for the particular search param
    //	NSArray *itemNodes = [[NSArray alloc] init];		
	NSArray *itemNodes = [[doc nodesForXPath: path error:&error] retain];
	
	if (!itemNodes) {
		NSLog(@"********** runSearchListQuery: nodeArray is nil!!!");
	}
	
	// Add the nodes the the return array
	NSInteger nodeCount = [itemNodes count];
	
	for (int i = 0; i < nodeCount; i++) {
		CXMLNode *childNode = [itemNodes objectAtIndex: i];
		NSString *path = [[NSString alloc] initWithString: [childNode stringValue]];
		
		[itemArray addObject: path];
		[path release];
	}
	
	[doc release];
	[itemNodes release];
	
	return [itemArray autorelease];
}

// *******


// This returns the item at the current pointer and increments the pointer
- (DazzItem *)getNextItem {
	
	DazzItem * nextItem = nil;
	
	if ( currentItemsIndex < dazzItems.count ) {
		nextItem = [dazzItems objectAtIndex: currentItemsIndex];
		currentItemsIndex++;
	}
	
	return nextItem;
}

- (DazzItem *)dazzItemAtIndex:(NSInteger) index {
	return [dazzItems objectAtIndex:index];
}

- (EbayItem *)ebayItemAtIndex:(NSInteger) index {
	return [ebayItems objectAtIndex:index];
}

// **** DazzItem methods ***
//

- (NSInteger) countOfItemsMatchingQuadernaryName:(NSInteger)index {
	
	NSInteger count = 1;
	DazzItem* dazzItem = [dazzItems objectAtIndex: index];
	NSString* makerName = dazzItem.maker;
	
	while ( index + count < dazzItems.count ) {
		DazzItem* dazzItem = [dazzItems objectAtIndex: index + count];
		
		if ( [dazzItem.maker caseInsensitiveCompare:makerName] != NSOrderedSame ) {
			break;
		}
		count++;
	}
	return count;
}

- (NSInteger) countOfItemsMatchingPrimaryName:(NSInteger)index {
	
	NSInteger count = 1;
	DazzItem* dazzItem = [dazzItems objectAtIndex: index];
	NSString* brandName = dazzItem.brand;
	
	while ( index + count < dazzItems.count ) {
		DazzItem* dazzItem = [dazzItems objectAtIndex: index + count];
		
		if ( [dazzItem.brand caseInsensitiveCompare:brandName] != NSOrderedSame ) {
			break;
		}
		count++;
	}
	return count;
}

- (NSInteger) countOfItemsMatchingSecondaryName:(NSInteger)index {
	
	NSInteger count = 1;
	DazzItem* dazzItem = [dazzItems objectAtIndex:index];
	NSString* sizeName = dazzItem.size;
	
	for ( int i = index; i < dazzItems.count; i++ ) {
		DazzItem* dazzItem = [dazzItems objectAtIndex:index + count];
		
		if ( [dazzItem.size caseInsensitiveCompare:sizeName] != NSOrderedSame ) {
			break;
		}
		count++;
	}
	return count;
}

- (NSInteger) countOfItemsMatchingTertiaryName:(NSInteger)index {
	
	NSInteger count = 1;
	DazzItem* dazzItem = [dazzItems objectAtIndex: index];
	NSString* modelName = dazzItem.model;
	
	for ( int i = index; i < dazzItems.count; i++ ) {
		DazzItem* dazzItem = [dazzItems objectAtIndex: index + count];
		
		if ( [dazzItem.model caseInsensitiveCompare:modelName] != NSOrderedSame ) {
			break;
		}
		count++;
	}
	return count;
}

// **** AmpItem methods ***
//

/*
- (NSInteger) countOfItemsMatchingMerchantName:(NSInteger)index {
	
	NSInteger count = 1;
	AmpItem* ampItem = [ampItems objectAtIndex: index];
	NSString* merchantName = ampItem.merchantName;
	
	while ( index + count < ampItems.count ) {
		AmpItem* item = [ampItems objectAtIndex: index + count];
		
		if ( [item.merchantName caseInsensitiveCompare: merchantName] != NSOrderedSame ) {
			break;
		}
		count++;
	}
	return count;
}

- (NSInteger) countOfItemsMatchingTitleName:(NSInteger)index {
	
	NSInteger count = 1;
	AmpItem* ampItem = [ampItems objectAtIndex: index];
	NSString* title = ampItem.title;
	
	while ( index + count < ampItems.count ) {
		AmpItem* item = [ampItems objectAtIndex: index + count];
		
		if ( [item.title caseInsensitiveCompare: title] != NSOrderedSame ) {
			break;
		}
		count++;
	}
	return count;
}

- (NSInteger) countOfItemsMatchingCostName:(NSInteger)index {
	
	NSInteger count = 1;
	AmpItem* ampItem = [ampItems objectAtIndex: index];
	NSString* price = ampItem.price;
	
	while ( index + count < ampItems.count ) {
		AmpItem* item = [ampItems objectAtIndex: index + count];
		
		if ( [item.price caseInsensitiveCompare: price] != NSOrderedSame ) {
			break;
		}
		count++;
	}
	return count;
}
*/

- (void) zeroItemsIndex {
	currentItemsIndex = 0;
}

- (void) orderItemsByType:(ItemFieldType)type {

    NSString *key = @"";
    
    switch (type) {
        case ItemMaker:
            key = @"maker";
            [self setFirstSortField:ItemMaker];
            break;
        case ItemBrand:
            default:
            key = @"brand";
            [self setSecondSortField:ItemBrand];
            break;
    }
    
    NSArray *sortedArray = [SharedConversions sortArray: dazzItems withKey: key ascending: YES];
    [dazzItems removeAllObjects];
    [dazzItems release];
    dazzItems = [[NSArray alloc] initWithArray: sortedArray];
    
    
//    NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:key ascending:YES] autorelease]; 
//    [ [self dazzItems sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
}

- (ItemFieldType) getFirstSortField {
	return firstSortField;
}

- (ItemFieldType) getSecondSortField {
	return secondSortField;
}

- (ItemFieldType) getThirdSortField {
	return thirdSortField;
}

- (void) setFirstSortField: (ItemFieldType)type {
	firstSortField = type;
}

- (void) setSecondSortField: (ItemFieldType)type {
	secondSortField = type;
}

- (void) setThirdSortField: (ItemFieldType)type {
	thirdSortField = type;
}

- (void)dealloc {
    [collectionId release];
    [name release];
	[collector release];
    [notes release];
	[date release];
    [itemCount release];
	
	// Will the runtime remove these?  If not, I will:
	if ([dazzItems retainCount] > 0) {
		for (int i = 0; i < [dazzItems count]; i++)
			[dazzItems removeLastObject];
	}
	[dazzItems release];
	[ebayItems release];
	[super dealloc];
}

@end
