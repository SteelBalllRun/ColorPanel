//
//  RoundExpandButton.h
//  ColorPanelView
//
//  Created by 舒 方昊 on 13-6-27.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface RoundExpandButton : UIView
{
    NSArray* item_arr;
    NSMutableArray *position_data;
    UIView* expand_panel;
    UIView* selected_panel;
    Point anchor_point;
    bool is_expanding;
}
@property (nonatomic, assign) Point anchor_point;
@property (nonatomic, retain) NSArray* item_arr;
-(id)initWithFrame:(CGRect)frame andItems:(NSArray*)arr;
@end
@interface PositionData : NSObject
{
    CGPoint data;
}
@property(nonatomic, assign)CGPoint data;
@end
