# AdsetToGMAdapter

Adset 的 GroMore（Ads-CN-Beta） 适配器。版本 `8.0.0.0`，最低支持 iOS 13.0。

## Pod 接入

[Git 仓库](https://github.com/OSETSDK/AdsetToGMAdapter) · [Podspec](https://github.com/OSETSDK/AdsetToGMAdapter/blob/main/AdsetToGMAdapter.podspec)

在 Podfile 中配置提供 Adset 正式版本的 Specs 源，并通过适配器 Git 地址和版本 tag 接入：

```ruby
source 'https://github.com/OSETSDK/Adset.git'
source 'https://cdn.cocoapods.org/'
platform :ios, '13.0'
use_frameworks! :linkage => :static

target 'YourApp' do
  pod 'Adset', '>= 8.0.0.0'
  pod 'AdsetToGMAdapter', :git => 'https://github.com/OSETSDK/AdsetToGMAdapter.git', :tag => '8.0.0.0'
end
```

## 依赖

| Pod | 最低版本 |
| --- | --- |
| [Adset](https://github.com/OSETSDK/Adset) | `8.0.0.0` |
| `Ads-CN-Beta/CSJMediation` | `7.9.0.3` |

`CSJMediation` 已间接依赖同版本 `BUAdSDK`，无需重复添加基础 SDK。

## 自定义 ADN 配置

a01、在 GroMore 后台创建或选择 iOS 应用，添加自定义广告网络“奇点”，按下表填写 iOS 适配器类名。

a02、添加奇点广告源：应用 ID 填奇点媒体 App ID，渠道代码位 ID 填奇点对应格式的广告位 ID。初始化不需要奇点 App Key。

a03、信息流渲染模式需与奇点广告位一致。聚合 SDK 通过 `BUMAdLoadingParamExpressAdType` 下发：2 为自渲染，0、1 或未传为模板，无需添加 `isExpressAd`。

a04、应用通过 GroMore 聚合广告位 ID 请求广告；适配器分别从 `BUMSdkInitConfig.appID` 和加载方法的 `slotID` 读取奇点 App ID、广告位 ID。

| 用途 | iOS 适配器类名 |
| --- | --- |
| 初始化 | `OSETCustomerGmInitAdapter` |
| 开屏 | `OSETCustomerGmSplashAdapter` |
| 插屏 | `OSETCustomerGmInterstitialAdapter` |
| 激励视频 | `OSETCustomerGmRewardAdapter` |
| Banner | `OSETCustomerGmBannerAdapter` |
| 信息流模板／自渲染 | `OSETCustomerGmNativeAdapter` |

类名不加 `.h`／`.m` 后缀。平台自身 App ID／App Key 用于初始化聚合平台，与奇点渠道参数分别配置。

后台操作参考 [第三方 ADN 接入说明](https://doc.shenshiads.com/IOS.html#gromore适配器接入)，Pod 名称和参数兼容规则以本文为准。

## 使用要求

- 宿主保留 `-ObjC` 链接参数，按平台文档完成聚合 SDK 初始化。
- 加载成功后再展示；在主线程传入有效的控制器或窗口。
- GM 与 CSJ 适配器含同名类，同一个 App target 仅选择一套。

许可证：[Apache 2.0](LICENSE)。
