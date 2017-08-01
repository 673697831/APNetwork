//
//  APBatchRequest.h
//  AiPai
//
//  Created by ozr on 17/3/17.
//  Copyright © 2017年 ozr. All rights reserved.
//

#import "APBatchRequest.h"
#import "YTKBatchRequest.h"

@interface APBatchRequest ()

@property (nonatomic, strong) YTKBatchRequest *realRequest;
@property (nonatomic, strong) NSMutableArray<id<APBaseApiRequestProtocol>> *requestArray;
@property (nonatomic, assign) NSInteger completedCount;

@end

@implementation APBatchRequest

- (instancetype)initWithRequestArray:(NSArray<id<APBaseApiRequestProtocol>> *)array
{
    if (self = [self init]) {
        _requestArray = [[NSMutableArray alloc] initWithArray:array];
        for (id<APBaseApiRequestProtocol>request in array) {
            if ([request respondsToSelector:@selector(addBaseRequestDelegate:)]) {
                [request addBaseRequestDelegate:self];
            }
        }
        
        _requestDelegates = [NSMutableArray new];
    }
    
    return self;
}

- (void)start
{
    for (id<APBaseApiRequestProtocol>request in self.requestArray) {
        [request start];
    }
}

- (void)cancel
{
    for (id<APBaseApiRequestProtocol>request in self.requestArray) {
        [request cancel];
    }
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self clearCompletionBlock];
}

- (void)clearCompletionBlock
{
    self.successBlock = nil;
    self.cancelBlock = nil;
    self.failureBlock = nil;
    [self.requestDelegates removeAllObjects];
    [self.requestArray removeAllObjects];
}

- (void)requestDidSuccess:(id)sender responseObject:(id)responseObject
{
    self.completedCount ++;
    if (self.completedCount == self.requestArray.count) {
        if (self.successBlock) {
            self.successBlock(nil);
        }
        for (id<APBaseRequestDelegate> delegate in self.requestDelegates) {
            [delegate requestDidSuccess:nil responseObject:nil];
        }
        
        [self clearCompletionBlock];
    }
}

- (void)requestDidFailed:(id)sender error:(NSError *)error
{
    if (self.failureBlock) {
        self.failureBlock(nil, nil);
    }
    
    for (id<APBaseRequestDelegate> delegate in self.requestDelegates) {
        [delegate requestDidFailed:sender error:error];
    }
    
    
    [self clearCompletionBlock];
}

- (void)requestDidCancel:(id)sender
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
    for (id<APBaseRequestDelegate> delegate in self.requestDelegates) {
        [delegate requestDidCancel:nil];
    }
    
    [self clearCompletionBlock];
}

- (void)addBaseRequestDelegate:(id<APBaseRequestDelegate>)delegate
{
    [self.requestDelegates addObject:delegate];
}

@end
