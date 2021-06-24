//
//  TouchView.m
//  DrawDemo
//
//  Created by sunhaosheng on 4/20/16.
//  Copyright © 2016 hs sun. All rights reserved.
//

#import "TouchView.h"

@interface TouchView ()

@property (nonatomic,copy) void(^MovedHandle)(NSMutableArray *paths);

@property (nonatomic,copy) void(^MoveCompletion)();

@end

@implementation TouchView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.canEditStatus) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}
- (instancetype)initWithFrame:(CGRect)frame andMovedHandle:(void (^)(NSMutableArray *))movedHandle MovedCompletion:(void (^)(void))completion {
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.center = self.superview.center;
        self.userInteractionEnabled = NO;
        _MovedHandle = movedHandle;
        _MoveCompletion = completion;
        _paths = [NSMutableArray array];


    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (!self.canEditStatus) {
        return;
    }
    
    if (self.paths_Mark && self.paths_Mark.count >= 1) {
        self.paths = [NSMutableArray arrayWithArray:self.paths_Mark];
    }
    
    
    UITouch *touch = [touches anyObject];
    PathModel *model = [[PathModel alloc] init];
    NSValue *point = [NSValue valueWithCGPoint:[self convertPoint:[touch locationInView:self] toView:self.superview]];
    
    [model.points addObject:point];
    model.lineWidth = [MaskConfigManager sharedInstance].lineWidth;
    model.blendMode = [MaskConfigManager sharedInstance].blendMode;
    model.strokeType = [MaskConfigManager sharedInstance].strokeType;
    model.gradientRate = [MaskConfigManager sharedInstance].gradientRate;
    [self.paths addObject:model];
    if (self.MovedHandle) {
        self.paths_Mark = [NSMutableArray arrayWithArray:self.paths];
        self.MovedHandle(self.paths);
    }
    
    if ([self.delegate respondsToSelector:@selector(maskTouchViewTouchBegin:)]) {
        [self.delegate maskTouchViewTouchBegin:[self convertPoint:[touch locationInView:self] toView:self.superview]];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (!self.canEditStatus) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [self convertPoint:[touch locationInView:self] toView:self.superview];
    NSValue *lastPoint = [[[self.paths lastObject] points] lastObject];
    CGPoint lastP = [lastPoint CGPointValue];
    CGFloat len = sqrtf(((currentPoint.x - lastP.x)*(currentPoint.x - lastP.x))+((currentPoint.y - lastP.y)*(currentPoint.y - lastP.y)));
    if (len >= 0.5) {
        NSValue *point = [NSValue valueWithCGPoint:currentPoint];
        [[[self.paths lastObject] points] addObject:point];
        if (self.MovedHandle) {
            self.MovedHandle(self.paths);
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(maskTouchViewTouchMove:)]) {
        [self.delegate maskTouchViewTouchMove:[self convertPoint:[touch locationInView:self] toView:self.superview]];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (!self.canEditStatus) {
        return;
    }
    
    if (self.MoveCompletion) {
        self.MoveCompletion();
    }
    UITouch *touch = [touches anyObject];
    if ([self.delegate respondsToSelector:@selector(maskTouchViewTouchEnd:)]) {
        [self.delegate maskTouchViewTouchEnd:[self convertPoint:[touch locationInView:self] toView:self.superview]];
    }
}

@end

@implementation PathModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _points = [NSMutableArray array];
    }
    return self;
}

@end
