//
//  IMStepper.m
//  Delivery
//
//  Created by Developer on 16.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMStepper.h"

@implementation IMStepper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setValue:(double)value
{
    BOOL isPlus  = self.value < value;
    BOOL isMinus = self.value > value;
    
    if (self.wraps) { // Handing wrapped values is tricky
        if (self.value > self.maximumValue - self.stepValue) {
            isPlus  = value < self.minimumValue + self.stepValue;
            isMinus = isMinus && !isPlus;
        } else if (self.value < self.minimumValue + self.stepValue) {
            isMinus = value > self.maximumValue - self.stepValue;
            isPlus  = isPlus && !isMinus;
        }
    }
    
    if (isPlus)
        self.plusMinusState = JLTStepperPlus;
    else if (isMinus)
        self.plusMinusState = JLTStepperMinus;
    
    [super setValue:value];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
