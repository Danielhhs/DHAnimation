//
//  DHAnimationRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHTransitionSettings.h"
#import "DHSceneMeshFactory.h"

@interface DHTransitionRenderer : NSObject<GLKViewDelegate> {
    GLuint srcProgram, dstProgram;
    GLuint srcTexture, dstTexture;
    GLuint srcMvpLoc, srcSamplerLoc;
    GLuint dstMvpLoc, dstSamplerLoc;
    GLuint srcPercentLoc, dstPercentLoc;
    GLuint srcDirectionLoc, dstDirectionLoc;
}

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKView *animationView;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic, strong) void(^completion)(void);
@property (nonatomic) NSBKeyframeAnimationFunction timingFunction;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) CGFloat percent;
@property (nonatomic) DHAnimationDirection direction;
@property (nonatomic, strong) NSArray *allowedDirection;
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toView;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) GLKMatrix4 mvpMatrix;

@property (nonatomic, strong) NSString *srcVertexShaderFileName;
@property (nonatomic, strong) NSString *srcFragmentShaderFileName;
@property (nonatomic, strong) NSString *dstVertexShaderFileName;
@property (nonatomic, strong) NSString *dstFragmentShaderFileName;


#pragma mark - Methods for overriding
- (void) update:(CADisplayLink *)displayLink;

//Override this method if you want to customize the set up OpenGL context. Default implementation set up srcProgram, dstProgram and get the location for "u_mvpMatrix" and "s_tex"
- (void) setupGL;

//Release OpenGL resource created in set up GL, don't foget to call super's implementation;
- (void) tearDownGL;

//Set up the parameters for animation. Override this method if you have any specific set ups;
- (void) initializeAnimationContext;

//You can override this method to set up meshes for your own animation; default implementation create simple mesh for fromView and toView for 1 column, 1 row;
- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView;

//Create textures for fromView and toView; default implementation create simple texture for fromView and toView;
- (void) setupTextureWithFromView:(UIView *)fromView toView:(UIView *)toView;

//Override this method to populate the current percentage of animation process;
//Default implementation is to populate the percent by timinigFunction;
- (void) populatePercent;

//Override this method to update any mesh properties or unfiorms in update: method;
- (void) updateMeshesAndUniforms;

//Set up default mvp matrix; Override if necessary
//modelview = translation(-view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24))
//projection = perspective(M_PI / 12, view.bounds.size.width / view.bounds.size.height, 1, 10000);
- (void) setupMvpMatrixWithView:(UIView *)view;

//Override these two methods if you have to set up more uniforms other than "u_mvpMatrix", "s_tex" and "u_percent";
//If you want to handle the whole drawing process, override "glkView:drawInRect:"
- (void) setupUniformsForDestinationProgram;
- (void) setupUniformsForSourceProgram;

//Set up drawing context, like culling, blending
- (void) setupDrawingContext;

//Override this method to tear down other resources in your own renderer
- (void) tearDownExtraResource;

//Override the getters of these properties to provide your meshes to be used for tear down GL;
@property (nonatomic, strong) DHSceneMesh * srcMesh;
@property (nonatomic, strong) DHSceneMesh * dstMesh;

//Override this method to prepare for drawing, like enabling Culling
- (void) prepareToDrawDestinationFace;
- (void) prepareToDrawSourceFace;

#pragma mark - Animation APIs
- (void) performAnimationWithSettings:(DHTransitionSettings *)settings;

//Default direction : Left to Right; TimingFunction : EaseInOutCubic; Column Count: 1; Completion : nil
- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration;

//Default TimingFunction : EaseInOutCubic; Column Count: 1; Completion:nil
- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction;

//Default Completion:nil
- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction;

//Default TimingFunction : EaseInOutCubic; Column Count: 1;
- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction completion:(void(^)(void))completion;

//Default Column Count: 1;
- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion;


- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView columnCount:(NSInteger)columnCount duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion;
@end
