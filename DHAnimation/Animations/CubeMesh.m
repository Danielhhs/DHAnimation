//
//  CubeMesh.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "CubeMesh.h"

@implementation CubeMesh
- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount transitionDirection:(AnimationDirection)direction
{
    return nil;
}

- (void) drawEntireMesh
{
    for (int i = 0; i < self.columnCount; i++) {
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, NULL + (i * 6 * sizeof(GLushort)));
    }
}

- (void) drawColumnAtIndex:(NSInteger)index
{
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, NULL + (index * 6 * sizeof(GLushort)));
}
@end
