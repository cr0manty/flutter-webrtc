//
//  FlutterDataHandler.m
//  flutter_webrtc
//
//  Created by Denys Dudka on 29.12.2021.
//

#import "FlutterDataHandler.h"

@interface FlutterSinkDataHandler()

@end

@implementation FlutterSinkDataHandler

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.sink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.sink = events;
    return nil;
}

@end
