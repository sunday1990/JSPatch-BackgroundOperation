//
//  AppDelegate.m
//  JPBackgroundOperation
//
//  Created by Xu Lian on 2013-07-19.
//  Copyright (c) 2013 Beyondcow. All rights reserved.
//

#import "AppDelegate.h"
//RSA非对称加解密工具
#import "Security.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSTJsonTool.h"
#import <AFNetworking/AFNetworking.h>

#define HTTP_APPKEY @"1234567890"           //根据自己服务器的情况定义

@interface AppDelegate()
{
    NSString *base64Encoded;
    NSString *urlString;       //服务器地址
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    //默认服务器地址
    urlString = @"http://ts.ccsunday/IosCode/index";

    //设置网址高亮显示
    NSError *error = NULL;
    dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    if (error) {
        dataDetector=nil;
    }
    [_textView didChangeText];
}

#pragma mark 高亮处理url
-(void)textDidChange:(NSNotification *)notification {
    if (notification.object==_textView) {
        if (dataDetector) {
            NSString *string = [_textView.textStorage string];
            NSArray *matches = [dataDetector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
            [_textView.textStorage beginEditing];
            [_textView.textStorage removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, [string length])];
            [_textView.textStorage removeAttribute:NSLinkAttributeName range:NSMakeRange(0, [string length])];
            for (NSTextCheckingResult *match in matches) {
                NSRange matchRange = [match range];
                if ([match resultType] == NSTextCheckingTypeLink) {
                    NSURL *url = [match URL];
                    [_textView.textStorage addAttributes:@{NSLinkAttributeName:url.absoluteString} range:matchRange];
                }
            }
            [_textView.textStorage endEditing];
        }
    }
}

#pragma mark 上传
- (void)uploadJS{
    if (_versionNumField.stringValue.length<=0) {
        _statusLabel.stringValue = @"选择版本";
        return;
    }
    _statusLabel.stringValue = @"开始上传";
    NSLog(@"uploadInfo:%@",base64Encoded);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:_versionNumField.stringValue forKey:@"edition"];
    [dic setObject:@"ios" forKey:@"platform"];
    [dic setObject:_resultTextField.stringValue forKey:@"code"];

#warning 此处不进行网络请求，只做演示用。
    return;
    
    [self postWithURL:urlString params:dic success:^(id response) {
        NSDictionary *jsonDic = response;
        _statusLabel.stringValue =jsonDic[@"msg"];
        NSLog(@"msg=%@",jsonDic[@"msg"]);
        NSLog(@"jsonDic%@",jsonDic);
    } failure:^(NSError * error) {
        NSLog(@"error%@",error.description);
    }];

}

- (IBAction)parseFiles:(NSButton *)sender {
    NSLog(@"文件路径：%@",_FilesPathTf.stringValue);
    //获得原始数据
    NSData *baseData = [NSData dataWithContentsOfFile:_FilesPathTf.stringValue];
    
    //获得RSA加密后的数据
    NSData *encryptData = [[Security sharedSecurity]encryptWithPublicKey:baseData];
    
    //获得RAS加密后的字符串,将此字符串上传服务器。服务器需要返回改字符串。
    base64Encoded = [encryptData base64EncodedStringWithOptions:0];
    _resultTextField.stringValue = base64Encoded;

    // NSData from the Base64 encoded str
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:base64Encoded options:0];
    
    //非对称私钥解密
    //    NSData *
    NSData *decryptData = [[Security sharedSecurity]decryptWithPrivateKey:nsdataFromBase64String];
    
    NSString *result = [[NSString alloc] initWithData:decryptData  encoding:NSUTF8StringEncoding];
    _originalContentTF.stringValue = result;
}

#pragma 提交
- (IBAction)commitBtn:(NSButton *)sender {
    
    [self uploadJS];
}
#pragma mark 重置
- (IBAction)reset:(NSButton *)sender {
    _FilesPathTf.stringValue = @"";
    _resultTextField.stringValue = @"";
    _originalContentTF.stringValue = @"";
    _statusLabel.stringValue = @"文件状态";
    _versionNumField.stringValue = @"";
}
#pragma mark 选择测试服务器
- (IBAction)selectedTs:(NSButton *)sender {

    urlString = @"http://ts.ccsunday/IosCode/index";//无效网址，到时候换为自己的即可
}

#pragma mark 选择正式服务器
- (IBAction)selected3w:(NSButton *)sender {
    urlString = @"http://www.ccsunday/IosCode/index";//无效网址，到时候换为自己的即可
}

#pragma mark 网络请求
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError * error))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript", @"text/html", nil];
    mgr.requestSerializer.timeoutInterval = 60.0;
   
    NSString *base64Text = @"";
   
    NSString *plainText = [NSTJsonTool getDicJSON:params options:NSJSONWritingPrettyPrinted error:nil];
    
    NSData *cipherData;

    cipherData = [[plainText dataUsingEncoding:NSUTF8StringEncoding]AES256EncryptWithKey:HTTP_APPKEY];
    
    base64Text = [cipherData base64EncodedString];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
   
    [param setObject:base64Text forKey:@"en"];

    // 2.发送一个POST请求
    [mgr POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *cipData = [data base64DecodedData];
        data  = [[NSString alloc] initWithData:[cipData AES256DecryptWithKey:HTTP_APPKEY] encoding:NSUTF8StringEncoding];
        cipData = [data dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        if (cipData) {
            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:cipData options:0 error:&error];
            if (success) {
                success(dictData);
            }
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 告诉外界(外面):我们请求失败了
        if (failure) {
            failure(error);
        }
        
    }];
}


@end
