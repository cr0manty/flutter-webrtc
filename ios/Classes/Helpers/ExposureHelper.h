//
//  ExposureHelper.h
//  flutter_webrtc
//
//  Created by Denys Dudka on 29.12.2021.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol FlutterPluginRegistrar;
@class FlutterWebRTCPlugin;


@interface ExposureHelper : NSObject

+(void)registerAdditionalHandlers:(NSObject<FlutterPluginRegistrar>*)registrar
                          instance:(FlutterWebRTCPlugin*)instance;

+(NSDictionary*)getExposureDurationSeconds:(AVCaptureDevice*)device
                                  duration:(CMTime) duration;

-(BOOL)isExposureModeSupported:(AVCaptureDevice*)device
                       modeNum:(NSInteger)modeNum;

-(NSArray*)getSupportedExposureMode:(AVCaptureDevice*)device;

-(BOOL)setExposureMode:(AVCaptureDevice*)device
               modeNum:(NSInteger)modeNum;

-(AVCaptureExposureMode)getExposureMode:(AVCaptureDevice*)device;

-(BOOL)changeISO:(AVCaptureDevice*)device
           value:(float)value;

-(float)getISO:(AVCaptureDevice*)device;

-(float)getMinISO:(AVCaptureDevice*)device;

-(float)getMaxISO:(AVCaptureDevice*)device;

-(float)getExposureTargetOffset:(AVCaptureDevice*)device;

-(BOOL)changeBias:(AVCaptureDevice*)device
            value:(float)value;

-(float)getExposureTargetBias:(AVCaptureDevice*)device;

-(float)getMaxExposureTargetBias:(AVCaptureDevice*)device;

-(float)getMinExposureTargetBias:(AVCaptureDevice*)device;

-(CMTime)minExposureDuration:(AVCaptureDevice*)device;

-(CMTime)maxExposureDuration:(AVCaptureDevice*)device;

-(BOOL)changeExposureDuration:(AVCaptureDevice*)device
                         value:(float)value;

-(CMTime)getExposureDuration:(AVCaptureDevice*)device;

-(NSDictionary*)getExposureDurationSeconds:(AVCaptureDevice*)device;


@end

NS_ASSUME_NONNULL_END
