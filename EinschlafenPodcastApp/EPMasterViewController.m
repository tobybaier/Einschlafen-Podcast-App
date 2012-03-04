//
//  EPMasterViewController.m
//  EinschlafenPodcastApp
//
//  Created by Toby Baier on 03.03.12.
//  Copyright (c) 2012 Toby Baier. All rights reserved.
//

#import "EPMasterViewController.h"
#import "EPDetailViewController.h"
#import "RSSEntry.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "NSDate+InternetDateTime.h"

@implementation EPMasterViewController

@synthesize queue = _queue;
@synthesize allEntries = _allEntries;
@synthesize detailViewController = _detailViewController;

- (void)parseFeed:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    
    NSArray *channels = [rootElement elementsForName:@"channel"];
    for (GDataXMLElement *channel in channels) {            
        
        NSString *blogTitle = [channel valueForChild:@"title"];                    
        
        NSArray *items = [channel elementsForName:@"item"];
        for (GDataXMLElement *item in items) {
            
            NSString *articleTitle = [item valueForChild:@"title"];
            NSString *articleUrl = [item valueForChild:@"link"];  
            NSString *length = [item valueForChild:@"itunes:duration"];  
            NSString *enclosureUrl = nil;
            NSArray *enclosures = [item elementsForName:@"enclosure"];
            if (sizeof enclosures > 0) {
                GDataXMLElement *enclosure = [enclosures objectAtIndex:0];
                enclosureUrl = [[enclosure attributeForName:@"url"] stringValue];
            }
            NSString *articleDateString = [item valueForChild:@"pubDate"];        
            NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC822];

            
            RSSEntry *entry = [[[RSSEntry alloc] initWithBlogTitle:blogTitle 
                                                   articleTitle:articleTitle 
                                                       articleUrl:articleUrl 
                                                               length:length
                                                   enclosureUrl:enclosureUrl 
                                                     articleDate:articleDate] autorelease];
            [entries insertObject:entry atIndex:0];
            
        }      
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    [_queue addOperationWithBlock:^{
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] 
                                                               options:0 error:&error];
        if (doc == nil) { 
            NSLog(@"Failed to parse %@", request.url);
        } else {
            
            NSMutableArray *entries = [NSMutableArray array];
            [self parseFeed:doc.rootElement entries:entries];                
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                for (RSSEntry *entry in entries) {
                    
                    int insertIdx = 0;                    
                    [_allEntries insertObject:entry atIndex:insertIdx];
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:insertIdx inSection:0]]
                                          withRowAnimation:UITableViewRowAnimationRight];
                    
                }                            
                
            }];
            
        }        
    }];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

- (void)refresh {
        NSURL *url = [NSURL URLWithString:@"http://feeds.feedburner.com/EinschlafenPodcast"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [_queue addOperation:request];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    RSSEntry *entry = [_allEntries objectAtIndex:indexPath.row];
    
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *articleDateString = [dateFormatter stringFromDate:entry.articleDate];
    
    cell.textLabel.text = entry.articleTitle;        
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", articleDateString, entry.length];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allEntries count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RSSEntry *entry = [_allEntries objectAtIndex:indexPath.row];
    if (_detailViewController == nil) {
        self.detailViewController = [[EPDetailViewController alloc] autorelease];
    }
    _detailViewController.entry = entry;
    [self.navigationController pushViewController:_detailViewController animated:YES];
    
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (EPDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    
    self.title = @"Einschlafen Podcast";
    self.allEntries = [NSMutableArray array];
    self.queue = [[[NSOperationQueue alloc] init] autorelease];
    [self refresh];}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_allEntries release];
    self.allEntries = nil;
    [_queue release];
    _queue = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
