//
//  IMAboutUsController.h
//  Delivery
//
//  Created by Peter on 05/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"

@interface IMAboutUsController : UIViewController <UIViewControllerRestoration>

@property IBOutlet UILabel* AboutUsLabel;
@property IBOutlet KASlideShow* SlideShow;

@end
