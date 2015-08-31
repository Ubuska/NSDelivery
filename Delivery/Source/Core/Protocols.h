
// Model Protocols

@class IMAbstractManager;
@protocol ParserInterface <NSObject>

- (void)ParseData:(NSData *)Data Manager:(IMAbstractManager*) ObjectManagerInstance;
- (void)SetUserInfo:(id)UserInfo;
- (NSError *)GetError;
- (NSArray *)GetItemsArray;
- (void)AbortParsing;

@end

@protocol ManagerInterface <NSObject>

- (void) InsertItem:(NSObject*) ItemToInsert AtIndex:(NSUInteger)InsertIndex;
- (void) AddItem:(NSObject*) ItemToAdd;
- (void) RemoveItem:(NSObject*) ItemToRemove;
- (void) ClearAll;

- (id) GetItemByName:(NSString*) ItemName;
- (id) GetItemById:(int) ItemId;
- (id) GetItemByIndex:(int) ItemIndex;
- (NSUInteger) GetItemsCount;
- (NSUInteger) GetIndexOfItem:(NSObject*) Item;

@end

@class IMItem;
@protocol IGraphItem <NSObject>

- (int) GetItemIndex;
- (int) GetParentIndex;
- (IMItem*) GetParentItem;
- (IMItem*) GetChildById;
- (IMItem*) GetChildByIndex:(int)Index;
- (int) GetChildCount;
- (NSMutableArray*) GetChildren;
- (NSMutableArray*) FilterChildrenByType:(Class)FilterClass;

- (void) SetItemIndex:(int)IndexToSet;
- (void) SetParentIndex:(int)IndexToSet;
- (void) AddChild:(IMItem*)Child;
- (void) AddParent:(IMItem*)Parent;

@end

// NSOperation Callback Protocol
@protocol OperationNotifyReceiver <NSObject>
- (void) OperationComplete;
- (void) OperationFailed:(NSString*)Error;
@optional
- (void) OperationReceivedResponse:(NSURLResponse*)Response;
- (void) OperationReceivedData:(NSMutableData*)ReceivedData;
@end

// View Update Protocols

@protocol UpdateControllerView <NSObject>
- (void) UpdateView;
@optional
- (void) PostUpdateView;
- (void) MakeTransition;
- (void) SetStepperValue:(NSObject*)Product ValueToSet:(int)Value;
@end

// Task Tracking
@protocol UpdateProgress <NSObject>
- (void) UpdateProgress:(float)ProgressPercent;
- (void) FinishLoading;
- (void) FailedLoading;
@end

@protocol DetailView <NSObject>
- (void) SetDetailItem:(id)DetailItem ParentDelegate:(id<UpdateControllerView>) Delegate;
@end

// Payment System

@protocol PaymentInstigator <NSObject>
- (void) PaymentSuccess;
- (void) PaymentFail:(NSString*)Reason;
@end

@protocol PaymentSystem <NSObject>
- (void) Initialize;
- (void) CommitPurchase:(id<PaymentInstigator>) Delegate;
@end

// Notifications

@protocol NotificationRespondHandler <NSObject>
- (void) TransitionFromNotification;
@end






