//
//  ItemViewController.m
//  UkuleleDazz
//
//  Created by Terry Tucker on 12/29/09.
//  Copyright 2009 Terry Tucker. All rights reserved.
//

#import "ItemViewController.h"
#import "UkuleleDazzAppDelegate.h"
#import "DazzItem.h"
#import "SharedConversions.h"
#import "ImageCell.h"
#import "DetailCell.h"
#import "NotesCell.h"
#import "CommentCell.h"
#import "Comment.h"

@implementation ItemViewController

@synthesize detailTableView;
@synthesize navigationController;
@synthesize dazzItem;


- (void)viewDidLoad {
    
    // Clicking this launches the carouselView
        UIBarButtonItem *imagesButton = [[[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Show Photos", @"")
                                                                          style: UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(showPhotos)] autorelease];
        self.navigationItem.rightBarButtonItem = imagesButton;
}

- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data.
    [detailTableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [detailTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.navigationController = nil;	
    self.detailTableView = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 1;
    switch (section) {
        case 0: rows = 1; break;
        case 1: rows = 1; break;
        case 2: 
			// Comments can have multiple sections.
			rows = [dazzItem comments].count;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DetailCell *detailCell = nil;
	NotesCell *notesCell = nil;
	CommentCell *commentCell = nil;
    switch (indexPath.section) {
        case 0: 
			detailCell = (DetailCell *)[detailTableView dequeueReusableCellWithIdentifier:@"DetailCell"];
			if (detailCell == nil) {
				// Create a new cell. CGRectZero allows the cell to determine the appropriate size.
				detailCell = [[[DetailCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DetailCell"] autorelease];
				detailCell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			detailCell.dazzItem = dazzItem;
            
            // Check to see if there are images to display
            if ( [[dazzItem imagePaths] count] > 0) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            else {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
                
			return detailCell;
        case 1:
			notesCell = (NotesCell *)[detailTableView dequeueReusableCellWithIdentifier:@"NotesCell"];
			if (notesCell == nil) {
				// Create a new cell. CGRectZero allows the cell to determine the appropriate size.
				notesCell = [[[NotesCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"NotesCell"] autorelease];
				notesCell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			[notesCell setNotesText: dazzItem.notes];
			
			// We are going to define the size of the label, but not the top/left origin.  We'll do that in layoutSubviews
			CGSize notesSize = [SharedConversions getSizeOfText: [notesCell notesText] screenOrientation: [self interfaceOrientation] screenBounds: [[UIScreen mainScreen] bounds]];
			[notesCell setLabelSize: notesSize];
			return notesCell;
        case 2:
			commentCell = (CommentCell *)[detailTableView dequeueReusableCellWithIdentifier: @"CommentCell"];
			if (commentCell == nil) {
				// Create a new cell. CGRectZero allows the cell to determine the appropriate size.
				commentCell = [[[CommentCell alloc] initWithFrame: CGRectZero reuseIdentifier: @"commentCell"] autorelease];
				commentCell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			// Comments can have 0..* rows
			[commentCell setComment: [dazzItem commentForRow:indexPath.row]];
			
			// We are going to define the size of the label, but not the top/left origin.  We'll do that in layoutSubviews
			CGSize commentSize = [SharedConversions getSizeOfText: [commentCell commentText].text screenOrientation: [self interfaceOrientation] screenBounds: [[UIScreen mainScreen] bounds]];
			[commentCell setCommentLabelSize: commentSize];
			return commentCell;
    }
	
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// This is the height of one normal text cell row
 	CGFloat height = ROW_SPACE;
	NSString*	text = nil;
	Comment *comment = nil;
	CGSize size;
	
    switch (indexPath.section) {
		case 0:
			// space above the image + the image height
			height = VERTICAL_IMAGE_MARGIN;
            // A weird artifact (a horizontal line at the bottom of the cell) displays when size.height isn't an integer
			size = [SharedConversions getRoundedSizeForImageView: dazzItem.detailImage]; 
			height += size.height;
			
			// space below the image + 1 px line height + space above the detail text 
			height += VERTICAL_IMAGE_MARGIN;
			height += 1;
			height += VERTICAL_TEXT_MARGIN;
			
			// plus the height of the content (number of lines * line height)
			height += PROPERTY_COUNT * ROW_SPACE; //105.0f;
            height += 0.0f;
			break;
		case 1:
			text = [dazzItem notes];
			// Height calculated below...
			break;
		case 2:
			comment = [dazzItem commentForRow: indexPath.row];
			text = comment.commentText;
			// Height calculated below...
			break;
	}
	
	// This will be either notes or comment text
	if (text) {
		// The notes can be of any height
		// This needs to work for both portrait and landscape orientations.
		// Calls to the table view to get the current cell and the rect for the current row are recursive and call back this method.
		
		CGSize size = [SharedConversions getSizeOfText:text screenOrientation: [self interfaceOrientation] screenBounds: [[UIScreen mainScreen] bounds]];
		
		// SECOND_ROW_TOP 28 + bottom margin (6)
		size.height += 34.0f;
		
		// at least one row
		height = size.height;	
	}
	
	return height;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    // Return the displayed title for the specified section.
    switch (section) {
        case 0: return nil;
        case 1: return @"Notes";
        case 2: return @"Comments";
    }
    return nil;
}

- (void)showPhotos {
	UkuleleDazzAppDelegate *appDelegate = (UkuleleDazzAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate goToPhotoView: dazzItem.imagePaths];
}

- (void)dealloc {
	[detailTableView release];
    detailTableView.delegate = nil; // Ensures subsequent delegate method calls won't crash
    self.detailTableView = nil;     // Releases if @property (retain)
    
    [navigationController release];
    navigationController = nil;
    
    [super dealloc];
}


@end
