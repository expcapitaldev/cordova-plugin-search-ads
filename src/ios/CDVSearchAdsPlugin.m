#import "CDVSearchAdsPlugin.h"
#import "CDVSearchAdsTool.h"

static NSString*const LOG_TAG = @"SearchAdsPlugin[native]";

@interface SearchAdsPlugin () {}
@end

@implementation SearchAdsPlugin

// @override abstract
- (void)pluginInitialize {
    NSLog(@"Starting SearchAdsPlugin");
}


#pragma mark - plugin API

- (void) getAttributionToken:(CDVInvokedUrlCommand*)command {

    [self.commandDelegate runInBackground:^{
        @try {

            __weak SearchAdsPlugin* weakSelf = self;

            [SearchAdsTool getAttributionTokenWithComplete:^(NSString *token, NSError *error) {
                if (token) {
                    [weakSelf sendPluginStringResult: token command: command];
                } else {
                    [weakSelf sendPluginErrorWithError:error command:command];
                }
            }];

        }@catch (NSException *exception) {
            [self handlePluginExceptionWithContext:exception :command];
        }
    }];
}



- (void) requestAttributionDetails:(CDVInvokedUrlCommand*)command {

    [self.commandDelegate runInBackground:^{
        @try {

        	__weak SearchAdsPlugin* weakSelf = self;

            [SearchAdsTool requestAttributionWithComplete:^(NSDictionary * _Nonnull data, NSError * _Nonnull error) {
                if (data) {
                    [weakSelf sendPluginDictionaryResult:data command:command];
                } else {
                    [weakSelf sendPluginErrorWithError:error command:command];
                }
            }];

        }@catch (NSException *exception) {
            [self handlePluginExceptionWithContext:exception :command];
        }
    }];
}

#pragma mark - utility functions

- (void) sendPluginStringResult:(NSString*)result command:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) sendPluginDictionaryResult:(NSDictionary*)result command:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) sendPluginErrorWithError:(NSError*)error command:(CDVInvokedUrlCommand*)command{
    CDVPluginResult *pluginResult =
          [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                        messageAsDictionary:@{
                          @"code" : error.code
                              ? [NSString stringWithFormat:@"%ld", (long)error.code]
                              : @"",
                          @"localizedDescription" : error.localizedDescription
                              ? error.localizedDescription
                              : @""
                        }];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) handlePluginExceptionWithContext: (NSException*) exception :(CDVInvokedUrlCommand*)command
{
    [self _logError:[NSString stringWithFormat:@"EXCEPTION: %@", exception.reason]];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{@"reason" : exception.reason}];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)_logError: (NSString*)msg
{
    NSLog(@"%@ ERROR: %@", LOG_TAG, msg);
    NSString* jsString = [NSString stringWithFormat:@"console.error(\"%@: %@\")", LOG_TAG, [self escapeJavascriptString:msg]];
    [self executeGlobalJavascript:jsString];
}

- (NSString*)escapeJavascriptString: (NSString*)str
{
    NSString* result = [str stringByReplacingOccurrencesOfString: @"\\\"" withString: @"\""];
    result = [result stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""];
    result = [result stringByReplacingOccurrencesOfString: @"\n" withString: @"\\\n"];
    return result;
}

- (void)executeGlobalJavascript: (NSString*)jsString
{
    [self.commandDelegate evalJs:jsString];
}

@end
