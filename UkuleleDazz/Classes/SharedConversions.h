//
//  SharedConversions.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 7/16/08.
//  Copyright 2008 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedTypes.h"

@class CXMLNode;

#define MAX_IMAGEVIEW_DIMENSION 200

@interface SharedConversions : NSObject {

}

+ (NSString *) stringForPath: (NSString *)xp ofNode: (CXMLNode *) node;

+ (NSString *) fullPathForImage: (NSString *)fileName;

+ (NSString *) fullPathForSound: (NSString *)fileName;

+ (NSString *) escapeUrlParam: (NSString *)param;

+ (NSString *)unescapeHtml:(NSString *)string;

+ (CGSize) getSizeOfText: (NSString *) text screenOrientation: (UIInterfaceOrientation)orientation screenBounds: (CGRect)bounds;
+ (CGSize) getSizeForImageView: (UIImage *) image;
+ (CGSize) getRoundedSizeForImageView: (UIImage *) image;

+ (CGSize) getlargestImageSizeForRect: (UIImage *) image maximumRect: (CGRect)maxRect;

+ (NSDictionary *)indexKeyedDictionaryFromArray: (NSArray *)array;

+ (NSArray*)sortArray:(NSArray*)arrayIn withKey:(NSString*)key ascending:(BOOL)asc;

@end
