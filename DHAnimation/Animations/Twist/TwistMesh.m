//
//  TwistSourceMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "TwistMesh.h"
@interface TwistMesh()
@property (nonatomic) NSInteger transitionLength;
@property (nonatomic) CGFloat radius;
@end

@implementation TwistMesh

- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored
{
    self = [super initWithView:view columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:splitTexture columnMajored:columnMajored];
    if (self) {
        _transitionLength = columnCount;
        _radius = view.bounds.size.height / 2;
    }
    return self;
}

- (void) updateWithRotation:(CGFloat)rotation transition:(CGFloat)transition direction:(AnimationDirection)direction
{
    if (direction == AnimationDirectionLeftToRight || direction == AnimationDirectionTopToBottom) {
        [self updateForwardWithRotation:rotation transition:transition];
    } else {
        [self updateBackwardWithRotation:rotation transition:transition];
    }
    [self makeDynamicAndUpdateWithVertices:vertices numberOfVertices:self.vertexCount];
}

- (void) updateForwardWithRotation:(CGFloat)rotation transition:(CGFloat)transition
{
    size_t zeroPosition = floor(self.transitionLength * transition);
    for (size_t i = 0; i <= zeroPosition; i++) {
        if (vertices[i * 2].rotation == M_PI) {
            continue;
        } else if (vertices[i * 2].rotation != 0) {
            vertices[i * 2].rotation += rotation;
            vertices[i * 2 + 1].rotation += rotation;
            if (vertices[i * 2].rotation > M_PI) {
                vertices[i * 2].rotation = M_PI;
                vertices[i * 2 + 1].rotation = M_PI;
            }
        } else if (vertices[i * 2].rotation == 0) {
            if (i == 0) {
                vertices[i * 2].rotation = rotation;
                vertices[i * 2 + 1].rotation = rotation;
            } else {
                vertices[i * 2].rotation = vertices[(i- 1) * 2].rotation - vertices[(i - 1) * 2].rotation / (zeroPosition - i + 2);
                vertices[i * 2 + 1].rotation = vertices[i * 2].rotation;
            }
        }
    }
}

- (void) updateBackwardWithRotation:(CGFloat)rotation transition:(CGFloat)transition
{
    int zeroPosition = floor(self.transitionLength * transition);
    for (int i = (int)self.transitionLength; i >= zeroPosition; i--) {
        if (vertices[i * 2].rotation == M_PI) {
            continue;
        } else if (vertices[i * 2].rotation != 0) {
            vertices[i * 2].rotation += rotation;
            vertices[i * 2 + 1].rotation += rotation;
            if (vertices[i * 2].rotation < -M_PI) {
                vertices[i * 2].rotation = -M_PI;
                vertices[i * 2 + 1].rotation = -M_PI;
            }
        } else if (vertices[i * 2].rotation == 0) {
            if (i == self.transitionLength) {
                vertices[i * 2].rotation = rotation;
                vertices[i * 2 + 1].rotation = rotation;
            } else {
                vertices[i * 2].rotation = vertices[(i + 1) * 2].rotation - vertices[(i + 1) * 2].rotation / (i - zeroPosition + 2);
                vertices[i * 2 + 1].rotation = vertices[i * 2].rotation;
            }
        }
    }
}
@end
