//
//  IMSectionViewCell.h
//  Delivery
//
//  Created by Developer on 12.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMSectionViewCell : UITableViewCell
{
    UILabel *SectionName;
}

@property (nonatomic, retain) IBOutlet UILabel *SectionName;
@end
