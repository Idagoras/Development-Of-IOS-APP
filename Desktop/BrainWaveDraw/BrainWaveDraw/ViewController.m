//
//  ViewController.m
//  BrainWaveDraw
//
//  Created by 吴伟 on 2020/1/14.
//  Copyright © 2020 吴伟. All rights reserved.
//
static i=0;
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
    self.LCView.type=QuadrilateralType;
    self.LCView.isShowLine=YES;
    [_LCView drawChartWithLineChart];
    [self.view addSubview:self.LCView];
}
- (IBAction)buttonClick:(id)sender {
    NSTimer *timer=[NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(updateTest) userInfo:nil repeats:YES];
       [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    //[self updateTest];
}
- (void)updatePoints:(NSValue *)pointObj1{
    [self.LCView.pointArray addObject:pointObj1];
    int x=[pointObj1 CGPointValue].x;
    for(int i=0;i<self.LCView.pointArray.count;i++){
        NSValue *pointObj=self.LCView.pointArray[i];
        CGPoint pointRestored=[pointObj CGPointValue];
        if(x>_LCView.xValues.count){
            if(pointRestored.x<(x-_LCView.xValues.count)){
                [_LCView.pointArray removeObject:pointObj];
            }
            
        }
    }
    [_LCView exchangeLineAnyTime];
}
-(void)updateTest{
        int value=arc4random_uniform(101);
        CGPoint point=CGPointMake(i,value);
        NSValue *pointObj=[NSValue valueWithCGPoint:point];
        [self updatePoints:pointObj];
        NSLog(@"%d %d",i,value);
        i++;
}


@end
