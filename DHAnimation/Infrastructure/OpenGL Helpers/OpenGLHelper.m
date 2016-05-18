 //
 //  ProgramLoader.m
 //  StartAgain
 //
 //  Created by Huang Hongsen on 5/11/15.
 //  Copyright (c) 2015 com.microstrategy. All rights reserved.
 //
 
#import "OpenGLHelper.h"
 
@implementation OpenGLHelper

+ (GLuint) loadProgramWithVertexShaderSrc:(NSString *)vertexShaderSrc fragmentShaderSrc:(NSString *)fragmentShaderSrc
{
    GLuint program = glCreateProgram();
    
    GLuint vertexShader = [OpenGLHelper loadShaderWithType:GL_VERTEX_SHADER sourceFileName:vertexShaderSrc];
    GLuint fragmentShader = [OpenGLHelper loadShaderWithType:GL_FRAGMENT_SHADER sourceFileName:fragmentShaderSrc];
    
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);
    int status = 0;
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status != GL_TRUE) {
        int errorLogLength;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &errorLogLength);
        char *errorLog = malloc(sizeof(char) * errorLogLength);
        glGetProgramInfoLog(program, errorLogLength, NULL, errorLog);
    }
    
    return program;
}

+ (GLuint) loadShaderWithType:(GLenum)type sourceFileName:(NSString *)sourceFileName
{
    GLuint shader = glCreateShader(type);
    
    NSBundle *bundle = [NSBundle mainBundle];
    if ([[[NSBundle mainBundle] infoDictionary][@"FrameworkTarget"] boolValue])  {
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"DHAnimationBundle" ofType:@"bundle"]];
    }
    NSString *srcPath = [[bundle resourcePath] stringByAppendingPathComponent:sourceFileName];
    
    const char *src = [[NSString stringWithContentsOfFile:srcPath encoding:NSUTF8StringEncoding error:NULL] cStringUsingEncoding:NSUTF8StringEncoding];
    glShaderSource(shader, 1, &src, NULL);
    glCompileShader(shader);
    
    int status = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status != GL_TRUE) {
        int errorlogLength = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &errorlogLength);
        char *errorLog = malloc(errorlogLength * sizeof(char));
        glGetShaderInfoLog(shader, errorlogLength, NULL, errorLog);
        NSLog(@"Fail to compile shader for : %s", errorLog);
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

@end

