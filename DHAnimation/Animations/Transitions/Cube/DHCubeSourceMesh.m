//
//  CubeMesh.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHCubeSourceMesh.h"

@implementation DHCubeSourceMesh

- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount transitionDirection:(DHAnimationDirection)direction
{
    self.vertexCount = 4 * columnCount;
    self.indexCount = 6 * columnCount;
    self.columnCount = columnCount;
    vertices = malloc(self.vertexCount * sizeof(SceneMeshVertex));
    indices = malloc(sizeof(GLuint) * self.indexCount);
    
    if (direction == DHAnimationDirectionTopToBottom || direction == DHAnimationDirectionBottomToTop) {
        [self generateVerticesForVerticalTransitionWithView:view];
    } else {
        [self generateVerticesForHorizontalTransitionWithView:view];
    }
    NSData *vertexData = [NSData dataWithBytes:vertices length:self.vertexCount * sizeof(SceneMeshVertex)];
    NSData *indexData = [NSData dataWithBytes:indices length:sizeof(GLuint) * self.indexCount];
    return [self initWithVerticesData:vertexData indicesData:indexData];
}

- (void) generateVerticesForVerticalTransitionWithView:(UIView *)view
{
    GLfloat vy = 1.f / self.columnCount;
    for (int i = 0; i < self.columnCount; i++) {
        vertices[i * 4 + 0].position.x = 0;
        vertices[i * 4 + 0].position.y = view.bounds.size.height * i * vy;
        vertices[i * 4 + 0].position.z = 0;
        vertices[i * 4 + 0].texCoords = GLKVector2Make(0, 1 - i * vy);
        vertices[i * 4 + 0].columnStartPosition = vertices[i*4+0].position;
        
        vertices[i * 4 + 1].position.x = view.bounds.size.width;
        vertices[i * 4 + 1].position.y = view.bounds.size.height * i * vy;
        vertices[i * 4 + 1].position.z = 0;
        vertices[i * 4 + 1].texCoords = GLKVector2Make(1, 1 - i * vy);
        vertices[i * 4 + 1].columnStartPosition = vertices[i*4+0].position;
        
        vertices[i * 4 + 2].position.x = 0;
        vertices[i * 4 + 2].position.y = view.bounds.size.height * (i + 1) * vy;
        vertices[i * 4 + 2].position.z = 0;
        vertices[i * 4 + 2].texCoords = GLKVector2Make(0, 1 - (i + 1) * vy);
        vertices[i * 4 + 2].columnStartPosition = vertices[i*4+0].position;
        
        vertices[i * 4 + 3].position.x = view.bounds.size.width;
        vertices[i * 4 + 3].position.y = view.bounds.size.height * (i + 1) * vy;
        vertices[i * 4 + 3].position.z = 0;
        vertices[i * 4 + 3].texCoords = GLKVector2Make(1, 1 - (i + 1) * vy);
        vertices[i * 4 + 3].columnStartPosition = vertices[i*4+0].position;
    }
    for (int index = 0; index < self.columnCount; index++) {
        indices[index * 6 + 0] = index * 4;
        indices[index * 6 + 1] = index * 4 + 1;
        indices[index * 6 + 2] = index * 4 + 2;
        indices[index * 6 + 3] = index * 4 + 1;
        indices[index * 6 + 4] = index * 4 + 2;
        indices[index * 6 + 5] = index * 4 + 3;
    }
}

- (void) generateVerticesForHorizontalTransitionWithView:(UIView *)view
{
    GLfloat vx = 1.f / self.columnCount;
    for (int i = 0; i < self.columnCount; i++) {
        vertices[i * 4 + 0].position.x = view.bounds.size.width * i * vx;
        vertices[i * 4 + 0].position.y = 0;
        vertices[i * 4 + 0].position.z = 0;
        vertices[i * 4 + 0].texCoords = GLKVector2Make(i * vx, 1);
        vertices[i * 4 + 0].columnStartPosition = vertices[i * 4 + 0].position;
        
        vertices[i * 4 + 1].position.x = view.bounds.size.width * i * vx;
        vertices[i * 4 + 1].position.y = view.bounds.size.height;
        vertices[i * 4 + 1].position.z = 0;
        vertices[i * 4 + 1].texCoords = GLKVector2Make(i * vx, 0);
        vertices[i * 4 + 1].columnStartPosition = vertices[i * 4 + 0].position;
        
        vertices[i * 4 + 2].position.x = view.bounds.size.width * (i + 1) * vx;
        vertices[i * 4 + 2].position.y = 0;
        vertices[i * 4 + 2].position.z = 0;
        vertices[i * 4 + 2].texCoords = GLKVector2Make((i + 1) * vx, 1);
        vertices[i * 4 + 2].columnStartPosition = vertices[i * 4 + 0].position;
        
        vertices[i * 4 + 3].position.x = view.bounds.size.width * (i + 1) * vx;
        vertices[i * 4 + 3].position.y = view.bounds.size.height;
        vertices[i * 4 + 3].position.z = 0;
        vertices[i * 4 + 3].texCoords = GLKVector2Make((i + 1) * vx, 0);
        vertices[i * 4 + 3].columnStartPosition = vertices[i * 4 + 0].position;
    }
    for (int index = 0; index < self.columnCount; index++) {
        indices[index * 6 + 0] = index * 4;
        indices[index * 6 + 1] = index * 4 + 1;
        indices[index * 6 + 2] = index * 4 + 2;
        indices[index * 6 + 3] = index * 4 + 2;
        indices[index * 6 + 4] = index * 4 + 1;
        indices[index * 6 + 5] = index * 4 + 3;
    }
}

- (void) drawEntireMesh
{
    for (int i = 0; i < self.columnCount; i++) {
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, NULL + (i * 6 * sizeof(GLuint)));
    }
}
@end
