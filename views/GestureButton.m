//
//  GestureButton.m
//  GestureDemo
//
//  Created by HeavenLi on 16/7/29.
//  Copyright © 2016年 HeavenLi. All rights reserved.
//

#import "GestureButton.h"

//圈内小圆的半径
#define smallRadiu      self.frame.size.width/10.0

//默认圆圈眼神(4个值分别是 R G B A, 可自行用取色器获取)
#define defaultArcColor                1,1,1,1.0

//选中圆圈外圈线条颜色
#define selectArcColor                 0.96,0.36,0.33,1.0
//选中内部圆圈颜色
#define selectSmallArcColor        0.96,0.36,0.33,1.0

//校验成功圆圈外圈线条颜色
#define successArcColor             0.25,0.81,0.29,1.0
//校验成功内部圆圈颜色
#define successSmallArcColor    0.25,0.81,0.29,1.0

@implementation GestureButton


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.isSellect = NO;
        self.success = NO;
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGFloat width = rect.size.width;
    CGFloat hight = rect.size.height;
    
    CGFloat centerX = width/2.;
    CGFloat centerY = hight/2.;
    
    CGFloat radius = width/2. - 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, 2.0);//线的宽度
    
    if (self.isSellect) {
        
        if (self.success) {
            
            CGContextSetRGBStrokeColor(context,successArcColor);//画笔线的颜色
    
            CGContextSetRGBFillColor(context,successSmallArcColor);//圈内小圆颜色
        
        }else{
            
            CGContextSetRGBStrokeColor(context,selectArcColor);//画笔线的颜色
    
            CGContextSetRGBFillColor(context, selectSmallArcColor);//圈内小圆颜色
    
        }
        
        CGContextAddArc(context, centerX, centerY, smallRadiu, 0, M_PI * 2, 1);//圈内小圆
        
        CGContextFillPath(context);//绘制路径
        
    }else{
        
        CGContextSetRGBStrokeColor(context,defaultArcColor);//画笔线的颜色
        
    }
    
    CGContextAddArc(context, centerX, centerY, radius, 0, M_PI * 2, 1);
    
    CGContextStrokePath(context);
    
    
}


@end
