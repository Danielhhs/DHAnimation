//
//  DHFlameAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/24/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFlameAnimationRenderer.h"
#import "OpenGLHelper.h"
#import "DHFlameEffect.h"
@interface DHFlameAnimationRenderer() {
}
@property (nonatomic, strong) DHSceneMesh *backgroundMesh;
@property (nonatomic, strong) DHFlameEffect *effect;
@end

@implementation DHFlameAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectFlameVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectFlameFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
    
    [self.effect draw];
}

- (void) setupMeshes
{
    self.mesh = [DHSceneMeshFactory sceneMeshForView:self.targetView containerView:self.containerView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:NO];
    [self.mesh generateMeshData];
}

- (void) setupEffects
{
    self.effect = [[DHFlameEffect alloc] initWithContext:self.context targetView:self.targetView containerView:self.containerView];
    self.effect.mvpMatrix = mvpMatrix;
    self.effect.elapsedTime = 0;
    self.effect.duration = self.duration;
}

- (void) updateAdditionalComponents
{
    [self.effect updateWithElapsedTime:self.elapsedTime percent:self.percent];
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionBottom)];
}
@end
