#import "CDVSearchAdsTool.h"
#import <iAd/iAd.h>
#import <AdServices/AdServices.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation SearchAdsTool

+ (void) getAttributionTokenWithComplete: (void(^)(NSString *token, NSError *error))complete {
    NSError *error;
    if (@available(iOS 14.3, *)) {
        NSString *token = [AAAttribution attributionTokenWithError:&error];
        if (token != nil && token.length > 0) {
            complete(token, nil);
        } else {
            complete(nil, error);
        }
    } else {
        complete(nil, [[NSError alloc] initWithDomain:@"app" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Wrong iOS version"}]);
    }
}

+ (void)requestAttributionWithComplete:(void(^)(NSDictionary *data, NSError *error))complete {
    if (@available(iOS 14.3, *)) {
        NSError *error;
        NSString *token = [AAAttribution attributionTokenWithError:&error];
        if (token != nil && token.length > 0) {
            [self requestAttributionWithToken:token complete:complete];
        } else {
            complete(nil, error);
        }
    } else {
        BOOL enable = true;
        if (@available(iOS 14.0, *)) {
            ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
            enable = status == ATTrackingManagerAuthorizationStatusNotDetermined || status == ATTrackingManagerAuthorizationStatusAuthorized;
//            if (@available(iOS 14.5, *)) {
//                enable = status == ATTrackingManagerAuthorizationStatusAuthorized;
//            }
        }

        if (enable) {
            if ([[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
                [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary<NSString *,NSObject *> * _Nullable attributionDetails, NSError * _Nullable error) {
                    if (error != nil) {
                        complete(nil, error);
                    } else {
                        NSString *key = [attributionDetails allKeys].firstObject;
                        if (key != nil) {
                            NSDictionary *dict = (NSDictionary *)attributionDetails[key];
                            complete(dict, nil);
                        } else {
                            complete(nil, [[NSError alloc] initWithDomain:@"app" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Data is Empty"}]);
                        }
                    }
                }];
            } else {
                complete(nil, [[NSError alloc] initWithDomain:@"app" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"ADClient error"}]);
            }
        } else {
            complete(nil, [[NSError alloc] initWithDomain:@"app" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"ATTracking Not Allowed"}]);
        }
    }
}

+ (void)requestAttributionWithToken:(NSString *)token complete:(void(^)(NSDictionary *data, NSError *error))complete {
    NSString *url = [NSString stringWithFormat:@"https://api-adservices.apple.com/api/v1/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    [request addValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    NSData *postData = [token dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *result = NULL;
        if (error) {
            if (complete) {
                complete(nil, error);
            }
        }else{
            NSError *error;
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            result = [[NSDictionary alloc] initWithDictionary:dict];
            if (complete) {
                complete(result, nil);
            }
        }
    }];
    [dataTask resume];
}

@end
