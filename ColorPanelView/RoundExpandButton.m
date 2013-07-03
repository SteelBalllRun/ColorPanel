//
//  RoundExpandButton.m
//  ColorPanelView
//
//  Created by 舒 方昊 on 13-6-27.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import "RoundExpandButton.h"

#define ITEM_VIEW_SIZE_WIDTH 15
#define ITEM_VIEW_SIZE_HEIGHT 15
#define KEY 233
#define M_PI_ 3.14

const static int position_factor[4][2]={{-1,0},{0,0},{0,1},{-1,1}};

@implementation PositionData

@synthesize data;

@end
@implementation RoundExpandButton
@synthesize item_arr;
@synthesize anchor_point;
-(id)initWithFrame:(CGRect)frame andItems:(NSArray*)arr
{
    self.item_arr= arr;
    is_expanding=false;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        position_data = [[NSMutableArray alloc]init];
        [self setUserInteractionEnabled:true];
        [self.layer setCornerRadius:50];
        
        expand_panel= [[UIView alloc]initWithFrame:CGRectMake(0,0, 100, 100)];
        [expand_panel.layer setBackgroundColor:[UIColor whiteColor].CGColor];
        [expand_panel.layer setCornerRadius:50];
        [self addShadowToView:expand_panel];
        [self addSubview:expand_panel];
        
        for (int i=0; i<item_arr.count; ++i) {
            UIView *_view= [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-ITEM_VIEW_SIZE_WIDTH/2, self.frame.size.height/2-ITEM_VIEW_SIZE_HEIGHT/2, ITEM_VIEW_SIZE_WIDTH, ITEM_VIEW_SIZE_HEIGHT)];
            [_view setTag:i+KEY];
            [_view setBackgroundColor:[UIColor colorWithRed:0.012*(i+1)*(i+1)+0.02 green:0.003*(i+1)*(i+1)+0.13 blue:0.001*(i+1)*(i+1)+0.13 alpha:1]];
            [expand_panel addSubview:_view];
            [_view release];
        }
        selected_panel=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addCoverToView:self];
        [expand_panel release];
        [self getTargetPositionForItems];
    }
    return self;
}
-(void)addCoverToView:(UIView *)_view
{

    CALayer *layer=selected_panel.layer;
    layer.cornerRadius=50;
    layer.backgroundColor=[UIColor orangeColor].CGColor;
    layer.frame= CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_view addSubview:selected_panel];
}

-(void)addShadowToView:(UIView*)_view
{
    CALayer *layer= [CALayer layer];
    layer.frame=CGRectMake(0, 0, _view.frame.size.width, _view.frame.size.height);
    layer.cornerRadius=50;
    layer.backgroundColor=[UIColor whiteColor].CGColor;
    layer.shadowColor=[UIColor blackColor].CGColor;
    layer.shadowOffset=CGSizeMake(0, 1.0);
    layer.shadowOpacity=0.5;
    layer.shadowRadius=5;
    [layer setDrawsAsynchronously:true];
    [_view.layer addSublayer:layer];
}


- (void)runAnimation:(bool)animation_direction
{
    if (animation_direction) {
        //expand
        [UIView beginAnimations:@"1.1" context:nil];
        [expand_panel.layer setTransform:CATransform3DMakeScale(2.0, 2.0, 1.0)];
        [UIView commitAnimations];
        
    }else
    {
        //close
        [UIView beginAnimations:@"1.2" context:nil];
        [expand_panel.layer setTransform:CATransform3DMakeScale(1, 1, 1.0)];
        [UIView commitAnimations];
    }
}
- (void) expandingItemsWithInfo:(id)userInfo
{
    NSNumber *animation_direction_number= [userInfo objectForKey:@"direction"] ;
    NSNumber *_index_number=[userInfo objectForKey:@"index"];
    int _index= _index_number.intValue;
    bool animation_direction=animation_direction_number.boolValue;
    if (animation_direction) {
        [UIView animateWithDuration:0.2
                         animations:^(void){
                             UIView *_item_view=[self viewWithTag:_index+KEY];
                             PositionData * position=(PositionData*)[position_data objectAtIndex:_index];
                             [_item_view setFrame:CGRectMake(self.frame.size.width/2-ITEM_VIEW_SIZE_WIDTH/2+position.data.x, self.frame.size.height/2-ITEM_VIEW_SIZE_HEIGHT/2+position.data.y, ITEM_VIEW_SIZE_WIDTH, ITEM_VIEW_SIZE_HEIGHT)];
                         }
                         completion:^(BOOL finished){
                             if (_index==item_arr.count-1) {
                                 is_expanding=false;
                             }
                         }];
        [UIView commitAnimations];
    }else
    {
        [UIView beginAnimations:@"2.2" context:nil];
        //close items
        UIView *_item_view=[self viewWithTag:_index+KEY];
        [_item_view setFrame:CGRectMake(self.frame.size.width/2-ITEM_VIEW_SIZE_WIDTH/2, self.frame.size.height/2-ITEM_VIEW_SIZE_HEIGHT/2, ITEM_VIEW_SIZE_WIDTH, ITEM_VIEW_SIZE_HEIGHT)];
        [UIView commitAnimations];
    }
}
- (void) getTargetPositionForItems
{
    float r=self.frame.size.height/2;
    //逆时针方向展开
    for (int i=1; i<=item_arr.count; ++i) {
        CGPoint p=CGPointMake(cos(2*i*M_PI_/item_arr.count)*(r-ITEM_VIEW_SIZE_WIDTH*2/3), sin(2*i*M_PI_/item_arr.count)*(r-ITEM_VIEW_SIZE_HEIGHT*2/3));
        PositionData *data= [[PositionData alloc]init];
        [data setData:p];
        [position_data addObject:data];
        [data release];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    is_expanding=true;
    [self runAnimation:true];
    for (int i=0; i<item_arr.count; ++i) {
        NSDictionary *_userInfo=[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:true],@"direction",[NSNumber numberWithInt:i],@"index", nil];
        [self performSelector:@selector(expandingItemsWithInfo:) withObject:_userInfo afterDelay:(0.05*i+0.05)];
        [_userInfo release];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self runAnimation:false];
    for (int i=0; i<item_arr.count; ++i) {
        NSDictionary *_userInfo=[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:false],@"direction",[NSNumber numberWithInt:i],@"index", nil];
        [self expandingItemsWithInfo:_userInfo];
        [_userInfo release];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touch_point=[[touches anyObject] locationInView:expand_panel];
    NSLog(@"x=%f,y=%f",touch_point.x,touch_point.y);
    for (int i=0; i<item_arr.count; ++i) {
        UIView *_item_view=[self viewWithTag:i+KEY];
        if ([self isTouch:touch_point InRect:_item_view.frame]&&!is_expanding)
        {
            [_item_view.layer setBorderColor:[UIColor greenColor].CGColor];
            [_item_view.layer setBorderWidth:2];
            [selected_panel setBackgroundColor:_item_view.backgroundColor];
        }else
        {
            [_item_view.layer setBorderColor:[UIColor clearColor].CGColor];
        }
    }
}

-(bool)isTouch:(CGPoint)_location InRect:(CGRect)_rect
{
    if (_location.x<_rect.origin.x||_location.x>_rect.origin.x+_rect.size.width
        ||_location.y<_rect.origin.y||_location.y>_rect.origin.y+_rect.size.height) {
        return false;
    }
    return true;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [position_data release];
    [item_arr release];
    [super dealloc];
}
@end
