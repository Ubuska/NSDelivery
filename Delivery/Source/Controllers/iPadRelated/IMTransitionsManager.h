//
//  IMTransitionsManager.h
//  Delivery
//
//  Created by Peter on 19/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMSplitViewController.h"

#define TransitionsManager [IMTransitionsManager sharedManager]

@interface IMTransitionsManager : NSObject
{
    IMSplitViewController* SplitController;
    UIView* RightView;
}

- (void) SetSplitController:(IMSplitViewController*)Controller;
- (void) SetRightView:(UIView*)View;
- (void) MakeTransition:(UIViewController*) RightController;


+ (id)sharedManager;

@end

