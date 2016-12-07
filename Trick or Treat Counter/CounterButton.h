//
//  CounterButton.h
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 11/21/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CounterButton : UIButton

@property (nonatomic) IBInspectable UIColor *fillColor;
@property (nonatomic) IBInspectable BOOL isAddButton;
@property (nonatomic) IBInspectable BOOL buttonPushed;
@property (nonatomic) float currentAngle;

@end
