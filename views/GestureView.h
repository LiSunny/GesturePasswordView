//
//  GestureView.h
//  GestureDemo
//
//  Created by HeavenLi on 16/7/29.
//  Copyright © 2016年 HeavenLi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GestureViewDelegate <NSObject>

/**
 *  回调代理方法
 *  {resCode:0000,message:"验证成功"}
 *  resCode 0000 -- 成功
 *                 0001 -- 两次密码不一致
 *                 0002 -- 密码错误
 */
- (void)gestureResult:(NSMutableDictionary *)resultDic;

@end



@interface GestureView : UIView

@property (nonatomic,weak) id <GestureViewDelegate> delegate;

//单节点开关
@property (nonatomic,assign) BOOL isSingleNode;
//空间调用情景 设置密码 or 验证密码
@property (nonatomic,assign) BOOL isVerify;
//重新验证
@property (nonatomic,assign) BOOL isRepart;





@end
