//
//  TouchStuffView.m
//  CharkText
//
//  Created by david on 12-12-7.
//  Copyright (c) 2012年 G-Power. All rights reserved.
//

#import "TouchStuffView.h"
#import "TouchStuffViewPrivate.h"


const NSTimeInterval doubleTapCheckThreshold = 0.13f;
const CGFloat AutoAlignThreshold = 8;
const CGFloat RotateThreshold = 0.08;

@interface TouchStuffView ()

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSInteger tapCount;
@property (nonatomic, assign) BOOL viewMoved;
@property (nonatomic, assign) CGPoint previousLocation;
@property (nonatomic, assign) NSTimeInterval tapIntervalTime;
- (void)viewDidTouchUp;

@end

@implementation TouchStuffView
- (float)originalScale
{
    return 1.f;
}

- (void)resetTransform:(CGAffineTransform)transform {
    originalTransform = transform;
    _touchTransform = transform;
    [self updateBtnOppositTransform];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self == nil) {
        return nil;
    }
    
    float originalScale = [self originalScale];
    originalTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0f/originalScale,1.0f/originalScale), CGAffineTransformIdentity);
    self.transform = CGAffineTransformConcat(originalTransform, CGAffineTransformIdentity);
    touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.exclusiveTouch = YES;
//    NSString *name;
//    name.capitalizedString
    self.startTime = 0;
    self.tapIntervalTime = 0;
    self.viewMoved = NO;
    self.hasMasked = NO;
    _isEditing = YES;
    
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setTransform:(CGAffineTransform)transform {
    [super setTransform:transform];
#ifdef Template
    CGFloat rotation = atan2(transform.b, transform.a);
    [PSProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%.2f",rotation / M_PI * 180]];
#endif
}


- (void)rotateButtonPanGestureDetected:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint thePoint = [panGestureRecognizer locationInView:self.superview];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.rotateButton setHighlighted:YES];
        
        [self resetTransform:self.transform];
        self.panBeginPoint = thePoint;
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGAffineTransform incrementalTransform = [self calculateTransformWithCenterAndPoint:thePoint];
        if ([self shouldApplyTransform:incrementalTransform]) {
            self.transform = CGAffineTransformConcat(incrementalTransform, self.touchTransform);
            [self viewAutoFlate];
            [self updateBtnOppositTransform];
            if ([self.delegate respondsToSelector:@selector(viewTouchMoved:)]) {
                [self.delegate viewTouchMoved:self];
            }
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //        self.panGestureDetected = NO;
        self.rotateButton.highlighted = NO;
        [self resetTransform:self.transform];
        if ([self.delegate respondsToSelector:@selector(viewTouchUp:)]) {
            [self.delegate viewTouchUp:self];
        }
    }
}

- (void)flipHorizontal
{
    originalTransform = CGAffineTransformScale(originalTransform, -1.0, 1.0);
    self.transform = CGAffineTransformConcat(originalTransform, CGAffineTransformIdentity);
}
- (void)flipVertical
{
    originalTransform = CGAffineTransformScale(originalTransform, 1.0, -1.0);
    self.transform = CGAffineTransformConcat(originalTransform, CGAffineTransformIdentity);
}

- (void)setupOriginalTransform:(CGFloat)rotoate
{
    originalTransform = CGAffineTransformConcat(originalTransform,CGAffineTransformMakeRotation(rotoate));
    self.transform = CGAffineTransformConcat(originalTransform, CGAffineTransformIdentity);
    
    /*
     CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:touches];
     self.transform = CGAffineTransformConcat(originalTransform, incrementalTransform);
     originalTransform = self.transform;
     
     CGAffineTransform CGAffineTransformMakeRotation(CGFloat angle);
     */
}

- (CGAffineTransform)viewTransform
{
    return originalTransform;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableSet *currentTouches = [[event touchesForView:self] mutableCopy];
    [currentTouches minusSet:touches];
    if ([touches count] == 1) {
        self.previousLocation = [[touches anyObject] locationInView:self.superview];
    }
    if ([currentTouches count] > 0) {
        //        [self updateOriginalTransformForTouches:currentTouches];
        [self cacheBeginPointForTouches:currentTouches];
    }
    [self cacheBeginPointForTouches:touches];
    //    [self.superview bringSubviewToFront:self];
    if ([self.delegate respondsToSelector:@selector(viewTouchDown:)]) {
        [self.delegate viewTouchDown:self];
    }
    self.tapCount = self.tapCount + 1;
    
    //    [self.delegate viewTouchDown:self];
    self.tapIntervalTime = event.timestamp;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isEditing) {
        return;
    }
    CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:[event touchesForView:self]];
    if ([self shouldApplyTransform:incrementalTransform]) {
        CGAffineTransform transform = CGAffineTransformConcat(originalTransform, incrementalTransform);
        if (transform.tx >= -AutoAlignThreshold && transform.tx <= AutoAlignThreshold) {
            transform.tx = 0;
        }
        if (transform.ty >= -AutoAlignThreshold && transform.ty <= AutoAlignThreshold) {
            transform.ty = 0;
        }
        self.transform = transform;
        
        CGFloat rotationSin = sin(self.rotation);
        if (rotationSin == 0 || fabs(rotationSin) == 1) {
            if (fabs(self.y) <= AutoAlignThreshold) {
                transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(0, -self.y));
            } else if (fabs(self.maxY - self.superview.height) <= AutoAlignThreshold) {
                transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(0, -(self.maxY - self.superview.height)));
            }
            if (fabs(self.x) <= AutoAlignThreshold) {
                transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(-self.x, 0));
            } else if (fabs(self.maxX - self.superview.width) <= AutoAlignThreshold) {
                transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(-(self.maxX - self.superview.width), 0));
            }
            self.transform = transform;
        } else  {
            [self viewAutoFlate];
        }
        UITouch * touch = [touches anyObject];
//        CGPoint currentPoint = [touch locationInView:self.superview];
//        CGFloat moveThreshold = 3;
//        if (fabs(currentPoint.x - self.previousLocation.x) > moveThreshold
//            || fabs(currentPoint.y - self.previousLocation.y) > moveThreshold) {
//            if ([self.delegate respondsToSelector:@selector(viewTouchMoved:)]) {
//                [self.delegate viewTouchMoved:self];
//            }
//        }
        if ([self.delegate respondsToSelector:@selector(viewTouchMoved:)]) {
            [self.delegate viewTouchMoved:self];
        }
        [self updateBtnOppositTransform];
    }
}

- (void)clearTapCount {
    self.tapCount = 0;
}

- (void)viewDidTouchUp {
    self.tapCount = 0;
    if ([self.delegate respondsToSelector:@selector(viewSingleClick:)]) {
        [self.delegate viewSingleClick:self];
    }
    
    //    [self.delegate viewTouchUp:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        CGPoint currentLocation = [[touches anyObject] locationInView:self.superview];
        CGFloat moveThreshold = 5;
        if (fabs(currentLocation.x - self.previousLocation.x) > moveThreshold
            || fabs(currentLocation.y - self.previousLocation.y) > moveThreshold)  {
            self.viewMoved = YES;
        }
        
        if (!self.viewMoved) {
            //            PTLog(@"if (!self.viewMoved)");
            //first tap
            if (self.tapCount == 1) {
                //                self.tapCount = 1;
                self.startTime = event.timestamp;
                UITouch *touch = [touches anyObject];
                CGPoint locationPoint = [touch locationInView:self];
                CGRect contentRect = CGRectInset(self.bounds, 0, 0);
                [self performSelector:@selector(clearTapCount) withObject:self afterDelay:doubleTapCheckThreshold];
                if (CGRectContainsPoint(contentRect, locationPoint)) {
                    [self performSelector:@selector(viewDidTouchUp) withObject:self afterDelay:doubleTapCheckThreshold];
                }
            }
            else {
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                if ((event.timestamp - self.startTime) / 3 < doubleTapCheckThreshold) {
                    if (self.tapCount >= 0) {
                        self.tapCount = 0;

                        UITouch *touch = [touches anyObject];
                        CGPoint locationPoint = [touch locationInView:self];
                        CGRect contentRect = CGRectInset(self.bounds, 0, 0);
                        if (CGRectContainsPoint(contentRect, locationPoint)) {
                            if ([self.delegate respondsToSelector:@selector(viewDoubleClick:)]) {
                                [self.delegate viewDoubleClick:self];
                            }
                        }
                    }
                   
                } else {
                    self.tapCount = 0;
                }
                self.startTime = event.timestamp;
            }
            if ([self.delegate respondsToSelector:@selector(viewTouchUp:)]) {
                [self.delegate viewTouchUp:self];
            }
        }
        else {
            
//            if ([self.delegate respondsToSelector:@selector(viewTouchUp:)]) {
//                [self.delegate viewTouchUp:self];
//            }
        }
    }
    
    self.viewMoved = NO;
    
    if (event.timestamp - self.tapIntervalTime > 0.08 && self.isEditing) {
        [self updateOriginalTransformForTouches:[event touchesForView:self]];
        [self removeTouchesFromCache:touches];
    }
    
    
    NSMutableSet *remainingTouches = [[event touchesForView:self] mutableCopy] ;
    [remainingTouches minusSet:touches];
    [self cacheBeginPointForTouches:remainingTouches];
    
    if ([self.delegate respondsToSelector:@selector(viewTouchEnd:)]) {
        [self.delegate viewTouchEnd:self];
    }
}

- (void)viewAutoFlate {
    CGFloat rotation = atan2(self.transform.b, self.transform.a);
    CGFloat rotationSin = sin(rotation);
    CGFloat rotationTan = tan(rotation);
    if (-RotateThreshold < rotationSin && rotationSin < RotateThreshold) {
        if (rotation < 1 && rotation > -1) {
            // 0
            self.transform = CGAffineTransformRotate(self.transform, -rotation);
            self.rotation = 0;
        } else {
            // M_PI
            self.transform = CGAffineTransformRotate(self.transform, M_PI - rotation);
            self.rotation = M_PI;
        }
    } else if (-1-RotateThreshold < rotationSin && rotationSin < -1+RotateThreshold) {
        self.transform = CGAffineTransformRotate(self.transform, M_PI_2 + M_PI - rotation);
        self.rotation = M_PI_2+M_PI;
    } else if (1-RotateThreshold < rotationSin && rotationSin < 1+RotateThreshold) {
        self.transform = CGAffineTransformRotate(self.transform, M_PI_2 - rotation);
        self.rotation = M_PI_2;
    } else if (1-RotateThreshold < rotationTan && rotationTan < 1+RotateThreshold) {
        self.transform = CGAffineTransformRotate(self.transform, M_PI_4 - rotation);
        self.rotation = M_PI_4;
    } else if (-1-RotateThreshold < rotationTan && rotationTan < -1+RotateThreshold) {
        self.transform = CGAffineTransformRotate(self.transform, -M_PI_4 - rotation);
        self.rotation = -M_PI_4;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}
//- (void)dealloc
//{
//    CFRelease(touchBeginPoints);
//    [super dealloc];
//}
- (void)setHilight:(BOOL)flag
{
    self.isHilightStatus = flag;
}

- (void)updateBtnOppositTransform {
    
}

@end

