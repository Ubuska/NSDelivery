//
//  IMAboutUsController.m
//  Delivery
//
//  Created by Peter on 05/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMAboutUsController.h"
#import "IMAppDelegate.h"
#import "Tools.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"
#import "IMSectionManager.h"
#import "IMAboutUsManager.h"
#import "AsyncImageView.h"
#import "IMAboutData.h"


IMAppDelegate* AppDelegate;
int ImagesCount = 0;

@implementation IMAboutUsController

- (void) LoadImageFromURL:(NSString*)URL
{
    // Check if we already have that image in cache.
    // NOTE: Checking by URL String.
    
    UIImage* ImageInCache = [AboutUsManager GetCachedImage:URL];
    if (ImageInCache)
    {
        [_SlideShow addImage:ImageInCache];
        [self TryStartSlideShow];
        return;
    }
    
    NSURL* ImageURL = [NSURL URLWithString:URL];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
       // NSLog(@"Screen %@ - pauseBannerFileImage download starts", self.name);
        UIImage *LoadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:ImageURL]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (LoadedImage)
            {
                [AboutUsManager CacheImage:LoadedImage ImageURL:URL];
                [_SlideShow addImage:LoadedImage];
                [self TryStartSlideShow];
            }
        });
    });
}

- (void) TryStartSlideShow
{
    ImagesCount += 1;
    if (ImagesCount == 2)
    {
        [_SlideShow start];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ImagesCount = 0;
    AppDelegate = (IMAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.barTintColor = AppDelegate.MainAppColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    IMAboutData* AboutUsItem = [AboutUsManager GetItemByIndex:0];
    _AboutUsLabel.text = AboutUsItem.Description;
    
    for (int i = 0; i < [AboutUsItem GetImagesCount]; ++i)
    {
        [self LoadImageFromURL:[AboutUsItem GetImageURLByIndex:i]];
    }
    //[_SlideShow addGesture:KASlideShowGestureTap];
    [_SlideShow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [_SlideShow addGesture:KASlideShowGestureSwipe];
    [_SlideShow setDelay:3]; // Delay between transitions
    [_SlideShow setTransitionDuration:1]; // Transition duration
    [_SlideShow setTransitionType:KASlideShowTransitionSlide]; // Choose a transition type (fade or slide)

    if ([Tools CanCreateDrawerButton])[self SetupLeftMenuButton];
    
}



- (void)LeftDrawerButtonPress:(id)LeftDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    // STYLE OF DRAWER TRANSITION
    
}

- (void)SetupLeftMenuButton
{
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(LeftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
    //[self.mm_drawerController setCenterHiddenInteractionMode:(MMDrawerOpenCenterInteractionModeNavigationBarOnly)];
    
    self.mm_drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;
    [self.mm_drawerController setMaximumLeftDrawerWidth:250];
    
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    self.mm_drawerController.closeDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    
    // super.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView | MMCloseDrawerGestureMode.TapCenterView
    
}

@end
