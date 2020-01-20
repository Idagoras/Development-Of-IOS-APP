//
//  SportLineView.h
//  BrainWaveDraw
//
//  Created by 吴伟 on 2020/1/14.
//  Copyright © 2020 吴伟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,ChartType) {
    QuadrilateralType=1,
    TriangleType=2
};
@interface SportLineView : UIView
@property(nonatomic,copy) NSArray *xValues;
@property(nonatomic,copy) NSArray *yValues;
@property(strong,nonatomic)NSMutableArray *AllLinePointsArray;
@property (nonatomic) NSMutableArray<UIColor *> *colorOfLines;
@property(nonatomic,assign)bool isShowLine;
@property NSInteger *countOfLines;
+(instancetype)lineChartViewWithFrame:(CGRect)frame;
-(void)drawChartWithLineChart;
@property(nonatomic,assign) ChartType type;
-(void)exchangeLineAnyTime;

@end

NS_ASSUME_NONNULL_END
