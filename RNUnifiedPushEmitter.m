//
//  RNUnifiedPushEmitter.m
//  RnUnifiedPush
//
//  Created by Massimiliano Ziccardi on 01/05/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RnUnifiedPushEmitter.h"

@implementation RNUnifiedPushEmitter

RCT_EXPORT_MODULE();


- (NSArray<NSString *> *)supportedEvents {
    return @[@"onUPSPushNotificationReceived"];
}


- (void)startObserving
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(sendEvent:)
                                               name:@"event-emitted"
                                              object:nil
   ];
}

- (void)stopObserving
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)sendEvent:(NSNotification *)notification {
  [self sendEventWithName:@"onUPSPushNotificationReceived" body:notification.userInfo];
}

+ (void)emitEvent:(NSDictionary*) payload
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"event-emitted"
                                                      object:self
                                                    userInfo:payload
   ];
}

@end
