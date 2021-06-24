//
//  MaskConfigManager.h
//  BMBlurMask
//
//  Created by JOJO on 2019/5/23.
//  Copyright © 2019 JOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, LineWidth) {
    width1 = 10,
    width2 = 20,
    width3 = 30,
    width4 = 40,
    width5 = 50,
};

#define GradientMid 1
#define GradientMax 0.4


typedef NS_ENUM(NSUInteger, StrokeType) {
    StrokeTypeNormal = 1,
    StrokeTypeGradient,
    StrokeTypeCustomPath,
};

typedef NS_ENUM(NSUInteger, BlendMode) {
    BlendModeStroke = 1,
    BlendModeClear,
};

NS_ASSUME_NONNULL_BEGIN

@interface MaskConfigManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,assign) BlendMode blendMode;

@property (nonatomic,assign) CGFloat lineWidth; //default 10

@property (nonatomic,assign) StrokeType strokeType;

@property (nonatomic,assign) CGFloat gradientRate;



// add girls camera
// 线条颜色 填充色 描边色
//@property (nonatomic, strong) UIColor *lineFillColor;
//@property (nonatomic, strong) UIColor *lineStrokeColor;
//// 渐变色 起始颜色 结束颜色
//@property (nonatomic, strong) UIColor *gradualColorOne;
//@property (nonatomic, strong) UIColor *gradualColorTwo;
// 是否是虚线

//线条颜色 填充色1 描边色2  //渐变色 起始颜色1 结束颜色2
@property (nonatomic, strong) UIColor *lineColorOne;
@property (nonatomic, strong) UIColor *lineColorTwo;



@property (nonatomic, assign) BOOL isDashLine;


@end

NS_ASSUME_NONNULL_END
