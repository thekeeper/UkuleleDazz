//
//  Dazz.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 6/22/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import "Dazz.h"
#import "DazzCollection.h"

#import "TouchXML.h"
#import "TouchJson.h"


@implementation Dazz

@synthesize dazzCollections;

// Retrieve minimal information for all objects.
- (id)initWithJson {
    
	// Get all of the collections info from the ukuzoo web service
    // The database is stored in the application bundle. 
	NSString *urlString = [NSString stringWithFormat:   
                           @"http://www.ukuzoo.com/ViewerWS.asmx/"
                           @"GetAllCollectionsJson"];
    // Execute search by performing an HTTP GET to the REST web service which returns JSON
    
    NSString *resultString = [self jsonFromURLString:urlString targetObject:@"Collection" isArray: YES];
    
    // ***** Testing with static file:
    //    NSString* path = [[NSBundle mainBundle] pathForResource:@"CollectionsJson" 
    //                                                     ofType:@"txt"];
    //    NSString* resultString = [NSString stringWithContentsOfFile:path
    //                                                  encoding:NSUTF8StringEncoding
    //                                                     error:NULL];    
    // *****
    
//    NSLog(@"resultString retainCount: %d", [resultString retainCount] );
    
    NSData *jsonData = [[resultString dataUsingEncoding:NSUTF32BigEndianStringEncoding] retain ];
    
    // Parse JSON results with TouchJSON.  It converts it into a dictionary.
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
    [self handleError:error errorLocation:@"DazzItem: hydrateDetailsFromJson"];	
	if (dazzCollections == nil) {
		dazzCollections = [[NSMutableArray alloc] init];
	}
    
	[dazzCollections removeAllObjects];
    
    NSArray *collectionArray = [resultsDictionary objectForKey:@"Collection"];
    for (NSDictionary *collectionDictionary in collectionArray) {
        DazzCollection *dazzCollection = [[[DazzCollection alloc] initWithDictionary: collectionDictionary] autorelease];
        [dazzCollections addObject: dazzCollection];
    }    
    
    [jsonData release];
    
    return self;
}

- (id)initWithSearchItemJson: (DazzItem *) dazzItem {
    
    return self;
}

// Retrieve minimal information for all objects.
- (void)initializeCollectionListXml {
    
	// Get all of the collections info from the ukuzoo web service
    // The database is stored in the application bundle. 
	NSString *urlString = [NSString stringWithFormat:   
                           @"http://www.ukuzoo.com/ViewerWS.asmx/"
                           @"GetAllCollectionsJson"];
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	
	// Fetch response
	NSData *urlData; 
	NSURLResponse *response;
	NSError *error;
	urlData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	if (!urlData) {
		NSLog(@"********** urlData is nil!!!");
		return;
	}
	
	// Parse response
	[doc release];
	doc = [[CXMLDocument alloc] initWithData:urlData
									 options:0
									   error:&error];
	if (!doc) {
		NSLog(@"********** doc is nil!!!");
		return;
	}
	
	[itemNodes release];
	itemNodes = [[doc nodesForXPath:@"Collections/Collection" error:&error] retain];
	
	if (!itemNodes) {
		NSLog(@"********** itemNodes is nil!!!");
		return;
	}
	
	if (dazzCollections == nil) {
		dazzCollections = [[NSMutableArray alloc] init];
	}
	
	for ( int i = 0; i < [itemNodes count]; i++) {
		
		CXMLNode *node = [itemNodes objectAtIndex: i];
        
		DazzCollection *dazzCollection = [[[DazzCollection alloc] initWithXmlNode: node] autorelease]; 
        
		// Set the default sort parameters
		[dazzCollection setFirstSortField: ItemMaker];
		[dazzCollection setSecondSortField:  ItemSize];
        [dazzCollection setThirdSortField: ItemModel];
		
		[dazzCollections addObject: dazzCollection];
	}
    
}

- (void)dealloc {
    //        [navigationController release];   
    //        [dazzCollections release];
    [itemNodes release];
    [super dealloc];
}

@end
