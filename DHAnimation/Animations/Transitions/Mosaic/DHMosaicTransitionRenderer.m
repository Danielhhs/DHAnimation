//
//  DHMosaicRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/18/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHMosaicTransitionRenderer.h"
#import "TextureHelper.h"
#import "DHMosaicMesh.h"
#import "DHMosaicBackMesh.h"

#define MOSAIC_COLUMN_WIDTH 50
#define MOSAIC_ROTATION_TIME_RATIO 0.3

@interface DHMosaicTransitionRenderer () {
    GLuint srcColumnWidhtLoc, dstColumnWidthLoc;
}
@property (nonatomic, strong) DHMosaicMesh *sourceMesh;
@property (nonatomic, strong) DHMosaicBackMesh *destinationMesh;
@property (nonatomic) NSInteger gridCount;
@property (nonatomic, strong) NSMutableArray *gridIndexNotRotating;
@property (nonatomic) NSTimeInterval accumulatedTime;
@end

@implementation DHMosaicTransitionRenderer

#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"MosaicSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"MosaicSourceFragment.glsl";
        self.dstVertexShaderFileName = @"MosaicDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"MosaicDestinationFragment.glsl";
        self.accumulatedTime = 0;
    }
    return self;
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnable(GL_CULL_FACE);
    
    [self setupMvpMatrixWithView:view];
    
    glCullFace(GL_FRONT);
    glUseProgram(dstProgram);
    glUniform1f(dstColumnWidthLoc, view.bounds.size.width / self.sourceMesh.columnCount);
    [self.dstMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.dstMesh drawEntireMesh];
    
    glCullFace(GL_BACK);
    glUseProgram(srcProgram);
    glUniform1f(srcColumnWidhtLoc, view.bounds.size.width / self.sourceMesh.columnCount);
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    self.accumulatedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        self.percent = self.timingFunction(self.elapsedTime * 1000, 0, self.duration, self.duration * 1000);
        NSMutableArray *gridIndicesToStart = [NSMutableArray array];
        if (self.accumulatedTime >= 0.1) {
            NSInteger numberOfFlipsNeeded = ceil(self.duration * (1 - MOSAIC_ROTATION_TIME_RATIO) / 0.1);
            NSInteger numberOfGridToStart =  self.gridCount / numberOfFlipsNeeded + 1;
            for (int i = 0; i < numberOfGridToStart; i++) {
                NSInteger index = arc4random() % [self.gridIndexNotRotating count];
                if ([self.gridIndexNotRotating count] >= index) {
                    [gridIndicesToStart addObject:self.gridIndexNotRotating[index]];
                    [self.gridIndexNotRotating removeObjectAtIndex:index];
                }
            }
            self.accumulatedTime = 0;
        }
        [self.sourceMesh updateWithIndicesItemsStartedRotation:gridIndicesToStart incrementedRotation:displayLink.duration / (self.duration * MOSAIC_ROTATION_TIME_RATIO) * M_PI];
        [self.destinationMesh updateWithIndicesItemsStartedRotation:gridIndicesToStart incrementedRotation:displayLink.duration / (self.duration * MOSAIC_ROTATION_TIME_RATIO) * M_PI];
        [self.animationView display];
    } else {
        self.percent = 1;
        [self.animationView display];
        [displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        if (self.completion) {
            self.completion();
        }
        [self tearDownGL];
    }
}

#pragma mark - Override
- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    NSInteger columnCount = fromView.bounds.size.width / MOSAIC_COLUMN_WIDTH;
    NSInteger rowCount = fromView.bounds.size.height / MOSAIC_COLUMN_WIDTH;
    self.gridCount = columnCount * rowCount;
    self.gridIndexNotRotating = [NSMutableArray array];
    for (int i = 0; i < self.gridCount; i++) {
        [self.gridIndexNotRotating addObject:@(i)];
    }
    self.sourceMesh = [[DHMosaicMesh alloc] initWithView:fromView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
    self.destinationMesh = [[DHMosaicBackMesh alloc] initWithView:toView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
}

- (DHSceneMesh *) srcMesh
{
    return self.sourceMesh;
}

- (DHSceneMesh *) dstMesh
{
    return self.destinationMesh;
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcColumnWidhtLoc = glGetUniformLocation(srcProgram, "u_columnWidth");
    
    glUseProgram(dstProgram);
    dstColumnWidthLoc = glGetUniformLocation(dstProgram, "u_columnWidth");
}

- (NSArray *) allowedDirections
{
    return nil;
}
@end
