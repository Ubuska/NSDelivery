//
//  ViewController.h
//  HandOff_ObjC
//
//  Created by Olga Dalton on 23/10/14.
//  Copyright (c) 2014 Olga Dalton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface ViewController : UIViewController <UpdateControllerView>

@property id<UpdateControllerView> PageUpdateDelegate;
@property IBOutlet UIButton* ButtonCart;
@property NSMutableArray* Products;
@property int PageIndex;
@end

