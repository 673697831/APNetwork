//
//  NSString+LZAdd.m
//  laizhan
//
//  Created by ozr on 17/3/16.
//  Copyright © 2017年 ozr. All rights reserved.
//

#import "NSString+LZAdd.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LZAdd)

static NSString *idFromKeyChain = nil;

- (NSString *)lz_md5
{
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)lz_escapedQueryStringPairMemberWithEncoding:(NSStringEncoding)encoding
{
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~',*[]";
    static NSString * const kAFCharactersToLeaveUnescaped = @".";
    NSString *string = [self copy];
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)lz_customUrlEncode
{
    NSString *string = [self copy];
    if (![string isKindOfClass:[NSString class]]) string = [(id)string stringValue];
    ;
    string = [string lz_escapedQueryStringPairMemberWithEncoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    string = [string stringByReplacingOccurrencesOfString:@"%7E" withString:@"~"];
    return string;
}

+ (NSString *)lz_uuid
{
    if (!idFromKeyChain) {
        @synchronized (self) {
            idFromKeyChain = [self idFromKeyChain];
        }
    }
    
    return idFromKeyChain;
}

+ (NSString *)lz_randomId
{
    char ch[33];
    for (int i=0; i<32; i++) {
        int t = arc4random() % 36;
        
        if (t < 10)
        {
            ch[i] = '0' + t;
        }
        else
        {
            ch[i] = 'a' - 10 + t;
        }
    }
    
    ch[32] = '\0';
    
    return [[NSString alloc] initWithCString:ch encoding:NSUTF8StringEncoding];
}

+ (NSString *)newStoredID
{
    CFMutableDictionaryRef query = CFDictionaryCreateMutable(kCFAllocatorDefault, 4, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(query, kSecClass, kSecClassGenericPassword);
    CFDictionarySetValue(query, kSecAttrAccount, CFSTR("lzid_account"));
    CFDictionarySetValue(query, kSecAttrService, CFSTR("lzid_service"));
    
    NSString *uuid = nil;
    if (NSClassFromString(@"UIDevice")) {
        uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    } else {
        uuid = [[NSUUID UUID] UUIDString];
    }
    
    CFDataRef dataRef = CFBridgingRetain([uuid dataUsingEncoding:NSUTF8StringEncoding]);
    CFDictionarySetValue(query, kSecValueData, dataRef);
    OSStatus status = SecItemAdd(query, NULL);
    
    if (status != noErr) {
        NSLog(@"Keychain Save Error: %d", (int)status);
        uuid = nil;
    }
    
    CFRelease(dataRef);
    CFRelease(query);
    
    return uuid;
}

+ (NSString *)idFromKeyChain {
    CFMutableDictionaryRef query = CFDictionaryCreateMutable(kCFAllocatorDefault, 4, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(query, kSecClass, kSecClassGenericPassword);
    CFDictionarySetValue(query, kSecAttrAccount, CFSTR("lzid_account"));
    CFDictionarySetValue(query, kSecAttrService, CFSTR("lzid_service"));
    
    // See if the attribute exists
    CFTypeRef attributeResult = NULL;
    OSStatus status = SecItemCopyMatching(query, (CFTypeRef *)&attributeResult);
    if (attributeResult != NULL)
        CFRelease(attributeResult);
    
    if (status != noErr) {
        CFRelease(query);
        if (status == errSecItemNotFound) {
            return [self newStoredID];
        } else {
            NSLog(@"Unhandled Keychain Error %d", (int)status);
            return nil;
        }
    }
    
    // Fetch stored attribute
    CFDictionaryRemoveValue(query, kSecReturnAttributes);
    CFDictionarySetValue(query, kSecReturnData, (id)kCFBooleanTrue);
    CFTypeRef resultData = NULL;
    status = SecItemCopyMatching(query, &resultData);
    
    if (status != noErr) {
        CFRelease(query);
        if (status == errSecItemNotFound){
            return [self newStoredID];
        } else {
            NSLog(@"Unhandled Keychain Error %d", (int)status);
            return nil;
        }
    }
    
    NSString *uuid = nil;
    if (resultData != NULL)  {
        uuid = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(resultData) encoding:NSUTF8StringEncoding];
    }
    
    CFRelease(query);
    
    return uuid;
}

@end
