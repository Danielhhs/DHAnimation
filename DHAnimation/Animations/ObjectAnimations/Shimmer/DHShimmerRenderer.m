//
//  ShimmerRenderer.m
//  Shimmer
//
//  Created by Huang Hongsen on 4/1/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShimmerRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
#import <OpenGLES/ES3/glext.h>
#import "DHShimmerBackgroundMesh.h"
#import "DHShimmerParticleEffect.h"
#import "DHShiningStarEffect.h"

@interface DHShimmerRenderer () {
}
@property (nonatomic, strong) NSMutableData *shiningStarData;
@property (nonatomic) NSInteger numberOfParticles;
@property (nonatomic, strong) DHShimmerBackgroundMesh *backgroundMesh;
@property (nonatomic, strong) DHShimmerParticleEffect *shimmerEffect;
@property (nonatomic, strong) DHShiningStarEffect *starEffect;
@property (nonatomic, strong) NSMutableArray *offsetData;
@end
@implementation DHShimmerRenderer

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    [super startAnimationForView:targetView inContainerView:containerView duration:duration columnCount:columnCount rowCount:rowCount event:event direction:direction timingFunction:timingFunction completion:completion];
    self.rowCount = 15;
    self.columnCount = 10;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    [self setupGL];
    [self setupMvpMatrixWithView:containerView];
    [self generateOffsetData];
    
    [self setupShimmerEffect];
    [self setupShiningStarEffect];
    [self setupTextures];
    
    self.backgroundMesh = [[DHShimmerBackgroundMesh alloc] initWithView:self.targetView containerView:self.containerView columnCount:self.columnCount rowCount:self.rowCount splitTexturesOnEachGrid:YES columnMajored:YES];
    [self.backgroundMesh updateWithOffsetData:self.offsetData event:self.event];
    self.animationView = [[GLKView alloc] initWithFrame:containerView.frame context:self.context];
    self.animationView.delegate = self;
    
    [containerView addSubview:self.animationView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithView:self.targetView];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    self.percent = self.elapsedTime / self.duration;
    self.shimmerEffect.percent = self.percent;
    self.starEffect.elapsedTime = self.elapsedTime;
    if (self.elapsedTime < self.duration) {
        [self.animationView display];
    } else {
        self.percent = 1;
        [self.animationView display];
        [displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        if (self.completion) {
            self.completion();
        }
    }
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, mvpMatrix.m);
    [self.backgroundMesh prepareToDraw];
    glUniform1f(percentLoc, self.percent);
    glUniform1f(eventLoc, self.event);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1f(samplerLoc, 0);
    [self.backgroundMesh drawEntireMesh];
    
    [self.shimmerEffect draw];
    
    [self.starEffect draw];
}

- (GLfloat) randomOffset
{
    int random = (arc4random() % 500 - 250);
    return random;
}

- (void) setupShimmerEffect
{
    self.shimmerEffect = [[DHShimmerParticleEffect alloc] initWithContext:self.context columnCount:self.columnCount rowCount:self.rowCount targetView:self.targetView containerView:self.containerView offsetData:self.offsetData event:self.event];
    self.shimmerEffect.mvpMatrix = mvpMatrix;
}

- (void) generateOffsetData
{
    self.offsetData = [NSMutableArray array];
    for (int x = 0; x < self.columnCount; x++) {
        for (int y = 0; y < self.rowCount; y++) {
            [self.offsetData addObject:@([self randomOffset])];
            [self.offsetData addObject:@([self randomOffset])];
            [self.offsetData addObject:@([self randomOffset])];
        }
    }
}

- (void) setupShiningStarEffect
{
    self.starEffect = [[DHShiningStarEffect alloc] initWithContext:self.context starImage:[UIImage imageNamed:@"ShiningStar.png"] targetView:self.targetView containerView:self.containerView duration:self.duration starsPerSecond:6 starLifeTime:0.382];
    self.starEffect.mvpMatrix = mvpMatrix;
}

- (NSString *) vertexShaderName
{
    return @"ShimmerBackgroundVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ShimmerBackgroundFragment.glsl";
}
@end
