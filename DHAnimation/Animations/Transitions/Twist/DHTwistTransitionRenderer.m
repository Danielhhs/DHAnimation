//
//  TwistRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTwistTransitionRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
#import "DHTwistMesh.h"
#import "DHTimingFunctionHelper.h"

@interface DHTwistTransitionRenderer () {
    GLuint srcCenterPositionLoc;
    GLuint dstCenterPositionLoc;
}
@property (nonatomic, strong) DHTwistMesh *sourceMesh;
@property (nonatomic, strong) DHTwistMesh *destinationMesh;
@property (nonatomic) GLfloat centerPosition;
@end

@implementation DHTwistTransitionRenderer
#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcFragmentShaderFileName = @"TwistSourceFragment.glsl";
        self.srcVertexShaderFileName = @"TwistSourceVertex.glsl";
        self.dstVertexShaderFileName = @"TwistDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"TwistDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Public Animation APIs
- (void) initializeAnimationContext
{
    if (self.direction == DHAnimationDirectionBottomToTop || self.direction == DHAnimationDirectionTopToBottom) {
        self.centerPosition = self.fromView.bounds.size.width / 2;
    } else {
        self.centerPosition = self.fromView.bounds.size.height / 2;
    }
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    glEnable(GL_CULL_FACE);

    [self setupMvpMatrixWithView:view];
    
    glCullFace(GL_BACK);
    glUseProgram(dstProgram);
    glUniform1f(dstCenterPositionLoc, self.centerPosition);
    glUniform1i(dstDirectionLoc, self.direction);
    [self.destinationMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.destinationMesh drawEntireMesh];
    
    glCullFace(GL_FRONT);
    glUseProgram(srcProgram);
    glUniform1f(srcCenterPositionLoc, self.centerPosition);
    glUniform1i(srcDirectionLoc, self.direction);
    [self.sourceMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.sourceMesh drawEntireMesh];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        CGFloat rotation = [self rotationBasedOnDirection:displayLink.duration / (self.duration * 0.618) * M_PI];
        CGFloat transition = [self transitionBasedOnDirection:self.elapsedTime / (self.duration * 0.382)];
        [self.sourceMesh updateWithRotation:rotation transition:transition direction:self.direction];
        [self.destinationMesh updateWithRotation:rotation transition:transition direction:self.direction];
        [self.animationView display];
    } else {
        CGFloat rotation = [self rotationBasedOnDirection:displayLink.duration / self.duration * M_PI * 3];
        [self.sourceMesh updateWithRotation:rotation transition:[self transitionBasedOnDirection:1] direction:self.direction];
        [self.destinationMesh updateWithRotation:rotation transition:[self transitionBasedOnDirection:1] direction:self.direction];
        [self.animationView display];
        [displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        if (self.completion) {
            self.completion();
        }
        [self tearDownGL];
    }
}

#pragma mark - Override Methods

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcCenterPositionLoc = glGetUniformLocation(srcProgram, "u_centerPosition");
    
    glUseProgram(dstProgram);
    dstCenterPositionLoc = glGetUniformLocation(dstProgram, "u_centerPosition");
}

- (DHSceneMesh *) srcMesh
{
    return self.sourceMesh;
}

- (DHSceneMesh *) dstMesh
{
    return self.destinationMesh;
}

- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    BOOL columnMajored = YES;
    NSInteger columnCount = fromView.bounds.size.width;
    NSInteger rowCount = 1;
    if (self.direction == DHAnimationDirectionBottomToTop || self.direction == DHAnimationDirectionTopToBottom) {
        columnMajored = NO;
        columnCount = 1;
        rowCount = fromView.bounds.size.height;
    }
    self.sourceMesh = [[DHTwistMesh alloc] initWithView:fromView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:NO columnMajored:columnMajored rotateTexture:YES];
    [self.sourceMesh generateMeshData];
    self.destinationMesh = [[DHTwistMesh alloc] initWithView:toView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:NO columnMajored:columnMajored rotateTexture:YES];
    [self.destinationMesh generateMeshData];
}

- (void) setupTextureWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    srcTexture = [TextureHelper setupTextureWithView:fromView];
    if (self.direction == DHAnimationDirectionLeftToRight || self.direction == DHAnimationDirectionRightToLeft) {
        dstTexture = [TextureHelper setupTextureWithView:toView flipHorizontal:NO flipVertical:YES];
    } else {
        dstTexture = [TextureHelper setupTextureWithView:toView flipHorizontal:YES];
    }
}

- (CGFloat) transitionBasedOnDirection:(CGFloat)transition
{
    if (self.direction == DHAnimationDirectionLeftToRight || self.direction == DHAnimationDirectionTopToBottom) {
        transition = MIN(transition, 1);
    } else {
        transition = MAX(1 - transition, 0);
    }
    return transition;
}

- (CGFloat) rotationBasedOnDirection:(CGFloat)rotation
{
    if (self.direction == DHAnimationDirectionRightToLeft || self.direction == DHAnimationDirectionBottomToTop) {
        rotation *= -1;
    }
    return rotation;
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft), @(DHAllowedAnimationDirectionRight), @(DHAllowedAnimationDirectionTop), @(DHAllowedAnimationDirectionBottom)];
}
@end
