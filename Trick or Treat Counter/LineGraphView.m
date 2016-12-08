//
//  LineGraphView.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/8/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "LineGraphView.h"

@implementation LineGraphView


- (void)drawRect:(CGRect)rect {
    
    // load data for graph
    
    CoreDataFunctions* coredataObject = [[CoreDataFunctions alloc] init];
    User *currentUser = [coredataObject performFetch];
    
    NSSet *yearsSet = [currentUser valueForKey:@"years"];
    
    _years = [[NSMutableArray alloc] init];
    
    _graphPoints = [[NSMutableArray alloc] init];
    
    for (Year *i in yearsSet) {
        
        [_years addObject:i];
        
        [_graphPoints addObject: @(i.visitors)];
        
    }
    
    // Create background color
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
    
    [path addClip];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray *colors = [NSArray arrayWithObjects:
                       [UIColor orangeColor].CGColor, nil];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat colorLocation[] = {0.0, 1.0};
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge_retained CFArrayRef) colors, colorLocation);
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(0, self.bounds.size.height);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // Build Lines for line graph
    
    CGFloat margin = 40.0;
    
    CGFloat topBorder = 60;
    CGFloat bottomBorder = 50;
    CGFloat graphHeight = height - topBorder - bottomBorder;
    int maxValue = [[_graphPoints valueForKeyPath:@"@max.intValue"] intValue];
    
    [[UIColor whiteColor] setFill];
    
    [[UIColor whiteColor] setStroke];
    
    UIBezierPath *graphPath = [[UIBezierPath alloc] init];
    
    [graphPath moveToPoint:CGPointMake([self calculateXPoint:0 width:width margin:margin], [self calculateYPoint:[_graphPoints objectAtIndex:0] maxValue:maxValue graphHeight:graphHeight topBorder:topBorder])];
    
    for (int i = 0; i <= _graphPoints.count - 1; i++) {
        
        CGPoint nextPoint = CGPointMake([self calculateXPoint:i width:width margin:margin], [self calculateYPoint:[_graphPoints objectAtIndex:i] maxValue:maxValue graphHeight:graphHeight topBorder:topBorder]);
        
        [graphPath addLineToPoint:nextPoint];
        
    }
    
    graphPath.lineWidth = 3.0;
    
    [graphPath stroke];
    
    // Add filled circles to each data point
    
    for (int i = 0; i <= _graphPoints.count - 1; i++) {
        
        CGPoint point = CGPointMake([self calculateXPoint:i width:width margin:margin], [self calculateYPoint:[_graphPoints objectAtIndex:i] maxValue:maxValue graphHeight:graphHeight topBorder:topBorder]);
        
        point.x = point.x - (15.0/2);
        point.y = point.y - (15.0/2);
        
        CGRect  pointRect = {point, CGSizeMake(15.0, 15.0)};
        
        UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect: pointRect];
        
        [circle fill];
        
        // add the bottom year label using the location data of the circle
        
        UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, height - bottomBorder, 50.0, 50.0)];
        
        Year *currentyear = [_years objectAtIndex:i];
        NSString *yearString = currentyear.year;
        yearLabel.text = [NSString stringWithFormat:@"%@", yearString];
        [self addSubview:yearLabel];
        
    }
    
    // Add top horizontal line for graph
    
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    
    [linePath moveToPoint:CGPointMake(margin, topBorder)];
    
    [linePath addLineToPoint:CGPointMake(width - margin, topBorder)];
    
    // add middle horizontal line for graph
    
    [linePath moveToPoint:CGPointMake(margin, graphHeight/2 + topBorder)];
    
    [linePath addLineToPoint:CGPointMake(width - margin, graphHeight/2 + topBorder)];
    
    // add bottom line for graph
    
    [linePath moveToPoint:CGPointMake(margin, height - bottomBorder)];
    
    [linePath addLineToPoint:CGPointMake(width - margin, height - bottomBorder)];
    
    linePath.lineWidth = 1.0;
    
    [linePath stroke];

    // Add value labels
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topBorder - 25, 25.0, 50.0)];
    topLabel.text = [NSString stringWithFormat:@"%hd", maxValue] ;
    
    [self addSubview:topLabel];
    
    int middleValue = maxValue / 2;
    
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height / 2 - 15, 25.0, 50.0)];
    middleLabel.text = [NSString stringWithFormat:@"%hd", middleValue];
    
    [self addSubview:middleLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - bottomBorder - 10 , 50.0, 25.0)];
    bottomLabel.text = @"0";
    
    [self addSubview:bottomLabel];
    
}


-(CGFloat)calculateXPoint:(int)column width:(CGFloat)width margin:(CGFloat)margin {
    
    CGFloat spacer = ((width - margin) - 50) / ((CGFloat)_graphPoints.count - 1);
    
    CGFloat x = ((CGFloat)column * spacer) + (margin + (CGFloat)2);
    
    return x;
}

-(CGFloat)calculateYPoint:(NSNumber*)graphPoint maxValue:(int)maxValue graphHeight:(CGFloat)graphHeight topBorder:(CGFloat)topBorder {
    
    int intGraphPoint = [graphPoint integerValue];
    
    CGFloat graphValue = (CGFloat)maxValue;
    
    CGFloat graphPercentage = ((CGFloat)intGraphPoint / graphValue) * graphHeight;
    
    CGFloat yValue = ((CGFloat)graphHeight + topBorder) - graphPercentage;
    
    return yValue;
    
}




@end
