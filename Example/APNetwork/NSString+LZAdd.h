//
//  NSString+LZAdd.h
//  laizhan
//
//  Created by ozr on 17/3/16.
//  Copyright © 2017年 ozr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LZAdd)

+ (NSString *)lz_uuid;
- (NSString *)lz_escapedQueryStringPairMemberWithEncoding:(NSStringEncoding)encoding;
- (NSString *)lz_customUrlEncode;
- (NSString *)lz_md5;

@end
