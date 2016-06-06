//
//  ViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTransitionTypeChooseViewController.h"
#import "DHTransitionPresentationViewController.h"
#import "DHConstants.h"
@interface DHTransitionTypeChooseViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *animations;
@property (nonatomic) NSInteger selectedIndex;
@end

@implementation DHTransitionTypeChooseViewController

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
    if ([segue.destinationViewController isKindOfClass:[DHTransitionPresentationViewController class]]) {
        DHTransitionPresentationViewController *viewController = (DHTransitionPresentationViewController *)segue.destinationViewController;
        viewController.animationType = self.selectedIndex;
    }
}


#pragma mark - Lazy Instantiation
- (NSArray *) animations
{
    if (!_animations) {
        _animations = [DHConstants transitions];
    }
    return _animations;
}
@end
