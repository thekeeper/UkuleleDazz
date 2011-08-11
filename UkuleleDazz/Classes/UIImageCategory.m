//
//  UIImageCategory.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 8/5/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import "UIImageCategory.h"

@implementation UIImage (UIImageCategory)

- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path {
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) {
        NSString *path2x = [[path stringByDeletingLastPathComponent] 
                            stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.%@", 
                                                            [[path lastPathComponent] stringByDeletingPathExtension], 
                                                            [path pathExtension]]];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:path2x] ) {
            return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:2.0 orientation:UIImageOrientationUp];
        }
    }
    
    return [self initWithData:[NSData dataWithContentsOfFile:path]];
}

+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path {
    return [[[UIImage alloc] initWithContentsOfResolutionIndependentFile:path] autorelease];
}

@end