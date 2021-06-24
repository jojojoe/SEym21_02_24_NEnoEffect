//
//  UIView+Frame.h
//  ImageSizer3
//
//  Created by sunhaosheng on 7/28/16.
//  Copyright © 2016 GPower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Frame)

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)x;

- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)y;

- (CGFloat)maxX;
- (CGFloat)maxY;

@end
