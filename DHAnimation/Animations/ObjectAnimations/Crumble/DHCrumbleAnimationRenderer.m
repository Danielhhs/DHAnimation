//
//  DHCrumbleAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/29/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHCrumbleAnimationRenderer.h"
#import "DHPolygon.h"
#import "DHLine.h"
#import "DHIntersectPoint.h"
#import "DHPolygon.h"
#import "DHCrumbleMesh.h"

@interface DHCrumbleAnimationRenderer ()
@property (nonatomic, strong) NSMutableArray *polygons;
@property (nonatomic, strong) DHLine *leftEdge;
@property (nonatomic, strong) DHLine *rightEdge;
@property (nonatomic, strong) DHLine *topEdge;
@property (nonatomic, strong) DHLine *bottomEdge;
@end

#define DEFAULT_GRID_SIZE 20

@implementation DHCrumbleAnimationRenderer

- (NSString *) vertexShaderName
{
    return @"ObjectCrumbleVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectCrumbleFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
}

- (void) setupMeshes
{
    [self generatePolygons];
    DHCrumbleMesh *mesh = [[DHCrumbleMesh alloc] initWithView:self.targetView containerView:self.containerView polygons:self.polygons];
    [mesh generateMeshData];
    self.mesh = mesh;
}

- (void) drawFrame
{
    [super drawFrame];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (void) generatePolygons
{
    NSArray *lines = [self generateLines];
    NSArray *intersectPoints = [self findIntersectPointsFromLines:lines];
    [self findAllPolygonsFromIntersectPoints:intersectPoints];
}

- (NSArray *) generateLines
{
    NSMutableArray *lines = [NSMutableArray array];
    
    CGPoint origin = CGPointMake(self.targetView.frame.origin.x, self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame));
    
    NSInteger numberOfRows = self.targetView.frame.size.height / DEFAULT_GRID_SIZE;
    NSInteger numberOfColumns = self.targetView.frame.size.width / DEFAULT_GRID_SIZE;
    GLfloat rowHeight = self.targetView.frame.size.height / numberOfRows;
    GLfloat columnWidth = self.targetView.frame.size.width / numberOfColumns;
    //Generate Lines started from left to right
    for (int i = 0; i < numberOfRows; i++) {
        DHLine *line = [[DHLine alloc] init];
        line.startPoint = GLKVector2Make(origin.x, origin.y + rowHeight * i + arc4random() % 50 / 100.f * rowHeight);
        line.direction = [self randomDirectionForDirection:DHAnimationDirectionLeftToRight];
        [lines addObject:line];
    }
    
    //Generate Lines started from right to left
    for (int i = 0; i < numberOfRows; i++) {
        DHLine *line = [[DHLine alloc] init];
        line.startPoint = GLKVector2Make(origin.x + self.targetView.frame.size.width, origin.y + rowHeight * i + arc4random() % 50 / 100.f * rowHeight);
        line.direction = [self randomDirectionForDirection:DHAnimationDirectionRightToLeft];
        [lines addObject:line];
    }
    
    //Generate Lines started from top to bottom
    for (int i = 0; i < numberOfColumns; i++) {
        DHLine *line = [[DHLine alloc] init];
        line.startPoint = GLKVector2Make(origin.x + i * columnWidth + arc4random() % 50 / 100.f * columnWidth, origin.y + self.targetView.frame.size.height);
        line.direction = [self randomDirectionForDirection:DHAnimationDirectionTopToBottom];
        [lines addObject:line];
    }
    
    //Generate Lines started from top to bottom
    for (int i = 0; i < numberOfColumns; i++) {
        DHLine *line = [[DHLine alloc] init];
        line.startPoint = GLKVector2Make(origin.x + i * columnWidth + arc4random() % 50 / 100.f * columnWidth, origin.y);
        line.direction = [self randomDirectionForDirection:DHAnimationDirectionBottomToTop];
        [lines addObject:line];
    }
    
    //Add rect edges
    self.leftEdge = [[DHLine alloc] init];
    self.leftEdge.startPoint = GLKVector2Make(origin.x, origin.y);
    self.leftEdge.direction = GLKVector2Make(0, 1);
    [lines addObject:self.leftEdge];
    
    self.bottomEdge = [[DHLine alloc] init];
    self.bottomEdge.startPoint = GLKVector2Make(origin.x, origin.y);
    self.bottomEdge.direction = GLKVector2Make(1, 0);
    [lines addObject:self.bottomEdge];
    
    self.topEdge = [[DHLine alloc] init];
    self.topEdge.startPoint = GLKVector2Make(origin.x + self.targetView.frame.size.width, origin.y + self.targetView.frame.size.height);
    self.topEdge.direction = GLKVector2Make(-1, 0);
    [lines addObject:self.topEdge];
    
    self.rightEdge = [[DHLine alloc] init];
    self.rightEdge.startPoint = GLKVector2Make(origin.x + self.targetView.frame.size.width, origin.y + self.targetView.frame.size.height);
    self.rightEdge.direction = GLKVector2Make(0, -1);
    [lines addObject:self.rightEdge];
    
    return lines;
}

- (GLKVector2) randomDirectionForDirection:(DHAnimationDirection) direction
{
    switch (direction) {
        case DHAnimationDirectionLeftToRight:
            return GLKVector2Normalize(GLKVector2Make(arc4random() % 1000, arc4random() % 2000 - 1000));
        case DHAnimationDirectionRightToLeft:
            return GLKVector2Normalize(GLKVector2Make(-arc4random() % 1000, arc4random() % 2000 - 1000));
        case DHAnimationDirectionBottomToTop:
            return GLKVector2Normalize(GLKVector2Make(arc4random() % 2000 - 1000, arc4random() % 1000));
        case DHAnimationDirectionTopToBottom:
            return GLKVector2Normalize(GLKVector2Make(arc4random() % 2000 - 1000, -arc4random() % 1000));
    }
}

- (NSArray *) findIntersectPointsFromLines:(NSArray *)lines
{
    NSMutableArray *points = [NSMutableArray array];
    CGPoint origin = CGPointMake(self.targetView.frame.origin.x, self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame));
    CGRect area = CGRectMake(origin.x, origin.y, self.targetView.frame.size.width, self.targetView.frame.size.height);
    for (DHLine *line1 in lines) {
        for (DHLine *line2 in lines) {
            if (![line1 isParallelWithLine:line2]) {
                DHIntersectPoint *point = [line1 intersectPointWithLine:line2];
                CGPoint intersectPoint = CGPointMake(point.position.x, point.position.y);
                if (CGRectContainsPoint(area, intersectPoint)) {
                    [line1 addInterSectPoint:point];
                    [line2 addInterSectPoint:point];
                    [points addObject:point];
                }
            }
        }
    }
    return points;
}

- (void) findAllPolygonsFromIntersectPoints:(NSArray *)points
{
    self.polygons = [NSMutableArray array];
    for (DHIntersectPoint *point in self.leftEdge.intersectPoints) {
        DHPolygon *polygon = [[DHPolygon alloc] init];
        [self findPolygon:polygon forPoint:point inLine:self.leftEdge];
    }
}

- (void) findPolygon:(DHPolygon *)polygon forPoint:(DHIntersectPoint *)point inLine:(DHLine *)line
{
    [polygon appendVertex:point];
    if ([self isPolygonCompleted:polygon forPoint:point atLine:line]) {
        if (![self.polygons containsObject:polygon]) {
            [self.polygons addObject:polygon];
        }
        return;
    }
    DHLine *nextLine = [point nextLineForLine:line];
    NSArray *nearestIntersetPoints = [nextLine nearestIntersectPointForPoint:point];
    for (DHIntersectPoint *point in nearestIntersetPoints) {
        [self findPolygon:polygon forPoint:point inLine:nextLine];
    }
}

- (BOOL) isPolygonCompleted:(DHPolygon *)polygon forPoint:(DHIntersectPoint *)point atLine:(DHLine *)line
{
    if ([polygon isCompleted]) {
        return YES;
    }
    if ([self.leftEdge containsPoint:point] || [self.rightEdge containsPoint:point] || [self.topEdge containsPoint:point] || [self.bottomEdge containsPoint:point]) {
        return YES;
    }
    return NO;
}
@end
