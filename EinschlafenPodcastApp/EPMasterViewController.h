//
//  EPMasterViewController.h
//  EinschlafenPodcastApp
//
//  Created by Tobias Baier on 03.03.12.
//  Copyright (c) 2012 CoreMedia AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPDetailViewController;

@interface EPMasterViewController : UITableViewController { 
    NSMutableArray *_allEntries;
    NSOperationQueue *_queue;
}

@property (retain) NSMutableArray *allEntries;
@property (retain) NSOperationQueue *queue;
@property (strong, nonatomic) EPDetailViewController *detailViewController;


@end
