//
//  IMSplitViewController.h
//  Delivery
//
//  Created by Peter on 18/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface IMSplitViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UpdateControllerView>
{
    UIViewController* RightViewController;
}

@property IBOutlet UIView* LeftView;
@property IBOutlet UIView* RightView;
@property (weak) id<UpdateControllerView> ControllerDelegate;

- (void) SetRightViewController:(UIViewController*)RightController;
@end
