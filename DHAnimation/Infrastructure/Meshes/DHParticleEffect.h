//
//  DHParticleEffect.h
//  Shimmer
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface DHParticleEffect : NSObject {
    GLuint program;
    GLuint texture, backgroundTexture;
    GLuint vertexBuffer;
    GLuint vertexArray;
    GLuint mvpLoc, samplerLoc, backgroundSamplerLoc, percentLoc, directionLoc, eventLoc, elapsedTimeLoc;
}
@property (nonatomic) GLKMatrix4 mvpMatrix;
@property (nonatomic) GLfloat percent;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) EAGLContext *context;
@property (nonatomic, strong) NSString *vertexShaderFileName;
@property (nonatomic, strong) NSString *fragmentShaderFileName;
@property (nonatomic, strong) NSString *particleImageName;
@property (nonatomic, strong) NSMutableData *particleData;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger rowCount;

- (void) prepareToDraw;
- (void) draw;
- (void) setupGL;
- (void) setupExtraUniforms;
- (void) setupTextures;
- (void) generateParticlesData;
- (instancetype) initWithContext:(EAGLContext *)context;
- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent;
- (GLKVector3) rotatedPosition:(GLKVector3)position;

- (void) tearDownGL;

@end
