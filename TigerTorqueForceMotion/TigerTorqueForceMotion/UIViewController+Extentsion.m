//
//  UIViewController+Extentsion.m
//  Tiger Torque ForceMotion
//
//  Created by Tiger Torque ForceMotion on 2024/8/2.
//

#import "UIViewController+Extentsion.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

@implementation UIViewController (Extentsion)

+ (NSString *)TorqueAppsFlyerDevKey
{
    return [NSString stringWithFormat:@"%@5Zs5%@Tj6sm%@", @"R9CH", @"bytFg", @"kgG8"];
}

- (NSString *)TorqueMainHostUrl
{
    return [NSString stringWithFormat:@"%@%@", @"en.pur", @"evision.top"];
}

- (NSString *)TorqueMainPrivacyUrl
{
    return @"https://www.termsfeed.com/live/fcff5a4e-38e2-4e9e-b9b5-ab020e9a40a9";
}

- (BOOL)TorqueNeedShowAds
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBrazil = [countryCode isEqualToString:[NSString stringWithFormat:@"B%@",self.llK]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    return isBrazil && !isIpd;
}

- (NSString *)llK
{
    return @"R";
}

- (void)TorqueShowAdViewC:(NSString *)adsUrl
{
    if (adsUrl.length) {
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:@"TigerTorquePrivacyVC"];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

- (NSDictionary *)TorqueJsonToDicWithJsonString:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    } else {
        return nil;
    }
}

- (void)TorqueShowAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)TorqueSendEvent:(NSString *)event values:(NSDictionary *)value
{
    if ([event isEqualToString:[NSString stringWithFormat:@"fir%@", self.one]] || [event isEqualToString:[NSString stringWithFormat:@"rech%@", self.two]] || [event isEqualToString:[NSString stringWithFormat:@"with%@", self.three]]) {
        id am = value[@"amount"];
        NSString * cur = value[[NSString stringWithFormat:@"cur%@", self.four]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                AFEventParamRevenue: [event isEqualToString:[NSString stringWithFormat:@"with%@", self.three]] ? @(-niubi) : @(niubi),
                AFEventParamCurrency: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
    }
}

- (NSString *)one
{
    return @"strecharge";
}

- (NSString *)two
{
    return @"arge";
}

- (NSString *)three
{
    return @"drawOrderSuccess";
}

- (NSString *)four
{
    return @"rency";
}

- (void)TorqueSendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self TorqueJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

@end
