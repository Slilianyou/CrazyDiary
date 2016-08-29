//
//  MyAFNetWork.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/22.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef  void (^myBlock)(id myAFNetworkResponeDic);
@interface MyAFNetWork : NSObject
+ (void)sendImageMethodWithImageData:(NSData *)data andParameters:(id)parameters andImageName:(NSString *)imageName andBlock:(myBlock)myRespBlock;















@end
