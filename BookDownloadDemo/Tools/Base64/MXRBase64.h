//
//  Base64.h
//  DreamPress
//
//  Created by MXR on 12-11-20.
//  Copyright (c) 2012年 MXR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRBase64 : NSObject

+ (NSString *)decodeBase64WithString:(NSString *)stringToDecode;
+ (NSString *)encodeBase64WithString:(NSString *)stringToEncode;

+ (NSString *)WebSafedecodeBase64WithString:(NSString *)stringToDecode;
+ (NSString *)WebSafeencodeBase64WithString:(NSString *)stringToEncode;

@end
