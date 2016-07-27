//
//  DHSparkleRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSparkleAnimationRenderer.h"
#import "DHSparkleEffect.h"
@interface DHSparkleAnimationRenderer() {
    GLuint xRangeLoc;
}
@property (nonatomic, strong) DHSparkleEffect *sparkleEffect;
@end

@implementation DHSparkleAnimationRenderer
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

- (void) setupEffects
{
    self.sparkleEffect = [[DHSparkleEffect alloc] initWithContext:self.context];
    self.sparkleEffect.targetView = self.targetView;
    self.sparkleEffect.containerView = self.containerView;
    self.sparkleEffect.rowCount = self.rowCount;
    self.sparkleEffect.columnCount = self.columnCount;
    self.sparkleEffect.mvpMatrix = mvpMatrix;
    self.sparkleEffect.rowCount = 7;
    self.sparkleEffect.duration = self.duration;
    self.sparkleEffect.direction = self.direction;
    [self.sparkleEffect generateParticlesData];
}

- (void) setupMeshes
{
    self.mesh = [DHSceneMeshFactory sceneMeshForView:self.targetView containerView:self.containerView columnCount:self.targetView.frame.size.width rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:NO];
    [self.mesh generateMeshData];
}

- (void) drawFrame
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform2f(xRangeLoc, self.targetView.frame.origin.x * [UIScreen mainScreen].scale, CGRectGetMaxX(self.targetView.frame) * [UIScreen mainScreen].scale);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1f(percentLoc, self.percent / (1 - SPARKLE_LIFE_TIME_RATIO / 2));
    glUniform1i(samplerLoc, 0);
    glUniform1f(directionLoc, self.direction);
    glUniform1f(eventLoc, self.event);
    [self.mesh drawEntireMesh];
    
    [self.sparkleEffect prepareToDraw];
    [self.sparkleEffect draw];
}

- (void) updateAdditionalComponents
{
    [self.sparkleEffect updateWithElapsedTime:self.elapsedTime percent:self.percent];
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft), @(DHAllowedAnimationDirectionRight)];
}

- (void) tearDownSpecificGLResources
{
    [self.sparkleEffect tearDownGL];
}
@end
