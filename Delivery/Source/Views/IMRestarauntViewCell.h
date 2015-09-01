//
//  IMRestarauntViewCell.h
//  Delivery
//
//  Created by Developer on 22.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface IMRestarauntViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *Name;
@property (nonatomic, retain) IBOutlet UILabel *Description;
@property (nonatomic, retain) IBOutlet UITextView *Phone;
@property (nonatomic, retain) IBOutlet UILabel *Address;
@property (nonatomic, retain) IBOutlet AsyncImageView *Photo;
@end
