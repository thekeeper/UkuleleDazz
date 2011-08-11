//
//  ZooObject.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 6/19/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import "DazzObject.h"
#import "TouchXML.h"
#import "TouchJson.h"
#import "SharedConversions.h"

@implementation DazzObject

@synthesize hydrated;
@synthesize dirty;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithXml {
    return self;
}

- (id)initWithJson {
    return self;
}

- (id)initWithXmlNode:(CXMLNode *)node{
    return self;
}

- (id)initWithJsonString:(NSString *) json{
    return self;
}

- (id)initWithDictionary:(NSDictionary *) dictionary{
    return self;
}

- (void)hydrateFromXml{
    
}

- (void)hydrateFromJson{
    
}

- (void)hydrateFromSql{
    
}

- (void)dehydrateToWeb{
    
}

- (void)dehydrateToSql{
    
}

- (void)hydrateFromZooSearchXml: (DazzItem*) dazzItem{
    
}

- (void)hydrateFromZooSearchJson: (DazzItem*) dazzItem{
    
}

- (void)deleteFromWeb {
}

- (void)deleteFromSql {
}


//http://www.ukuzoo.com/ViewerWS.asmx/GetItemsFromSearchStandardSort?firstWhere=Nunes,%2520Leonardo&secondWhere=Nunes,%252520Leonardo&thirdWhere=&fourthWhere=&withSound=false&forSale=false


#pragma mark Helper methods

- (NSString *)jsonFromURLString:(NSString *)urlString targetObject:(NSString *)target isArray:(BOOL)array {
	
	// Encode spaces, quotes, etc
//	NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString: urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"GET"];
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [request release];
    [self handleError:error errorLocation:@"DazzObject: jsonFromUrlString"];    
	NSString *resultString = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
    
    // These next calls fix the json so it will parse
    if (array == NO) {
        resultString = [self jsonObjectToArray:resultString targetObject:target];
    }
    
    // Get rid of things like &amp; and &quot;
    NSString *jsonString = [SharedConversions unescapeHtml: [self jsonCleanup: resultString targetObject:target]];
    
    return jsonString;
}

- (NSString *)jsonCleanup:(NSString *)resultString targetObject:(NSString *)target {
    
    if (resultString.length == 0) {
        return resultString;
    }
    
    //@"{\"Collection\"" or @"{\"Ukulele\""
    NSString *targetString = [NSString stringWithFormat: @"{\"%@\"", target];
    NSRange range = [resultString rangeOfString: targetString];
    NSInteger index = range.location;
    
    if (index < 0 || index > (resultString.length - 1)) {
        return @"";
    }
    
    NSString *jsonString = [resultString substringFromIndex: index]; 
    
    // Now remove the very last brace (and the xml string close tag):
    range = [jsonString rangeOfString: @"}" options: NSBackwardsSearch ];
    jsonString = [jsonString substringToIndex: range.location ];
    
    return jsonString;
}

// This takes a single returned object and makes it an array of 1
- (NSString *)jsonObjectToArray:(NSString *)resultString targetObject:(NSString *)target {
    
    //@"{\"Collection\"" or @"{\"Ukulele\""
    NSString *targetString = [NSString stringWithFormat: @"{\"%@\":", target];
    NSString *replacementString = [NSString stringWithFormat:@"%@[", targetString];
    
    // Add the begin-array square bracket
    NSString *newString = [resultString stringByReplacingOccurrencesOfString:targetString withString:replacementString];
    
    // Add the end-array square bracket
    NSString *jsonString = [newString stringByReplacingOccurrencesOfString:@"}}}" withString:@"}]}}"];
    
    return jsonString;
}

// This shows the error to the user in an alert.
- (void)handleError:(NSError *)error errorLocation:(NSString *)location {
	if (error != nil) {
        NSString *errorMessage = [NSString stringWithFormat: @"[%@] - %@", location, [error localizedDescription]];
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [errorAlertView show];
        [errorAlertView release];
	}  
}

@end
