//
//  APDownloadImageRequest.h
//  AiPai
//
//  Created by ozr on 17/3/17.
//  Copyright © 2017年 ozr. All rights reserved.
//

#import "APDownloadImageRequest.h"
#if __has_include(<SDWebImageManager.h>)
#import <SDWebImageManager.h>
#else
#import "SDWebImageManager.h"
#endif

@interface APDownloadImageRequest ()

@property (nonatomic, strong) NSMutableArray<id<APBaseRequestDelegate>> *requestDelegates;

@end

@implementation APDownloadImageRequest

- (instancetype)init
{
    if (self = [super init]) {
        _requestDelegates = [NSMutableArray new];
    }
    
    return self;
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl
{
    if (self = [self init]) {
        _imageUrl = [imageUrl copy];
    }
    
    return self;
}

- (void)start
{
    void (^success)(id) = self.successBlock;
    void (^failure)(id, NSError *) = self.failureBlock;
    __weak typeof (self)wself = self;
    NSMutableArray<id<APBaseRequestDelegate>> *requestDelegates = self.requestDelegates;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.imageUrl]
                                                    options:0
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        __strong typeof(wself)strongSelf = wself;
        if (error)
        {
            if (failure) {
                failure(nil, error);
            }
            
            for (id <APBaseRequestDelegate>requestDelegate in requestDelegates) {
                [requestDelegate requestDidFailed:strongSelf error:error];
            }
            
            
            return;
        }
        if (success) {
            success(image);
        }
        
        for (id <APBaseRequestDelegate>requestDelegate in requestDelegates) {
            [requestDelegate requestDidSuccess:strongSelf responseObject:image];
        }
        
        
    }];

}

- (void)cancel
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self clearCompletionBlock];
    
    for (id <APBaseRequestDelegate>requestDelegate in self.requestDelegates) {
        [requestDelegate requestDidCancel:self];
    }
}

- (void)clearCompletionBlock
{
    self.successBlock = nil;
    self.cancelBlock = nil;
    self.failureBlock = nil;
    [self.requestDelegates removeAllObjects];
}

- (void)addBaseRequestDelegate:(id<APBaseRequestDelegate>)delegate
{
    [self.requestDelegates addObject:delegate];
}

@end
