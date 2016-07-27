//
//  DHObjectAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
@interface DHObjectAnimationRenderer() {
    GLuint backgroundProgram;
    GLuint backgroundMVPLoc, backgroundSamplerLoc;
    GLuint backgroundTexture;
}
@property (nonatomic, strong) DHSceneMesh *backgroundMesh;
@end

@implementation DHObjectAnimationRenderer

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration
{
    [self prepareAnimationForView:targetView inContainerView:containerView background:background animationView:animationView duration:duration completion:nil];
}

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
    [self prepareAnimationForView:targetView inContainerView:containerView background:background animationView:animationView duration:duration timingFunction:NSBKeyframeAnimationFunctionLinear completion:completion];
}

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction
{
    [self prepareAnimationForView:targetView inContainerView:containerView background:background animationView:animationView duration:duration event:DHAnimationEventBuiltIn direction:direction];
}

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration event:(DHAnimationEvent)event
{
    [self prepareAnimationForView:targetView inContainerView:containerView background:background animationView:animationView duration:duration event:event direction:DHAnimationDirectionLeftToRight];
}

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration event:(DHAnimationEvent)event direction:(DHAnimationDirection)direction
{
    [self prepareAnimationForView:targetView inContainerView:containerView background:background animationView:animationView duration:duration event:event direction:direction timingFunction:NSBKeyframeAnimationFunctionLinear];
}

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration event:(DHAnimationEvent)event direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction
{
    [self prepareAnimationForView:targetView inContainerView:containerView background:background animationView:animationView duration:duration event:event direction:direction timingFunction:timingFunction completion:nil];
}

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction
{
    [self prepareAnimationForView:targetView inContainerView:containerView background:background animationView:animationView duration:duration timingFunction:timingFunction completion:nil];
}

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void(^)(void))completion
{
    [self prepareAnimationForView:targetView inContainerView:containerView background:background animationView:animationView duration:duration event:DHAnimationEventBuiltIn direction:DHAnimationDirectionLeftToRight timingFunction:timingFunction completion:completion];
}

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration event:(DHAnimationEvent)event direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    [self prepareAnimationForView:targetView inContainerView:containerView background:background animationView:animationView duration:duration columnCount:1 rowCount:1 event:event direction:direction timingFunction:timingFunction beforeAnimationPreparation:nil completion:completion];
}

- (void) prepareAnimationForView:(UIView *)targetView inContainerView:(UIView *)containerView background:(UIImage *)background animationView:(GLKView *)animationView duration:(NSTimeInterval)duration columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount event:(DHAnimationEvent)event direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction beforeAnimationPreparation:(void(^)(void))beforeAnimation completion:(void (^)(void))completion
{
    self.targetView = targetView;
    self.containerView = containerView;
    self.duration = duration;
    self.event = event;
    self.direction = direction;
    self.timingFunction = timingFunction;
    self.completion = completion;
    self.beforeAnimation = beforeAnimation;
    self.columnCount = columnCount;
    self.rowCount = rowCount;
    self.containerViewSnapshot = background;
    
    self.animationView = animationView;
    self.context = animationView.context;
    [self setupGL];
    [self setupMvpMatrixWithView:containerView];
    [self additionalSetUp];
    
    [self setupBackground];
    [self setupMeshes];
    [self setupEffects];
    [self setupTextures];
    
}

- (void) prepareAnimationWithSettings:(DHObjectAnimationSettings *)settings
{
    [self prepareAnimationForView:settings.targetView inContainerView:settings.containerView background:settings.background animationView:settings.animationView duration:settings.duration columnCount:settings.columnCount rowCount:settings.rowCount event:settings.event direction:settings.direction timingFunction:[DHTimingFunctionHelper functionForTimingFunction:settings.timingFunction] beforeAnimationPreparation:settings.beforeAnimation completion:settings.completion];
}
 
- (void) startAnimation{
    self.elapsedTime = 0.f;
    self.percent = 0.f;
    self.animationView.delegate = self;
    
    if (self.containerView != self.animationView) {
        [self.containerView addSubview:self.animationView];
    }
    [self.animationView display];
    if (self.beforeAnimation) {
        self.beforeAnimation();
    }
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) setupMvpMatrixWithView:(UIView *)view
{
    GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(-view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 1, 0, 0, 0, 0, 1, 0);
    GLKMatrix4 modelView = GLKMatrix4Multiply(viewMatrix, modelMatrix);
    GLKMatrix4 projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), view.bounds.size.width / view.bounds.size.height, 0.1, 10000);
    
    mvpMatrix = GLKMatrix4Multiply(projection, modelView);
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glUseProgram(backgroundProgram);
    glUniformMatrix4fv(backgroundMVPLoc, 1, GL_FALSE, mvpMatrix.m);
    [self.backgroundMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(backgroundSamplerLoc, 0);
    [self.backgroundMesh drawEntireMesh];
    
    [self drawFrame];
}

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    if (self.vertexShaderName != nil && self.fragmentShaderName != nil) {
        program = [OpenGLHelper loadProgramWithVertexShaderSrc:self.vertexShaderName fragmentShaderSrc:self.fragmentShaderName];
        glUseProgram(program);
        mvpLoc = glGetUniformLocation(program, "u_mvpMatrix");
        samplerLoc = glGetUniformLocation(program, "s_tex");
        percentLoc = glGetUniformLocation(program, "u_percent");
        eventLoc = glGetUniformLocation(program, "u_event");
        directionLoc = glGetUniformLocation(program, "u_direction");
    }
    
    backgroundProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"ObjectBackgroundVertex.glsl" fragmentShaderSrc:@"ObjectBackgroundFragment.glsl"];
    backgroundMVPLoc = glGetUniformLocation(backgroundProgram, "u_mvpMatrix");
    backgroundSamplerLoc = glGetUniformLocation(backgroundProgram, "s_tex");
    
    glClearColor(0, 0, 0, 1);
}

- (void) additionalSetUp
{
    
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        NSTimeInterval populatedTime = self.timingFunction(self.elapsedTime * 1000, 0, self.duration, self.duration * 1000);
        self.percent = populatedTime / self.duration;
        [self updateAdditionalComponents];
        [self.animationView display];
    } else {
        self.percent = 1.f;
        [self updateAdditionalComponents];
        [self.animationView display];
        if (self.completion) {
            self.completion();
        }
        [self.displayLink invalidate];
        self.animationView.delegate = nil;
        self.displayLink = nil;
        if ([self shouldTearDownGL]) {
            [self tearDownGL];
        }
    }
}

- (void) drawFrame
{
    glUseProgram(program);
    glUniform1f(eventLoc, self.event);
    glUniform1f(directionLoc, self.direction);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(percentLoc, self.percent);
}

- (void) setupTextures
{
    texture = [TextureHelper setupTextureWithView:self.targetView];
}

- (void) setupMeshes
{
    self.mesh = [DHSceneMeshFactory sceneMeshForView:self.targetView containerView:self.containerView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:NO];
    [self.mesh generateMeshData];
}

- (void) setupEffects
{
    
}

- (void) setupBackground
{
    self.backgroundMesh = [DHSceneMeshFactory sceneMeshForView:self.containerView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
    [self.backgroundMesh generateMeshData];
    backgroundTexture = [TextureHelper setupTextureWithImage:self.containerViewSnapshot];
}

- (void) updateAdditionalComponents
{
    
}

- (void) tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    [self.mesh tearDown];
    [self.backgroundMesh tearDown];
    if (texture) {
        glDeleteTextures(1, &texture);
        texture = 0;
    }
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }
    [self tearDownSpecificGLResources];
    [EAGLContext setCurrentContext:nil];
    self.context = nil;
}

- (void) tearDownSpecificGLResources
{
    
}

- (void) dealloc
{
    [self tearDownGL];
}

- (BOOL) shouldTearDownGL
{
    return YES;
}
@end
