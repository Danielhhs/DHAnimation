//
//  DHShredderConfettiMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/2/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShredderConfettiMesh.h"

typedef struct{
    GLKVector3 position;
    GLKVector2 texCoords;
    GLKVector3 targetPosition;
    GLfloat rotation;
}DHShredderConfettiMeshAttributes;

@interface DHShredderConfettiMesh () {
    DHShredderConfettiMesh *vertices;
    GLuint *indices;
}
@property (nonatomic) NSInteger numberOfConfetties;
@end

@implementation DHShredderConfettiMesh

- (instancetype) initWithTargetView:(UIView *)targetView containerView:(UIView *)containerView columnCount:(NSInteger)columnCount
{
    self = [super init];
    if (self) {
        self.targetView = targetView;
        self.containerView = containerView;
        self.columnCount = columnCount;
    }
    return self;
}

- (void) generateMeshData
{
    self.numberOfConfetties = 0;
    NSArray *numberOfConfettiesForEachColumn = [self numberOfConfettiesForEachColumn];
    self.vertexCount = self.numberOfConfetties * 4;
    vertices = (__bridge DHShredderConfettiMesh *)(malloc(self.vertexCount * sizeof(DHShredderConfettiMeshAttributes)));
    NSInteger currentIndex = 0;
    for (int i = 0; i < self.columnCount; i++) {
        for (int j = 0; j < [numberOfConfettiesForEachColumn[i] integerValue]; j++) {
//            vertices[currentIndex * 4 + 0].position = GLKVector3Make(<#float x#>, <#float y#>, <#float z#>)
        }
    }
}

- (NSArray *) numberOfConfettiesForEachColumn
{
    NSMutableArray *numberOfConfettiesForEachColumn = [NSMutableArray array];
    NSInteger base = (int)self.targetView.frame.size.height % 30;
    NSInteger max = (int)self.targetView.frame.size.height % 15;
    for (int i = 0; i < self.columnCount; i++) {
        NSInteger number = base + arc4random() % (max - base);
        self.numberOfConfetties += number;
        [numberOfConfettiesForEachColumn addObject:@(number)];
    }
    return numberOfConfettiesForEachColumn;
}

@end
