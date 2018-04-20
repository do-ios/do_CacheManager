//
//  do_CacheManager_SM.m
//  DoExt_API
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_CacheManager_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doISourceFS.h"
#import "doServiceContainer.h"
#import "doIGlobal.h"
#import "doIOHelper.h"

@implementation do_CacheManager_SM
#pragma mark - 方法
#pragma mark - 同步异步方法的实现
//同步
//异步
- (void)clearImageCache:(NSArray *)parms
{
    //异步耗时操作，但是不需要启动线程，框架会自动加载一个后台线程处理这个函数
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    NSString *_callbackName = [parms objectAtIndex:2];
    //回调函数名_callbackName
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
    //_invokeResult设置返回值

    @try {
        NSString * _dirFullPath = [self getPath];
        if(![doIOHelper ExistDirectory:_dirFullPath]){
            [_invokeResult SetResultBoolean:YES];
        }else{
            BOOL result = [[NSFileManager defaultManager] removeItemAtPath:_dirFullPath error:nil];
            [_invokeResult SetResultBoolean:result];
        }
    }
    @catch (NSException *exception) {
        [_invokeResult SetResultBoolean:NO];
    }
    @finally {
    }
    [_scritEngine Callback:_callbackName :_invokeResult];
}

- (NSString *)getPath
{
    NSString *_dataRoot = [NSString stringWithFormat:@"%@/main/%@/data", [doServiceContainer Instance].Global.DataRootPath ,@"app"];
    NSString *cachePath = [NSString stringWithFormat:@"%@/sys/imagecache",_dataRoot];
    
    return cachePath;
}

- (void)getImageCacheSize:(NSArray *)parms
{
    //异步耗时操作，但是不需要启动线程，框架会自动加载一个后台线程处理这个函数
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    NSString *_callbackName = [parms objectAtIndex:2];
    //回调函数名_callbackName
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
    //_invokeResult设置返回值
    
    NSString *cachePath = [self getPath];
    float size = [self directorySizeAtPath:cachePath];
    
    [_invokeResult SetResultText:[@(size) stringValue]];
    [_scritEngine Callback:_callbackName :_invokeResult];

}

- (float)directorySizeAtPath:(NSString*) path{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        folderSize += [self imageSizeAtPath:fileAbsolutePath];
    }
    return folderSize/1024.0;
}
     
- (long long)imageSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end