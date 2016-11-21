//
//  CounterButton.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 11/21/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "CounterButton.h"
#import <UIKit/UIKit.h>

@interface CounterButton ()


@end

@implementation CounterButton

_currentAngle = 1.0;

CGFloat π = M_PI;

CFTimeInterval timeBetweenDraw = 0.005;

-(void)updateTimer{
    
    if(_currentAngle < 7.5){
        _currentAngle += 0.4;
        [self setNeedsDisplay];
    } else {
        _buttonPushed = false;
        [self setNeedsDisplay];
    }
}


- (void)drawRect:(CGRect)rect {

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    _fillColor.setFill;
    path.fill;
    
    
    CGFloat plusHeight = 3.0;
    CGFloat plusWidth = MIN(rect.size.width, rect.size.height) * 0.6;
    
    UIBezierPath *plusPath = [UIBezierPath bezierPath];
    plusPath.lineWidth = plusHeight;
    [plusPath moveToPoint:CGPointMake(rect.size.width * 0.25, rect.size.height / 2)];
    [plusPath addLineToPoint:CGPointMake(rect.size.width * 0.75, rect.size.height / 2)];
    
    if (self.isAddButton) {
        [plusPath moveToPoint:CGPointMake(rect.size.width / 2, rect.size.height * 0.25)];
        [plusPath addLineToPoint:CGPointMake(rect.size.width / 2, rect.size.height * 0.75)];
    }
    
    [[UIColor whiteColor] setStroke];

    [plusPath stroke];
    
    
    
    if (_buttonPushed) {
        
        [NSTimer scheduledTimerWithTimeInterval:timeBetweenDraw
                                         target:self
                                       selector:@selector(updateTimer)
                                       userInfo:nil
                                        repeats:NO];
        
        CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
        CGFloat radius = MAX(rect.size.width, rect.size.height);
        CGFloat arcWidth = 5.0;
        
        UIBezierPath *animatedPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius / 2 - arcWidth / 2 startAngle: 1 endAngle:_currentAngle clockwise:true];
        
        
        animatedPath.lineWidth = arcWidth;
        
        [[UIColor redColor] setStroke];
        [animatedPath stroke];
        
    }
    
    
    
    
    
    
    
    

}


@end
