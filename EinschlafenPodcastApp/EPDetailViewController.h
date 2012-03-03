//
//  EPDetailViewController.h
//  EinschlafenPodcastApp
//
//  Created by Tobias Baier on 03.03.12.
//  Copyright (c) 2012 CoreMedia AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
