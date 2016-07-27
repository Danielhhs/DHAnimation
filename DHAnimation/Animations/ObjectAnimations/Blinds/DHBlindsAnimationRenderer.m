//
//  DHBlindsAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHBlindsAnimationRenderer.h"
#import "TextureHelper.h"
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
    if (self.direction == DHAnimationDirectionBottomToTop || self.direction == DHAnimationDirectionTopToBottom) {
        columMajored = NO;
    }
    self.mesh = [DHSceneMeshFactory sceneMeshForView:self.targetView containerView:self.containerView columnCount:self.columnCount rowCount:self.rowCount splitTexturesOnEachGrid:YES columnMajored:columMajored rotateTexture:YES];
    [self.mesh generateMeshData];
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithView:self.targetView rotate:YES];
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


- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft), @(DHAllowedAnimationDirectionRight), @(DHAllowedAnimationDirectionTop), @(DHAllowedAnimationDirectionBottom)];
}
@end
