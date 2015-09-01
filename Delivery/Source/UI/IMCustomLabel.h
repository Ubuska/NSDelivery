#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface IMCustomLabel : UILabel
{
@private  VerticalAlignment _verticalAlignment;
}

@property (nonatomic, readwrite, assign) VerticalAlignment verticalAlignment;


@end