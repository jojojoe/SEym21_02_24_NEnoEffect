//
//  UIView+Frame.m
//  ImageSizer3
//
//  Created by sunhaosheng on 7/28/16.
//  Copyright © 2016 GPower. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView(Frame)

- (CGFloat)x {
    return CGRectGetMinX(self.frame);
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x,self.y , self.width, self.height);
}

- (CGFloat)y {
    return CGRectGetMinY(self.frame);
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x,y, self.width, self.height);
}

- (CGFloat)width {
    return CGRectGetWidth(self.bounds);
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x,self.y , width, self.height);
}

- (CGFloat)height {
    return CGRectGetHeight(self.bounds);
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x,self.y , self.width, height);
}

- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterX:(CGFloat)x {
    self.center = CGPointMake(x, self.centerY);
}

- (CGFloat)centerY {
    return self.center.y;
}
- (void)setCenterY:(CGFloat)y {
    self.center = CGPointMake(self.centerX, y);
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

@end
