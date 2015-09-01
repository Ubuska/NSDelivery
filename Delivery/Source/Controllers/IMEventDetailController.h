//
//  IMEventDetailController.h
//  Delivery
//
//  Created by Developer on 22.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMCartViewController.h"
#import "Protocols.h"
#import "IMEvent.h"

@interface IMEventDetailController : UIViewController <UpdateProgress, DetailView>
{
    IMEvent* EventDetailItem;
    id <UpdateControllerView> ParentViewDelegate;
}

@property (nonatomic, strong) IBOutlet UILabel *EventLabel;
@property (nonatomic, strong) IBOutlet UILabel *EventDescriptionLabel;
@property (nonatomic, strong) IBOutlet AsyncImageView *EventImage;
@property (nonatomic, strong) IBOutlet UIButton* ButtonCart;


@end
