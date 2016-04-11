//
//  DHSparkleRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSparkleRenderer.h"
#import "DHSparkleEffect.h"
@interface DHSparkleRenderer() {
    
}
@property (nonatomic, strong) DHSparkleEffect *sparkleEffect;
@end

@implementation DHSparkleRenderer

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    [super startAnimationForView:targetView inContainerView:containerView duration:duration event:event direction:direction timingFunction:timingFunction completion:completion];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    [self setupMvpMatrixWithView:containerView];
    
    [self setupSparkleEffect];
    
    self.animationView = [[GLKView alloc] initWithFrame:containerView.frame context:self.context];
    self.animationView.delegate = self;
    
    [containerView addSubview:self.animationView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) setupSparkleEffect
{
    self.sparkleEffect = [[DHSparkleEffect alloc] initWithContext:self.context targetView:self.targetView containerView:self.containerView];
    self.sparkleEffect.mvpMatrix = mvpMatrix;
    self.sparkleEffect.rowCount = 7;
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_COLOR, GL_ONE_MINUS_SRC_ALPHA);
    [self.sparkleEffect prepareToDraw];
    [self.sparkleEffect draw];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        self.percent = self.elapsedTime / self.duration;
        [self.sparkleEffect updateWithElapsedTime:self.elapsedTime percent:self.percent];
        [self.animationView display];
    } else {
        self.percent = 1;
        [self.animationView display];
        [self.displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        if (self.completion) {
            self.completion();
        }
    }
}

@end
