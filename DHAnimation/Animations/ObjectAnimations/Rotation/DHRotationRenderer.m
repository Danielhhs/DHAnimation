//
//  DHRotationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHRotationRenderer.h"
#import "SceneMesh.h"
@interface DHRotationRenderer()
@property (nonatomic, strong) SceneMesh *backgroundMesh;
@end

@implementation DHRotationRenderer

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    [super startAnimationForView:targetView inContainerView:containerView duration:duration columnCount:columnCount rowCount:rowCount event:event direction:direction timingFunction:timingFunction completion:completion];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [self setupGL];
    
    self.backgroundMesh = [[SceneMesh alloc] initWithView:targetView containerView:containerView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:YES columnMajored:YES];
    [self setupTextures];
    
    self.animationView = [[GLKView alloc] initWithFrame:containerView.frame context:self.context];
    self.animationView.delegate = self;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
}

- (void) update:(CADisplayLink *)displayLink
{
    
}

@end
