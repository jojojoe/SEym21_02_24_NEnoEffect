
//
//  MaskConfigManager.m
//  BMBlurMask
//
//  Created by JOJO on 2019/5/23.
//  Copyright © 2019 JOJO. All rights reserved.
//

#import "MaskConfigManager.h"

@implementation MaskConfigManager

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _blendMode = BlendModeStroke;
        _lineWidth = width2;
        _strokeType = StrokeTypeNormal;
        _gradientRate = GradientMid;
    }
    
    return self;
}

@end
