//
//  BMICounterView.m
//  BodyTracker
//
//  Created by MInju on 10/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "BMICounterView.h"

@implementation BMICounterView

@synthesize counterColor, outlineColor;

int noOfParts = 7;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self != nil) {
        _part = 0;
    }
    
    return self;
}

- (void)setCounter:(int)inCounter {
    if (_part <= noOfParts) {
        _part = inCounter;
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    counterColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.0f];
    outlineColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5f];
    
    CGRect bounds = self.bounds;
    
    CGPoint center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
    CGFloat radius = bounds.size.width/2;
    CGFloat startAngle = 5 * M_PI / 6 + (M_PI / 6 / 2);
    CGFloat endAngle = M_PI / 6 - (M_PI / 6 / 2);
    CGFloat arcWidth = 30.0f;
    
    UIBezierPath *aPart = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:radius - (arcWidth / 2)
                                                     startAngle:startAngle
                                                       endAngle:endAngle
                                                      clockwise:YES];
    
    [aPart setLineWidth:arcWidth];
    [counterColor setStroke];
    [aPart stroke];
    
    CGFloat angleDifference = 2 * M_PI - startAngle + endAngle;
    CGFloat arcLengthPerPart = angleDifference / (CGFloat)noOfParts;
    CGFloat outlineStartAngle = arcLengthPerPart * ((CGFloat)_part-1) + startAngle;
    CGFloat outlineEndAngle = arcLengthPerPart * (CGFloat)_part + startAngle;
    
    //if part 1 or 2 (underweight and healthy weight, has different length, so need to set different start and end point)
    if (_part == 1){
        outlineStartAngle = arcLengthPerPart * ((CGFloat)_part-1) + startAngle;
        // one part has 5 and underweight is using 3.5 more in a part
        outlineEndAngle = (arcLengthPerPart * (CGFloat)_part + startAngle) + (arcLengthPerPart / 10 * 7);
    } else if (_part == 2) {
        outlineStartAngle = arcLengthPerPart * ((CGFloat)_part) + startAngle - (arcLengthPerPart / 10 * 3);
        outlineEndAngle = arcLengthPerPart * ((CGFloat)_part + 1) + startAngle;
    }
    
    //draw outer arc
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithArcCenter:center radius:bounds.size.width/2-2.5 startAngle:outlineStartAngle endAngle:outlineEndAngle clockwise:YES];
    //draw inner arc
    [outlinePath addArcWithCenter:center radius:bounds.size.width/2 - arcWidth+2.5 startAngle:outlineEndAngle endAngle:outlineStartAngle clockwise:NO];
    //close path
    [outlinePath closePath];
    
    [outlineColor setStroke];
    [outlinePath setLineWidth:5.0f];
    [outlinePath stroke];

}

@end
