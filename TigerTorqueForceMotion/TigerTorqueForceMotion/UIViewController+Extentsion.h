//
//  UIViewController+Extentsion.h
//  Tiger Torque ForceMotion
//
//  Created by Tiger Torque ForceMotion on 2024/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extentsion)

- (void)TorqueSendEventsWithParams:(NSString *)params;

- (void)TorqueSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)TorqueAppsFlyerDevKey;

- (NSString *)TorqueMainHostUrl;

- (NSString *)TorqueMainPrivacyUrl;

- (BOOL)TorqueNeedShowAds;

- (void)TorqueShowAdViewC:(NSString *)adsUrl;

- (NSDictionary *)TorqueJsonToDicWithJsonString:(NSString *)jsonString;

- (void)TorqueShowAlertWithTitle:(NSString *)title message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
