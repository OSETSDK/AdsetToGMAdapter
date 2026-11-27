//
//  OSETCustomerGmInitAdapter.m
//  BUADDemo
//
//  Created by Shens on 5/3/2025.
//  Copyright © 2025 bytedance. All rights reserved.
//

#import "OSETCustomerGmInitAdapter.h"
#import <Adset/OSETSDK.h>
@interface OSETCustomerGmInitAdapter ()
/** 最近一次初始化的完成结果，供 GroMore 查询。 */
@property (atomic, assign) BOOL initializationSucceeded;
@end

@implementation OSETCustomerGmInitAdapter

/// 该自定义adapter是基于哪个版本实现的，填写编写时的最新值即可，GroMore会根据该值进行兼容处理
- (BUMCustomAdapterVersion *)basedOnCustomAdapterVersion {
    return BUMCustomAdapterVersion1_1;
}

/** 初始化 OSET SDK，完成后更新 GroMore 可查询的渠道状态。
 * @param initConfig GroMore 下发的 App ID 和其他渠道配置；OSET 初始化仅使用 App ID。
 */
- (void)initializeAdapterWithConfiguration:(BUMSdkInitConfig *_Nullable)initConfig {
    NSString *appId = initConfig.appID;
#if DEBUG
    NSLog(@"hh [OSETGroMoreAdapter] 奇点初始化开始，后台下发 appId=%@", @"<redacted>");
#endif
    self.initializationSucceeded = NO;
    if (!appId.length) {
#if DEBUG
        NSLog(@"hh [OSETGroMoreAdapter] 初始化失败，App ID 为空");
#endif
        return;
    }

    [OSETManager configureWithAppId:appId completion:^(BOOL success, NSError *error) {
        self.initializationSucceeded = success;
#if DEBUG
        NSLog(@"hh [OSETGroMoreAdapter] 奇点初始化结果 appId=%@ success=%d errorCode=%ld", @"<redacted>", success, (long)error.code);
#endif
    }];
}

/// adapter的版本号
- (NSString *_Nonnull)adapterVersion {
    return @"8.0.0.0";
}

/// adn的版本号
- (NSString *_Nonnull)networkSdkVersion {
    return [OSETManager version];
}

/// 隐私权限更新，用户更新隐私配置时触发，初始化方法调用前一定会触发一次
- (void)didRequestAdPrivacyConfigUpdate:(NSDictionary *)config {
    /// 处理隐私问题
}

- (nonnull NSMutableDictionary *)adnInitInfo {
    return [[NSMutableDictionary alloc] initWithDictionary:@{@"status":@(self.initializationSucceeded)}];
}

- (void)didReceiveConfigUpdateRequest:(nonnull BUMUserConfig *)config {

}

@end
