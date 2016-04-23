//
//  ParticleAnimationTypeChooseTableViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationTypeChooseTableViewController.h"
#import "DHObjectAnimationPresentatioinViewController.h"
@interface DHObjectAnimationTypeChooseTableViewController ()
@property (nonatomic, strong) NSArray *animations;
@property (nonatomic) NSInteger selectedAnimationType;
@end

@implementation DHObjectAnimationTypeChooseTableViewController

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParticleAnimationCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.animations[indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedAnimationType = indexPath.row;
    [self performSegueWithIdentifier:@"ShowParticleAnimation" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DHObjectAnimationPresentatioinViewController class]]) {
        DHObjectAnimationPresentatioinViewController *dstVC = (DHObjectAnimationPresentatioinViewController *)segue.destinationViewController;
        dstVC.animationType = self.selectedAnimationType;
    }
}

- (NSArray *) animations
{
    if (!_animations) {
        _animations = @[@"Shimmer", @"Sparkle", @"Rotation", @"Confetti", @"Blinds", @"Firework", @"Blur", @"Flip", @"Drop", @"Pivot", @"Pop", @"Scale", @"Scale Big", @"Spin", @"Twirl"];
    }
    return _animations;
}


@end
