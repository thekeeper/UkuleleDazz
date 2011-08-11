//
//  NSDate.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 3/29/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import "NSDate.h"

/*
 To serialize NSDates to JSON
*/
@implementation NSDate (jsondatarepresentation)

- (NSData *) JSONDataRepresentation {
    
    return [[[NSNumber numberWithDouble:[self timeIntervalSince1970]] stringValue] dataUsingEncoding:NSUTF8StringEncoding];
}

@end
