//
//  IMEventViewCell.h
//  Delivery
//
//  Created by Developer on 22.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface IMEventViewCell : UITableViewCell
{
    UILabel *name;
    AsyncImageView *photo;
    UILabel *description;
}

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet AsyncImageView *photo;
@property (nonatomic, retain) IBOutlet UILabel *description;
@property IBOutlet UIButton *RemoveButton;

@end
