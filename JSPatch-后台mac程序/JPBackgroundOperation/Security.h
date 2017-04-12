//
//  Security.h
//  testMacDemo
//
//  Created by ccSunday on 2017/3/17.
//  Copyright © 2017年 ccSunday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Security : NSObject

+ (instancetype)sharedSecurity;

// RSA公钥加密，支持长数据加密
- (NSData *)encryptWithPublicKey:(NSData *)plainData;

// RSA私钥解密，支持长数据解密
- (NSData *)decryptWithPrivateKey:(NSData *)cipherData;

@end
