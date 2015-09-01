//
//  IMHeaderViewCell.h
//  Delivery
//
//  Created by Peter on 18/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridController.h"
#import "Section.h"

@interface IMHeaderViewCell : UICollectionReusableView

@property IBOutlet UILabel* Label;
@property IBOutlet GridController* Controller;
@property IBOutlet Section* HeaderSection;

- (void) OnHeaderPress;

@end
