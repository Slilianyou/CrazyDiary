//
//  CustomizedNSLog.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/30.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#ifndef CustomizedNSLog_h
#define CustomizedNSLog_h

// 可变参数宏  ## __VA_ARGS__
#ifdef DEBUG
#define CLog(format,...)  NSLog(format,## __VA_ARGS__)
#define EnableLog 1

#else
#define CLog(format,...)
#define EnableLog 0

#endif

#if (EnableLog)
#define NSLog(s, ... ) printf("\n%s\n%s\n",[[NSString stringWithFormat:@"%@",[NSDate date]] UTF8String],[[NSString stringWithFormat:@"%@\n%@\n%d\n%@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],[NSString stringWithUTF8String:__func__],__LINE__,[NSString stringWithFormat:(s),## __VA_ARGS__]] UTF8String])

#else
#define NSLog(s, ... )

#endif





#endif /* CustomizedNSLog_h */
