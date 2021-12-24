//
//  VideoHelper.h
//  flutter_webrtc
//
//  Created by Denys Dudka on 23.12.2021.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoHelper : NSObject

#pragma mark - lens switching

-(int)cameraLensAmount;

-(AVCaptureDevice*)getWideAngleCamera;

#pragma mark zoom

-(BOOL)setZoom:(AVCaptureDevice*)device
          zoom:(NSInteger)zoom;

-(float)getMaxZoomFactor:(AVCaptureDevice*)device;

-(float)getMinZoomFactor:(AVCaptureDevice*)device;

-(float)getZoomFactor:(AVCaptureDevice*)device;

#pragma mark - focus

-(AVCaptureFocusMode)isFocusModeSupported:(AVCaptureDevice*)device
                    modeNum:(NSInteger)modeNum;

-(BOOL)getFocusMode:(AVCaptureDevice*)device;

-(BOOL)setFocusMode:(AVCaptureDevice*)device
               modeNum:(NSInteger)modeNum;

-(BOOL)setFocusPoint:(AVCaptureDevice*)device
                point:(CGPoint)point;

-(BOOL)setFocusPointLocked:(AVCaptureDevice*)device
                lensPosition:(float)lensPosition;

-(float)getFocusPointLocked:(AVCaptureDevice*)device;

#pragma  mark - white balance

-(AVCaptureWhiteBalanceMode)getWhiteBalanceMode:(AVCaptureDevice*)device;

-(BOOL)isWhiteBalanceModeSupported:(AVCaptureDevice*)device
                           modeNum:(NSInteger)modeNum;

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

#pragma exposure change

-(BOOL)isExposureModeSupported:(AVCaptureDevice*)device
                       modeNum:(NSInteger)modeNum;

-(BOOL)setExposureMode:(AVCaptureDevice*)device
               modeNum:(NSInteger)modeNum;

-(BOOL)changeISO:(AVCaptureDevice*)device
           value:(float)value;

-(BOOL)changeBias:(AVCaptureDevice*)device
            value:(float)value;

-(float)getMaxBalanceGains:(AVCaptureDevice*)device;

-(AVCaptureWhiteBalanceGains)getCurrentBalanceGains:(AVCaptureDevice*)device;

-(AVCaptureWhiteBalanceTemperatureAndTintValues)getCurrentTemperatureBalanceGains:(AVCaptureDevice*)device;

-(BOOL)changeExposureDuration:(AVCaptureDevice*)device
                         value:(float)value;



@end

NS_ASSUME_NONNULL_END
