#import "RnUnifiedPush.h"
#import <AGDeviceRegistration.h>

static NSData* _deviceToken;
static NSDictionary* _config;
static RCTResponseSenderBlock _callback;
static RCTResponseSenderBlock _messageHandler;

@implementation RnUnifiedPush

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    // TODO: Implement some actually useful functionality
    callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
}

+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  _deviceToken = deviceToken;
  if (_callback != nil) {
    [RnUnifiedPush registerToUPS: _callback];
  }
}

+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
  if (_messageHandler != nil) {
    _messageHandler(@[ userInfo[@"aps"][@"alert"][@"body"] ]);
  }
}

RCT_EXPORT_METHOD(initialize: (NSDictionary*)config onSuccess: (RCTResponseSenderBlock)callback) {
  _config = config;
  if (_config != nil) {
    [RnUnifiedPush registerToUPS:callback];
  } else {
    _callback = callback;
  }
}

+ (void)registerToUPS: (RCTResponseSenderBlock)callback {
  AGDeviceRegistration *d = [[AGDeviceRegistration alloc] initWithServerURL:[NSURL URLWithString:_config[@"url"]]];
  [d registerWithClientInfo:^(id<AGClientDeviceInformation> clientInfo) {
    [clientInfo setDeviceToken:_deviceToken];
    [clientInfo setVariantID:_config[@"variantId"]];
    [clientInfo setVariantSecret:_config[@"secret"]];
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    // set some 'useful' hardware information params
    [clientInfo setOperatingSystem:[currentDevice systemName]];
    [clientInfo setOsVersion:[currentDevice systemVersion]];
    [clientInfo setDeviceType:[currentDevice model]];
  } success:^{
      NSLog(@"RN-IOS => UnifiedPush Server registration worked");
      NSLog(@"RN-IOS => Invoking callback");
      callback(@[[NSNull null], @"Wow! Done!"]);
      NSLog(@"RN-IOS => Callback invoked");
  } failure:^(NSError * err) {
    NSLog(@"RN-IOS => UnifiedPush Server registration Error: %@", err);
    callback(@[err]);
  }];
}

RCT_EXPORT_METHOD(registerMessageHandler: (RCTResponseSenderBlock)callback) {
  _messageHandler = callback;
}

RCT_EXPORT_METHOD(unregisterMessageHandler: (RCTResponseSenderBlock)callback) {
  _messageHandler = nil;
}


@end
