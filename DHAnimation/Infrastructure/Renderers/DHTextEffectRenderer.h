//
//  DHTextEffectRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/19/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHConstants.h"
#import "DHTextSceneMesh.h"
#import "DHTextAnimationSettings.h"
@interface DHTextEffectRenderer : NSObject<GLKViewDelegate> {
    GLuint program;
    GLuint texture;
    GLuint mvpLoc, percentLoc, eventLoc, samplerLoc, timeLoc;
    
}

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic) CGPoint origin;
@property (nonatomic) GLKMatrix4 mvpMatrix;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) CGFloat percent;
@property (nonatomic) DHAnimationEvent event;
@property (nonatomic) DHAnimationDirection direction;
@property (nonatomic, strong) DHTextSceneMesh *mesh;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) GLKView *animationView;
@property (nonatomic, weak) UIView *textContainerView;
@property (nonatomic) NSBKeyframeAnimationFunction timingFunction;
@property (nonatomic, strong) void (^completion)(void);
@property (nonatomic, strong) void (^beforeAnimationAction)(void);
@property (nonatomic) NSTimeInterval elapsedTime;

@property (nonatomic, strong) CADisplayLink *displayLink;

#pragma mark - For Override
//Override this method to provide vertexShader file name
- (NSString *) vertexShaderName;
//Override this method to provide fragmentShader file name
- (NSString *) fragmentShaderName;

//Override this method to set up extra uniforms you need while setting up OpenGL ES context.
//This happens right after initialization
- (void) setupExtraUniforms;

//Override this method to set up meshes to render for text
//Default implementation is to set up a grid for each of the character
- (void) setupMeshes;

//Override this method to set up Drawing context for rendering frame. Like culling.
//This happens before using the program and setting up the uniforms.
- (void) prepareDrawingContext;

//Override this method to perform the drawing commands.
//Default implementation does nothing.
- (void) drawFrame;

//Override this method to tear down any OpenGL resource you created in sub class.
//Resources created by base class are released;
- (void) tearDownExtraOpenGLResource;

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(CGFloat)percent;

#pragma mark - Public APIs
//Call this method to set up animation context
- (void) prepareAnimationWithSettings:(DHTextAnimationSettings *)settings;

//Call this method to start animation;
- (void) startAnimation;

@end
