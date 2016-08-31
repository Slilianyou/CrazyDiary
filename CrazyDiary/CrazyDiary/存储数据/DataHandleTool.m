//
//  DataHandleTool.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/29.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "DataHandleTool.h"

@implementation DataHandleTool
+ (id)manage
{
    static DataHandleTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[DataHandleTool alloc]init];
    });
    return _tool;
}
- (void)loadData
{
    // 检查数据库是否存在；
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isFileExist = [fileManager fileExistsAtPath:[self getDBPath]];
    if (!isFileExist) {
        FMDatabase *db = [FMDatabase databaseWithPath:[self getDBPath]];
        if ([db open]) {
            // 初始化数据库
            [db executeUpdate:@"CREATE TABLE DiaryCacheList (pid text, context text, updateTime text,create_id text)"];
            [db executeUpdate:@"CREATE TABLE DiaryImageList (imagePath text,imageName text,cid text,updateTime text,height text,width text,image_description text,pid text)"];
        } else {
            // 失败
        }
        
        [db close];
    }
    // 加载本地数据
    [self loadDiaryList];
}
#pragma mark --加载本地数据
- (void)loadDiaryList
{
    if (!self.diaryList) {
        self.diaryList = [NSMutableArray arrayWithCapacity:0];
    }
    [self.diaryList removeAllObjects];
    
    NSMutableArray *datalist = [NSMutableArray arrayWithCapacity:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([db open]) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM DiaryCacheList"];
        while ([result next]) {
            DiaryModel *diaryModel = [[DiaryModel alloc]init];
            diaryModel.pid = [result stringForColumn:@"pid"];
            diaryModel.content = [result stringForColumn:@"content"];
            diaryModel.updateTime = [result stringForColumn:@"updateTime"];
            diaryModel.create_id = [result stringForColumn:@"create_id"];
            
            // 更新数据
            NSMutableArray *imagelist = [NSMutableArray array];
            NSString *searchStr = [NSString stringWithFormat:@"SELECT * FROM DiaryImageList WHERE cid = '%@'",diaryModel.create_id];
            FMResultSet *result = [db executeQuery:searchStr];
            while ([result next]) {
                IMAGEDATA *imagedata = [[IMAGEDATA alloc]init];
                imagedata.imageName = [result stringForColumn:@"imageName"];
                imagedata.imagePath = [result stringForColumn:@"imagePath"];
                imagedata.cid = [result stringForColumn:@"cid"];
                imagedata.updateTime = [result stringForColumn:@"updateTime"];
                imagedata.height = [result stringForColumn:@"height"];
                imagedata.image_description = [result stringForColumn:@"image_description"];
                imagedata.pid = [result stringForColumn:@"pid"];
                
                //
                NSString *path = [self getImagePath];
                NSString *imagePath = [path stringByAppendingPathComponent:imagedata.imageName];
                imagedata.imagePath = imagePath;
                [imagelist addObject:imagedata];
            }
            diaryModel.images = [[NSMutableArray alloc]initWithArray:imagelist];
            [self sortImageList:diaryModel];
            [datalist addObject:diaryModel];
        }
    }
    
    [db close];
    
    [self.diaryList addObjectsFromArray:[[datalist reverseObjectEnumerator]allObjects]];
}

// 对图片数组排序（排序网络详情数据）
- (void)sortImageList:(DiaryModel *)data
{
    
}

#pragma mark --数据库路径
- (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"diaryCache.db"];
    NSLog(@"db路径－－－－%@",dbPath);
    return dbPath;
}

#pragma mark - GETIMAGEPATH
- (NSString *)getImagePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *userImagesPath = [documentsDirectory stringByAppendingPathComponent:@"userImages"];
    if (![fileManager fileExistsAtPath:userImagesPath]) {
        [fileManager createDirectoryAtPath:userImagesPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    CLog(@"%@",userImagesPath);

    return userImagesPath;
}
























@end
