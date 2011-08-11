//
//  UIImageResizing.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 3/1/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "UIImageResizing.h"
#include <math.h>


@implementation UIImage (Resizing)

static inline double radians (double degrees) {return degrees * M_PI/180;}

- (UIImage*)scaleToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (id)rotateToPortrait {
	CGSize imgSize = [self size];
	
	// In this case we need to rotate 90 degrees before we scale
	if (imgSize.height > imgSize.width) {
		return self;
	}
	
	UIGraphicsBeginImageContext(imgSize);
//	CGContextRef context = UIGraphicsGetCurrentContext();
	
//	CGContextTranslateCTM (context, 0.0f, 0.0f);
	
	// Rotate CCW
//	CGContextRotateCTM (context, radians(-90.) );
	
	// Switch the height and width
//	CGRect portraitRect = CGRectMake(0.0f, 0.0f, imgSize.height, imgSize.width);
//	CGContextDrawImage(context, portraitRect, self.CGImage);
	UIImage* rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
			
//	CGSize viewSize = rotatedImage.size;
	return rotatedImage;
}

- (id)rotateToPortrait2 {
	CGSize imgSize = [self size];
	
	// In this case we need to rotate 90 degrees before we scale
	if (imgSize.height > imgSize.width) {
		return self;
	}
	
	UIGraphicsBeginImageContext(imgSize);
	CGImageRef imageRef = [self CGImage];
	CGContextRef context = UIGraphicsGetCurrentContext();
		
	CGContextTranslateCTM (context, 0.0f, imgSize.height);

	// Rotate CCW
	CGContextRotateCTM (context, radians(-90.) );
		
	CGContextDrawImage(context, CGRectMake(0, 0, imgSize.height, imgSize.width), imageRef );
	CGImageRef ref = CGBitmapContextCreateImage( context );	
	UIGraphicsEndImageContext(); //CGContextRelease( bitmap );
	UIImage *oimg = [UIImage imageWithCGImage:ref];
	CGImageRelease( ref );
	
	return oimg;
}


@end
