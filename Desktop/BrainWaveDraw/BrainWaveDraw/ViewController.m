//
//  ViewController.m
//  BrainWaveDraw
//
//  Created by 吴伟 on 2020/1/14.
//  Copyright © 2020 吴伟. All rights reserved.
//
static int i=0;
#import "ViewController.h"
#import "SportLineView.h"
@interface ViewController ()
@property SportLineView *LCView;
@property (weak, nonatomic) IBOutlet UIButton *button1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSportLine:CGRectMake(10, 40, CGRectGetWidth([UIScreen mainScreen].bounds)-20, self.view.frame.size.height/2.0)];
    // Do any additional setup after loading the view.
}
-(void)loadSportLine:(CGRect)frame{
    self.LCView=[SportLineView lineChartViewWithFrame:frame];
    self.LCView.xValues=@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    self.LCView.yValues=@[@10,@20,@30,@40,@50,@60,@70,@80,@90,@100];
    self.LCView.countOfLines=3;
    self.LCView.type=QuadrilateralType;
    self.LCView.isShowLine=YES;
    [self.LCView.colorOfLines addObject:[UIColor redColor]];
    [self.LCView.colorOfLines addObject:[UIColor blueColor]];
    [self.LCView.colorOfLines addObject:[UIColor greenColor]];
    [_LCView drawChartWithLineChart];
    [self.view addSubview:self.LCView];
}
- (IBAction)buttonClick:(id)sender {
    NSTimer *timer=[NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(updateTest) userInfo:nil repeats:YES];
       [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    //[self updateTest];
}
- (void)updatePoints:(NSMutableArray *)pointObjs{
    int j=0;
    for(NSMutableArray *pointArray in self.LCView.AllLinePointsArray){
        [pointArray addObject:pointObjs[j]];
    int x=[pointObjs[j] CGPointValue].x;
    for(int i=0;i<pointArray.count;i++){
        NSValue *pointObj=pointArray[i];
        CGPoint pointRestored=[pointObj CGPointValue];
        if(x>_LCView.xValues.count){
            if(pointRestored.x<(x-_LCView.xValues.count)){
                [pointArray removeObject:pointObj];
            }
            
        }
    }
        j++;
    }
    [_LCView exchangeLineAnyTime];
}
-(void)updateTest{
        int value1=arc4random_uniform(101);
    int value2=arc4random_uniform(101);
    int value3=arc4random_uniform(101);
        CGPoint point1=CGPointMake(i,value1);
    CGPoint point2=CGPointMake(i, value2);
    CGPoint point3=CGPointMake(i, value3);
        NSValue *pointObj1=[NSValue valueWithCGPoint:point1];
    NSValue *pointObj2=[NSValue valueWithCGPoint:point2];
    NSValue *pointObj3=[NSValue valueWithCGPoint:point3];
    NSMutableArray *pointsArray=[NSMutableArray array];
    [pointsArray addObject:pointObj1];
    [pointsArray addObject:pointObj2];
    [pointsArray addObject:pointObj3];
    [self updatePoints:pointsArray];
        i++;
}


@end
