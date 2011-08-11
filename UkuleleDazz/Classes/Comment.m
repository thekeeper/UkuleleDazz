//
//  Comment.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 2/8/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "Comment.h"
#import "TouchXML.h"
#import "CXMLNode_PrivateExtensions.h"


@implementation Comment

@synthesize commentId;
@synthesize itemId;
@synthesize flag;
@synthesize memberName;
@synthesize date;
@synthesize commentText;

- (id)initAsEmpty {
	commentId = @"0";
	itemId = @"0";
	self.memberName = @"---";
	self.date = @"---";
	self.commentText = @"No Comments";
	self.flag = @"0";
	
	return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    NSObject* obj = [dictionary objectForKey:@"RemarkId"];
    if (obj == [NSNull null])
        self.commentId = @"";
    else
        self.commentId = (NSString *) obj;
    
    obj = [dictionary objectForKey:@"ItemId"];
    if (obj == [NSNull null])
        self.itemId = @"";
    else
        self.itemId = (NSString *) obj;
    
    obj = [dictionary objectForKey:@"MemberName"];
    if (obj == [NSNull null])
        self.memberName = @"";
    else
        self.memberName = (NSString *) obj;
    
    obj = [dictionary objectForKey:@"Remark"];
    if (obj == [NSNull null])
        self.commentText = @"";
    else
        self.commentText = (NSString *) obj;
    
    obj = [dictionary objectForKey:@"Flag"];
    if (obj == [NSNull null])
        self.flag = @"";
    else
        self.flag = (NSString *) obj;
    
    obj = [dictionary objectForKey:@"Date"];
    if (obj == [NSNull null])
        self.date = @"";
    else
        self.date = (NSString *) obj;

    return self;
}

- (id)initWithXmlNode:(CXMLNode *)node {
    if ( (self = [super init]) ) {
		CXMLNode *childNode;
		int nodeCount = 0;
		NSError *error = nil;
		// The node we have here is an DazzItem node.  We are going to parse out its child nodes
		// to get the basic information about this particular dazzItem:
		
		// 1. CommentId
		[itemNodes release];
		itemNodes = [node nodesForXPath: @"RemarkID" error: &error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex: 0];
			self.commentId = [childNode stringValue];
		}
		else {
			// Need to do an assert here!
			commentId = @"0";
		}
		
		// 2. ItemId
		itemNodes = [node nodesForXPath: @"UkuleleID" error: &error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex: 0];
			self.itemId = [childNode stringValue];
		}
		else {
			// Need to do an assert here!
			itemId = @"0";
		}
		
		// 3. MemberName
		itemNodes = [node nodesForXPath: @"MemberName" error: &error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex: 0];
			self.memberName = [childNode stringValue];
		}
		else {
			self.memberName = @"Unknown";
		}
		
		// 4. Date
		itemNodes = [node nodesForXPath: @"Date" error: &error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex: 0];
			self.date = [childNode stringValue];
		}
		else {
			self.date = @"Unknown";
		}
		
		// 5. Comment
		itemNodes = [node nodesForXPath: @"Remark" error: &error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex: 0];
			self.commentText = [childNode stringValue];
		}
		else {
			self.commentText = @"Unknown";
		}
		
		// 6. Flag
		itemNodes = [node nodesForXPath: @"Flag" error: &error];
		nodeCount = [itemNodes count];
		if (nodeCount > 0) {
			childNode = [itemNodes objectAtIndex: 0];
			self.flag = [childNode stringValue];
		}
		else {
			self.flag = @"0";
		}
    }
	
    return [self autorelease];
}


@end
