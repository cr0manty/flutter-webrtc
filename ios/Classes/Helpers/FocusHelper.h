//
//  FocusHelper.h
//  flutter_webrtc
//
//  Created by Denys Dudka on 29.12.2021.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FlutterPluginRegistrar;
@class FlutterWebRTCPlugin;


@interface FocusHelper : NSObject

+(void)registerAdditionalHandlers:(NSObject<FlutterPluginRegistrar>*)registrar
                          instance:(FlutterWebRTCPlugin*)instance;

+(void)addObservers:(AVCaptureDevice*)device
           instance:(id)instance;

+(void)removeObservers:(AVCaptureDevice*)device
              instance:(id)instance;

-(BOOL)isFocusModeSupported:(AVCaptureDevice*)device
                    modeNum:(NSInteger)modeNum;

-(BOOL)isLockingFocusWithCustomLensPositionSupported:(AVCaptureDevice*)device;

-(AVCaptureFocusMode)getFocusMode:(AVCaptureDevice*)device;

-(NSArray*)getSupportedFocusMode:(AVCaptureDevice*)device;

-(BOOL)isFocusPointOfInterestSupported:(AVCaptureDevice*)device;

-(BOOL)setFocusMode:(AVCaptureDevice*)device
               modeNum:(NSInteger)modeNum;

-(BOOL)setFocusPoint:(AVCaptureDevice*)device
                point:(CGPoint)point;

-(BOOL)setFocusPointLocked:(AVCaptureDevice*)device
                lensPosition:(float)lensPosition;

-(float)getFocusPointLocked:(AVCaptureDevice*)device;

-(CGPoint)getCGPointForCoordsWithOrientation:(UIDeviceOrientation)orientation
                                            x:(double)x
                                            y:(double)y;

-(void)applyExposureMode:(AVCaptureDevice*)device;

@end

NS_ASSUME_NONNULL_END
