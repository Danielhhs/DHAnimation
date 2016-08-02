//
//  DHShredderAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 7/31/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShredderAnimationRenderer.h"
#import "DHShredderAnimationSceneMesh.h"
#import "OpenGLHelper.h"
#import "DHShredderMesh.h"
#import "TextureHelper.h"
#import "DHConstants.h"
@interface DHShredderAnimationRenderer () {
    GLuint shredderPositionLoc, timeLoc, durationLoc, columnWidthLoc, screenScaleLoc, shredderDisappearTimeLoc, maxShredderPositionLoc;
    GLuint shredderProgram, shredderMvpLoc, shredderShredderPosistionLoc, shredderSamplerLoc, shredderTexture;
}
@property (nonatomic, strong) DHShredderMesh *shredderMesh;
@end

#define SHREDDER_APPEAR_TIME_RATIO 0.1
#define SHREDDER_DISAPPEAR_TIME_RATIO 0.1
#define SHREDDER_STOP_TIME_RATIO 0.05
#define SHREDDER_TIME_RATIO (1-SHREDDER_APPEAR_TIME_RATIO-SHREDDER_DISAPPEAR_TIME_RATIO-SHREDDER_STOP_TIME_RATIO)

@implementation DHShredderAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectShredderPiecesVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectShredderPiecesFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
    shredderPositionLoc = glGetUniformLocation(program, "u_shredderPosition");
    timeLoc = glGetUniformLocation(program, "u_time");
    durationLoc = glGetUniformLocation(program, "u_duration");
    columnWidthLoc = glGetUniformLocation(program, "u_columnWidth");
    screenScaleLoc = glGetUniformLocation(program, "u_screenScale");
    shredderDisappearTimeLoc = glGetUniformLocation(program, "u_shredderDisappearTime");
    maxShredderPositionLoc = glGetUniformLocation(program, "u_maxShredderPosition");
    self.animationView.drawableMultisample = GLKViewDrawableMultisample4X;
    
    shredderProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"ObjectShredderVertex.glsl" fragmentShaderSrc:@"ObjectShredderFragment.glsl"];
    shredderShredderPosistionLoc = glGetUniformLocation(shredderProgram, "u_shredderPosition");
    shredderMvpLoc = glGetUniformLocation(shredderProgram, "u_mvpMatrix");
    shredderSamplerLoc = glGetUniformLocation(shredderProgram, "s_tex");
}

- (void) setupMeshes
{
    self.mesh = [[DHShredderAnimationSceneMesh alloc] initWithTargetView:self.targetView containerView:self.containerView columnCount:self.columnCount];
    [self.mesh generateMeshData];

    self.shredderMesh = [[DHShredderMesh alloc] initWithView:self.targetView containerView:self.containerView shredderHeight:self.shredderHeight];
}

- (void) setupTextures
{
    [super setupTextures];
    NSString *shredderImageFile = [DHConstants resourcePathForFile:@"Shredder" ofType:@"png"];
    shredderTexture = [TextureHelper setupTextureWithImage:[UIImage imageWithContentsOfFile:shredderImageFile]];
}

- (void) drawFrame
{
    [super drawFrame];
    GLfloat shredderPosition = [self shredderPosition];
    glUniform1f(shredderPositionLoc, shredderPosition);
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(durationLoc, self.duration);
    glUniform1f(columnWidthLoc, self.targetView.frame.size.width / self.columnCount);
    glUniform1f(shredderDisappearTimeLoc, self.duration * SHREDDER_DISAPPEAR_TIME_RATIO);
    glUniform1f(maxShredderPositionLoc, self.containerView.bounds.size.height - self.targetView.frame.origin.y);
    glUniform1f(screenScaleLoc, [UIScreen mainScreen].scale);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1f(samplerLoc, 0);
    [self.mesh drawEntireMesh];
    
    glUseProgram(shredderProgram);
    glUniformMatrix4fv(shredderMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(shredderShredderPosistionLoc, shredderPosition + 5);
    glBindTexture(GL_TEXTURE_2D, shredderTexture);
    glUniform1i(samplerLoc, 0);
    [self.shredderMesh drawEntireMesh];
}

- (GLfloat) shredderHeight
{
    if (_shredderHeight == 0) {
        _shredderHeight = 200;
    }
    return _shredderHeight;
}

- (GLfloat) shredderPosition
{
    GLfloat shredderPosition = 0;
    GLfloat base = (self.containerView.frame.size.height - CGRectGetMaxY(self.targetView.frame) + self.shredderMesh.shredderHeight);
    if (self.percent < SHREDDER_APPEAR_TIME_RATIO) {
        shredderPosition = self.percent / SHREDDER_APPEAR_TIME_RATIO * base;
    } else if (self.percent < SHREDDER_APPEAR_TIME_RATIO + SHREDDER_STOP_TIME_RATIO) {
        shredderPosition = base;
    } else if (self.percent < 1 - SHREDDER_DISAPPEAR_TIME_RATIO) {
        GLfloat time = self.percent - (SHREDDER_APPEAR_TIME_RATIO + SHREDDER_STOP_TIME_RATIO);
        shredderPosition = base + time / SHREDDER_TIME_RATIO * self.targetView.frame.size.height;
    } else {
        shredderPosition = (base + self.targetView.frame.size.height) + (self.percent - (1 - SHREDDER_DISAPPEAR_TIME_RATIO)) / SHREDDER_DISAPPEAR_TIME_RATIO * (self.targetView.frame.origin.y + self.shredderMesh.shredderHeight);
    }
    return shredderPosition;
}

@end
