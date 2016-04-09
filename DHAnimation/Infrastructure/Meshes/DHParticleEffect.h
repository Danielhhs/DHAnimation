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
    GLuint mvpLoc, samplerLoc, backgroundSamplerLoc, percentLoc, directionLoc, eventLoc;
}
@property (nonatomic) GLKMatrix4 mvpMatrix;
@property (nonatomic) GLfloat percent;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) EAGLContext *context;
@property (nonatomic, strong) NSString *vertexShaderFileName;
@property (nonatomic, strong) NSString *fragmentShaderFileName;

- (void) prepareToDraw;
- (void) draw;
- (void) setupGL;
- (void) setupExtraUniforms;
- (instancetype) initWithContext:(EAGLContext *)context targetView:(UIView *)targetView containerView:(UIView *)containerView;
@end
