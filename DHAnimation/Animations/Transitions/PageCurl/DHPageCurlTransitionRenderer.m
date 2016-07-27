//
//  DHPageCurlTransitionRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHPageCurlTransitionRenderer.h"
#import "TextureHelper.h"
#import "OpenGLHelper.h"
#import "DHConstants.h"

@interface DHPageCurlTransitionRenderer () {
    GLuint srcPositionLoc, srcDirectionLoc, srcRadiusLoc;
    GLuint dstPositionLoc, dstDirectionLoc, dstRadiusLoc;
    GLuint backProgram;
    GLuint backMvpLoc, backSamplerLoc, backGradientLoc, backPositionLoc, backDirectionLoc, backRadiusLoc;
    GLuint backTexture;
}
@property (nonatomic) GLfloat angle;
@property (nonatomic) GLKVector2 position;
@property (nonatomic) GLfloat radius;
@property (nonatomic, strong) DHSceneMesh *backMesh;
@end

@implementation DHPageCurlTransitionRenderer

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcPositionLoc = glGetUniformLocation(srcProgram, "u_position");
    srcDirectionLoc = glGetUniformLocation(srcProgram, "u_direction");
    srcRadiusLoc = glGetUniformLocation(srcProgram, "u_radius");
    self.position = GLKVector2Make(self.fromView.frame.size.width, 0);
    
    glUseProgram(dstProgram);
    dstPositionLoc = glGetUniformLocation(dstProgram, "u_position");
    dstDirectionLoc = glGetUniformLocation(dstProgram, "u_direction");
    dstRadiusLoc = glGetUniformLocation(dstProgram, "u_radius");
    
    backProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"PageCurlBackPageVertex.glsl" fragmentShaderSrc:@"PageCurlBackPageFragment.glsl"];
    glUseProgram(backProgram);
    backMvpLoc = glGetUniformLocation(backProgram, "u_mvpMatrix");
    backSamplerLoc = glGetUniformLocation(backProgram, "s_tex");
    backGradientLoc = glGetUniformLocation(backProgram, "s_gradient");
    backPositionLoc = glGetUniformLocation(backProgram, "u_position");
    backDirectionLoc = glGetUniformLocation(backProgram, "u_direction");
    backRadiusLoc = glGetUniformLocation(backProgram, "u_radius");
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"PageCurlSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"PageCurlSourceFragment.glsl";
        self.dstVertexShaderFileName = @"PageCurlDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"PageCurlDestinationFragment.glsl";
        _angle = M_PI / 4;
        _radius = 150;
    }
    return self;
}

- (void) setupUniformsForSourceProgram
{
    glUniform2f(srcPositionLoc, self.position.x, self.position.y);
    glUniform2f(srcDirectionLoc, cos(self.angle), sin(self.angle));
    glUniform1f(srcRadiusLoc, self.radius);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform2f(dstPositionLoc, self.position.x, self.position.y);
    glUniform2f(dstDirectionLoc, cos(self.angle), sin(self.angle));
    glUniform1f(dstRadiusLoc, self.radius);
}

- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.srcMesh = [DHSceneMeshFactory sceneMeshForView:fromView columnCount:self.fromView.frame.size.width / 2 rowCount:self.fromView.frame.size.height /2  splitTexturesOnEachGrid:NO columnMajored:YES rotateTexture:YES];
    [self.srcMesh generateMeshData];
    self.dstMesh = [DHSceneMeshFactory sceneMeshForView:toView columnCount:1 rowCount:1 splitTexturesOnEachGrid:NO columnMajored:YES rotateTexture:YES];
    [self.dstMesh generateMeshData];
    self.backMesh = [DHSceneMeshFactory sceneMeshForView:fromView columnCount:self.fromView.frame.size.width / 2 rowCount:self.fromView.frame.size.height / 2 splitTexturesOnEachGrid:NO columnMajored:YES rotateTexture:YES];
    [self.backMesh generateMeshData];
}

- (void) setupTextureWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    [super setupTextureWithFromView:fromView toView:toView];
    backTexture = [TextureHelper setupTextureWithImage:[UIImage imageNamed:[DHConstants resourcePathForFile:@"BackPageGradient" ofType:@"png"]]];
}

- (void) updateMeshesAndUniforms
{
    self.angle = M_PI_4 + (M_PI / 2 - 0.23 - M_PI_4) * self.percent;
    self.position = GLKVector2Make(self.fromView.frame.size.width *  (1 - self.percent * (1 + self.fromView.frame.size.height / tan(self.angle) / self.fromView.frame.size.width)), self.fromView.frame.size.height * self.percent);
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self setupDrawingContext];
    [self setupMvpMatrixWithView:view];
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
    
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
    
    glCullFace(GL_BACK);
    [self.backMesh prepareToDraw];
    glUseProgram(backProgram);
    glUniformMatrix4fv(backMvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform2f(backPositionLoc, self.position.x, self.position.y);
    glUniform2f(backDirectionLoc, cos(self.angle), sin(self.angle));
    glUniform1f(backRadiusLoc, self.radius);
    [self.backMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(backSamplerLoc, 0);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, backTexture);
    glUniform1i(backGradientLoc, 1);
    [self.backMesh drawEntireMesh];
}

- (void) tearDownExtraResource
{
    [self.backMesh tearDown];
    if (backProgram) {
        glDeleteProgram(backProgram);
        backProgram = 0;
    }
    if (backTexture) {
        glDeleteTextures(1, &backTexture);
        backTexture = 0;
    }
}
@end
