//
//  MaskView.m
//  DrawDemo
//
//  Created by sunhaosheng on 4/7/16.
//  Copyright © 2016 hs sun. All rights reserved.
//

#import "MaskView.h"


@interface MaskView()

@property (nonatomic,strong) PathModel *currentDrawingPath;

@property (nonatomic,strong) UIImage *mainImage;

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, assign) NSInteger saveRatio;

@property (nonatomic, strong) UIImage *customShapeImage;

@end

@implementation MaskView


#pragma mark - Public
- (void)setupCustomShapeImage:(UIImage *)shapeImage {
    self.customShapeImage = shapeImage;
    self.mainImage = [self fitCenterShapeImageWithOriginalImage:shapeImage];
    [self setNeedsDisplay];
}

- (UIImage *)fitCenterShapeImageWithOriginalImage:(UIImage *)shapeImage {
    CGFloat length = MIN(self.bounds.size.width, self.bounds.size.height);
    UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, length, length)];
    contentImageView.image = shapeImage;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    contentImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height / 2);
    bgView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:contentImageView];
    
    UIImage *image = [self imageWithContentView:bgView];
    return image;
}

- (UIImage *)imageWithContentView:(UIView *)contentView {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(contentView.bounds.size.width), floorf(contentView.bounds.size.height)) , NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * color = [UIColor clearColor];
    CGContextSetFillColorWithColor(context, color.CGColor);
    [contentView.layer renderInContext:context];
    CGContextFlush(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)clearPath {
    
    if (self.paths) {
        [self.paths removeAllObjects];
    }
    if (self.paths_Mark) {
        [self.paths_Mark removeAllObjects];
    }
    if (self.touchView.paths) {
        [self.touchView.paths removeAllObjects];
    }
    if (self.touchView.paths_Mark) {
        [self.touchView.paths_Mark removeAllObjects];
    }
    self.perPaintMoveCompletion(NO, NO);
    
    [self clearAllLineActionAtView];

}


- (void)clearAllLineActionAtView {
    UIGraphicsBeginImageContextWithOptions(self.superview.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, self.superview.bounds);
    self.layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
    self.mainImage = nil;
}



- (void)beforeStepAction {
    if (self.paths_Mark && self.paths_Mark.count >= 1) {
        [self.paths_Mark removeLastObject];
        [self.touchView.paths_Mark removeLastObject];
        
        if (self.paths_Mark.count >= 1) {
            self.perPaintMoveCompletion(YES, YES);
            
            self.currentDrawingPath = nil;
            self.mainImage = nil;
            [self setNeedsDisplay];
            [self drawPathCompletion];
        } else {
            self.perPaintMoveCompletion(NO, YES);
            
            self.mainImage = nil;
            [self clearAllLineActionAtView];
        }
    } else {
        //
        NSLog(@"不应该存在，无法返回上一步");
    }
}

- (void)nextStepAction {
    
    if (self.paths.count > self.paths_Mark.count) {
        [self.paths_Mark addObject:self.paths[self.paths_Mark.count]];
        [self.touchView.paths_Mark addObject:self.touchView.paths[self.touchView.paths_Mark.count]];
        if (self.paths_Mark.count == self.paths.count) {
            self.perPaintMoveCompletion(YES, NO);
        } else {
            self.perPaintMoveCompletion(YES, YES);
        }
        self.currentDrawingPath = nil;
        self.mainImage = nil;
        [self setNeedsDisplay];
        [self drawPathCompletion];
        
    } else {
        NSLog(@"不应该存在，无法下一步");
    }
}

#pragma mark - Init

- (NSLock *)lock {
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _saveRatio = 1;
    };
    return self;
}

- (void)didMoveToSuperview {
    if (self.superview) {
        self.superview.userInteractionEnabled = YES;
        if (!self.touchView) {
            __weak typeof(self) weakSelf = self;
            CGRect touchViewRect = CGRectApplyAffineTransform(self.bounds, CGAffineTransformMakeScale(1.5, 1.5));
            TouchView *touchView = [[TouchView alloc] initWithFrame:touchViewRect andMovedHandle:^(NSMutableArray *paths) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.paths = paths;
                strongSelf.paths_Mark = paths;
                
                strongSelf.currentDrawingPath = [paths lastObject];
                [self setNeedsDisplay];
                
            } MovedCompletion:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf drawPathCompletion];
                //
                strongSelf.paths_Mark = [NSMutableArray arrayWithArray:self.paths];
                strongSelf.perPaintMoveCompletion(YES,NO);
                //
            }];
            touchView.backgroundColor = [UIColor clearColor];
            self.touchView = touchView;
            self.touchView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            [self.superview addSubview:touchView];
            
            if (_perPaintMoveCompletion) {
                _perPaintMoveCompletion(NO,NO);
            }
            
            
        }
    } else {
        [self.touchView removeFromSuperview];
    }
}


- (void)drawPathCompletion {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(self.bounds.size.width), floorf(self.bounds.size.height)) , NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * color = [UIColor clearColor];
    CGContextSetFillColorWithColor(context, color.CGColor);
    [self.layer renderInContext:context];
    CGContextFlush(context);
    self.mainImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.layer.contents = (id)self.mainImage.CGImage;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.touchView.frame = CGRectMake(0, 0, frame.size.width * 2, frame.size.height * 2);
    self.touchView.center = self.center;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.touchView.frame = CGRectMake(0, 0, bounds.size.width * 2, bounds.size.height * 2);
    self.touchView.center = self.center;
}



- (void)drawRect:(CGRect)rect {
    if ([self.lock tryLock]) {
        [super drawRect:rect];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        if (!self.mainImage) {
            CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
            CGContextFillRect(context, self.bounds);
            
        } else {
            CGContextSaveGState(context);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            CGContextTranslateCTM(context, 0.0f, -self.frame.size.height);
            CGContextDrawImage(context, rect, self.mainImage.CGImage);
            CGContextRestoreGState(context);
        }
        
        if ([MaskConfigManager sharedInstance].strokeType == StrokeTypeCustomPath) {
//            CGContextAddPath(context, self.customPath.CGPath);
//            self.touchView.userInteractionEnabled = NO;
        } else if ([MaskConfigManager sharedInstance].strokeType == StrokeTypeNormal) {
//            self.touchView.userInteractionEnabled = YES;
            if (self.currentDrawingPath) {
                [self strokeNormalPathInContext:context WithPathModel:self.currentDrawingPath];
            } else {
                [self strokeNormalPathInContext:context WithPathModelList:self.paths_Mark];
            }
            
        } else if ([MaskConfigManager sharedInstance].strokeType == StrokeTypeGradient) {
//            self.touchView.userInteractionEnabled = YES;
            if (self.currentDrawingPath) {
                [self strokeGradientPathInContext:context WithPathModel:self.currentDrawingPath drawing:YES];
            } else {
                [self strokeGradientPathInContext:context WithPathModelList:self.paths_Mark drawing:YES];
            }
            
        }

        [self.lock unlock];
    }
}

- (void)strokeNormalPathInContext:(CGContextRef)context WithPathModel:(PathModel *)model {
    CGContextSetLineWidth(context, model.lineWidth);
    
    model.lineColorOne = model.lineColorOne?model.lineColorOne:[MaskConfigManager sharedInstance].lineColorOne;
    model.lineColorTwo = model.lineColorTwo?model.lineColorTwo:[MaskConfigManager sharedInstance].lineColorTwo;
    
    
    if (model.blendMode == BlendModeStroke) {
        CGContextSetBlendMode(context, kCGBlendModeNormal);
//        CGContextSetRGBStrokeColor(context, 1, 0, 0,1);
        CGContextSetStrokeColorWithColor(context, model.lineColorOne.CGColor);
//        CGContextSetFillColorWithColor(context, model.lineColorTwo.CGColor);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 0), model.lineWidth * 0.2, model.lineColorTwo.CGColor);
    } else {
        CGContextSetBlendMode(context, kCGBlendModeClear);
//        CGContextSetRGBStrokeColor(context, 1, 0, 0,0);
        CGContextSetStrokeColorWithColor(context, model.lineColorOne.CGColor);
//        CGContextSetFillColorWithColor(context, model.lineColorTwo.CGColor);
    }
    
    
    if (model.points.count < 2) {
        CGPoint point = [model.points[0] CGPointValue];
        CGPoint point2 = CGPointMake(point.x + 1, point.y + 1);
        CGContextMoveToPoint(context, point.x, point.y);
        CGContextAddLineToPoint(context, point2.x, point2.y);
//        CGContextFillEllipseInRect(context, CGRectMake (point.x - model.lineWidth / 2, point.y - model.lineWidth / 2, model.lineWidth , model.lineWidth));
        CGContextStrokePath(context);
    } else {
        self.isEditingStatus = YES;
        [model.points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGPoint point = [obj CGPointValue];
            
            if (idx == 0) {
                CGContextMoveToPoint(context, point.x, point.y);
            } else {
                CGContextAddLineToPoint(context, point.x, point.y);
            }
        }];
        CGContextStrokePath(context);
    }
}

- (void)drawRadialGradientWithPoint:(CGPoint)point InContext:(CGContextRef)ctx pathModel:(PathModel *)model {
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    
    UIColor *colorOne = model.lineColorOne?model.lineColorOne:[UIColor whiteColor];
    UIColor *colorTwo = model.lineColorTwo?model.lineColorTwo:[UIColor whiteColor];
    
    CGFloat* comp = (CGFloat *)CGColorGetComponents(colorOne.CGColor);
    CGFloat* comp2 = (CGFloat *)CGColorGetComponents(colorTwo.CGColor);
    
    CGFloat locations[2] = {0.0f,1.0f};
//    CGFloat colors[8] = { comp[0], comp[1], comp[2], model.gradientRate , comp[0], comp[1], comp[2], 0.0f};
    
    CGFloat colors[8] = { comp[0], comp[1], comp[2], model.gradientRate , comp2[0], comp2[1], comp2[2], model.gradientRate};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, colors, locations, num_locations);
    if (model.blendMode == BlendModeClear) {
        CGContextSetBlendMode(ctx, kCGBlendModeDestinationOut);
    } else {
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    }
    
    CGContextDrawRadialGradient(ctx, gradient, point, 0.0f, point, model.lineWidth / 2, 0);
    CFRelease(gradient);
    CFRelease(colorspace);
    
}

- (void)strokeGradientPathInContext:(CGContextRef)ctx WithPathModel:(PathModel *)model drawing:(BOOL)isDrawing {
    NSInteger startIndex = 0;
    NSInteger endIndex = 0;
    NSInteger count = model.points.count;
    
    model.lineColorOne = [MaskConfigManager sharedInstance].lineColorOne;
    model.lineColorTwo = [MaskConfigManager sharedInstance].lineColorTwo;
    
    if (isDrawing) {
        if (count < 4) {
            [self drawRadialGradientWithPoint:[model.points[0] CGPointValue] InContext:ctx pathModel:model];

            return;
        } else {
            self.isEditingStatus = YES;
            startIndex = count - 4;
            endIndex = count - 2;
        }
        for (NSInteger i = startIndex; i < endIndex; i++) {
            CGPoint fromPoint = [model.points[i] CGPointValue];
            CGPoint point = fromPoint;
            
            CGPoint toPoint = [model.points[i + 1] CGPointValue];
            CGFloat dx = toPoint.x - fromPoint.x;
            CGFloat dy = toPoint.y - fromPoint.y;
            CGFloat len = sqrtf((dx*dx)+(dy*dy));
            CGFloat ix = dx/len;
            CGFloat iy = dy/len;
            NSInteger ilen = (NSInteger) len;
            for (int i = 0; i <= ilen; i++) {
                [self drawRadialGradientWithPoint:point InContext:ctx pathModel:model];
                point.x += ix;
                point.y += iy;
            }
        }
        [self drawPathCompletion];
    } else {
        if (count < 4) {
            [self drawRadialGradientWithPoint:[model.points[0] CGPointValue] InContext:ctx pathModel:model];
            return;
        } else {
            startIndex = 1;
            endIndex = count - 3;
            
            for (NSInteger i = startIndex; i < endIndex; i++) {
                CGPoint fromPoint = [model.points[i] CGPointValue];
                CGPoint point = fromPoint;
                
                CGPoint toPoint = [model.points[i + 1] CGPointValue];
                CGFloat dx = toPoint.x - fromPoint.x;
                CGFloat dy = toPoint.y - fromPoint.y;
                CGFloat len = sqrtf((dx*dx)+(dy*dy));
                CGFloat ix = dx/len;
                CGFloat iy = dy/len;
                NSInteger ilen = (NSInteger) len;
 
                for (int i = 0; i <= ilen; i++) {
                    [self drawRadialGradientWithPoint:point InContext:ctx pathModel:model];
                    point.x += ix;
                    point.y += iy;
                }
            }
        }
    }
}

- (void)restoreTheMarkMask {
    
    UIGraphicsBeginImageContextWithOptions(self.superview.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextFillRect(ctx, self.bounds);
    for (PathModel *model in self.paths) {
        
        if (model.strokeType == StrokeTypeNormal) {
            [self strokeNormalPathInContext:ctx WithPathModel:model];
        } else {
            [self strokeGradientPathInContext:ctx WithPathModel:model drawing:NO];
        }
    }
    self.mainImage = UIGraphicsGetImageFromCurrentImageContext();
    self.layer.contents = (id)self.mainImage.CGImage;
    UIGraphicsEndImageContext();
}

- (void)drawMaskWithMaskView:(MaskView *)maskView {
    if (self == maskView) {
        return;
    }
    self.paths = [NSMutableArray arrayWithArray:maskView.paths];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextFillRect(context, self.bounds);
    CGFloat ratio = CGRectGetWidth(self.bounds)/CGRectGetWidth(maskView.bounds);
    self.saveRatio = ratio;
    for (PathModel *model in maskView.paths) {
        PathModel *newModel = [[PathModel alloc] init];
        [model.points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGPoint point = [obj CGPointValue];
            point = CGPointMake(point.x * ratio, point.y * ratio);
            NSValue *pointValue = [NSValue valueWithCGPoint:point];
            [newModel.points addObject:pointValue];
        }];
        newModel.blendMode = model.blendMode;
        newModel.strokeType = model.strokeType;
        newModel.lineWidth = roundf( model.lineWidth * ratio );
        newModel.gradientRate =model.gradientRate ;
        if (newModel.strokeType == StrokeTypeNormal) {
            [self strokeNormalPathInContext:context WithPathModel:newModel];
        } else {
            [self strokeGradientPathInContext:context WithPathModel:newModel drawing:NO];
        }
    }
    self.mainImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}






// new add before action \ next action

- (void)strokeNormalPathInContext:(CGContextRef)context WithPathModelList:(NSArray <PathModel *>*)modelList {
    
    for (PathModel *model in modelList) {
//        CGContextSetLineWidth(context, model.lineWidth);
//
//        UIColor *colorOne = model.lineColorOne?model.lineColorOne:[UIColor whiteColor];
//        UIColor *colorTwo = model.lineColorTwo?model.lineColorTwo:[UIColor whiteColor];
//
        
        [self strokeNormalPathInContext:context WithPathModel:model];
        
        
//
//        if (model.blendMode == BlendModeStroke) {
//            CGContextSetStrokeColorWithColor(context, colorOne.CGColor);
//            CGContextSetFillColorWithColor(context, colorTwo.CGColor);
//        } else {
//            CGContextSetStrokeColorWithColor(context, colorOne.CGColor);
//            CGContextSetFillColorWithColor(context, colorTwo.CGColor);
//        }
//        if (model.points.count < 2) {
//            CGPoint point = [model.points[0] CGPointValue];
//            CGContextFillEllipseInRect(context, CGRectMake (point.x - model.lineWidth / 2, point.y - model.lineWidth / 2, model.lineWidth , model.lineWidth));
//
//        } else {
//            self.isEditingStatus = YES;
//            [model.points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                CGPoint point = [obj CGPointValue];
//                //            CGAffineTransform trans = self.transform;
//                //            NSLog(@"transx trans.a = %f, trans.b = %f,trans.c = %f,trans.d = %f,trans.tx = %f,trans.ty = %f, ",trans.a,trans.b,trans.c,trans.d,trans.tx,trans.ty);
//
//                if (idx == 0) {
//                    CGContextMoveToPoint(context, point.x, point.y);
//                } else {
//                    CGContextAddLineToPoint(context, point.x, point.y);
//                }
//            }];
//            CGContextStrokePath(context);
//        }
    }
    
    
}


- (void)strokeGradientPathInContext:(CGContextRef)ctx WithPathModelList:(NSArray <PathModel *>*)modelList drawing:(BOOL)isDrawing {
    
    for (PathModel *model in modelList) {

        
        NSInteger startIndex = 0;
        NSInteger endIndex = 0;
        NSInteger count = model.points.count;
        
        if (isDrawing) {
            if (count < 4) {
                [self drawRadialGradientWithPoint:[model.points[0] CGPointValue] InContext:ctx pathModel:model];

                return;
            } else {
                self.isEditingStatus = YES;
                startIndex = count - 4;
                endIndex = count - 2;
            }
            for (NSInteger i = startIndex; i < endIndex; i++) {
                CGPoint fromPoint = [model.points[i] CGPointValue];
                CGPoint point = fromPoint;

                CGPoint toPoint = [model.points[i + 1] CGPointValue];
                CGFloat dx = toPoint.x - fromPoint.x;
                CGFloat dy = toPoint.y - fromPoint.y;
                CGFloat len = sqrtf((dx*dx)+(dy*dy));
                CGFloat ix = dx/len;
                CGFloat iy = dy/len;
                NSInteger ilen = (NSInteger) len;
                for (int i = 0; i <= ilen; i++) {
                    [self drawRadialGradientWithPoint:point InContext:ctx pathModel:model];
                    point.x += ix;
                    point.y += iy;
                }
            }
            [self drawPathCompletion];
        } else {
            if (count < 4) {
                [self drawRadialGradientWithPoint:[model.points[0] CGPointValue] InContext:ctx pathModel:model];
                return;
            } else {
                startIndex = 1;
                endIndex = count - 3;

                for (NSInteger i = startIndex; i < endIndex; i++) {
                    CGPoint fromPoint = [model.points[i] CGPointValue];
                    CGPoint point = fromPoint;

                    CGPoint toPoint = [model.points[i + 1] CGPointValue];
                    CGFloat dx = toPoint.x - fromPoint.x;
                    CGFloat dy = toPoint.y - fromPoint.y;
                    CGFloat len = sqrtf((dx*dx)+(dy*dy));
                    CGFloat ix = dx/len;
                    CGFloat iy = dy/len;
                    NSInteger ilen = (NSInteger) len;

                    for (int i = 0; i <= ilen; i++) {
                        [self drawRadialGradientWithPoint:point InContext:ctx pathModel:model];
                        point.x += ix;
                        point.y += iy;
                    }
                }
            }
        }
    }
}







@end

