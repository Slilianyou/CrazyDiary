//
//  MyAFNetWork.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/22.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "MyAFNetWork.h"
#import <AFNetworking.h>
#import "JSONKit.h"

@implementation MyAFNetWork
+ (void)sendImageMethodWithImageData:(NSData *)data andParameters:(id)parameters andImageName:(NSString *)imageName andBlock:(myBlock)myRespBlock
{
    AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
    httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpSessionManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    httpSessionManager.requestSerializer.timeoutInterval = 30.f;
    httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [httpSessionManager POST:@" " parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:imageName fileName:[NSString stringWithFormat:@"%@.png",imageName] mimeType:@"image/jpeg"];  
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        myRespBlock([responseObject JSONString]);
       
        NSLog(@"%@",[responseObject JSONString]);
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        myRespBlock([error localizedDescription]);
        
    }];
}























@end
