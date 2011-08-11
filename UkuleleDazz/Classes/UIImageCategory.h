//
//  UIImageCategory.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 8/5/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (UIImageCategory)
- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path;
+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path;
@end

