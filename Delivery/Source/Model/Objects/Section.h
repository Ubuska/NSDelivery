
#import <Foundation/Foundation.h>
#import "IMItem.h"
#import "Protocols.h"

@interface Section : IMItem <IGraphItem>
{
    int SectionIndex;
    int ParentIndex;

    
    
    id SectionManagerHandler;
}


- (void) SetSectionManagerHandler:(id)Handler;
- (id) GetSectionManagerHandler;
@end
