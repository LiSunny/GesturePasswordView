//
//  GestureView.m
//  GestureDemo
//
//  Created by HeavenLi on 16/7/29.
//  Copyright © 2016年 HeavenLi. All rights reserved.
//

#import "GestureView.h"
#import "GestureButton.h"


#define SCREENWIDTH     [UIApplication sharedApplication].keyWindow.bounds.size.width
#define SCREENHIGHT      [UIApplication sharedApplication].keyWindow.bounds.size.hight
#define LineColor                 0.96,0.36,0.33,1.0


@interface GestureView ()
{
    
    CGPoint lineEndPoint;
    NSInteger inputCount;
    BOOL isFirst;
    NSMutableDictionary * resultDic;

}

@property (nonatomic,strong) NSMutableArray * btnArr;
@property (nonatomic,strong) NSMutableArray * selectBtnArr;
@property (nonatomic,strong) NSMutableArray * selectlineArr;
@property (nonatomic,strong) NSMutableArray * passwordArr;
@property (nonatomic,strong) NSMutableArray * verifyPasswordArr;

@end


@implementation GestureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        isFirst = YES;
        inputCount = 0;
        _btnArr = [NSMutableArray array];
        _selectBtnArr = [NSMutableArray array];
        _selectlineArr = [NSMutableArray array];
        _passwordArr = [NSMutableArray array];
        _verifyPasswordArr = [NSMutableArray array];
        resultDic = [NSMutableDictionary dictionary];
        
        [self configerGestureView];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

    //首先判断线段数字是否为空
    for (int i = 0; i < self.selectlineArr.count; i++) {
        
         CGContextRef context = UIGraphicsGetCurrentContext();
        //如果是最后一个元素
        if (i == self.selectlineArr.count - 1) {
            CGContextMoveToPoint(context, [[[self.selectlineArr lastObject] objectForKey:@"centerX"] floatValue], [[[self.selectlineArr lastObject] objectForKey:@"centerY"] floatValue]);
            CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
        }else{
            
            CGContextMoveToPoint(context, [[[self.selectlineArr objectAtIndex:i] objectForKey:@"centerX"] floatValue], [[[self.selectlineArr objectAtIndex:i] objectForKey:@"centerY"] floatValue]);
            CGContextAddLineToPoint(context,[[[self.selectlineArr objectAtIndex:i + 1] objectForKey:@"centerX"] floatValue], [[[self.selectlineArr objectAtIndex:i + 1] objectForKey:@"centerY"] floatValue]);
        }
        
        CGContextSetLineWidth(context, 2);
        CGContextSetRGBStrokeColor(context,LineColor);
        
        CGContextStrokePath(context);
    }

}
- (void)configerGestureView
{
    //300 * 300
    for (int i = 0; i < 9; i++) {
        
        GestureButton * btn = [[GestureButton alloc] initWithFrame:CGRectMake(30 + i%3 *(30 + 60), 30 + i/3*(30 + 60), 60, 60)];
        
        btn.tag = 10086 + i;
        
        [self addSubview:btn];
        
        [self.btnArr addObject:btn];
        
    }

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch * touch = touches.allObjects[0];
    
    CGPoint startPoint = [touch locationInView:self];
    
    for (int i = 0; i < self.btnArr.count; i ++) {
        
        GestureButton * btn = ((GestureButton *) [self.btnArr objectAtIndex:i]);

        if (CGRectContainsPoint(btn.frame, startPoint)) {
            
            btn.isSellect = YES;
            [btn setNeedsDisplay];
            
            //记录密码
            if (!isFirst) {
                [self.verifyPasswordArr addObject:[NSNumber numberWithInteger:btn.tag]];
            }else{
                [self.passwordArr addObject:[NSNumber numberWithInteger:btn.tag]];
            }
            
            
            //按钮数组
            [self.selectBtnArr  addObject:btn];
            
            //连线数组
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:btn.center.x],@"centerX",[NSNumber numberWithFloat:btn.center.y],@"centerY", nil];
            
            [self.selectlineArr addObject:dic];

        }
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch * touch = touches.allObjects[0];
    
    CGPoint startPoint = [touch locationInView:self];
    
    for (int i = 0; i < self.btnArr.count; i ++) {
        
        GestureButton * btn = ((GestureButton *) [self.btnArr objectAtIndex:i]);
        
        if (CGRectContainsPoint(btn.frame, startPoint)) {
           
            if ([self.selectBtnArr containsObject:btn]) {
    
            
            }else{
    
                NSLog(@"%ld",(long)btn.tag);
                //当前选中的按钮
                btn.isSellect = YES;
                [btn setNeedsDisplay];
                
                //记录密码
                if (!isFirst) {
                    [self.verifyPasswordArr addObject:[NSNumber numberWithInteger:btn.tag]];
                }else{
                    [self.passwordArr addObject:[NSNumber numberWithInteger:btn.tag]];
                }
                
                //按钮数组
                [self.selectBtnArr  addObject:btn];
                
                //线段数组
                NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:btn.center.x],@"centerX",[NSNumber numberWithFloat:btn.center.y],@"centerY", nil];
                [self.selectlineArr addObject:dic];
                
                if (self.isSingleNode) {
                    //单节点开关
                    [self updateGestureBtnState];

                }
                
            }
        }else{
            lineEndPoint = startPoint;
        }
    }
    
    [self setNeedsDisplay];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //可以在这里添加 输入完成后密码样式
    [self performSelector:@selector(dismissGesture) withObject:nil afterDelay:0.5];

}
- (void)updateGestureBtnState
{
    //按钮状态
    if (self.selectBtnArr.count > 2 && self.selectBtnArr.count != 0) {
        
        for (int i = 0; i < self.selectBtnArr.count - 2; i ++) {
            //选中数组中的 2个之前的按钮
            GestureButton * btn = ((GestureButton *) [self.selectBtnArr objectAtIndex:i]);
            btn.isSellect = NO;
            [btn setNeedsDisplay];
            
        }
    }
    //横线
    if (self.selectlineArr.count > 2 && self.selectlineArr.count != 0) {
        
        for (int i = 0; i < self.selectlineArr.count - 2; i ++) {
            //当前节点之前的节点连心
            [self.selectlineArr removeObjectAtIndex:i];
            [self setNeedsDisplay];
        }
    }
    
}
- (void)dismissGesture
{
    
    //按钮状态置为默认
    for (int i = 0; i < self.selectBtnArr.count; i ++) {
        
        GestureButton * btn = [self.selectBtnArr objectAtIndex:i];
        btn.isSellect = NO;
        btn.success = NO;
        [btn setNeedsDisplay];
        
    }

    [self.selectlineArr removeAllObjects];
    [self.selectBtnArr removeAllObjects];
    
    //清除连线
    [self setNeedsDisplay];
    
    //验证
    if (self.isVerify) {
        //纪录输入次数
        inputCount ++;
        
        if (inputCount == 2) {
            
            NSLog(@"verifyArr%@",self.verifyPasswordArr);
            
            if ([self.passwordArr isEqual:self.verifyPasswordArr]) {
                NSLog(@"相同");
                
                [[NSUserDefaults standardUserDefaults] setObject:self.verifyPasswordArr forKey:@"password"];
                
                //存储密码
                [resultDic setObject:[NSNumber numberWithInteger:0000] forKey:@"resCode"];
                [resultDic setObject:@"成功" forKey:@"message"];
                
               
        
            }else{
                NSLog(@"不同");
                //返回提示信息
                [resultDic setObject:[NSNumber numberWithInteger:0001] forKey:@"resCode"];
                [resultDic setObject:@"两次密码不一致" forKey:@"message"];
                
                
            }

            isFirst = YES;
            inputCount = 0;
            //清空数据
            [self.passwordArr removeAllObjects];
            [self.verifyPasswordArr removeAllObjects];

            [self.delegate gestureResult:resultDic];
            
        }else{
            NSLog(@"%@",self.passwordArr);
            isFirst = NO;
        }
        
    }else{
        
         NSLog(@"登录－－－%@",self.passwordArr);
        //取出存储数据 与 输入的数据作对比
        NSMutableArray * passWordArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        
        if ([passWordArr isEqual:self.passwordArr]) {
            [resultDic setObject:[NSNumber numberWithInteger:0000] forKey:@"resCode"];
            [resultDic setObject:@"成功" forKey:@"message"];
            
        }else{
            
            [resultDic setObject:[NSNumber numberWithInteger:0002] forKey:@"resCode"];
            [resultDic setObject:@"密码错误" forKey:@"message"];
        }
        //清空数据
        [self.passwordArr removeAllObjects];
        [self.delegate gestureResult:resultDic];
    }

}




@end
