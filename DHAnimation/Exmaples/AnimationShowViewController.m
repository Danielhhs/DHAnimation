//
//  AnimationShowViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "AnimationShowViewController.h"
#import "DHDoorWayRenderer.h"
#import "DHCubeRenderer.h"
#import "DHTwistRenderer.h"
#import "DHClothLineRenderer.h"
#import "DHShredderRenderer.h"
#import "AnimationSettingViewController.h"
#import "DHSwitchRenderer.h"
#import "DHGridRenderer.h"
#import "DHConfettiRenderer.h"
#import "DHPushRenderer.h"
#import "DHRevealRenderer.h"
#import "DHDropRenderer.h"
#import "DHMosaicRenderer.h"
#import "DHFlopRenderer.h"
#import "DHCoverRenderer.h"
#import "DHFlipRenderer.h"
#import "DHReflectionRenderer.h"

@interface AnimationShowViewController ()
@property (nonatomic, strong) DHAnimationSettings *settings;
@property (nonatomic, strong) UIImageView *fromView;
@property (nonatomic, strong) UIImageView *toView;
@end

@implementation AnimationShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settings = [DHAnimationSettings defaultSettings];
    UIBarButtonItem *animationSettingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showSettingsPanel)];
    UIBarButtonItem *startAnimationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(performAnimation)];
    [self.navigationItem setRightBarButtonItems:@[animationSettingButton, startAnimationButton]];
}

- (void) showSettingsPanel
{
    AnimationSettingViewController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@                                                          "AnimationSettingViewController"];
    settingsController.settings = self.settings;
    [self.navigationController pushViewController:settingsController animated:YES];
}

- (void) performAnimation
{
    [self updateAnimationSettings];
    switch (self.animationType) {
        case AnimationTypeDoorWay:
        {
            self.settings.timingFunction = DHTimingFunctionEaseInOutCubic;
            self.renderer = [[DHDoorWayRenderer alloc] init];
        }
            break;
        case AnimationTypeCube:
        {
            self.settings.timingFunction = DHTimingFunctionEaseInOutBack;
            self.renderer = [[DHCubeRenderer alloc] init];
        }
            break;
        case AnimationTypeTwist:
        {
            self.renderer = [[DHTwistRenderer alloc] init];
        }
            break;
        case AnimationTypeClothLine:
        {
            self.settings.duration = 3.f;
            self.renderer = [[DHClothLineRenderer alloc] init];
        }
            break;
        case AnimationTypeShredder:
        {
            self.settings.columnCount = 12;
            self.settings.duration = 3.f;
            self.renderer = [[DHShredderRenderer alloc] init];
        }
            break;
        case AnimationTypeSwitch:
        {
            self.renderer = [[DHSwitchRenderer alloc] init];
        }
            break;
        case AnimationTypeGrid:
        {
            self.renderer = [[DHGridRenderer alloc] init];
        }
            break;
        case AnimationTypeConfetti:
        {
            self.settings.timingFunction = DHTimingFunctionEaseOutCubic;
            self.settings.duration = 2;
            self.renderer = [[DHConfettiRenderer alloc] init];
        }
            break;
        case AnimationTypePush:
        {
            self.renderer = [[DHPushRenderer alloc] init];
        }
            break;
        case AnimationTypeReveal:
        {
            self.renderer = [[DHRevealRenderer alloc] init];
        }
            break;
        case AnimationTypeDrop:
        {
            self.settings.timingFunction = DHTimingFunctionEaseOutBounce;
            self.renderer = [[DHDropRenderer alloc] init];
        }
            break;
        case AnimationTypeMosaic:
        {
            self.renderer = [[DHMosaicRenderer alloc] init];
        }
            break;
        case AnimationTypeFlop:
        {
            self.renderer = [[DHFlopRenderer alloc] init];
        }
            break;
        case AnimationTypeCover:
        {
            self.renderer = [[DHCoverRenderer alloc] init];
        }
            break;
        case AnimationTypeFlip:
        {
            self.renderer = [[DHFlipRenderer alloc] init];
        }
            break;
        case AnimationTypeReflection:
        {
            self.renderer = [[DHReflectionRenderer alloc] init];
        }
            break;
        
        default:
            break;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    } completion:^(BOOL finished) {
        [self.renderer performAnimationWithSettings:self.settings];
    }];
}

- (void) updateAnimationSettings
{
    self.settings.fromView = self.fromView;
    [self.view addSubview:self.fromView];
    self.toView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.toView.image = [self randomImage];
    self.settings.toView = self.toView;
    self.settings.containerView = self.view;
    __weak AnimationShowViewController *weakSelf = self;
    self.settings.completion = ^{
        [weakSelf.view addSubview:weakSelf.toView];
        [weakSelf.fromView removeFromSuperview];
        weakSelf.fromView = weakSelf.toView;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        } completion:nil];
    };
}

- (UIImageView *)fromView
{
    if (!_fromView) {
        _fromView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _fromView.image = [self randomImage];
    }
    return _fromView;
}

- (UIImage *)randomImage
{
    int randomNumber = arc4random() % 10;
    return [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", randomNumber]];
}
@end
