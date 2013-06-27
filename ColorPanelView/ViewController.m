//
//  ViewController.m
//  ColorPanelView
//
//  Created by 舒 方昊 on 13-6-27.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_rdb= [[RoundExpandButton alloc]initWithFrame:CGRectMake( 110 , 320, 100, 100) andItems:[self makeViewData]];
    [self.view addSubview: m_rdb];
    [m_rdb release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray*)makeViewData
{
    NSMutableArray* make_views= [[NSMutableArray alloc]init];
    for (int i=0;i<15; i++) {
        NSString *_view_name= [NSString stringWithFormat:@"view %d",i];
        [make_views addObject:_view_name];
    }
    return make_views;
}


@end
