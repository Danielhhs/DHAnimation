//
//  DHFireworkAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFireworkAnimationRenderer.h"
#import "DHFireworkEffect.h"
@interface DHFireworkAnimationRenderer()
@property (nonatomic, strong) DHFireworkEffect *effect;
@end

#define EXPLOSION_COUNT_PER_SECOND 3
#define EXPLOSION_TIME_RATIO 0.382
#define MAX_EXPLOSION_RATIO 0.382
#define MIN_EXPLOSION_RATIO 0.2
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
            GLKVector3 emissionPosition = [self randomEmissionPosition];
            CGFloat duration = [self randomDuration];
            CGFloat emissionTime = [self randomBetweenZeroToOne] + startTime;
            [self.effect addExplosionAtPosition:emissionPosition explosionTime:emissionTime duration:duration color:[self randomColor] baseVelocity:200];
        }
    }
    [self.effect prepareToDraw];
}

- (GLKVector3) randomEmissionPosition
{
    GLfloat x = ((arc4random() % 100) / 100.f * (1 - MIN_EXPLOSION_RATIO * 2) + MIN_EXPLOSION_RATIO) * self.containerView.frame.size.width;
    GLfloat y = ((arc4random() % 100) / 100.f * (1 - MIN_EXPLOSION_RATIO * 2) + MIN_EXPLOSION_RATIO) * self.containerView.frame.size.height;
    GLfloat z = (arc4random() % 100) / 100.f * 200 + self.containerView.frame.size.height / 2;
    return GLKVector3Make(x, y, z);
}

- (GLfloat) randomDuration
{
    int duration = (self.duration - 2) * 100;
    duration = arc4random() % duration;
    return duration / 100.f + 2;
}

- (CGFloat) randomBetweenZeroToOne
{
    int random = arc4random() % 1000;
    return random / 1000.f;
}

- (UIColor *) randomColor
{
    return [UIColor colorWithRed:[self randomColorComponent] green:[self randomColorComponent] blue:[self randomColorComponent] alpha:1.f];
}

- (CGFloat) randomColorComponent
{
    return arc4random() % 255 / 255.f;
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
