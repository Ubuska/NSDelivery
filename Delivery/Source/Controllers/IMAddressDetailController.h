//
//  IMRestarauntDetailController.h
//  Delivery
//
//  Created by Developer on 22.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMCartViewController.h"
#import "AsyncImageView.h"
#import "Protocols.h"
#import "IMAddress.h"

@interface IMAddressDetailController : UIViewController <UpdateControllerView, DetailView>
{
    IMAddress* AddressDetailItem;
    id <UpdateControllerView> ParentViewDelegate;
}

@property (nonatomic, strong) IBOutlet UILabel *RestarauntLabel;
@property (nonatomic, strong) IBOutlet UILabel *RestarauntDescriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *RestarauntCityLabel;
@property (nonatomic, strong) IBOutlet UIButton *RestarauntPhoneButton;
@property (nonatomic, strong) IBOutlet UILabel *RestarauntAdressLabel;

@property IBOutlet UIScrollView *scroller;

@property (nonatomic, strong) IBOutlet AsyncImageView *RestarauntImage;
@property (nonatomic, strong) IBOutlet UIButton* ButtonCart;


@end
