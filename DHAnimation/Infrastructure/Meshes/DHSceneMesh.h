//
//  SceneMesh.h
//  StartAgain
//
//  Created by Huang Hongsen on 5/18/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef struct {
    GLKVector3 position;    //0
    GLKVector3 normal;      //1
    GLKVector2 texCoords;   //2
    GLKVector3 columnStartPosition; //3
    float rotation;         //4
    GLKVector3 originalCenter;  //5
    GLKVector3 targetCenter;    //6
    BOOL rotating;              //7
    float startTime;            //8
}SceneMeshVertex;

@interface DHSceneMesh : NSObject {
    GLuint vertexBuffer;
    GLuint indexBuffer;
    GLuint vertexArray;
    SceneMeshVertex *vertices;
    GLuint *indices;
}
@property (nonatomic, strong) NSData *verticesData;
@property (nonatomic, strong) NSData *indicesData;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic) NSInteger vertexCount;
@property (nonatomic) NSInteger indexCount;
@property (nonatomic) NSInteger verticesSize;
@property (nonatomic) NSInteger indicesSize;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger rowCount;
@property (nonatomic) CGFloat originX;
@property (nonatomic) CGFloat originY;
@property (nonatomic) BOOL bufferDataBumped;

- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored rotateTexture:(BOOL)rotateTexture;
- (instancetype) initWithView:(UIView *)view containerView:(UIView *)containerView columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored rotateTexture:(BOOL)rotateTexture;
- (instancetype) initWithVerticesData:(NSData *)verticesData indicesData:(NSData *)indicesData;
- (void) prepareToDraw;
- (void) drawIndicesWithMode:(GLenum)mode startIndex:(GLuint)index indicesCount:(size_t)indicesCount;
- (void) makeDynamicAndUpdateWithVertices:(const SceneMeshVertex *)vertices numberOfVertices:(size_t)numberOfVertices;
- (void) tearDown;
- (void) drawEntireMesh;
- (void) destroyGL;
- (void) generateMeshData;  //This method must be called to generate the mesh data. You can override this method to update your mesh data in your own class, but remember to call super's implementation at the last line;

- (void) setupForVertexAtX:(NSInteger)x y:(NSInteger)y index:(NSInteger)index;

- (void) printVertices;

- (void) generateVerticesAndIndicesForView:(UIView *)view containerView:(UIView *)containerView columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount columnMajored:(BOOL)columnMajor rotateTexture:(BOOL)rotateTexture;

- (BOOL) needToUpdateBufferData;

@end
