//
//  ParticleAnimationTypeChooseTableViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBuiltInAnimationTypeChooseTableViewController.h"
#import "DHObjectAnimationPresentatioinViewController.h"
@interface DHBuiltInAnimationTypeChooseTableViewController ()
@property (nonatomic) NSInteger selectedAnimationType;
@end

@implementation DHBuiltInAnimationTypeChooseTableViewController

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
    return [self.animations count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ObjectAnimationCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.animations[indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *animationName = self.animations[indexPath.row];
    self.selectedAnimationType = [DHConstants animationTypeFromAnimationName:animationName];
    [self performSegueWithIdentifier:@"ShowObjectAnimation" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DHObjectAnimationPresentatioinViewController class]]) {
        DHObjectAnimationPresentatioinViewController *dstVC = (DHObjectAnimationPresentatioinViewController *)segue.destinationViewController;
        dstVC.animationType = self.selectedAnimationType;
        dstVC.animationEvent = self.animationEvent;
    }
}

- (NSArray *) animations
{
    if (!_animations) {
        _animations = [DHConstants builtInAnimations];
    }
    return _animations;
}


- (DHAnimationEvent)animationEvent {
    return DHAnimationEventBuiltIn;
}

@end
