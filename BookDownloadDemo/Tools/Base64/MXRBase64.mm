//
//  Base64.m
//  DreamPress
//
//  Created by MXR on 12-11-20.
//  Copyright (c) 2012年 MXR. All rights reserved.
//

#import "MXRBase64.h"
#import "GTMBase64.h"

//#define __SMALL_PACKET__

#ifdef __SMALL_PACKET__
//typedef unsigned short PACKETID;
#define PACKET_HEADER_SIZE  3
#else
//typedef unsigned long PACKETID;
#define PACKET_HEADER_SIZE  5
#endif

//#define PACKET_HEADER_SIZE  (sizeof(PACKETID) + 1)

@implementation MXRBase64
bool CMasCommonDecryption_v2(char * src, char * dest, unsigned int length)
{
    char cKey = *src;
    
	unsigned int dwDataSize = length - PACKET_HEADER_SIZE;
	if ((int)dwDataSize <= 0)return false;
    
	src += PACKET_HEADER_SIZE;
    
	if (cKey != '\0')
	{
		for ( int i = 0; i < dwDataSize; i++)
		{
			*(dest + i)  = *(src + i)  ^ (cKey ^ (dwDataSize - i));
			*(dest + i)  -= (i ^ cKey);
		}
	}
    
	return true;
}

+ (NSString *)decodeBase64WithString:(NSString *)stringToDecode {
    NSData *decodeData = [GTMBase64 decodeString:stringToDecode];
    if (decodeData == nil)
    {
        NSLog(@"服务返回的加密数据错误");
        return nil;
    }
    char * source = (char *)[decodeData bytes];
    char * dest = (char *)malloc(sizeof(char)*[decodeData length]);
    memset(dest, 0, [decodeData length]);
    if (CMasCommonDecryption_v2(source, dest,(unsigned int)[decodeData length])) {
        NSString *resultString = [NSString stringWithUTF8String:dest];
        free(dest);
        return resultString;
    } else {
        free(dest);
        return nil;
    }
}
+ (NSString *)encodeBase64WithString:(NSString *)stringToEncode {
    if (!stringToEncode) {
        NSLog(@"empty string");
        return @"";
    }
    const char *sendBuffer = [stringToEncode UTF8String];
    int size = (int)strlen(sendBuffer);
    char *encodedBuffer = Encryption(sendBuffer, size, YES);
    NSData *data = [GTMBase64 encodeBytes:encodedBuffer length:size];
    NSString *encodedStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    delete [] encodedBuffer;
    return encodedStr;
}

char* Encryption(const char *pSndBuf, int &iSize, bool bEncryption)
{
	char *pTempBuffer =new char[iSize + PACKET_HEADER_SIZE];
	if (pTempBuffer == NULL)
	{
		return NULL;
	}
    memset(pTempBuffer, 0, iSize + PACKET_HEADER_SIZE);
	if (bEncryption)
	{
		//rand find
		srand(static_cast<unsigned int>(time(NULL)));
		*pTempBuffer = rand() % 128;
	}
	else
	{
		*pTempBuffer = '\0';
	}
    *(short*)(pTempBuffer + 1) = iSize + PACKET_HEADER_SIZE;
    
	memcpy(pTempBuffer + PACKET_HEADER_SIZE, pSndBuf, iSize);
    
	if (*pTempBuffer != '\0')
	{
		for (int i = 0; i < iSize; i++)
		{
			*(pTempBuffer + PACKET_HEADER_SIZE + i) += (i ^ (*pTempBuffer));
			*(pTempBuffer + PACKET_HEADER_SIZE + i) = *(pTempBuffer + PACKET_HEADER_SIZE + i) ^ ((*pTempBuffer) ^ (iSize - i));
		}
	}
    
	iSize += PACKET_HEADER_SIZE;
	return pTempBuffer;
}

bool CMasCommonDecryption(char* &pBuffer, unsigned int uSize)
{
	char cKey = *pBuffer;
    
	unsigned int dwDataSize = uSize - PACKET_HEADER_SIZE;
	if ((int)dwDataSize <= 0)return false;
    
	pBuffer += PACKET_HEADER_SIZE;
    
	if (cKey != '\0')
	{
		for ( int i = 0; i < dwDataSize; i++)
		{
			*(pBuffer + i)  = *(pBuffer + i)  ^ (cKey ^ (dwDataSize - i));
			*(pBuffer + i)  -= (i ^ cKey);
		}
	}
    
	return true;
}

+ (NSString *)WebSafedecodeBase64WithString:(NSString *)stringToDecode
{
    NSData *decodeData = [GTMBase64 webSafeDecodeString:stringToDecode];
    char *str = (char *)[decodeData bytes];
    if (CMasCommonDecryption(str, (unsigned int)[decodeData length])) {
        NSString *resultString = [NSString stringWithUTF8String:str];
        return resultString;
    } else {
        return nil;
    }
}

+ (NSString *)WebSafeencodeBase64WithString:(NSString *)stringToEncode
{
    const char *sendBuffer = [stringToEncode UTF8String];
    int size = (int)strlen(sendBuffer);
    char *encodedBuffer = Encryption(sendBuffer, size, YES);
    
    NSData *data = [GTMBase64 webSafeEncodeBytes:encodedBuffer length:size padded:NO];
    NSString *encodedStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    delete [] encodedBuffer;
    return encodedStr;
}

@end
