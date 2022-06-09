//
//  FlutterDataHandler.h
//  flutter_webrtc
//
//  Created by Denys Dudka on 29.12.2021.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <Flutter/Flutter.h>
#elif TARGET_OS_MAC
#import <FlutterMacOS/FlutterMacOS.h>
#endif


NS_ASSUME_NONNULL_BEGIN

@interface FlutterSinkDataHandler : NSObject<FlutterStreamHandler>
@property (nonatomic, copy) FlutterEventSink _Nullable sink;
@end

NS_ASSUME_NONNULL_END
