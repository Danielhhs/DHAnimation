//
//  DHObjectAnimationRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHObjectAnimationSettings.h"
#import "DHSceneMeshFactory.h"
@interface DHObjectAnimationRenderer : NSObject <GLKViewDelegate> {
    GLKMatrix4 mvpMatrix;
    GLuint program;
    GLuint texture;
    GLuint mvpLoc, samplerLoc, percentLoc, eventLoc, directionLoc;
}

@property (nonatomic, weak) EAGLContext *context;
@property (nonatomic, weak) GLKView *animationView;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, strong) UIImage *containerViewSnapshot;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic) CGFloat percent;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) void(^completion)(void);
@property (nonatomic, strong) void(^beforeAnimation)(void);
@property (nonatomic) NSBKeyframeAnimationFunction timingFunction;
@property (nonatomic) DHAnimationEvent event;
@property (nonatomic) DHAnimationDirection direction;
@property (nonatomic, strong) NSArray *allowedDirections;
@property (nonatomic) NSInteger rowCount;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic, strong) NSString *vertexShaderName;
@property (nonatomic, strong) NSString *fragmentShaderName;
@property (nonatomic, strong) DHSceneMesh *mesh;

//Override this method to set up more uniform locations; Default implementation will set up unfiorms: u_mvpMatrix, s_tex, u_percent, u_direction, u_event; If you need these uniforms, just call super's implementation;
- (void) setupGL;

//Happens before set up effect and mesh; Override this method to set up some common data for both effects and meshes;
- (void) additionalSetUp;

//Set up meshes; You MUST override this method if you need to draw with some meshes. Default implementation is empty;
- (void) setupMeshes;

//Set up effects; Default implementation is empty;
- (void) setupEffects;

//Set up textures; default implementation just set up a texture with targetView;
- (void) setupTextures;

- (void) setupBackground;

//Update your own data on every display link duration; default update is to update the elapsedTime and percent;
- (void) updateAdditionalComponents;

//Any drawing code would have to be writtin here; Default implementation just set the default uniform values;
- (void) drawFrame;

- (void) setupMvpMatrixWithView:(UIView *)view;

//Override this method to release the resources retained by your own renderer, like meshes, vertex arrays and effects;
- (void) tearDownSpecificGLResources;

//Override this method to tell whether the GL properties should be cleared when animation is done;
- (BOOL) shouldTearDownGL;

#pragma mark - Animation APIs
- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration;
- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration completion:(void(^)(void))completion;
- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration event:(DHAnimationEvent)event;
- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction;
- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration event:(DHAnimationEvent)event direction:(DHAnimationDirection)direction;
- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction;

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion;
- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration event:(DHAnimationEvent)event direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction;
- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration event:(DHAnimationEvent)event direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion;
- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount event:(DHAnimationEvent)event direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction beforeAnimationPreparation:(void(^)(void))beforeAnimation completion:(void(^)(void))completion;
- (void) prepareAnimationWithSettings:(DHObjectAnimationSettings *)settings;

- (void) startAnimation;
@end
