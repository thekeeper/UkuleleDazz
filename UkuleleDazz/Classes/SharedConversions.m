//
//  SharedConversions.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 7/16/08.
//  Copyright 2008 Terry Tucker. All rights reserved.
//

#import "SharedConversions.h"
#import "CXMLNode.h"


@implementation SharedConversions

+ (NSString *) stringForPath: (NSString *)xp ofNode: (CXMLNode *) node {
	NSError *error;
	NSArray *nodes = [node nodesForXPath:xp
								   error:&error];
	
	if (!nodes) {
		NSLog(@"stringForPath - nodes is nil");
		return nil;
	}
	
	if ( [nodes count] > 0) {
		return [[nodes objectAtIndex:0] stringValue];
	}
	return nil;
}

+ (NSString *) fullPathForImage: (NSString *)fileName {
	
	// fileName includes the /Images/ path   
	NSString *fullPath = [NSString stringWithFormat: @"http://ukuzoo.s3.amazonaws.com/Images/%@", fileName];
	return fullPath;
}

+ (NSString *) fullPathForSound: (NSString *)fileName {
	
	// fileName does not include the relative /Sound/ path
	NSString *fullPath = [NSString stringWithFormat: @"http://www.ukuzoo.com/Sound/%@", fileName];
	return fullPath;
}

+ (NSString *) escapeUrlParam: (NSString *)param {
	// Ampersands present a problem in the url.  The normal escape method will not escape an ampersand since they are used to delineate parameters
	// We can, however, escape the ampersand in the parameter itself
	NSString* escapedParam = [param stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

	escapedParam = [escapedParam stringByReplacingOccurrencesOfString: @"&" withString: @"%26"];
	return escapedParam;
}

+ (NSString *)unescapeHtml:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    return string;
}

+ (CGSize) getSizeOfText: (NSString *) text screenOrientation: (UIInterfaceOrientation)orientation screenBounds: (CGRect)bounds {
	CGFloat		width = 0;
	CGFloat		tableViewWidth;
	
	if (UIInterfaceOrientationIsPortrait(orientation))
		tableViewWidth = bounds.size.width;
	else
		tableViewWidth = bounds.size.height;
	
	// fudge factor
	width = tableViewWidth - 40;		
	
	// The max width is known, the max height is sort of a guess, after all it scrolls 
	CGSize		textSize = { width, 20000.0f };
	CGSize		size = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
	return size;
}

+ (CGSize) getSizeForImageView: (UIImage *) image {
	CGFloat conversionFactor = 1.0;
	CGSize finalSize;
		
	finalSize.height = image.size.height;
	finalSize.width = image.size.width;
	
	// First, lets see if we need to smallify our image...
	if (finalSize.height > MAX_IMAGEVIEW_DIMENSION || finalSize.width > MAX_IMAGEVIEW_DIMENSION) {
		// Figure the size for the view
		if (finalSize.height > finalSize.width) {
			conversionFactor = MAX_IMAGEVIEW_DIMENSION / finalSize.height;
		}
		else {
			conversionFactor = MAX_IMAGEVIEW_DIMENSION / finalSize.width;
		}
		
		// Changing the frame size of the view will automatically scale the image
		finalSize.height = finalSize.height * conversionFactor;
		finalSize.width = finalSize.width * conversionFactor;
	}
	return finalSize;
}

+ (CGSize) getRoundedSizeForImageView: (UIImage *) image {
	
	CGSize exactSize = [SharedConversions getSizeForImageView:image];
    CGSize finalSize;
    
	finalSize.height = roundf(exactSize.height + 0.5f);
	finalSize.width = roundf(exactSize.width + 0.5f);
	
	return finalSize;
}

+ (CGSize) getlargestImageSizeForRect: (UIImage *) image maximumRect: (CGRect)maxRect {
	CGFloat conversionFactor = 1.0;
	CGFloat imageHeight = image.size.height;
	CGFloat imageWidth = image.size.width;;
	
	// Bail out early if image already fits in both dimension
	if (imageHeight <= maxRect.size.height && imageWidth <= maxRect.size.width) {
		return image.size;
	}
	
	CGFloat maxRatio = maxRect.size.height / maxRect.size.width;
	
	// The rotatedImageSize will always be square or portrait
	CGSize rotatedImageSize = CGSizeMake(imageWidth, imageHeight);
	if (imageHeight < imageWidth) {
		rotatedImageSize = CGSizeMake(imageHeight, imageWidth);
	}
	CGFloat rotatedImageRatio = rotatedImageSize.height / rotatedImageSize.width;
	
	// In this case the image is taller, but relatively skinnier, so it will top out first
	if (rotatedImageRatio > maxRatio) {
		conversionFactor = maxRect.size.height / rotatedImageSize.height;
		rotatedImageSize.height = maxRect.size.height;
		rotatedImageSize.width = rotatedImageSize.width * conversionFactor;
	}
	else {
		conversionFactor = maxRect.size.width / rotatedImageSize.width;
		rotatedImageSize.width = maxRect.size.width;
		rotatedImageSize.height = rotatedImageSize.height * conversionFactor;
	}
		
	return rotatedImageSize;
}

+ (NSDictionary *)indexKeyedDictionaryFromArray: (NSArray *)array
{
    id objectInstance;
    NSUInteger indexKey = 0;
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array) {
        [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithInt:indexKey]];
        indexKey++;
    }
    
    return (NSDictionary *)[mutableDictionary autorelease];
}

+(NSArray*)sortArray:(NSArray*)arrayIn withKey:(NSString*)key ascending:(BOOL)asc {
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey: key ascending: asc] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject: sortDescriptor];
    NSArray *sortedArray = [arrayIn sortedArrayUsingDescriptors: sortDescriptors];
    
    return sortedArray;
}


@end
