//
//  SceneMesh.h
//  StartAgain
//
//  Created by Huang Hongsen on 5/18/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef struct {
    GLKVector3 position;
    GLKVector3 normal;
    GLKVector2 texCoords;
    GLKVector3 columnStartPosition;
    float rotation;
    GLKVector3 originalCenter;
    GLKVector3 targetCenter;
    BOOL rotating;
}SceneMeshVertex;

@interface SceneMesh : NSObject {
    GLuint vertexBuffer;
    GLuint indexBuffer;
    SceneMeshVertex *vertices;
    GLuint *indices;
}
@property (nonatomic, strong) NSData *verticesData;
@property (nonatomic, strong) NSData *indicesData;
@property (nonatomic) NSInteger vertexCount;
@property (nonatomic) NSInteger indexCount;
@property (nonatomic) NSInteger verticesSize;
@property (nonatomic) NSInteger indicesSize;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger rowCount;

- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored;
- (instancetype) initWithVerticesData:(NSData *)verticesData indicesData:(NSData *)indicesData;
- (void) prepareToDraw;
- (void) drawIndicesWithMode:(GLenum)mode startIndex:(GLuint)index indicesCount:(size_t)indicesCount;
- (void) makeDynamicAndUpdateWithVertices:(const SceneMeshVertex *)vertices numberOfVertices:(size_t)numberOfVertices;
- (void) tearDown;
- (void) drawEntireMesh;
- (void) destroyGL;

- (void) setupColumnStartPositionAndRotationForVertexAtX:(NSInteger)x y:(NSInteger)y index:(NSInteger)index;
@end
