//
//  WhiteBalanceHelper.h
//  flutter_webrtc
//
//  Created by Denys Dudka on 29.12.2021.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol FlutterPluginRegistrar;
@class FlutterWebRTCPlugin;


@interface WhiteBalanceHelper : NSObject

+(void)registerAdditionalHandlers:(NSObject<FlutterPluginRegistrar>*)registrar
                          instance:(FlutterWebRTCPlugin*)instance;

-(AVCaptureWhiteBalanceMode)getWhiteBalanceMode:(AVCaptureDevice*)device;

-(NSArray*)getSupportedWhiteBalanceMode:(AVCaptureDevice*)device;

-(BOOL)isWhiteBalanceModeSupported:(AVCaptureDevice*)device
                           modeNum:(NSInteger)modeNum;

-(BOOL)isWhiteBalanceLockSupported:(AVCaptureDevice*)device;

-(BOOL)setWhiteBalanceMode:(AVCaptureDevice*)device
                   modeNum:(NSInteger)modeNum;

-(BOOL)setWhiteBalance:(AVCaptureDevice*)device
                  gains:(AVCaptureWhiteBalanceGains)gains;

-(BOOL)changeWhiteBalanceTemperature:(AVCaptureDevice*)device
                         temperature:(float)temperature
                                tint:(float)tint;

-(AVCaptureWhiteBalanceGains)normalizedGains:(AVCaptureDevice*)device
                                       gains:(AVCaptureWhiteBalanceGains) gains;

-(BOOL)lockWithGrayWorld:(AVCaptureDevice*)device;

-(float)getMaxBalanceGains:(AVCaptureDevice*)device;

-(AVCaptureWhiteBalanceGains)getCurrentBalanceGains:(AVCaptureDevice*)device;

-(AVCaptureWhiteBalanceTemperatureAndTintValues)getCurrentTemperatureBalanceGains:(AVCaptureDevice*)device;

@end

NS_ASSUME_NONNULL_END
