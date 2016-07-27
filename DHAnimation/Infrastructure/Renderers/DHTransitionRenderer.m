//
//  DHAnimationRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTransitionRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
#import "DHTimingFunctionHelper.h"

@implementation DHTransitionRenderer

#pragma mark - Public Animation APIs
- (void) performAnimationWithSettings:(DHTransitionSettings *)settings
{
    [self startAnimationFromView:settings.fromView toView:settings.toView inContainerView:settings.containerView columnCount:settings.columnCount duration:settings.duration direction:settings.animationDirection timingFunction:[DHTimingFunctionHelper functionForTimingFunction:settings.timingFunction] completion:settings.completion];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration
{
    [self startAnimationFromView:fromView toView:toView inContainerView:containerView duration:duration direction:DHAnimationDirectionLeftToRight];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction
{
    [self startAnimationFromView:fromView toView:toView inContainerView:containerView duration:duration direction:direction completion:nil];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction completion:(void (^)(void))completion
{
    [self startAnimationFromView:fromView toView:toView inContainerView:containerView duration:duration direction:direction timingFunction:NSBKeyframeAnimationFunctionLinear completion:completion];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction
{
    [self startAnimationFromView:fromView toView:toView inContainerView:containerView duration:duration direction:direction timingFunction:timingFunction completion:nil];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    [self startAnimationFromView:fromView toView:toView inContainerView:containerView columnCount:1 duration:duration direction:direction timingFunction:timingFunction completion:completion];
}

- (void) startAnimationFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView columnCount:(NSInteger)columnCount duration:(NSTimeInterval)duration direction:(DHAnimationDirection)direction timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    self.duration = duration;
    self.elapsedTime = 0.f;
    self.percent = 0.f;
    self.timingFunction = timingFunction;
    self.completion = completion;
    self.direction = direction;
    self.fromView = fromView;
    self.toView = toView;
    self.columnCount = columnCount;
    
    [self initializeAnimationContext];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [self setupGL];
    [self setupMeshWithFromView:fromView toView:toView];
    [self setupTextureWithFromView:fromView toView:toView];
    self.animationView = [[GLKView alloc] initWithFrame:fromView.frame context:self.context];
    self.animationView.delegate = self;
    [containerView addSubview:self.animationView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self setupDrawingContext];
    [self setupMvpMatrixWithView:view];
    
    [self prepareToDrawDestinationFace];
    glUseProgram(dstProgram);
    glUniform1f(dstPercentLoc, self.percent);
    glUniform1i(dstDirectionLoc, self.direction);
    [self setupUniformsForDestinationProgram];
    [self.dstMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.dstMesh drawEntireMesh];
    
    [self prepareToDrawSourceFace];
    glUseProgram(srcProgram);
    glUniform1f(srcPercentLoc, self.percent);
    glUniform1i(srcDirectionLoc, self.direction);
    [self setupUniformsForSourceProgram];
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        [self populatePercent];
        [self updateMeshesAndUniforms];
        [self.animationView display];
    } else {
        self.percent = 1;
        [self.animationView display];
        [displayLink invalidate];
        self.displayLink = nil;
        [self.animationView removeFromSuperview];
        if (self.completion) {
            self.completion();
        }
        [self tearDownGL];
    }
}

- (void) prepareToDrawDestinationFace
{
    
}

- (void) prepareToDrawSourceFace
{
    
}

#pragma mark - OpenGL
- (void) tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    [self.srcMesh tearDown];
    [self.dstMesh tearDown];
    if (srcTexture) {
        glDeleteTextures(1, &srcTexture);
        srcTexture = 0;
    }
    if (dstTexture) {
        glDeleteTextures(1, &dstTexture);
        dstTexture = 0;
    }
    if (srcProgram) {
        glDeleteProgram(srcProgram);
        srcProgram = 0;
    }
    if (dstProgram) {
        glDeleteProgram(dstProgram);
        dstProgram = 0;
    }
    [self tearDownExtraResource];
    self.animationView = nil;
    [EAGLContext setCurrentContext:nil];
    self.context = nil;
}

- (void) tearDownExtraResource
{
    
}

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    if (self.srcVertexShaderFileName && self.srcFragmentShaderFileName) {
        srcProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:self.srcVertexShaderFileName fragmentShaderSrc:self.srcFragmentShaderFileName];
        glUseProgram(srcProgram);
        srcMvpLoc = glGetUniformLocation(srcProgram, "u_mvpMatrix");
        srcSamplerLoc = glGetUniformLocation(srcProgram, "s_tex");
        srcPercentLoc = glGetUniformLocation(srcProgram, "u_percent");
        srcDirectionLoc = glGetUniformLocation(srcProgram, "u_direction");
    }
    if (self.dstVertexShaderFileName && self.dstFragmentShaderFileName) {
        dstProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:self.dstVertexShaderFileName fragmentShaderSrc:self.dstFragmentShaderFileName];
        glUseProgram(dstProgram);
        dstMvpLoc = glGetUniformLocation(dstProgram, "u_mvpMatrix");
        dstSamplerLoc = glGetUniformLocation(dstProgram, "s_tex");
        dstPercentLoc = glGetUniformLocation(dstProgram, "u_percent");
        dstDirectionLoc = glGetUniformLocation(dstProgram, "u_direction");
    }
    glClearColor(0, 0, 0, 1);
}

- (void) initializeAnimationContext
{
    
}

- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.srcMesh = [DHSceneMeshFactory sceneMeshForView:fromView columnCount:1 rowCount:1 splitTexturesOnEachGrid:NO columnMajored:YES rotateTexture:YES];
    [self.srcMesh generateMeshData];
    self.dstMesh = [DHSceneMeshFactory sceneMeshForView:toView columnCount:1 rowCount:1 splitTexturesOnEachGrid:NO columnMajored:YES rotateTexture:YES];
    [self.dstMesh generateMeshData];
}

- (void) setupTextureWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    srcTexture = [TextureHelper setupTextureWithView:fromView];
    dstTexture = [TextureHelper setupTextureWithView:toView];
}

- (void) setupMvpMatrixWithView:(UIView *)view
{
    GLKMatrix4 modelView = GLKMatrix4MakeTranslation(-view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    GLfloat aspect = view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 projectioin = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(projectioin, modelView);
    
    glUseProgram(srcProgram);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    
    glUseProgram(dstProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    self.mvpMatrix = mvpMatrix;
}

- (void) setupUniformsForSourceProgram
{
    
}

- (void) setupUniformsForDestinationProgram
{
    
}

- (void) setupDrawingContext
{
    
}

- (void) populatePercent
{
    GLfloat populatedTime = self.timingFunction(self.elapsedTime * 1000, 0, self.duration, self.duration * 1000);
    self.percent = populatedTime / self.duration;
}

- (void) updateMeshesAndUniforms
{
    
}
@end
