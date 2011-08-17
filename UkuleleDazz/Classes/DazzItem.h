//
//  DazzItem.h
//  UkuleleDazz
//
//  Created by Terry Tucker on 6/12/08.
//  Copyright 2008 Terry Tucker. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <sqlite3.h>
#import "SharedTypes.h"
#import "DazzObject.h"

//@class CXMLDocument;
//@class CXMLNode;

@class Comment;

@interface DazzItem : DazzObject {
    // Primary key in the database.
    NSInteger primaryKey;
	// For the items that don't have images uploaded yet
	NSString *detailImagePath;
    // Attributes.
    NSString *itemId;
	NSString *anotherItemId;
    NSString *brand;
    NSString *maker;
    NSString *size;
    NSString *model;
    NSString *vintage;
	NSString *condition;
	NSString *sound;
	NSString *notes;
	
	// Shown in the itemView
	UIImage  *thumbnailImage;
	// Shown in the itemView
	UIImage  *detailImage;

//	CXMLDocument *itemDoc;
//	NSArray *itemNodes;

	CXMLDocument *commentsDoc;
	NSMutableArray *imagePaths;
	NSMutableArray *comments;

    NSData *data;
}

// Property exposure for primary key and other attributes. The primary key is 'assign' because it is not an object, 
// nonatomic because there is no need for concurrent access, and readonly because it cannot be changed without corrupting the database.
@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (copy, nonatomic) NSString *itemId;
@property (copy, nonatomic) NSString *anotherItemId;

@property (nonatomic, retain) NSMutableArray *imagePaths;
@property (nonatomic, retain) NSMutableArray *comments;

// The remaining attributes are copied rather than retained because they are value objects.
@property (copy, nonatomic) NSString *brand;
@property (copy, nonatomic) NSString *maker;
@property (copy, nonatomic) NSString *size;
@property (copy, nonatomic) NSString *model;
@property (copy, nonatomic) NSString *vintage;
@property (copy, nonatomic) NSString *condition;
@property (copy, nonatomic) NSString *sound;
@property (copy, nonatomic) NSString *notes;

@property (copy, nonatomic) UIImage  *thumbnailImage;
@property (copy, nonatomic) UIImage  *detailImage;
			
- (void)setThumbnailImageFromPath: (NSString *)path;
- (bool)setDetailImageFromPath: (NSString *)path;
- (UIImage *)orientResizeAndCrop:(UIImage *)originalImage toSize:(CGSize)croppedSize;

- (Comment *)commentForRow: (NSInteger)row;

@end
