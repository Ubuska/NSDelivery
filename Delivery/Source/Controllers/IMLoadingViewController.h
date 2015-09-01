//
//  IMLoadingViewController.h
//  Delivery
//
//  Created by Peter on 17/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface IMLoadingViewController : UIViewController <UpdateProgress, OperationNotifyReceiver>

@property IBOutlet UIActivityIndicatorView* Spinner;
@property IBOutlet UIProgressView* ProgressBar;

@end
