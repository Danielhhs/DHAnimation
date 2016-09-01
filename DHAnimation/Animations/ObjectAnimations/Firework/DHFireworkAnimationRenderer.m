//
//  DHFireworkAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFireworkAnimationRenderer.h"
#import "DHFireworkEffect.h"
#import "DHFireworkSettings.h"
@interface DHFireworkAnimationRenderer()
@property (nonatomic, strong) DHFireworkEffect *effect;
@end

@implementation DHFireworkAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"FireworkBackgroundVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"FireworkBackgroundFragment.glsl";
}

- (void) setupEffects
{
    self.effect = [[DHFireworkEffect alloc] initWithContext:self.context];
    self.effect.mvpMatrix = mvpMatrix;
    CGFloat space = self.duration - 2;
    for (int i = 0; i < space; i++) {
        CGFloat startTime = i;
        for (int i = 0; i < 2; i++) {
            DHFireworkSettings *settings = [DHFireworkSettings randomFireworkInView:self.containerView duration:self.duration startTime:startTime];
            [self.effect addFireworkWithSettings:settings];
            [self.effect prepareToDraw];
        }
    }
    [self.effect prepareToDraw];
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

- (void) updateAdditionalComponents
{
    [self.effect updateWithElapsedTime:self.elapsedTime percent:self.percent];
}


- (NSArray *) allowedDirections
{
    return nil;
}
@end
