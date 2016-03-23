//
//  ViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "ViewController.h"
#import "AnimationShowViewController.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *animations;
@property (nonatomic) NSInteger selectedIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.animations count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnimationCell"];
    
    if (cell) {
        cell.textLabel.text = self.animations[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"ShowAnimation" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:NSClassFromString(@"AnimationShowViewController")]) {
        AnimationShowViewController *viewController = (AnimationShowViewController *)segue.destinationViewController;
        viewController.animationType = self.selectedIndex;
    }
}


#pragma mark - Lazy Instantiation
- (NSArray *) animations
{
    if (!_animations) {
        _animations = @[@"DoorWay", @"Cube", @"Twist", @"ClothLine", @"Shredder", @"Switch", @"Grid", @"Confetti", @"Push", @"Reveal", @"Drop", @"Mosaic", @"Flop", @"Cover", @"Flip", @"Reflection", @"Rotate Dismiss"];
    }
    return _animations;
}
@end
