//
//  NSArrayCategory.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 6/25/11.
//  Copyright 2011 Terry Tucker. All rights reserved.
//

#import "NSArrayCategory.h"


@implementation NSArray (NSArrayCategory)

- (NSDictionary *)indexKeyedDictionary
{
    NSUInteger arrayCount = [self count];
    id arrayObjects[arrayCount], objectKeys[arrayCount];
    
    [self getObjects:arrayObjects range:NSMakeRange(0UL, arrayCount)];
    for(NSUInteger index = 0UL; index < arrayCount; index++) { objectKeys[index] = [NSNumber numberWithUnsignedInteger:index]; }
    
    return([NSDictionary dictionaryWithObjects:arrayObjects forKeys:objectKeys count:arrayCount]);
}

@end