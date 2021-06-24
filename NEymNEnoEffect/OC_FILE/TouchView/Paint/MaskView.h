//
//  MaskView.h
//  DrawDemo
//
//  Created by sunhaosheng on 4/7/16.
//  Copyright © 2016 hs sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchView.h"
#import "MaskConfigManager.h"



@interface MaskView : UIView
/**
 *  路径数组
 */
@property (nonatomic,strong) NSMutableArray<PathModel *> *paths;
@property (nonatomic,strong) NSMutableArray<PathModel *> *paths_Mark;


@property (nonatomic,weak) TouchView *touchView;

/**
 *  重置mask
 */
- (void)clearPath;
/**
 *  根据指定mask的路径 绘制当前mask的路径（大图保存时使用）
 *
 *  @param maskView 指定的mask
 */
- (void)drawMaskWithMaskView:(MaskView *)maskView ;

/**
 *  恢复到上次纪录的mask路径
 */
- (void)restoreTheMarkMask;


- (void)setupCustomShapeImage:(UIImage *)shapeImage;

@property (nonatomic, assign) BOOL isEditingStatus;

- (void)beforeStepAction;
- (void)nextStepAction;

//每次画完一笔后调用
@property (nonatomic,copy) void(^perPaintMoveCompletion)(BOOL canBeforeAction, BOOL canNextAction);

@end
