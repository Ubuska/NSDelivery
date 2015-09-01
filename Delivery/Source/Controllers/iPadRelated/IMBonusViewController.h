//
//  IMBonusViewController.h
//  Delivery
//
//  Created by Peter on 26/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"
#import <Foundation/Foundation.h>

@interface IMBonusViewController : UIViewController <UpdateProgress, UpdateControllerView ,UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UIActivityIndicatorView *Spinner;
    UIRefreshControl *RefreshControl;
    NSOperationQueue* Queue;
}

@property IBOutlet UITableView* TableView;
- (IBAction)OnProductPress:(id)sender;
@property UITapGestureRecognizer* TapBehindGesture;

@property (nonatomic, strong) IBOutlet UIButton* ButtonCart;


@end
