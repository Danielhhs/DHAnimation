//
//  UITextAnimationChooseTypeTableViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/19/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextAnimationChooseTypeTableViewController.h"
#import "DHConstants.h"
#import "DHTextAnimationPresentationViewController.h"
#import "DHTextAnimationSettings.h"

@interface DHTextAnimationChooseTypeTableViewController ()
@property (nonatomic) NSInteger selectedIndex;
@end

@implementation DHTextAnimationChooseTypeTableViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[DHConstants textAnimations] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextAnimationCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [DHConstants textAnimations][indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"presentAnimation" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentAnimation"]) {
        if ([segue.destinationViewController isKindOfClass:NSClassFromString(@"DHTextAnimationPresentationViewController")]) {
            DHTextAnimationPresentationViewController *dstVC = (DHTextAnimationPresentationViewController *)(segue.destinationViewController);
            dstVC.animationType = self.selectedIndex;
        }
    }
}

@end
