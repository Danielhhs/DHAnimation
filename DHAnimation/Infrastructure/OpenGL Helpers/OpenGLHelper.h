//
//  ProgramLoader.h
//  StartAgain
//
//  Created by Huang Hongsen on 5/11/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface OpenGLHelper : NSObject

+ (GLuint) loadProgramWithVertexShaderSrc:(NSString *)vertexShaderSrc
                        fragmentShaderSrc:(NSString *)fragmentShaderSrc;
@end
