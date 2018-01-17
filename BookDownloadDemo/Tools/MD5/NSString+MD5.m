//
//  NSString+MD5.m
//  BookDownloadDemo
//
//  MD5是使用哈希算法计算文件或字符串的摘要，将不定长的输入数据转化成128bit的数据，一般在使用的时候需要将它转换成十六进制输出，并且同时输出为小写，是不可还原出原始数据的（目前网站解密方式是采用撞库的方式，不是真正的解密）。
//
//  Created by MountainX on 2018/1/17.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

#define CC_MD5_DIGEST_LENGTH 16//1字节=8位(1 byte = 8bit)
- (NSString *)MD5 {
    const char *cStr = [self UTF8String];//转换成utf-8
    unsigned char digest[CC_MD5_DIGEST_LENGTH];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest);//在求字符串长度的时候，sizeof求的是所有字符串的长度，包括‘‘\0’以及空字符；而strlen求出的字符串长度是以'\0'为结束标示的。在遇到'\0'结束返回'\0'之前的字符串长度
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    NSString *MD5Str = [NSString string];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        MD5Str = [MD5Str stringByAppendingString:[NSString stringWithFormat:@"%02x", digest[i]]];
    }
    return MD5Str;
    /*
     x表示十六进制，%02x  意思是不足两位将用0补齐，如果多余两位则不影响
     这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
     NSLog("%02x", 0x888);  //888
     NSLog("%02x", 0x4); //04
     */
}

#define FileHashDefaultChunkSizeForReadingData 1024*8
- (NSString *)fileMD5 {
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)self, FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    
    CFStringRef result = NULL;
    
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    
    CFURLRef fileURL =
    
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  
                                  (CFStringRef)filePath,
                                  
                                  kCFURLPOSIXPathStyle,
                                  
                                  (Boolean)false);
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            
                                            (CFURLRef)fileURL);
    
    if (!readStream) goto done;
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    
    CC_MD5_CTX hashObject;
    
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    
    if (!chunkSizeForReadingData) {
        
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        
    }
    
    // Feed the data to the hash object
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            
            hasMoreData = false;
            
            continue;
            
        }
        
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
        
    }
    
    // Check if the read operation succeeded
    
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    
    if (!didSucceed) goto done;
    
    // Compute the string result
    
    char hash[2 * sizeof(digest) + 1];
    
    for (size_t i = 0; i < sizeof(digest); ++i) {
        
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
    
    
done:
    
    if (readStream) {
        
        CFReadStreamClose(readStream);
        
        CFRelease(readStream);
        
    }
    
    if (fileURL) {
        
        CFRelease(fileURL);
        
    }
    
    return result;
    
}

@end
