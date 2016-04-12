//
//  AnimationShowViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTransitionPresentationViewController.h"
#import "DHDoorWayTransitionRenderer.h"
#import "DHCubeTransitionRenderer.h"
#import "DHTwistTransitionRenderer.h"
#import "DHClothLineTransitionRenderer.h"
#import "DHShredderTransitionRenderer.h"
#import "DHTransitionSettingViewController.h"
#import "DHSwitchTransitionRenderer.h"
#import "DHGridTransitionRenderer.h"
#import "DHConfettiTransitionRenderer.h"
#import "DHPushTransitionRenderer.h"
#import "DHRevealTransitionRenderer.h"
#import "DHDropTransitionRenderer.h"
#import "DHMosaicTransitionRenderer.h"
#import "DHFlopTransitionRenderer.h"
#import "DHCoverTransitionRenderer.h"
#import "DHFlipTransitionRenderer.h"
#import "DHReflectionTransitionRenderer.h"
#import "DHSpinDismissTransitionRenderer.h"
#import "DHRippleTransitionRenderer.h"
#import "DHResolvingDoorTransitionRenderer.h"

@interface DHTransitionPresentationViewController ()
@property (nonatomic, strong) DHTransitionSettings *settings;
@property (nonatomic, strong) UIImageView *fromView;
@property (nonatomic, strong) UIImageView *toView;
@end

@implementation DHTransitionPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settings = [DHTransitionSettings defaultSettings];
    UIBarButtonItem *animationSettingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showSettingsPanel)];
    UIBarButtonItem *startAnimationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(performAnimation)];
    [self.navigationItem setRightBarButtonItems:@[animationSettingButton, startAnimationButton]];
}

- (void) showSettingsPanel
{
    DHTransitionSettingViewController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@                                                          "AnimationSettingViewController"];
    settingsController.settings = self.settings;
    [self.navigationController pushViewController:settingsController animated:YES];
}

- (void) performAnimation
{
    [self updateAnimationSettings];
    switch (self.animationType) {
        case TransitionTypeDoorWay:
        {
            self.settings.timingFunction = DHTimingFunctionEaseInOutCubic;
            self.renderer = [[DHDoorWayTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeCube:
        {
            self.settings.timingFunction = DHTimingFunctionEaseInOutBack;
            self.renderer = [[DHCubeTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeTwist:
        {
            self.renderer = [[DHTwistTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeClothLine:
        {
            self.settings.duration = 3.f;
            self.renderer = [[DHClothLineTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeShredder:
        {
            self.settings.columnCount = 12;
            self.settings.duration = 3.f;
            self.renderer = [[DHShredderTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeSwitch:
        {
            self.renderer = [[DHSwitchTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeGrid:
        {
            self.renderer = [[DHGridTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeConfetti:
        {
            self.settings.timingFunction = DHTimingFunctionEaseOutCubic;
            self.settings.duration = 2;
            self.renderer = [[DHConfettiTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypePush:
        {
            self.renderer = [[DHPushTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeReveal:
        {
            self.renderer = [[DHRevealTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeDrop:
        {
            self.settings.timingFunction = DHTimingFunctionEaseOutBounce;
            self.renderer = [[DHDropTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeMosaic:
        {
            self.renderer = [[DHMosaicTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeFlop:
        {
            self.renderer = [[DHFlopTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeCover:
        {
            self.renderer = [[DHCoverTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeFlip:
        {
            self.renderer = [[DHFlipTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeReflection:
        {
            self.renderer = [[DHReflectionTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeRotateDismiss:
        {
            self.renderer = [[DHSpinDismissTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeRipple:
        {
            self.renderer = [[DHRippleTransitionRenderer alloc] init];
        }
            break;
        case TransitionTypeResolvingDoor:
        {
            self.settings.timingFunction = DHTimingFunctionEaseInOutBack;
            self.renderer = [[DHResolvingDoorTransitionRenderer alloc] init];
        }
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
    __weak DHTransitionPresentationViewController *weakSelf = self;
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
