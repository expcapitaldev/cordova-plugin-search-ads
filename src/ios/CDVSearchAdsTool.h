#import <Foundation/Foundation.h>

@interface SearchAdsTool : NSObject
+ (void)requestAttributionWithComplete:(void(^)(NSDictionary *data, NSError *error))complete;
+ (void)getAttributionTokenWithComplete:(void(^)(NSString *token, NSError *error))complete;
@end

