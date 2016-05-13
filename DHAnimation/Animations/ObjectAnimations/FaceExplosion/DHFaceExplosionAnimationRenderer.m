//
//  DHFaceExplosionAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 5/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFaceExplosionAnimationRenderer.h"
#import "DHFaceExplosionEffect.h"

#define EXPLOSION_TIME_RATIO 0.9

@interface DHFaceExplosionAnimationRenderer()
@property (nonatomic, strong) DHFaceExplosionEffect *effect;
@end

@implementation DHFaceExplosionAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectFaceExplosionVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectFaceExplosionFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    
    GLfloat percent = self.elapsedTime / (self.duration * (1.f - EXPLOSION_TIME_RATIO));
    glUniform1f(percentLoc, percent);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
    
    [self.effect draw];
}

- (void) setupEffects
{
    self.effect = [[DHFaceExplosionEffect alloc] initWithContext:self.context targetView:self.targetView containerView:self.containerView];
    self.effect.mvpMatrix = mvpMatrix;
    self.effect.duration = self.duration * EXPLOSION_TIME_RATIO;
    self.effect.startTime = self.duration * (1 - EXPLOSION_TIME_RATIO);
}

- (void) updateAdditionalComponents
{
    [self.effect updateWithElapsedTime:self.elapsedTime percent:self.percent];
}

- (void) tearDownSpecificGLResources
{
    [self.effect tearDownGL];
}
@end
