//
//  Comment.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 2/8/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DazzObject.h"

@class CXMLNode;


@interface Comment : DazzObject {
    NSString *commentId;
    NSString *itemId;
	NSString *flag;
    NSString *memberName;
	NSString *date;	
	NSString *commentText;
	NSArray *itemNodes;
}

@property (copy, nonatomic)NSString *commentId;
	// This is the item the comment is targeted to
@property (copy, nonatomic)NSString *itemId;
	// This is undefined but maybe some day (can't remember why I added it!)
@property (copy, nonatomic)NSString *flag;
	// The user who left the comment
@property (copy, nonatomic) NSString *memberName;
	// The time and date as a string (formatted to string by the xsl transform)
@property (copy, nonatomic) NSString *date;
	// The actual text of the comment
@property (copy, nonatomic) NSString *commentText;

	// Creates the object from an xml node and populates everything
- (id)initWithXmlNode:(CXMLNode *)node;
	// Creates the object from an xml node and populates everything
- (id)initAsEmpty;

@end
