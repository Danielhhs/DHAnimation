//
//  DHSparkleRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSparkleRenderer.h"
#import "DHSparkleEffect.h"
#import "SceneMesh.h"
@interface DHSparkleRenderer() {
    GLuint xRangeLoc;
}
@property (nonatomic, strong) DHSparkleEffect *sparkleEffect;
@property (nonatomic, strong) SceneMesh *backgroundMesh;
@end

@implementation DHSparkleRenderer

- (void) startAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount event:(AnimationEvent)event direction:(AnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    [super startAnimationForView:targetView inContainerView:containerView duration:duration columnCount:columnCount rowCount:rowCount event:event direction:direction timingFunction:timingFunction completion:completion];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [self setupGL];
    [self setupMvpMatrixWithView:containerView];
    [self setupSparkleEffect];
    
    self.backgroundMesh = [[SceneMesh alloc] initWithView:targetView containerView:containerView columnCount:targetView.frame.size.width rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES];
    [self setupTextures];
    
    self.animationView = [[GLKView alloc] initWithFrame:containerView.frame context:self.context];
    self.animationView.delegate = self;
    
    [containerView addSubview:self.animationView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) setupGL
{
    [super setupGL];
    xRangeLoc = glGetUniformLocation(program, "u_targetXPositionRange");
}

- (NSString *) vertexShaderName
{
    return @"SparkleBackgroundVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"SparkleBackgroundFragment.glsl";
}

- (void) setupSparkleEffect
{
    self.sparkleEffect = [[DHSparkleEffect alloc] initWithContext:self.context targetView:self.targetView containerView:self.containerView rowCount:self.rowCount columnCount:self.columnCount];
    self.sparkleEffect.mvpMatrix = mvpMatrix;
    self.sparkleEffect.rowCount = 7;
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform2f(xRangeLoc, self.targetView.frame.origin.x * [UIScreen mainScreen].scale, CGRectGetMaxX(self.targetView.frame) * [UIScreen mainScreen].scale);
    [self.backgroundMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1f(percentLoc, self.percent);
    glUniform1i(samplerLoc, 0);
    glUniform1f(directionLoc, self.direction);
    glUniform1f(eventLoc, self.event);
    [self.backgroundMesh drawEntireMesh];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
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
