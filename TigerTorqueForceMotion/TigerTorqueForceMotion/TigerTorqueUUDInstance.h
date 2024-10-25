//
//  RatFindUUDInstance.h
//  RatSpiFind
//
//  Created by RatSpiFind on 2024/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TigerTorqueUUDInstance : NSObject

+ (instancetype)sharedInstance;

- (NSString *)getUUID;

@end

NS_ASSUME_NONNULL_END
