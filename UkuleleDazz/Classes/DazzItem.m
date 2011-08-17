 //
//  DazzItem.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 6/12/08.
//  Copyright 2008 Terry Tucker. All rights reserved.
//

#import "DazzItem.h"
#import "Comment.h"
#import "NSArrayCategory.h"
#import "SharedConversions.h"
#import "TouchXML.h"
#import "CXMLNode_PrivateExtensions.h"

#define THUMBNAIL_WIDTH 43
#define THUMBNAIL_HEIGHT 35

// Private interface for DazzItem - internal only methods.
@interface DazzItem (Private)
- (CXMLNode *)getNotesAndImagesNode;
- (void)hydrateDetailsFromJson;
- (void)hydrateCommentsFromJson;
- (NSMutableArray *)getCommentsArrayFromXml;
- (NSMutableArray *)getCommentsArrayFromJson;
- (void)hydrateFromXmlNodes:(CXMLNode *)itemNode commentsNodes:(NSMutableArray *)nodeArray;
//- (void)hydrateFromXmlNodes:(CXMLNode *)itemNode commentsNodes:(NSMutableArray *)nodeArray;
@end

@implementation DazzItem

@synthesize brand;
@synthesize maker;
@synthesize size;
@synthesize model;
@synthesize notes;
@synthesize condition;
@synthesize vintage;
@synthesize sound;

@synthesize itemId;
@synthesize anotherItemId;
@synthesize detailImage;
@synthesize thumbnailImage;
@synthesize comments;
@synthesize imagePaths;

#pragma mark The Web Service access methods:

-(id)init
{
    if ((self = [super init]))
    {		
		//self.collector = @"Me";
    }
    return self;
}

- (id)initWithXmlNode:(CXMLNode *)node {
    if ( (self = [super init]) ) {
		CXMLNode *childNode;
		int nodeCount = 0;
		NSError *error = nil;
		
		// Before doing any of the parsing we will initialize two of the image fields with small default images
		// The database is stored in the application bundle. 
//		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//		NSString *documentsDirectory = [paths objectAtIndex:0];
//		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"ukuzoo.db"];
		
		// The node we have here is an DazzItem node.  We are going to parse out its child nodes
		// to get the basic information about this particular dazzItem:
		
		// 1. ID
//		[itemNodes release];
		NSArray *itemNodes = [node nodesForXPath:@"UkuleleID" error:&error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex:0];
			self.itemId = [childNode stringValue];
			
			// Set the thumbnail image path
			// There is a thumbnail created specifically for this purpose so let's use it:
			NSString *imagePath = [NSString stringWithFormat:	@"%@_1_th.jpg", itemId];
			[self setThumbnailImageFromPath:imagePath];
		}
		else {
			// Need to do an assert here!
			itemId = @"0";
		}
		
		// 2. Brand
		itemNodes = [node nodesForXPath:@"Brand" error:&error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex:0];
			self.brand = [childNode stringValue];
		}
		else {
			self.brand = @"Unknown";
		}
		
		// 3. Maker (I know the param is 'maker')
		itemNodes = [node nodesForXPath:@"Maker" error:&error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex:0];
			self.maker = [childNode stringValue];
		}
		else {
			self.maker = @"Unknown";
		}
		
		// 4. Type (I know the param is 'size')
		itemNodes = [node nodesForXPath:@"Size" error:&error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex:0];
			self.size = [childNode stringValue];
		}
		else {
			self.size = @"Unknown";
		}
		
		// 5. Model
		itemNodes = [node nodesForXPath:@"Model" error:&error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex:0];
			self.model = [childNode stringValue];
		}
		else {
			self.model = @"Unknown";
		}
		
		// 6. Date
		itemNodes = [node nodesForXPath:@"Date" error:&error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex:0];
			self.vintage = [childNode stringValue];
		}
		else {
			self.vintage = @"Unknown";
		}
		
		// 7. Condition
		itemNodes = [node nodesForXPath:@"Condition" error:&error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex:0];
			self.condition = [childNode stringValue];
		}
		else {
			self.condition = @"Unknown";
		}
		
		// 8. Does this have a sound file?
		itemNodes = [node nodesForXPath:@"Sound" error:&error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex:0];
			self.sound = [childNode stringValue];
			
			// If this string is not nil, display the sound icon:
			
		}
		else {
			self.condition = @"Unknown";
		}
    }
    return [self autorelease];
}

- (id)initWithDictionary: (NSDictionary *)dictionary {
    
    NSObject* obj = [dictionary objectForKey:@"ItemId"];
    if (obj == [NSNull null])
        self.itemId = @"";
    else
        self.itemId = (NSString *) obj;
    
    obj = [dictionary objectForKey:@"Brand"];
    if (obj == [NSNull null])
        self.brand = @"";
    else
        self.brand = (NSString *) obj;
    
    obj = [dictionary objectForKey:@"Maker"];
    if (obj == [NSNull null])
        self.maker = @"";
    else
        self.maker = (NSString *) obj;

	obj = [dictionary objectForKey:@"Size"];
    if (obj == [NSNull null])
        self.size = @"";
    else
        self.size = (NSString *) obj;
    
    obj = [dictionary objectForKey:@"Model"];
    if (obj == [NSNull null])
        self.model = @"";
    else
        self.model = (NSString *) obj;
    
    obj = (NSString *)[dictionary objectForKey: @"Date"];
    if (obj == [NSNull null])
        self.vintage = @"";
    else
        self.vintage = (NSString *) obj;
    
    obj = [dictionary objectForKey: @"Condition"];
    if (obj == [NSNull null])
        self.condition = @"";
    else
        self.condition = (NSString *) obj;
    
    obj = [dictionary objectForKey: @"Sound"];
    if (obj == [NSNull null])
        self.sound = @"";
    else
        self.sound = (NSString *) obj;
    
    // Set the thumbnail image path
    // There is a thumbnail created specifically for this purpose but we have to generate the path using the id:
    NSString *imagePath = [NSString stringWithFormat:	@"%@_1_th.jpg", itemId];
    [self setThumbnailImageFromPath:imagePath];
	
    return self;

}

// This is done when we drill down to display a single item
//
// *** Objects we will purge from memory (dehydrate):
// notes - because they could be detailed?
// Pics
//
- (void)hydrateFromXml {
	
    // Check if action is necessary.
    if (hydrated) return;
	
	/////////////////////////////////////////////////////////////////////////////////
	//
	// Get the collection items from the web service
	//
	
	CXMLNode *itemNode = [self getNotesAndImagesNode];
	NSMutableArray *commentsNodes = [self getCommentsArrayFromXml];
	[self hydrateFromXmlNodes:itemNode commentsNodes:commentsNodes];
	
    // Update object state with respect to hydration.
    hydrated = YES;
}

- (void)hydrateFromJson {
	
    // Check if action is necessary.
    if (hydrated) return;
    
    // Get the image names, notes, ...	
//	[self hydrateDetailsFromJson];
    
//    NSString *resultString = [self jsonFromURLString:@"http://www.ukuzoo.com/ViewerWS.asmx/GetItemDetailsByIdJson?id=76&withSound=false" targetObject:@"Ukulele" isArray: NO];
    
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/"
                         @"GetItemDetailsByIdJson?"];
	NSString *soundQuery = @"&withSound=false";
	NSString *idQuery = [NSString stringWithFormat: @"id=%@", itemId];
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat: @"%@%@%@",
                           urlText,
                           idQuery,
                           soundQuery];
    
    NSString *resultString = [self jsonFromURLString:urlString targetObject:@"Ukulele" isArray: NO];

    if (resultString.length < 1) {
        return;
    }
    
    NSData *jsonData = [[resultString dataUsingEncoding:NSUTF32BigEndianStringEncoding] retain ];
    
    // Parse JSON results with TouchJSON.  It converts it into a dictionary.
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
    [self handleError:error errorLocation:@"DazzItem: hydrateDetailsFromJson"];
    
    // There is only one object at this level, not an array
    NSArray *itemArray = [resultsDictionary objectForKey:@"Ukulele"];
    
    for (NSDictionary *itemDictionary in itemArray) {
    
        NSObject* obj = [itemDictionary objectForKey: @"Notes"];
        if (obj == [NSNull null])
            self.notes = @"";
        else
            self.notes = (NSString *) obj;
        
        // Set the detailImage image object using the image name
        obj = [itemDictionary objectForKey: @"Image"];
        if (obj != [NSNull null]) {
            NSString *path = [NSString stringWithFormat:@"%@", (NSString *) obj];
            [self setDetailImageFromPath: path];
        }
        
        // Get the photo paths
        obj = [itemDictionary objectForKey: @"PhotoName"];
        if (obj != [NSNull null]) {
            self.imagePaths = [[NSMutableArray alloc] initWithArray: (NSArray *)obj];
        }
        
    }    
    
    [jsonData release];
    
    
    // Get the comments
	[self hydrateCommentsFromJson];
	
    // Update object state with respect to hydration.
    hydrated = YES;
}

- (void)hydrateDetailsFromJson {
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/"
                         @"GetItemDetailsByIdJson?"];
	NSString *soundQuery = @"&withSound=false";
	NSString *idQuery = [NSString stringWithFormat: @"id=%@", itemId];
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat: @"%@%@%@",
                           urlText,
                           idQuery,
                           soundQuery];
    
//    NSString *urlString = @"http://www.ukuzoo.com/ViewerWS.asmx/GetItemDetailsByIdJson?id=76&withSound=false";
    
    NSString *resultString = [self jsonFromURLString:urlString targetObject:@"Ukulele" isArray: NO];
    
    if (resultString.length < 1) {
        return;
    }
    
    NSData *jsonData = [[resultString dataUsingEncoding:NSUTF32BigEndianStringEncoding] retain ];
    
    // Parse JSON results with TouchJSON.  It converts it into a dictionary.
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
    [self handleError:error errorLocation:@"DazzItem: hydrateDetailsFromJson"];
    
    // There is only one object at this level, not an array
    NSArray *itemArray = [resultsDictionary objectForKey:@"Ukulele"];
    
    for (NSDictionary *itemDictionary in itemArray) {
        
        NSObject* obj = [NSNull null];
        obj = [itemDictionary objectForKey: @"Notes"];
        if (obj == [NSNull null])
            self.notes = @"";
        else
            self.notes = (NSString *) obj;
        
        // Set the detailImage image object using the image name
        obj = [itemDictionary objectForKey: @"Image"];
        if (obj != [NSNull null]) {
            NSString *path = [NSString stringWithFormat:@"%@", (NSString *) obj];
            [self setDetailImageFromPath: path];
        }
    }    
    
    [jsonData release];
}

- (void)hydrateCommentsFromJson {
	
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/"
                            @"GetRemarksJson?"];
	
	
    NSString *idQuery = [NSString stringWithFormat: @"id=%@", itemId];
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat:	@"%@%@",
                           urlText,
                           idQuery];
    
    NSString *resultString = [self jsonFromURLString:urlString targetObject:@"Remark" isArray: YES];
    
    if (resultString.length < 1) {
        return;
    }
    
    NSData *jsonData = [[resultString dataUsingEncoding:NSUTF32BigEndianStringEncoding] retain ];
    
    // Parse JSON results with TouchJSON.  It converts into a dictionary.
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];
    [self handleError:error errorLocation:@"DazzItem: hydrateCommentsFromJson"];
	
	if (comments == nil) {
		comments = [[NSMutableArray alloc] init];
	}
    
	[comments removeAllObjects];
    
    // When there is only one item in the collection, we get a dictionary rather than an array of dictionaries.
    id obj = (NSArray *)[resultsDictionary objectForKey:@"Remark"];
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        Comment *comment = [[Comment alloc] initWithDictionary: obj];
        [comments addObject: comment];
    } else {
        for (NSDictionary *commentDictionary in obj) {
            Comment *comment = [[Comment alloc] initWithDictionary: commentDictionary];
            [comments addObject: comment];
        }    
    }
    
    [jsonData release];
}

- (CXMLNode *)getNotesAndImagesNode {
	CXMLNode *itemNode = nil;
	
	// First, set up the strings that will be concatenated to form the query url:
	//
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/"
		@"GetItemDetailsById?"];
	NSString *soundQuery = @"&withSound=false";
	NSString *idQuery = [NSString stringWithFormat: @"id=%@", itemId];
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat:	@"%@%@%@",
		urlText,
		idQuery,
		soundQuery];
	
	///////////////////////////////
	// Get the array containing a single item:
	
//	NSMutableArray *itemArray = [[NSMutableArray alloc] init];
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	
	// Fetch response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	if (!urlData) {
		NSLog(@"********** urlData is nil!!!");
		return itemNode;
	}
	
	// Parse response
	CXMLDocument *itemDoc = [[CXMLDocument alloc] initWithData:urlData
									 options:0
									   error:&error];
	if (!itemDoc) {
		NSLog(@"********** doc is nil!!!");
		return itemNode;
	}
	
	NSMutableArray *itemArray = [[itemDoc nodesForXPath:@"Ukuleles/Ukulele" error:&error] retain];
	
	if (!itemArray) {
		NSLog(@"********** itemNodes is nil!!!");
		return itemNode;
	}
	
	int count = [itemArray count];
	
	if (count > 0) {
		itemNode = [itemArray objectAtIndex: 0];
	}
	
	[itemArray release];
	
	return itemNode;
}

- (NSMutableArray *)getCommentsArrayFromXml {
	
	NSMutableArray *itemArray = [[NSMutableArray alloc] init];
	
	// First, set up the strings that will be concatenated to form the query url:
	//
	NSString *urlText = [NSString stringWithFormat:	@"http://www.ukuzoo.com/ViewerWS.asmx/"
		@"GetRemarks?"];
	
	NSString *idQuery = [NSString stringWithFormat: @"id=%@", itemId];
	
	// Build the entire request string:
	NSString *urlString = [NSString stringWithFormat:	@"%@%@",
		urlText,
		idQuery];
	
	///////////////////////////////
	// Get the array containing a single item:
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	
	// Fetch response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	if (!urlData) {
		NSLog(@"********** getCommentsArray: urlData is nil!!!");
		return [itemArray autorelease];
	}
	
	// Parse response
	[commentsDoc release];
	commentsDoc = [[CXMLDocument alloc] initWithData:urlData
									 options:0
									   error:&error];
	if (!commentsDoc) {
		NSLog(@"********** getCommentsArray: doc is nil!!!");
		return [itemArray autorelease];
	}
	
	[itemArray release];
	itemArray = [[commentsDoc nodesForXPath:@"Remarks/Remark" error:&error] retain];
	
	if (!itemArray) {
		NSLog(@"********** getCommentsArray: itemNodes is nil!!!");
	}
	
	return [itemArray autorelease];
}

- (void)hydrateFromXmlNodes:(CXMLNode *)itemNode commentsNodes:(NSMutableArray *)nodeArray {
	
	CXMLNode *childNode;
	int nodeCount = 0;
	NSError *error = nil;
	
	// First, get the notes and the image paths:
	
	// The node we have here is an DazzItem node.  We are going to parse out its child nodes
	// to get the basic information about this particular dazzItem:
	
	if (itemNode != nil) {
		// 1. Notes
		NSArray *itemNodes = [itemNode nodesForXPath:@"Notes" error:&error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex:0];
			[self setNotes: [childNode stringValue]];
		}
		else {
			// Need to do an assert here!
			[self setNotes: @""];
		}
	
		// 2. ImagePaths
		itemNodes = [itemNode nodesForXPath:@"ImagePath" error: &error];
		nodeCount = [itemNodes count];
		bool detailImageCreated = false;

		if (nodeCount > 0) {
		
			NSMutableArray *tempArray = [[NSMutableArray alloc] init];
			NSLog(@"************* DazzItem hydrateFromXmlNodes self.imagePaths = tempArray");
			self.imagePaths = tempArray;
			[tempArray release];
		
			for (int i = 0; i < nodeCount; i++) {
				childNode = [itemNodes objectAtIndex: i];
				NSString *path = [[NSString alloc] initWithFormat: @"%@", [childNode stringValue]];

				// When the path is empty, the xsl returns "/Images/\n"
				if ( [path rangeOfString: @".jpg"].location != NSNotFound) {
					// Use the first image for the top of the Item Detail Page
					if ( i == 0 ) {
						// This is the image the thumbnail is created from. If it fails we will use the default image
						detailImageCreated = [self setDetailImageFromPath: path];
					}
					NSLog(@"************* DazzItem hydrateFromXmlNodes [self.imagePaths addObject: path]");

					[self.imagePaths addObject: path];
				}
				[path release];
			}
		}
		if (detailImageCreated == false) {
			[self setDetailImageFromPath: @"/Images/DefaultDetailImage.png"];
		}
	}
	
	if (nodeArray != nil) {
		nodeCount = [nodeArray count];
		
		// Initialize the array:
		NSMutableArray *tempArray = [[NSMutableArray alloc] init];
		self.comments = tempArray;
		[tempArray release];
		
		for (int i = 0; i < nodeCount; i++) {
			CXMLNode *node = [nodeArray objectAtIndex: i];
			
			Comment *comment = [Comment alloc];
			[comments addObject: [comment initWithXmlNode:node]];	
//			[comment release];
		}
	}
	
	// Create an empty Comment to display that there are no comments :-)
	if (nodeArray == nil || [nodeArray count] < 1) {
		
		Comment *comment = [Comment alloc];
//		[comment initAsEmpty];
		[comments addObject:comment];	
		[comment release];
	}
}

// Flushes all but the primary key, maker, size, model, and vintage out to the database.
- (void)dehydrateToWeb {
    if (dirty) {
        // Write any changes to the database.

        // Update the object state with respect to unwritten changes.
        dirty = NO;
    }
    // Release member variables to reclaim memory. Set to nil to avoid over-releasing them if dehydrate is called multiple times.
    [notes release];
    notes = nil;

    hydrated = NO;
}

- (Comment *)commentForRow: (NSInteger)row {
	if (row > -1 && row < comments.count) {
        return [comments objectAtIndex:row];
	}
	return nil;
}

#pragma mark Properties
// Accessors implemented below. All the "get" accessors simply return the value directly, with no additional
// logic or steps for synchronization. The "set" accessors attempt to verify that the new value is definitely
// different from the old value, to minimize the amount of work done. Any "set" which actually results in changing
// data will mark the object as "dirty" - i.e., possessing data that has not been written to the database.
// All the "set" accessors copy data, rather than retain it. This is common for value objects - strings, numbers, 
// dates, data buffers, etc. This ensures that subsequent changes to either the original or the copy don't violate 
// the encapsulation of the owning object.

- (NSInteger)primaryKey {
    return primaryKey;
}

//- (NSString *)brand {
//    return brand;
//}
//
//- (void)setBrand:(NSString *)aString {
//    if ((!brand && !aString) || (brand && aString && [brand isEqualToString:aString])) return;
//    dirty = YES;
//    [brand release];
//    brand = [aString copy];
//}

- (void)setThumbnailImageFromPath: (NSString *)path {
	NSString *fullPath = [SharedConversions fullPathForImage:path];
	
	NSURL *url = [NSURL URLWithString:fullPath];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:imageData]; //    thumbnailImage = [[UIImage alloc] initWithData:imageData];
    
    NSLog(@"image (%f, %f)", [image size].width, [image size].height);
    

    CGSize finalSize = CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
    
    // Check for retina display
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) {
        finalSize = CGSizeMake(THUMBNAIL_WIDTH * 2, THUMBNAIL_HEIGHT * 2);
    }
    
    thumbnailImage = [self orientResizeAndCrop:image toSize: finalSize];
    [image release];
    
    NSLog(@"thumbnailImage (%f, %f)", [thumbnailImage size].width, [thumbnailImage size].height);
    
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) {
        CGImageRef ref = [thumbnailImage CGImage];
        [thumbnailImage initWithCGImage:ref scale:2.0 orientation:UIImageOrientationUp];
    }
	
	if ( thumbnailImage == nil ) {
		NSLog(@"setThumbnailImageFromPath: %@, is not found", fullPath);
        
        // Set image from filename
        thumbnailImage = [UIImage imageNamed:@"DefaultThumbnailImage.png"];
	}
}

// The path requires the "/Images/" folder path.  Since that's how it is sent in the xml other calls need that too
- (bool)setDetailImageFromPath: (NSString *)path {
	bool isImageFound = true;
	NSString *fullPath = [SharedConversions fullPathForImage:path];
	
	NSURL *url = [NSURL URLWithString:fullPath];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	detailImage = [[UIImage alloc] initWithData:imageData];
    
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) {
        CGImageRef ref = [detailImage CGImage];
        [detailImage initWithCGImage:ref scale:2.0 orientation:UIImageOrientationUp];
    }
	
	if ( detailImage == nil ) {
		NSLog(@"setDetailImageFromPath: path, %@, is not found", fullPath);
		isImageFound = false;
	}
	return isImageFound;
}

// WARNING!! This method assumes the the croppedSize is in Landscape mode.
- (UIImage *)orientResizeAndCrop:(UIImage *)originalImage toSize:(CGSize)croppedSize {
    
    // Get dimensions of original image	
	CGImageRef originalImageRef = originalImage.CGImage;	
	CGFloat originalWidth = CGImageGetWidth(originalImageRef);
	CGFloat originalHeight = CGImageGetHeight(originalImageRef);
    
    // This will be set to YES if the image is not the same orientation (landscape vs portrait) as the croppedSize
    bool doRotate = NO;
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, originalWidth, originalHeight);
    
    // What we want is to be sure a reduced and cropped image will fill the entire croppedImage rect
    // So we choose the correct dimension to get our ratio and cropthe other dimension 
    // If necessary we will rotate so that the image is in landscape perspective
    CGFloat originalAspectRatio = originalWidth / originalHeight;
    CGFloat croppedAspectRatio =  croppedSize.width / croppedSize.height;
    CGFloat scaleRatio = 0.0;
    bool cropHeight = NO;
    
    // Original is in landscape mode
    if (originalAspectRatio > 1) {
        scaleRatio = croppedSize.height / originalHeight;
        bounds.size.width = originalWidth * scaleRatio;
        bounds.size.height = croppedSize.height;
        
        // This is where we ensure that the proper ratio and crop dimensions are used
        if (originalAspectRatio < croppedAspectRatio) {
            scaleRatio = croppedSize.width / originalWidth;
            bounds.size.width = croppedSize.width;
            bounds.size.height = originalHeight * scaleRatio;
            cropHeight = YES;
        }
    }
    // Original is in portrait mode and must be rotated
    else {
        originalAspectRatio = originalHeight / originalWidth;
        scaleRatio = croppedSize.height / originalWidth;
        bounds.size.width = originalHeight * scaleRatio;
        bounds.size.height = croppedSize.height;
        
        // This is where we ensure that the proper ratio and crop dimensions are used to fill the smaller rectangle
        if (originalAspectRatio < croppedAspectRatio) {
            scaleRatio = croppedSize.width / originalHeight;
            bounds.size.width = croppedSize.width;
            bounds.size.height = originalWidth * scaleRatio;
            cropHeight = YES;
        }
        doRotate = YES;
    }
	
	UIImageOrientation orient = originalImage.imageOrientation;

    CGFloat x = 0.0;
    CGFloat y = 0.0;
    
    if (doRotate) {
        transform = CGAffineTransformMakeTranslation(0.0, originalWidth);
        transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
        
        // I can't explaing this, but it works!
        x = -(originalHeight - originalWidth); //-(originalWidth) * 0.5);
    }
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -originalHeight, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -originalHeight);
	}
	
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(x, y, originalWidth, originalHeight), originalImageRef);
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
//    return [scaledImage retain];

    //
    //*********** End first image context and begin a new one ***************//
    //
    
    // Now crop
    //create a context to do our clipping
    UIGraphicsBeginImageContext(croppedSize);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Create a rect with the size we want to crop the image to
    // The X and Y here are zero so we start at the beginning of our newly created context
    CGRect clippedRect = CGRectMake(0, 0, croppedSize.width, croppedSize.height);
    CGContextClipToRect( currentContext, clippedRect);
    
    // We will only be offsetting one dimension. Scaling took care of the other dimension
    x = 0.0;
    y = 0.0;
    if (cropHeight && bounds.size.height > croppedSize.height) {
        y = (bounds.size.height - croppedSize.height) * 0.5;
    }
    else {
        if (bounds.size.width > croppedSize.width) {
            x = (bounds.size.width - croppedSize.width) * 0.5;
        }
    }
    
    // Create a rect equivalent to the full size of the image
    // Offset the rect by the X and Y we want to start the crop from in order to cut off anything before them
    CGRect drawRect = CGRectMake(x * -1, //rect.origin.x * -1,
                                 y * -1, //rect.origin.y * -1,
                                 scaledImage.size.width,
                                 scaledImage.size.height);
    
    // Account for 1st quadrant drawing implemented by Quartz
    CGContextTranslateCTM(currentContext, 0.0, drawRect.size.height);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    //draw the image to our clipped context using our offset rect
    CGContextDrawImage(currentContext, drawRect, scaledImage.CGImage);
    
    //pull the image from our cropped context
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    //Note: this is autoreleased
    return [croppedImage retain];
}

- (void)dealloc {
    [brand release];
    [maker release];
    [size release];
    [model release];
	[vintage release];
	[condition release];
	[sound release];
	[detailImage release];
	[comments release];
	[thumbnailImage release];
	[imagePaths release];
    [super dealloc];
}

@end
