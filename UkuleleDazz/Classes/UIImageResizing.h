//
//  UIImageResizing.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 3/1/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Resize)
- (UIImage*)scaleToSize: (CGSize)size;
- (id)rotateToPortrait;

- (CGFloat)toRadians: (CGFloat) degrees;

@end
