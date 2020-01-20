//
//  SportLineView.m
//  BrainWaveDraw
//
//  Created by 吴伟 on 2020/1/14.
//  Copyright © 2020 吴伟. All rights reserved.
//

#import "SportLineView.h"

static CGRect myFrame;
static int count; //点个数，x轴格子数
static int yCount;//y轴格子数
static CGFloat everyX;//x轴每个格子的宽度
static CGFloat everyY;//y轴每个格子的高度
static CGFloat maxY;//最大的y值
static CGFloat allH;//整个图标的高度
static CGFloat allW;//整个图标的宽度
#define kMargin 30//标签的长度
@interface SportLineView()
@property(weak,nonatomic)IBOutlet UIView *bgView;
@property(strong,nonatomic)NSMutableArray *xLabels;
@end
@implementation SportLineView
+ (instancetype)lineChartViewWithFrame:(CGRect)frame{
    SportLineView *lineChartView=[[NSBundle mainBundle] loadNibNamed:@"SportLineView" owner:self options:nil].lastObject;
    if(lineChartView==nil) NSLog(@"no");
    lineChartView.frame=frame;
    myFrame=frame;
    return lineChartView;
}
#pragma mark - 计算
-(void)doWithCaculate{
    if(!self.xValues||!self.yValues||!self.xValues.count||!self.yValues.count){
        return;
    }
    if(self.xValues.count>self.yValues.count){
        NSMutableArray *xArr=[self.xValues mutableCopy];
        for(int i=0;i<_xValues.count-_yValues.count;i++){
            [xArr removeLastObject];
        }
        self.xValues=[xArr mutableCopy];
    }
    if(self.xValues.count<self.yValues.count){
        NSMutableArray *yArr=[_yValues mutableCopy];
        for(int i=0;i<_yValues.count-_xValues.count;i++){
            [yArr removeLastObject];
        }
        self.yValues=[yArr mutableCopy];
    }
    count=(int)_xValues.count;
    everyX=(CGFloat)(CGRectGetWidth(myFrame)-2*kMargin)/count;
    yCount=count<=10?count:10;
    everyY=(CGFloat)(CGRectGetHeight(myFrame)-2*kMargin)/yCount;
    maxY=CGFLOAT_MIN;
    for(int i=0;i<count;i++){
        if([self.yValues[i] floatValue]>maxY){maxY=[self.yValues[i] floatValue];}
    }
    allH=CGRectGetHeight(myFrame)-2*kMargin;
    allW=CGRectGetWidth(myFrame)-2*kMargin;
}
#pragma mark - 画x,y轴
-(void) drawXYLine{
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(kMargin,kMargin/2.0-5)];
    //x轴
    [path addLineToPoint:CGPointMake(kMargin, CGRectGetHeight(myFrame)-kMargin)];
    //y轴
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-kMargin/2.0+5, CGRectGetHeight(myFrame)-kMargin)];
    //x轴箭头
    [path moveToPoint:CGPointMake(kMargin-5, kMargin/2.0+4)];
    [path addLineToPoint:CGPointMake(kMargin, kMargin/2.0-4)];
    [path addLineToPoint:CGPointMake(kMargin+5, kMargin/2.0+4)];
    //y轴箭头
    [path moveToPoint:CGPointMake(CGRectGetWidth(myFrame)-kMargin/2.0-4, CGRectGetHeight(myFrame)-kMargin-5)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-kMargin/2.0+5, CGRectGetHeight(myFrame)-kMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-kMargin/2.0-4, CGRectGetHeight(myFrame)-kMargin+5)];
    CAShapeLayer *layer=[[CAShapeLayer alloc] init];
    layer.path=path.CGPath;
    layer.strokeColor=[UIColor brownColor].CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.lineWidth=2.0;
    [self.layer addSublayer:layer];
}
#pragma mark - 添加label
-(void) drawLabels{
    //y轴
    for(int i=0;i<=yCount;i++){
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(0, kMargin+everyY*i-everyY/2, kMargin-1, everyY)];
        lbl.textColor=[UIColor blackColor];
        lbl.font=[UIFont systemFontOfSize:10];
        lbl.textAlignment=NSTextAlignmentRight;
        lbl.text=[NSString stringWithFormat:@"%d",(int)(maxY/yCount*(yCount-i))];
        [self addSubview:lbl];
    }
    //x轴
    for(int i=1;i<=count;i++){
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(kMargin+everyX*i-everyX/2, CGRectGetHeight(myFrame)-kMargin, everyX, kMargin)];
        lbl.textColor=[UIColor blackColor];
        lbl.font=[UIFont systemFontOfSize:12];
        lbl.textAlignment=NSTextAlignmentCenter;
        [self.xLabels addObject:lbl];
        NSValue *pointObj=[self.AllLinePointsArray[0] lastObject];
        CGPoint pointRestored=[pointObj CGPointValue];
        CGFloat maxX=pointRestored.x;
        int maxValueX=(int)maxX;
        CGFloat xFloat=maxX-maxValueX;
        //如果最后一个点有小数部分，就将坐标轴最后一个值加一
        if(xFloat>0) maxValueX++;
        if(maxValueX<=count)
            lbl.text=[NSString stringWithFormat:@"%@",self.xValues[i-1]];
        else
            lbl.text=[NSString stringWithFormat:@"%d",maxValueX-count+i];
        [self addSubview:lbl];
    }
}
#pragma mark - 画网格
-(void) drawLines{
    UIBezierPath *path=[UIBezierPath bezierPath];
    //横线
    for(int i=0;i<yCount;i++){
        [path moveToPoint:CGPointMake(kMargin, kMargin+everyY*i)];
        [path addLineToPoint:CGPointMake(kMargin+allW, kMargin+everyY*i)];
    }
    //竖线
    for (int i=1; i<=count; i++) {
        [path moveToPoint:CGPointMake(kMargin+everyX*i, kMargin)];
        [path addLineToPoint:CGPointMake(kMargin+everyX*i, kMargin+allH)];
    }
    CAShapeLayer *layer=[[CAShapeLayer alloc] init];
    layer.path=path.CGPath;
    layer.strokeColor=[UIColor lightGrayColor].CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.lineWidth=0.5;
    [self.layer addSublayer:layer];
}
#pragma mark - 画折线
-(void) drawFoldLineWithLineChart{
    int index=0;
    for(NSMutableArray *pointArray in self.AllLinePointsArray){
    UIBezierPath *path=[UIBezierPath bezierPath];
    NSValue *pointObj=[pointArray firstObject];
    CGPoint pointRestored=[pointObj CGPointValue];
    CGFloat xPoint=pointRestored.x;
    CGFloat yPoint=pointRestored.y;
    int maxValueX=count;
    if(xPoint <=0){
        //原点
        [path moveToPoint:CGPointMake(kMargin, kMargin+allH)];
    }else
    {
        NSValue *MaxPointObj=[pointArray lastObject];
        CGPoint MaxPointRestored=[MaxPointObj CGPointValue];
        CGFloat maxX=MaxPointRestored.x;
        maxValueX=(int)maxX;
        CGFloat xfloat=maxX-maxValueX;
        if(xfloat>0) maxValueX++;
        if(maxValueX<=count){
            [path moveToPoint:CGPointMake(kMargin+xPoint*allW/count, kMargin+(1-yPoint/maxY)*allH)];
        }else{
            for(int i=1;i<pointArray.count;i++){
                NSValue *pointObj=pointArray[i];
                CGPoint pointRestored=[pointObj CGPointValue];
                if(pointRestored.x>=(maxValueX-count)){
                    [path moveToPoint:CGPointMake(kMargin+(pointRestored.x-(maxValueX-count))*allW/count, kMargin+(1-pointRestored.y/maxY)*allH)];
                    i=(int)(pointArray.count+1);
                }
            }
        }
        
    }
    for(int i=0;i<pointArray.count;i++){
        NSValue *pointObj=pointArray[i];
        CGPoint pointRestored=[pointObj CGPointValue];
        if(maxValueX<=count){
            [path addLineToPoint:CGPointMake(kMargin+pointRestored.x*allW/count, kMargin+(1-pointRestored.y/maxY)*allH)];
        }else{
            if(pointRestored.x>=(maxValueX-count)){
                [path addLineToPoint:CGPointMake(kMargin+(pointRestored.x-(maxValueX-count))*allW/count, kMargin+(1-pointRestored.y/maxY)*allH)];
            }
        }
    }
    if(pointArray.count==0){
        [path addLineToPoint:CGPointMake(kMargin, kMargin+allH)];
    }
    CAShapeLayer *layer=[[CAShapeLayer alloc] init];
    layer.path=path.CGPath;
    layer.strokeColor=self.colorOfLines[index].CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
   /* CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue=@(0);
    animation.toValue=@(1);
    animation.duration=0.5;
    [layer addAnimation:animation forKey:nil];
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion=NO;*/ //动画效果，在高刷新下不需要
    [self.bgView.layer addSublayer:layer];
        index++;
    }
}
#pragma mark - 画封闭图形
-(void)drawClosedQuadrilateralChartWithArray:(NSArray *)points{
    UIBezierPath *path=[UIBezierPath bezierPath];
    for(int i=0;i<points.count;i++){
        NSValue *pointObj=points[i];
        CGPoint pointRestored=[pointObj CGPointValue];
        if(i==0){
            [path moveToPoint:CGPointMake(kMargin+pointRestored.x*allW/count, kMargin+(1-pointRestored.y/maxY)*allH)];
        }else{
            [path addLineToPoint:CGPointMake(kMargin+pointRestored.x*allW/count, kMargin+(1-pointRestored.y/maxY)*allH)];
        }
            
    }
    [path closePath];
    CAShapeLayer *layer=[[CAShapeLayer alloc] init];
    layer.path=path.CGPath;
    layer.strokeColor=[UIColor lightGrayColor].CGColor;
    layer.fillColor=[UIColor blueColor].CGColor;
    [self.layer addSublayer:layer];
}
#pragma mark - 更新折线图，x轴坐标
-(void)exchangeLineAnyTime{
     
    [self doWithCaculate];
    NSArray *layers=[self.bgView.layer.sublayers mutableCopy];
    //NSLog(@"num is %d",self.bgView.layer.sublayers.count);
    for(CAShapeLayer *layer in layers){
        [layer removeFromSuperlayer];
       
    }
    [self drawFoldLineWithLineChart];
    [self exchangeXlabels];
}
-(void) exchangeXlabels{
    NSValue *pointObj=[self.AllLinePointsArray[0] lastObject];
    CGPoint pointRestored=[pointObj CGPointValue];
    CGFloat maxX=pointRestored.x;
    int maxValueX=(int)maxX;
    CGFloat xFloat=maxX-maxValueX;
    if(xFloat>0) maxValueX++;
    if(maxValueX>count){
        for(int i=0;i<self.xLabels.count;i++){
            UILabel *label=self.xLabels[i];
            label.text=[NSString stringWithFormat:@"%d",maxValueX-count+i+1];
        }
    }
}
#pragma mark - 整合，画图表
-(void)drawChartWithLineChart{
    [self doWithCaculate];
    if(self.isShowLine){
        [self drawLines];
    }
    [self drawXYLine];
    [self drawLabels];
   /* if(self.type==QuadrilateralType){
        NSMutableArray *points=[NSMutableArray array];
        CGPoint point1=CGPointMake(1.5, 0);
        NSValue *pointObj1=[NSValue valueWithCGPoint:point1];
        [points addObject:pointObj1];
        
        CGPoint point2=CGPointMake(2,45);
        NSValue *pointObj2=[NSValue valueWithCGPoint:point2];
        [points addObject:pointObj2];
        
        CGPoint point3=CGPointMake(8, 45);
        NSValue *pointObj3=[NSValue valueWithCGPoint:point3];
        [points addObject:pointObj3];
        
        CGPoint point4=CGPointMake(8.5, 0);
        NSValue *pointObj4=[NSValue valueWithCGPoint:point4];
        [points addObject:pointObj4];
        [self drawClosedQuadrilateralChartWithArray:points];
    }else if(self.type==TriangleType){
        for(int i=0;i<5;i++){
            NSMutableArray *points=[NSMutableArray array];
                   CGPoint point1=CGPointMake(2*(i+1), 0);
                   NSValue *pointObj1=[NSValue valueWithCGPoint:point1];
                   [points addObject:pointObj1];
                   
                   CGPoint point2=CGPointMake(2*(i+1)+0.5,100);
                   NSValue *pointObj2=[NSValue valueWithCGPoint:point2];
                   [points addObject:pointObj2];
                   
                   CGPoint point3=CGPointMake(2*(i+1)+1, 0);
                   NSValue *pointObj3=[NSValue valueWithCGPoint:point3];
                   [points addObject:pointObj3];
                  
                   [self drawClosedQuadrilateralChartWithArray:points];
        }
    }*/
}
#pragma mark - 懒加载
-(NSMutableArray *)AllLinePointsArray{
    if(!_AllLinePointsArray){
        _AllLinePointsArray=[NSMutableArray array];
        for(int i=0;i<(int)self.countOfLines;i++){
            [_AllLinePointsArray addObject:[NSMutableArray array]];
        }
    }
    return _AllLinePointsArray;
}
-(NSMutableArray *)xLabels{
    if(!_xLabels){
        _xLabels=[NSMutableArray array];
    }
    return _xLabels;
}
-(NSMutableArray *)colorOfLines{
    if(!_colorOfLines){
        _colorOfLines=[NSMutableArray array];
    }
    return _colorOfLines;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
