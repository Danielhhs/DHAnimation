//
//  DHShiningStarEffect.m
//  Shimmer
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShiningStarEffect.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
#import <OpenGLES/ES3/glext.h>

typedef struct {
    GLKVector3 position;
    GLfloat startShiningTime;
    GLfloat lifeTime;
    GLfloat size;
    GLfloat rotation;
}DHShimmerShiningStarAttributes;

@interface DHShiningStarEffect () {
    GLuint program;
    GLuint mvpMatrixLoc, samplerLoc, percentLoc, elapsedTimeLoc, rotationMatrixLoc;
    GLuint texture;
    GLuint vertexBuffer, vertexArray;
}
@property (nonatomic) NSInteger starsPerSecond;
@property (nonatomic) NSTimeInterval starLifeTime;
@end

@implementation DHShiningStarEffect

- (instancetype) initWithContext:(EAGLContext *)context starImage:(UIImage *)starImage targetView:(UIView *)targetView containerView:(UIView *)containerView duration:(NSTimeInterval) duration starsPerSecond:(NSInteger) starsPerSecond starLifeTime:(NSTimeInterval)starLifeTime
{
    self = [super init];
    if (self) {
        self.context = context;
        self.targetView = targetView;
        self.containerView = containerView;
        self.duration = duration;
        _starsPerSecond = starsPerSecond;
        _starLifeTime = starLifeTime;
        [self setupEffect];
        [self generateParticleData];
        [self setupTextureWithImage:starImage];
        [self prepareToDraw];
    }
    return self;
}

- (void) setupEffect
{
    program = [OpenGLHelper loadProgramWithVertexShaderSrc:@"ShimmerShiningStarVertex.glsl" fragmentShaderSrc:@"ShimmerShiningStarFragment.glsl"];
    mvpMatrixLoc = glGetUniformLocation(program, "u_mvpMatrix");
    samplerLoc = glGetUniformLocation(program, "s_tex");
    rotationMatrixLoc = glGetUniformLocation(program, "u_rotationMatrix");
    elapsedTimeLoc = glGetUniformLocation(program, "u_elapsedTime");
}

- (void) setupTextureWithImage:(UIImage *)starImage
{
    texture = [TextureHelper setupTextureWithImage:starImage];
}

- (void) draw
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpMatrixLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(elapsedTimeLoc, self.elapsedTime);

    glBindVertexArray(vertexArray);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self.particleData length] / sizeof(DHShimmerShiningStarAttributes));
    glBindVertexArray(0);
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_DYNAMIC_DRAW);
    }
    
    glGenVertexArrays(1, &vertexArray);
    glBindVertexArray(vertexArray);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHShimmerShiningStarAttributes), NULL + offsetof(DHShimmerShiningStarAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 1, GL_FLOAT, GL_FALSE, sizeof(DHShimmerShiningStarAttributes), NULL + offsetof(DHShimmerShiningStarAttributes, startShiningTime));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHShimmerShiningStarAttributes), NULL + offsetof(DHShimmerShiningStarAttributes, lifeTime));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHShimmerShiningStarAttributes), NULL + offsetof(DHShimmerShiningStarAttributes, size));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHShimmerShiningStarAttributes), NULL + offsetof(DHShimmerShiningStarAttributes, rotation));
    glBindVertexArray(0);
}

- (void) generateParticleData
{
    self.particleData = [NSMutableData data];
    for (int i = 0; i < self.duration * self.starsPerSecond; i++) {
        DHShimmerShiningStarAttributes star;
        star.position = [self randomPositionForShiningStar];
        star.size = [self randomPointSize] * 2;
        star.startShiningTime = (GLfloat)(arc4random() % 20) / (GLfloat)20 * (self.duration - self.starLifeTime);
        star.lifeTime = self.starLifeTime;
        [self.particleData appendBytes:&star length:sizeof(star)];
    }
}

- (GLKVector3) randomPositionForShiningStar
{
    GLKVector3 position;
    position.x = arc4random() % (int)self.targetView.bounds.size.width + self.targetView.frame.origin.x;
    position.y = arc4random() % (int)self.targetView.bounds.size.height + self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame);
    position.z = 0;
    return position;
}

- (GLfloat) randomPointSize
{
    return arc4random() % 100;
}

@end
