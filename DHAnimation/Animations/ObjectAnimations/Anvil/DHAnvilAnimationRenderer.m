//
//  DHAnvilAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/26/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnvilAnimationRenderer.h"
#import "TextureHelper.h"
#import "DHDustEffect.h"
#import "DHCameraShakeEffect.h"
#import "DHPointExplosionEffect.h"
@interface DHAnvilAnimationRenderer () {
    GLuint yOffsetLoc, timeLoc, resolutionLoc;
}
@property (nonatomic, strong) DHDustEffect *effect;
@property (nonatomic, strong) DHPointExplosionEffect *pointExplosionEffect;
@property (nonatomic) NSTimeInterval fallTime;
@end

@implementation DHAnvilAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    yOffsetLoc = glGetUniformLocation(program, "u_yOffset");
    timeLoc = glGetUniformLocation(program, "u_time");
    resolutionLoc = glGetUniformLocation(program, "u_resolution");
    self.fallTime = 0.3;
}

- (NSString *) vertexShaderName
{
    return @"ObjectAnvilVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectAnvilFragment.glsl";
}

- (void) drawFrame
{
    [super drawFrame];
    glUniform2f(resolutionLoc, self.containerView.frame.size.width, self.containerView.frame.size.height);
    glUniform1f(yOffsetLoc, CGRectGetMaxY(self.targetView.frame));
    glUniform1f(timeLoc, self.elapsedTime);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    
    [self.mesh drawEntireMesh];
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    [self.effect draw];
    [self.pointExplosionEffect draw];
}

- (void) setupEffects
{
    self.effect = [[DHDustEffect alloc] initWithContext:self.context];
    self.effect.emitPosition = GLKVector3Make(CGRectGetMidX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame), 0);
    self.effect.emissionWidth = self.targetView.frame.size.width;
    self.effect.numberOfEmissions = 10;
    self.effect.direction = DHDustEmissionDirectionHorizontal;
    self.effect.dustWidth = self.targetView.frame.size.width;
    self.effect.emissionRadius = self.targetView.frame.size.width * 1.5;
    self.effect.timingFuntion = DHTimingFunctionEaseOutExpo;
    self.effect.mvpMatrix = mvpMatrix;
    self.effect.startTime = self.fallTime;
    self.effect.duration = self.duration - self.fallTime;
    [self.effect generateParticlesData];
    
    self.pointExplosionEffect = [[DHPointExplosionEffect alloc] initWithContext:self.context emissionPosition:GLKVector3Make(CGRectGetMidX(self.targetView.frame), self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame), 0) numberOfParticles:20 startTime:self.fallTime];
    self.pointExplosionEffect.mvpMatrix = mvpMatrix;
    self.pointExplosionEffect.duration = self.duration - self.fallTime;
}

- (void) updateAdditionalComponents
{
    
    if (self.elapsedTime - self.fallTime >= 0.f && self.elapsedTime - self.fallTime < 0.2) {
        [self updateMvpMatrixWithView:self.containerView];
    } else {
        [self setupMvpMatrixWithView:self.containerView];
    }
    [self.effect updateWithElapsedTime:self.elapsedTime percent:self.percent];
    self.effect.mvpMatrix = mvpMatrix;
    [self.pointExplosionEffect updateWithElapsedTime:self.elapsedTime percent:self.percent];
    self.pointExplosionEffect.mvpMatrix = mvpMatrix;
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionTop)];
}

- (void) tearDownSpecificGLResources
{
    [self.effect tearDownGL];
    [self.pointExplosionEffect tearDownGL];
}

- (void) updateMvpMatrixWithView:(UIView *)view
{
    GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(-view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    GLKMatrix4 viewMatrix = [DHCameraShakeEffect shakeCameraWithElapsedTime:self.elapsedTime - self.fallTime duration:0.2 shakingFactor:0.01];
    GLKMatrix4 modelView = GLKMatrix4Multiply(viewMatrix, modelMatrix);
    GLKMatrix4 projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), view.bounds.size.width / view.bounds.size.height, 0.1, 10000);
    
    mvpMatrix = GLKMatrix4Multiply(projection, modelView);
}
@end
