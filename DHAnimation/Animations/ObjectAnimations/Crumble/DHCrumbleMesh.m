//
//  DHCrumbleMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/29/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHCrumbleMesh.h"
#import "DHPolygon.h"
#import <OpenGLES/ES3/glext.h>

typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLfloat startFallingTime;
}DHCrumbleMeshAttributes;

@interface DHCrumbleMesh() {
    DHCrumbleMeshAttributes *vertices;
}
@property (nonatomic, strong) NSArray *polygons;
@property (nonatomic) NSInteger numberOfTriangles;
@property (nonatomic) CGPoint origin;
@end

@implementation DHCrumbleMesh

- (instancetype) initWithView:(UIView *)view containerView:(UIView *)containerView polygons:(NSArray *)polygons
{
    self = [super init];
    if (self) {
        self.containerView = containerView;
        self.targetView = view;
        self.polygons = polygons;
        self.origin = CGPointMake(self.targetView.frame.origin.x, containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame));
        for (DHPolygon *polygon in polygons) {
            self.numberOfTriangles += [polygon.vertices count] - 2;
        }
    }
    return self;
}

- (void) generateMeshData
{
    self.vertexCount = self.numberOfTriangles * 3;
    self.indexCount = self.numberOfTriangles * 3;
    
    vertices = malloc(self.vertexCount * sizeof(DHCrumbleMeshAttributes));
    
    int counter = 0;
    for (DHPolygon *polygon in self.polygons) {
        for (DHIntersectPoint *point in [polygon vertices]) {
            DHCrumbleMeshAttributes attributes;
            attributes.position = GLKVector3Make(point.position.x, point.position.y, 0);
            attributes.texCoords = GLKVector2Make((point.position.x - self.origin.x) / self.targetView.frame.size.width, (point.position.y - self.origin.y) / self.targetView.frame.size.height);
            vertices[counter] = attributes;
            counter++;
        }
    }
    
    indices = malloc(sizeof(GLuint) * self.indexCount);
    for (int i = 0; i < self.indexCount; i++) {
        indices[i] = i;
    }
    
    self.verticesData = [NSData dataWithBytes:vertices length:sizeof(DHCrumbleMeshAttributes) * self.vertexCount];
    self.indicesData = [NSData dataWithBytes:indices length:sizeof(GLuint) * self.indexCount];
    
    [self prepareToDraw];
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0 && [self.verticesData length] > 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.verticesData length], [self.verticesData bytes], GL_STATIC_DRAW);
        glGenVertexArrays(1, &vertexArray);
    }
    if (indexBuffer == 0 && [self.indicesData length] > 0) {
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indicesData length], [self.indicesData bytes], GL_STATIC_DRAW);
    }
    
    glBindVertexArray( vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHCrumbleMeshAttributes), NULL + offsetof(DHCrumbleMeshAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHCrumbleMeshAttributes), NULL + offsetof(DHCrumbleMeshAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHCrumbleMeshAttributes), NULL + offsetof(DHCrumbleMeshAttributes, startFallingTime));
    
    glBindVertexArray(0);
}

- (void) drawEntireMesh
{
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glDrawElements(GL_TRIANGLES, self.indexCount, GL_UNSIGNED_INT, NULL);
}

@end
