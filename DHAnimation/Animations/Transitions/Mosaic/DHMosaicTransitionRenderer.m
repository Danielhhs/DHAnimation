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
#define MOSAIC_ROTATION_TIME_RATIO 0.2

@interface DHMosaicTransitionRenderer () {
    GLuint srcColumnWidhtLoc, dstColumnWidthLoc, srcTimeLoc, dstTimeLoc, srcRotationTimeLoc, dstRotationTimeLoc;
}
@property (nonatomic, strong) DHMosaicMesh *sourceMesh;
@property (nonatomic, strong) DHMosaicBackMesh *destinationMesh;
@property (nonatomic) NSInteger gridCount;
@property (nonatomic) NSMutableArray *startTimeArray;
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
    glUniform1f(dstRotationTimeLoc, self.duration * MOSAIC_ROTATION_TIME_RATIO);
    glUniform1f(dstTimeLoc, self.elapsedTime);
    [self.dstMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.dstMesh drawEntireMesh];
    
    glCullFace(GL_BACK);
    glUseProgram(srcProgram);
    glUniform1f(srcColumnWidhtLoc, view.bounds.size.width / self.sourceMesh.columnCount);
    glUniform1f(srcRotationTimeLoc, self.duration * MOSAIC_ROTATION_TIME_RATIO);
    glUniform1f(srcTimeLoc, self.elapsedTime);
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
}

#pragma mark - Override
- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    NSInteger columnCount = fromView.bounds.size.width / MOSAIC_COLUMN_WIDTH;
    NSInteger rowCount = fromView.bounds.size.height / MOSAIC_COLUMN_WIDTH;
    [self generateStartTimeWithRowCount:rowCount columnCount:columnCount];
    self.sourceMesh = [[DHMosaicMesh alloc] initWithView:fromView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:YES columnMajored:NO rotateTexture:YES];
    [self.sourceMesh updateStartTime:self.startTimeArray];
    [self.sourceMesh generateMeshData];
    self.destinationMesh = [[DHMosaicBackMesh alloc] initWithView:toView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:YES columnMajored:NO rotateTexture:YES];
    [self.destinationMesh updateStartTime:self.startTimeArray];
    [self.destinationMesh generateMeshData];
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
    srcTimeLoc = glGetUniformLocation(srcProgram, "u_time");
    srcRotationTimeLoc = glGetUniformLocation(srcProgram, "u_rotationTime");
    
    glUseProgram(dstProgram);
    dstColumnWidthLoc = glGetUniformLocation(dstProgram, "u_columnWidth");
    dstTimeLoc = glGetUniformLocation(dstProgram, "u_time");
    dstRotationTimeLoc = glGetUniformLocation(dstProgram, "u_rotationTime");
}

- (NSArray *) allowedDirections
{
    return nil;
}

- (void) generateStartTimeWithRowCount:(NSInteger)rowCount columnCount:(NSInteger) columnCount
{
    self.startTimeArray = [NSMutableArray array];
    NSTimeInterval averageTimeForGrid = self.duration * (1.f - MOSAIC_ROTATION_TIME_RATIO) / columnCount;
    for (int row = 0; row < rowCount; row++) {
        NSTimeInterval previousStartTime = arc4random() % 1000 / 1000.f * averageTimeForGrid;
        [self.startTimeArray addObject:@(previousStartTime)];
        for (int column = 1; column < columnCount; column++) {
            NSTimeInterval startTime = previousStartTime + arc4random() % 1000 / 1000.f * averageTimeForGrid;
            previousStartTime = startTime;
            [self.startTimeArray addObject:@(startTime)];
        }
    }
}
@end
