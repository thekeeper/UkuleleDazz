//
//  ImageCell.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 2/14/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "ImageCell.h"
#import "SharedConversions.h"


@implementation ImageCell

@synthesize image;
@synthesize imageSize;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier  ]) {

		UIView *myContentView = self.contentView;
		
		// Add an image view to display a picture
//		imageView = [[UIImageView alloc] initWithImage: [[UIImage imageNamed:@"DefaultDetailImage.png"] retain]];
		UIImage *detailImage = [[UIImage imageNamed:@"DefaultDetailImage.png"] retain];
		imageView = [[UIImageView alloc] initWithImage: detailImage];
		[myContentView addSubview:imageView];
		
		[detailImage release];
		[imageView release];
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
//    if( !self.selected && NULL != cellColor)
//    { 
		[ self setCellColor: [ UIColor clearColor ] ];
//		[ self setCellColor: [ UIColor colorWithRed: 0.8196 green: 0.8392 blue: 0.8627 alpha: 1.0 ] ];
	
		self.backgroundColor = cellColor;
        [ self colorAllSubviews: self backgroundColor: cellColor ];
//    }
	
	CGSize frameSize = [SharedConversions getSizeForImageView: image];
	CGFloat boundsX = contentRect.origin.x;
	CGFloat originX = boundsX + (contentRect.size.width - frameSize.width) / 2;
		
	CGRect frame;
	frame = [imageView frame];
	frame.origin.x = originX;
	frame.origin.y = 0;
	frame.size.height = frameSize.height;
	frame.size.width = frameSize.width;
	
 	imageView.frame = frame;
	imageView.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCellColor: (UIColor*)color {
    cellColor = color;
}

- (void) colorAllSubviews: (UIView*)ownerView backgroundColor: (UIColor*)color {
    NSEnumerator *enumerator = [ownerView.subviews objectEnumerator];
    id object;
    
    while (object = [enumerator nextObject]) {
        if( [object isKindOfClass: [ UIView class] ] )
        {
            ((UIView*)object).backgroundColor = color;
            [ self colorAllSubviews: object backgroundColor: color];
        }
    }
}


- (void)dealloc {
    [super dealloc];
}


@end
