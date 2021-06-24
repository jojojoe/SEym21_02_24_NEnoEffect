//
//  TouchStuffViewPrivate.m
//  CharkText
//
//  Created by david on 12-12-7.
//  Copyright (c) 2012年 G-Power. All rights reserved.
//

#import "TouchStuffViewPrivate.h"

#define TOUCH_VIEW_MAX_SCALE 5.0f
#define TOUCH_VIEW_MIN_SCALE (isPad?0.4f:0.3f)

@implementation UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj
{
    if ((__bridge void *)self < (__bridge void *)obj) {
        return NSOrderedAscending;
    } else if ((__bridge void *)self == (__bridge void *)obj) {
        return NSOrderedSame;
    } else {
        return NSOrderedDescending;
    }
}

@end

@implementation TouchStuffView (Private)
#pragma mark -  按钮 缩放时的变化
- (void)touchViewButtonOppositTransform:(UIView *)touchView {
    CGAffineTransform touchTransform = self.transform;
    
//    CGPoint translation = CGPointMake(originalTransform.tx , originalTransform.ty );
    CGFloat rotation = atan2(touchTransform.b, touchTransform.a);
    CGFloat scaleX = sqrt(touchTransform.a * touchTransform.a + touchTransform.c * touchTransform.c);
    CGFloat scaleY = sqrt(touchTransform.b * touchTransform.b + touchTransform.d * touchTransform.d);
    
//    touchView.transform = CGAffineTransformTranslate(touchView.transform, -translation.x, -translation.y);
    touchView.transform = CGAffineTransformMakeScale(1/scaleX, 1/scaleY);
    touchView.transform = CGAffineTransformRotate(touchView.transform , - rotation);
    
}

- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches
{
    NSArray *sortedTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    NSInteger numTouches = [sortedTouches count];
    
    // No touches
    if (numTouches == 0) {
        return CGAffineTransformIdentity;
    }
    
    // Single touch
    if (numTouches == 1) {
        UITouch *touch = [sortedTouches objectAtIndex:0];
         
         CGPoint beginPoint = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch));
         
         CGPoint currentPoint = [touch locationInView:self.superview];
        
         return CGAffineTransformMakeTranslation(currentPoint.x - beginPoint.x, currentPoint.y - beginPoint.y);
    }
    
    // If two or more touches, go with the first two (sorted by address)
    UITouch *touch1 = [sortedTouches objectAtIndex:0];
    UITouch *touch2 = [sortedTouches objectAtIndex:1];
    
    CGPoint beginPoint1 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch1));
    CGPoint currentPoint1 = [touch1 locationInView:self.superview];
    CGPoint beginPoint2 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch2));
    CGPoint currentPoint2 = [touch2 locationInView:self.superview];
    
    double layerX = self.center.x;
    double layerY = self.center.y;
    
    double x1 = beginPoint1.x - layerX;
    double y1 = beginPoint1.y - layerY;
    double x2 = beginPoint2.x - layerX;
    double y2 = beginPoint2.y - layerY;
    double x3 = currentPoint1.x - layerX;
    double y3 = currentPoint1.y - layerY;
    double x4 = currentPoint2.x - layerX;
    double y4 = currentPoint2.y - layerY;
    
    // Solve the system:
    //   [a b t1, -b a t2, 0 0 1] * [x1, y1, 1] = [x3, y3, 1]
    //   [a b t1, -b a t2, 0 0 1] * [x2, y2, 1] = [x4, y4, 1]
    
    double D = (y1-y2)*(y1-y2) + (x1-x2)*(x1-x2);
    if (D < 0.1) {
        return CGAffineTransformMakeTranslation(x3-x1, y3-y1);
    }
    
    double a = (y1-y2)*(y3-y4) + (x1-x2)*(x3-x4);
    double b = (y1-y2)*(x3-x4) - (x1-x2)*(y3-y4);
    double tx = (y1*x2 - x1*y2)*(y4-y3) - (x1*x2 + y1*y2)*(x3+x4) + x3*(y2*y2 + x2*x2) + x4*(y1*y1 + x1*x1);
    double ty = (x1*x2 + y1*y2)*(-y4-y3) + (y1*x2 - x1*y2)*(x3-x4) + y3*(y2*y2 + x2*x2) + y4*(y1*y1 + x1*x1);
    CGAffineTransform calculatedTransform = CGAffineTransformMake(a/D, -b/D, b/D, a/D, tx/D, ty/D);
    [self logTheTransform:calculatedTransform];
    return CGAffineTransformMake(a/D, -b/D, b/D, a/D, tx/D, ty/D);
}
- (void)logTheTransform:(CGAffineTransform) calculatedTransform{
    self.rotation = atan2(calculatedTransform.b, calculatedTransform.a);
}
- (CGAffineTransform)calculateTransformWithCenterAndPoint:(CGPoint)point {
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGPoint beginPoint1 = self.panBeginPoint;
    CGPoint currentPoint1 = point;
    CGPoint beginPoint2 = CGPointMake(self.center.x + self.touchTransform.tx, self.center.y + self.touchTransform.ty);
    CGPoint currentPoint2 = CGPointMake(self.center.x + self.touchTransform.tx, self.center.y + self.touchTransform.ty);
    
    // beginPoint1 = [self convertPoint:beginPoint1 toView:self.superview];
    // currentPoint1 = CGPointApplyAffineTransform(currentPoint1, self.transform);
    // beginPoint2 = CGPointApplyAffineTransform(beginPoint2, self.transform);
    // currentPoint2 = CGPointApplyAffineTransform(currentPoint2, self.transform);
    
    double layerX = self.center.x + self.touchTransform.tx;
    double layerY = self.center.y + self.touchTransform.ty;
    
    double x1 = beginPoint1.x - layerX;
    double y1 = beginPoint1.y - layerY;
    double x2 = beginPoint2.x - layerX;
    double y2 = beginPoint2.y - layerY;
    double x3 = currentPoint1.x - layerX;
    double y3 = currentPoint1.y - layerY;
    double x4 = currentPoint2.x - layerX;
    double y4 = currentPoint2.y - layerY;
    
    // Solve the system:
    // [a b t1, -b a t2, 0 0 1] * [x1, y1, 1] = [x3, y3, 1]
    // [a b t1, -b a t2, 0 0 1] * [x2, y2, 1] = [x4, y4, 1]
    
    double D = (y1-y2)*(y1-y2) + (x1-x2)*(x1-x2);
    if (D < 0.1) {
        return CGAffineTransformMakeTranslation(x3-x1, y3-y1);
    }
    
    double a = (y1-y2)*(y3-y4) + (x1-x2)*(x3-x4);
    double b = (y1-y2)*(x3-x4) - (x1-x2)*(y3-y4);
    // double tx = (y1x2 - x1y2)(y4-y3) - (x1x2 + y1y2)(x3+x4) + x3(y2y2 + x2x2) + x4(y1y1 + x1x1);
    // double ty = (x1x2 + y1y2)(-y4-y3) + (y1x2 - x1y2)(x3-x4) + y3(y2y2 + x2x2) + y4(y1y1 + x1x1);
    
    CGAffineTransform calculatedTransform = CGAffineTransformMake(a/D, -b/D, b/D, a/D, 0, 0);
    [self logTheTransform:calculatedTransform];
    transform = calculatedTransform;
    return transform;
}

- (CGAffineTransform)singleOrientationCalculateTransformWithCenterAndPoint:(CGPoint)point orientation:(NSString *)orientation {
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGPoint beginPoint1 = self.panBeginPoint;
    CGPoint currentPoint1 = point;
    CGPoint beginPoint2 = CGPointMake(self.center.x + self.touchTransform.tx, self.center.y + self.touchTransform.ty);
    CGPoint currentPoint2 = CGPointMake(self.center.x + self.touchTransform.tx, self.center.y + self.touchTransform.ty);
    
    // beginPoint1 = [self convertPoint:beginPoint1 toView:self.superview];
    // currentPoint1 = CGPointApplyAffineTransform(currentPoint1, self.transform);
    // beginPoint2 = CGPointApplyAffineTransform(beginPoint2, self.transform);
    // currentPoint2 = CGPointApplyAffineTransform(currentPoint2, self.transform);
    
    double layerX = self.center.x + self.touchTransform.tx;
    double layerY = self.center.y + self.touchTransform.ty;
    
    double x1 = beginPoint1.x - layerX;
    double y1 = beginPoint1.y - layerY;
    double x2 = beginPoint2.x - layerX;
    double y2 = beginPoint2.y - layerY;
    double x3 = currentPoint1.x - layerX;
    double y3 = currentPoint1.y - layerY;
    double x4 = currentPoint2.x - layerX;
    double y4 = currentPoint2.y - layerY;
    
    // Solve the system:
    // [a b t1, -b a t2, 0 0 1] * [x1, y1, 1] = [x3, y3, 1]
    // [a b t1, -b a t2, 0 0 1] * [x2, y2, 1] = [x4, y4, 1]
    
    double D = (y1-y2)*(y1-y2) + (x1-x2)*(x1-x2);
    if (D < 0.1) {
        return CGAffineTransformMakeTranslation(x3-x1, y3-y1);
    }
    
    double a = (y1-y2)*(y3-y4) + (x1-x2)*(x3-x4);
    double b = (y1-y2)*(x3-x4) - (x1-x2)*(y3-y4);
    // double tx = (y1x2 - x1y2)(y4-y3) - (x1x2 + y1y2)(x3+x4) + x3(y2y2 + x2x2) + x4(y1y1 + x1x1);
    // double ty = (x1x2 + y1y2)(-y4-y3) + (y1x2 - x1y2)(x3-x4) + y3(y2y2 + x2x2) + y4(y1y1 + x1x1);
    CGAffineTransform calculatedTransform;
    if ([orientation isEqualToString:@"hor"]) {
        calculatedTransform = CGAffineTransformMake(a/D, 0, 0, 1, 0, 0);
    } else if ([orientation isEqualToString:@"ver"]) {
        calculatedTransform = CGAffineTransformMake(1, 0, 0, a/D, 0, 0);
    }
    
//    [self logTheTransform:calculatedTransform];
    transform = calculatedTransform;
    return transform;
}

- (void)updateOriginalTransformForTouches:(NSSet *)touches
{
//    if ([touches count] > 0) {
//        CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:touches];
//        if ([self shouldApplyTransform:incrementalTransform]) {
//            self.transform = CGAffineTransformConcat(originalTransform, incrementalTransform);
//            originalTransform = self.transform;
//        } else {
//            originalTransform = self.transform;
//        }
//    }
    originalTransform = self.transform;
}

- (void)cacheBeginPointForTouches:(NSSet *)touches
{
    if ([touches count] > 0) {
        for (UITouch *touch in touches) {
            CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch));
            if (point == NULL) {
                point = (CGPoint *)malloc(sizeof(CGPoint));
                CFDictionarySetValue(touchBeginPoints, (__bridge const void *)(touch), point);
            }
            *point = [touch locationInView:self.superview];
        }
    }
}

- (void)removeTouchesFromCache:(NSSet *)touches
{
    for (UITouch *touch in touches) {
        CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch));
        if (point != NULL) {
            free((void *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch)));
            CFDictionaryRemoveValue(touchBeginPoints, (__bridge const void *)(touch));
        }
    }
}

- (BOOL)shouldApplyTransform:(CGAffineTransform)transform {
    CGFloat originalScaleX = sqrt(originalTransform.a * originalTransform.a + originalTransform.c * originalTransform.c);
    CGFloat originalScaleY = sqrt(originalTransform.b * originalTransform.b + originalTransform.d * originalTransform.d);
    
    CGFloat scaleX = sqrt(transform.a * transform.a + transform.c * transform.c);
    CGFloat scaleY = sqrt(transform.b * transform.b + transform.d * transform.d);
    
    CGFloat finalScaleX = scaleX * originalScaleX;
    CGFloat finalScaleY = scaleY * originalScaleY;
    
    if (finalScaleX > TOUCH_VIEW_MAX_SCALE
        || finalScaleY > TOUCH_VIEW_MAX_SCALE
        || finalScaleX < TOUCH_VIEW_MIN_SCALE
        || finalScaleY < TOUCH_VIEW_MIN_SCALE) {
        return NO;
    }

    CGPoint translation = CGPointMake(transform.tx + originalTransform.tx, transform.ty + originalTransform.ty);
    
    CGRect transformedRect = CGRectApplyAffineTransform(CGRectInset(self.bounds, 20 * finalScaleX, 20 * finalScaleY), CGAffineTransformConcat(originalTransform, transform));
    transformedRect = self.frame;
    CGPoint center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    CGFloat limitationX = transformedRect.size.width * 0.4;
    CGFloat limitationY = transformedRect.size.height * 0.4;
    if (center.x < -limitationX * finalScaleX) {
        return NO;
    }
    if (center.y < -limitationY * finalScaleY) {
        return NO;
    }
    if (center.x > self.superview.bounds.size.width + limitationX * finalScaleX) {
        return NO;
    }
    if (center.y > self.superview.bounds.size.height + (limitationY * finalScaleY)) {
        return NO;
    }

   
    return YES;
}


- (void)storeFinalTransform:(CGAffineTransform)transform {
    originalTransform = transform;
}
@end
