//
//  do_CacheManager_App.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_CacheManager_App.h"
static do_CacheManager_App* instance;
@implementation do_CacheManager_App
@synthesize OpenURLScheme;
+(id) Instance
{
    if(instance==nil)
        instance = [[do_CacheManager_App alloc]init];
    return instance;
}
@end
