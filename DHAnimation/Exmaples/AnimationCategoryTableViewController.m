//
//  AnimationCategoryTableViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/25/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "AnimationCategoryTableViewController.h"

@interface AnimationCategoryTableViewController ()

@end

@implementation AnimationCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"showTransitions" sender:self];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"builtInAnimations" sender:self];
    } else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"builtOutAnimations" sender:self];
    } else if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"textAnimations" sender:self];
    }
}
@end
