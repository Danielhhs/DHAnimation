//
//  DHDiffuseSceneMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 7/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHDiffuseSceneMesh.h"
#import <OpenGLES/ES3/glext.h>
@implementation DHDiffuseSceneMesh

- (void) setupForVertexAtX:(NSInteger)x y:(NSInteger)y index:(NSInteger)index
{
    vertices[index].rotation = [self randomRotation];
    vertices[index + 1].rotation = vertices[index].rotation;
    vertices[index + 2].rotation = vertices[index].rotation;
    vertices[index + 3].rotation = vertices[index].rotation;
    
    GLKVector3 direction = [self randomDirection];
    GLKVector3 offset = GLKVector3MultiplyScalar(direction, [self randomOffset]);
    vertices[index].targetCenter = GLKVector3Add(vertices[index].position, offset);
    vertices[index + 1].targetCenter = GLKVector3Add(vertices[index + 1].position, offset);
    vertices[index + 2].targetCenter = GLKVector3Add(vertices[index + 2].position, offset);
    vertices[index + 3].targetCenter = GLKVector3Add(vertices[index + 3].position, offset);

    vertices[index + 0].startTime = (GLfloat)x / self.columnCount;
    vertices[index + 1].startTime = (GLfloat)x / self.columnCount;
    vertices[index + 2].startTime = (GLfloat)x / self.columnCount;
    vertices[index + 3].startTime = (GLfloat)x / self.columnCount;
    
    vertices[index + 0].originalCenter = GLKVector3Make((vertices[index + 0].position.x + vertices[index + 1].position.x) / 2, (vertices[index + 0].position.y + vertices[index + 2].position.y) / 2, 0);
    vertices[index + 1].originalCenter = vertices[index + 0].originalCenter;
    vertices[index + 2].originalCenter = vertices[index + 0].originalCenter;
    vertices[index + 3].originalCenter = vertices[index + 0].originalCenter;
}


- (CGFloat) randomRotation
{
    int numberOfRotatioins = arc4random() % 7 + 1;
    return numberOfRotatioins * M_PI * 2;
}

- (GLKVector3) randomDirection
{
    int x = arc4random() % 100 + 100;
    int y = arc4random() % 200 - 100;
    int z = arc4random() % 50;
    return GLKVector3Normalize(GLKVector3Make(x, y, z));
}

- (GLfloat) randomOffset
{
    return arc4random() % 100 + 70;
}

- (void) drawEntireMeshWithDirection:(DHAnimationDirection)direction
{
     glBindVertexArray(vertexArray);
    if (direction == DHAnimationDirectionLeftToRight) {
        for (NSInteger i = self.columnCount - 1; i >= 0; i--) {
            glDrawElements(GL_TRIANGLES, (GLsizei)self.rowCount * 6, GL_UNSIGNED_INT, NULL + (i * self.rowCount * 6 * sizeof(GLuint)));
        }
    } else {
        glDrawElements(GL_TRIANGLES, (GLsizei)self.indexCount, GL_UNSIGNED_INT, NULL);
    }
    glBindVertexArray(0);
}
@end
