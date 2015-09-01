//
//  IMStepper.h
//  Delivery
//
//  Created by Developer on 16.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum JLTStepperPlusMinusState_
{
    JLTStepperMinus = -1,
    JLTStepperPlus  = 1,
    JLTStepperUnset = 0
} JLTStepperPlusMinusState;



@interface IMStepper : UIStepper
@property (nonatomic) JLTStepperPlusMinusState plusMinusState;
@property (nonatomic, strong) IBOutlet UILabel *StepperValue;
@property (nonatomic, strong) IBOutlet UICollectionViewCell *StepperCellContainer;
@property bool *bAnimated;

@end
