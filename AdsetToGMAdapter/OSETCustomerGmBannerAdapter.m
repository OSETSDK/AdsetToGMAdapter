#import "OSETCustomerGmBannerAdapter.h"
#import "OSETGmAdapterSupport.h"

@interface OSETCustomerGmBannerAdapter () <OSETBannerAdDelegate>
@property (nonatomic, strong) OSETBannerAd *bannerAd;
@property (nonatomic, strong) OSETBaseView *bannerView;
@end

@implementation OSETCustomerGmBannerAdapter

- (void)loadBannerAdWithSlotID:(NSString *)slotID andSize:(CGSize)adSize parameter:(NSDictionary *)parameter {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{ [self loadBannerAdWithSlotID:slotID andSize:adSize parameter:parameter]; });
        return;
    }

    self.bannerAd.delegate = nil;
    self.bannerAd = nil;
    self.bannerView = nil;
    UIViewController *controller = [self.bridge viewControllerForPresentingModalView];
    if (!slotID.length || !controller) {
        NSError *error = [NSError errorWithDomain:@"OSETGmBannerAdapter" code:72000
                                        userInfo:@{NSLocalizedDescriptionKey: @"Banner 广告位或展示控制器无效"}];
        [self.bridge bannerAd:self didLoadFailWithError:error ext:@{}];
        return;
    }

    CGFloat width = adSize.width > 0 ? adSize.width : CGRectGetWidth(controller.view.bounds);
    CGFloat height = adSize.height > 0 ? adSize.height : 80;
    self.bannerAd = [[OSETBannerAd alloc] initWithSlotId:slotID rootViewController:controller rect:CGRectMake(0, 0, width, height)];
    self.bannerAd.delegate = self;
    [self.bannerAd loadAdData];
}

- (BUMMediatedAdStatus)mediatedAdStatus {
    return self.bannerView ? BUMMediatedAdStatusNormal
        : BUMMediatedAdStatusMake(BUMMediatedAdStatusValueDeny, BUMMediatedAdStatusValueUnknown, BUMMediatedAdStatusValueDeny);
}

- (void)bannerDidReceiveSuccess:(id)banner slotId:(NSString *)slotId {
    if (![banner isKindOfClass:OSETBaseView.class]) {
        NSError *error = [NSError errorWithDomain:@"OSETGmBannerAdapter" code:72000
                                        userInfo:@{NSLocalizedDescriptionKey: @"奇点 Banner 未返回展示视图"}];
        [self bannerLoadToFailed:self.bannerAd error:error];
        return;
    }

    OSETBaseView *view = banner;
    self.bannerView = view;
    [self.bridge bannerAd:self didLoad:view ext:OSETGmLoadingExt(view.eCPM)];
}

- (void)bannerLoadToFailed:(id)banner error:(NSError *)error {
    if (!self.bannerAd || banner != self.bannerAd) { return; }
    self.bannerView = nil;
    [self.bridge bannerAd:self didLoadFailWithError:error ext:@{}];
}

- (void)bannerDidExposures:(id)banner {
    if (banner == self.bannerView) [self.bridge bannerAdDidBecomeVisible:self bannerView:banner];
}

- (void)bannerDidClick:(id)banner {
    if (banner == self.bannerView) [self.bridge bannerAdDidClick:self bannerView:banner];
}

- (void)bannerDidClose:(id)banner {
    if (banner != self.bannerView) { return; }
    self.bannerView = nil;
    self.bannerAd.delegate = nil;
    [self.bridge bannerAd:self bannerView:banner didClosedWithDislikeWithReason:nil];
}

- (void)didReceiveBidResult:(BUMMediaBidResult *)result {
    OSETGmReportBidResult(self.bannerView, result);
}

- (void)dealloc {
    _bannerAd.delegate = nil;
}

@end
