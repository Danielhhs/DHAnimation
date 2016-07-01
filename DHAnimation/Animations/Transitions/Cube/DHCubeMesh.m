//
//  CubeMesh.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHCubeMesh.h"
#import <OpenGLES/ES3/glext.h>

@implementation DHCubeMesh
- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount transitionDirection:(DHAnimationDirection)direction
{
    return nil;
}

- (void) drawEntireMesh
{
    for (int i = 0; i < self.columnCount; i++) {
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, NULL + (i * 6 * sizeof(GLuint)));
    }
}

- (void) drawColumnAtIndex:(NSInteger)index
{
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, NULL + (index * 6 * sizeof(GLuint)));
    glBindVertexArray(0);
}
@end
