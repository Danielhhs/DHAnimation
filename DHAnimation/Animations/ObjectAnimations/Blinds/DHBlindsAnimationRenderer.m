//
//  DHBlindsAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBlindsAnimationRenderer.h"

@interface DHBlindsAnimationRenderer() {
    GLuint columnWidthLoc, columnHeightLoc;
}
@property (nonatomic) CGFloat columnWidth;
@property (nonatomic) CGFloat columnHeight;
@end

@implementation DHBlindsAnimationRenderer

- (void) setupGL
{
    [super setupGL];
    columnWidthLoc = glGetUniformLocation(program, "u_columnWidth");
    columnHeightLoc = glGetUniformLocation(program, "u_columnHeight");
    self.columnWidth = self.targetView.frame.size.width / self.columnCount;
    self.columnHeight = self.targetView.frame.size.height / self.rowCount;
}

- (void) setupMeshes
{
    BOOL columMajored = YES;
    if (self.direction == AnimationDirectionBottomToTop || self.direction == AnimationDirectionTopToBottom) {
        columMajored = NO;
    }
    self.mesh = [[SceneMesh alloc] initWithView:self.targetView containerView:self.containerView columnCount:self.columnCount rowCount:self.rowCount splitTexturesOnEachGrid:YES columnMajored:columMajored];
}

- (void) drawFrame
{
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    [super drawFrame];
    glUniform1f(columnWidthLoc, self.columnWidth);
    glUniform1f(columnHeightLoc, self.columnHeight);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

#pragma mark - Shaders
- (NSString *) vertexShaderName
{
    return @"BlindsAnimationVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"BlindsAnimationFragment.glsl";
}
@end
