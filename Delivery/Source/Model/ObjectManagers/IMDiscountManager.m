//
//  IMUserInfoManager.m
//  Delivery
//
//  Created by Peter on 10/08/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMDiscountManager.h"
#import "IMOperationRequestDiscount.h"
#import "IMOperationRequestCardDiscount.h"
#import "IMCartManager.h"

@implementation IMDiscountManager

#pragma mark - Getters and Setters

- (NSUInteger) GetCardNumber
{
    return DiscountCardInfo.CardNumber;
}
- (NSUInteger) GetDiscountAmount
{
    NSUInteger DiscountAmount = 0;
    switch (DiscountType)
    {
        case EDT_Card:
            DiscountAmount = DiscountCardInfo.CardDiscountAmount;
            break;
            
        case EDT_Outsum:
        {
             DiscountAmount = [CurrentDiscount GetDiscountPercent];
            break;
        }
            
    }
    return DiscountAmount;
}
- (NSURL*) GetCardImageURL
{
    NSURL* URL = [NSURL URLWithString:DiscountCardInfo.CardImageURL];
    return URL;
}

-(EDiscountType) GetDiscountType
{
    return DiscountType;
}

// Setters

- (void) SetCardNumber:(NSString*)Number
{
    DiscountCardInfo.CardNumber = [Number integerValue];
}
- (void) SetCardDiscountAmount:(NSString*)DiscountAmount
{
    DiscountCardInfo.CardDiscountAmount = [DiscountAmount integerValue];
}
- (void) SetCardImageURL:(NSString*)URL
{
    DiscountCardInfo.CardImageURL = URL;
}

- (void) SetDiscountType:(EDiscountType)Type
{
    DiscountType = Type;
}

#pragma mark - Manager Methods

- (void) RequestDiscount
{
    IMOperationRequestDiscount* DiscountRequest = [IMOperationRequestDiscount new];
    [DiscountRequest Initialize:self];
    [DiscountRequest start];
}

- (void) InsertItem:(NSObject*) ItemToInsert AtIndex:(NSUInteger)InsertIndex
{
    [DataContainer insertObject:ItemToInsert atIndex:InsertIndex];
}

- (void) AddItem:(NSObject*) ItemToAdd;
{
    [DataContainer addObject:ItemToAdd];
}

// Returns first found discount larger than discount with outsum passed in.
// Returns next discount after active.
- (IMDiscount*)GetNextDiscountAfterCurrent
{
    NSUInteger CurrentDiscountIndex = [DataContainer indexOfObject:CurrentDiscount];
    return DataContainer[CurrentDiscountIndex + 1];
}

- (void) SetCurrentDiscount:(IMDiscount*)Discount
{
    CurrentDiscount = Discount;
}

- (IMDiscount*)GetCurrentDiscount
{
    return CurrentDiscount;
}

- (BOOL) SearchDiscount
{
    BOOL bIsFound = NO;
    for (int i = 0; i < [DataContainer count]; ++i)
    {
        IMDiscount* Discount = DataContainer[i];
        if ([CartManager GetMoneyInCartWithoutDiscount] >= (int)[Discount GetOutsum])
        {
            [self SetCurrentDiscount:Discount];
            bIsFound = YES;
        }
    }
    return bIsFound;
}

- (BOOL) IsDiscountActive
{
    if (CurrentDiscount)
    {
        return [self SearchDiscount];
    }
    else
    {
    
    for (IMDiscount* Discount in DataContainer)
    {
        if ([CartManager GetMoneyInCartWithoutDiscount] >= (int)[Discount GetOutsum])
        {
            [self SetCurrentDiscount:Discount];
            return true;
        }
    }
    }
    return false;
    
}

- (id) GetItemByIndex:(int) ItemIndex
{
    if (DataContainer[ItemIndex]) return DataContainer[ItemIndex];
    
    return NULL;
}
- (void) SortDiscountsByOutsum
{
    DataContainer = [NSMutableArray arrayWithArray:[self QuickSort:[NSMutableArray arrayWithArray:[DataContainer copy]]]];
}

- (NSArray*) QuickSort:(NSMutableArray *)unsortedDataArray
{
    int QuicksortCount;
        NSMutableArray *lessArray = [[NSMutableArray alloc] init];
        NSMutableArray *greaterArray =[[NSMutableArray alloc] init];
        if ([unsortedDataArray count] <1)
        {
            return nil;
        }
        int randomPivotPoint = arc4random() % [unsortedDataArray count];
        IMDiscount *pivotValue = [unsortedDataArray objectAtIndex:randomPivotPoint];
        [unsortedDataArray removeObjectAtIndex:randomPivotPoint];
        for (IMDiscount *Discount in unsortedDataArray)
        {
            QuicksortCount++; //This is required to see how many iterations does it take to sort the array using quick sort
            if ([Discount GetOutsum] < [pivotValue GetOutsum])
            {
                [lessArray addObject:Discount];
            }
            else
            {
                [greaterArray addObject:Discount];
            }
        }
        NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
        [sortedArray addObjectsFromArray:[self QuickSort:lessArray]];
        [sortedArray addObject:pivotValue];
        [sortedArray addObjectsFromArray:[self QuickSort:greaterArray]];
        return sortedArray;
    
}

#pragma mark - Operation Notifications Receiver Delegate Methods

- (void)OperationComplete
{
    
}

- (void)OperationFailed:(NSString *)Error
{
    
}

// Optional methods of the OperationNotifyResponder Protocol

-(void)OperationReceivedData:(NSMutableData *)ReceivedData
{
    }

- (void)OperationReceivedResponse:(NSURLResponse *)Response
{
    
}

#pragma mark - Abstract Manager Methods

- (void) ClearAll
{
    
}

@end
