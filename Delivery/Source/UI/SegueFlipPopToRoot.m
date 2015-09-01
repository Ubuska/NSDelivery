//
//  SegueFlipPopToRoot.m
//  Delivery
//
//  Created by Peter on 18/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "SegueFlipPopToRoot.h"

@implementation SegueFlipPopToRoot

- (void) perform
{
    
    // Получаем экраны, с которыми будем работать
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    // Осуществляем простой переход
    [UIView transitionFromView:src.view
                        toView:dst.view
                      duration:1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:nil];
    
    // Осуществляем переход для Navigation Controller'a
    [UIView transitionFromView:src.navigationItem.titleView
                        toView:dst.navigationItem.titleView
                      duration:1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:nil];
    
    // Добавляем Push нашей Segue
    [src.navigationController pushViewController:dst animated:YES];
}


@end
