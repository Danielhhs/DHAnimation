//
//  DHFoldSceneMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/10/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFoldSceneMesh.h"
#import <OpenGLES/ES3/glext.h>
typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLfloat index;
    GLKVector3 columnStartPosition;
}DHFoldSceneMeshAttributes;

@interface DHFoldSceneMesh () {
    DHFoldSceneMeshAttributes *vertices;
}
@property (nonatomic) DHAnimationDirection direction;
@property (nonatomic) CGFloat headerHeight;
@end

@implementation DHFoldSceneMesh

- (instancetype) initWithView:(UIView *)view containerView:(UIView *)containerView headerHeight:(float)headerHeight animationDirection:(DHAnimationDirection)direction columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount columnMajored:(BOOL)columnMajored
{
    self = [super init];
    if (self) {
        self.targetView = view;
        self.containerView = containerView;
        self.rowCount = rowCount;
        self.columnCount = columnCount;
        self.direction = direction;
        self.headerHeight = headerHeight;
        
        [self generateVerticesData];
        
        self.indexCount = (self.columnCount + 1) * 6;
        indices = malloc(sizeof(GLuint) * self.indexCount);
        for (int i = 0; i <= self.columnCount; i++) {
            indices[i * 6 + 0] = i * 4 + 0;
            indices[i * 6 + 1] = i * 4 + 1;
            indices[i * 6 + 2] = i * 4 + 2;
            indices[i * 6 + 3] = i * 4 + 2;
            indices[i * 6 + 4] = i * 4 + 1;
            indices[i * 6 + 5] = i * 4 + 3;
        }
    }
    self.verticesData = [NSData dataWithBytesNoCopy:vertices length:self.vertexCount * sizeof(DHFoldSceneMeshAttributes) freeWhenDone:YES];
    self.indicesData = [NSData dataWithBytes:indices length:self.indexCount * sizeof(GLuint)];
    [self prepareToDraw];
    return self;
}

- (void) generateVerticesData
{
    switch (self.direction) {
        case DHAnimationDirectionLeftToRight:
        case DHAnimationDirectionRightToLeft:
        {
            [self generateVerticesForHorizontal];
        }
            break;
        case DHAnimationDirectionBottomToTop:
        case DHAnimationDirectionTopToBottom:
        {
            [self generateVerticesForVertical];
        }
            break;
        default:
            break;
    }
}

- (void) generateVerticesForHorizontal
{
    self.vertexCount = (self.columnCount + 1) * 4;
    vertices = malloc(self.vertexCount * sizeof(DHFoldSceneMeshAttributes));
    
    GLfloat columnWidth = (self.targetView.frame.size.width - self.headerHeight) / self.columnCount;
    GLfloat originX = self.targetView.frame.origin.x;
    GLfloat originY = 0;
    if (self.containerView) {
        originY = self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame);
    }
    
    CGFloat originXOffset = self.headerHeight;
    if (self.direction == DHAnimationDirectionRightToLeft) {
        vertices[0].position = GLKVector3Make(originX + self.targetView.frame.size.width - self.headerHeight, originY, 0);
        vertices[0].texCoords = GLKVector2Make(1 - self.headerHeight / self.targetView.frame.size.width, 1);
        vertices[0].index = -1.f;
        vertices[1].position = GLKVector3Make(originX + self.targetView.frame.size.width, originY, 0);
        vertices[1].texCoords = GLKVector2Make(1, 1);
        vertices[1].index = -1.f;
        
        vertices[2].position = GLKVector3Make(originX + self.targetView.frame.size.width - self.headerHeight, originY + self.targetView.frame.size.height, 0);
        vertices[2].texCoords = GLKVector2Make(1 - self.headerHeight / self.targetView.frame.size.width, 0);
        vertices[2].index = -1.f;
        vertices[3].position = GLKVector3Make(originX + self.targetView.frame.size.width, originY + self.targetView.frame.size.height, 0);
        vertices[3].texCoords = GLKVector2Make(1, 0);
        vertices[3].index = -1.f;
        originXOffset = 0;
    } else {
        vertices[0].position = GLKVector3Make(originX, originY, 0);
        vertices[0].texCoords = GLKVector2Make(0, 1);
        vertices[0].index = -1.f;
        vertices[1].position = GLKVector3Make(originX + self.headerHeight, originY, 0);
        vertices[1].texCoords = GLKVector2Make(self.headerHeight / self.targetView.frame.size.width, 1);
        vertices[1].index = -1.f;
        
        vertices[2].position = GLKVector3Make(originX, originY + self.targetView.frame.size.height, 0);
        vertices[2].texCoords = GLKVector2Make(0, 0);
        vertices[2].index = -1.f;
        vertices[3].position = GLKVector3Make(originX + self.headerHeight, originY + self.targetView.frame.size.height, 0);
        vertices[3].texCoords = GLKVector2Make(self.headerHeight / self.targetView.frame.size.width, 0);
        vertices[3].index = -1.f;
    }
    for (int i = 0; i < self.columnCount; i++) {
        vertices[(i + 1) * 4 + 0].position = GLKVector3Make(originX + originXOffset + i * columnWidth, originY, 0);
        vertices[(i + 1) * 4 + 0].texCoords = GLKVector2Make((originXOffset + i * columnWidth) / self.targetView.frame.size.width, 1.f);
        vertices[(i + 1) * 4 + 0].index = i;
        vertices[(i + 1) * 4 + 0].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
        
        vertices[(i + 1) * 4 + 1].position = GLKVector3Make(originX + originXOffset + (i + 1) * columnWidth, originY, 0);
        vertices[(i + 1) * 4 + 1].texCoords = GLKVector2Make((originXOffset + (i + 1) * columnWidth) / self.targetView.frame.size.width, 1.f);
        vertices[(i + 1) * 4 + 1].index = i;
        vertices[(i + 1) * 4 + 1].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
        
        vertices[(i + 1) * 4 + 2].position = GLKVector3Make(originX + originXOffset + i * columnWidth, originY + self.targetView.frame.size.height, 0);
        vertices[(i + 1) * 4 + 2].texCoords = GLKVector2Make((originXOffset + i * columnWidth) / self.targetView.frame.size.width, 0.f);
        vertices[(i + 1) * 4 + 2].index = i;
        vertices[(i + 1) * 4 + 2].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
        
        vertices[(i + 1) * 4 + 3].position = GLKVector3Make(originX + originXOffset + (i + 1) * columnWidth, originY + self.targetView.frame.size.height, 0);
        vertices[(i + 1) * 4 + 3].texCoords = GLKVector2Make((originXOffset + (i + 1) * columnWidth) / self.targetView.frame.size.width, 0.f);
        vertices[(i + 1) * 4 + 3].index = i;
        vertices[(i + 1) * 4 + 3].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
    }
    
}

- (void) generateVerticesForVertical
{

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
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHFoldSceneMeshAttributes), NULL + offsetof(DHFoldSceneMeshAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHFoldSceneMeshAttributes), NULL + offsetof(DHFoldSceneMeshAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHFoldSceneMeshAttributes), NULL + offsetof(DHFoldSceneMeshAttributes, index));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(DHFoldSceneMeshAttributes), NULL + offsetof(DHFoldSceneMeshAttributes, columnStartPosition));
    
    glBindVertexArray(0);
}

- (void) drawEntireMesh
{
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glDrawElements(GL_TRIANGLES, (GLsizei)self.indexCount, GL_UNSIGNED_INT, NULL);
    glBindVertexArray(0);
}

@end
