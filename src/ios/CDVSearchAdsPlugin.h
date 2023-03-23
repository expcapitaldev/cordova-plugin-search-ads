#import <Cordova/CDVPlugin.h>

@interface SearchAdsPlugin : CDVPlugin
- (void)requestAttributionDetails:(CDVInvokedUrlCommand*)command;
- (void)getAttributionToken:(CDVInvokedUrlCommand*)command;
@end
