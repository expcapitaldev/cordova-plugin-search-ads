#import <Cordova/CDVPlugin.h>

@interface SearchAdsPlugin : CDVPlugin
- (void)requestAttributionDetails:(CDVInvokedUrlCommand*)command;
@end
