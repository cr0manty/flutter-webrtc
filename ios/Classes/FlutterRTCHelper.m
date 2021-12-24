//
//  VideoHelper.m
//  flutter_webrtc
//
//  Created by Denys Dudka on 23.12.2021.
//

#import "FlutterRTCHelper.h"
#import <AVFoundation/AVFoundation.h>
#include <math.h>

@implementation VideoHelper
__const float kExposureDurationPower = 5.0;
__const float kExposureMinimumDuration = 1.0/1000;

#pragma mark - lens switching

-(int)cameraLensAmount {
    if (@available(iOS 10.2, *)) {
        if ([AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack]) {
            return 3;
        } else if ([AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack]) {
            return 2;
        }
    }
    return 1;
}

-(AVCaptureDevice*)getWideAngleCamera {
    return [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
}

#pragma mark - set zoom

-(BOOL)setZoom:(AVCaptureDevice*)device
          zoom:(NSInteger)zoom {
    NSError *error;
    
    if([device lockForConfiguration:&error]) {
        [device setVideoZoomFactor:zoom];
        [device unlockForConfiguration];
        return TRUE;
    }
    
    if (error) {
        @throw [NSException exceptionWithName:@"Set Zoom excetion"
                                       reason:[NSString stringWithFormat:@"%@", error]
                                     userInfo:nil];
    }
    
    return  FALSE;
}

-(float)getMaxZoomFactor:(AVCaptureDevice*)device {
    if (@available(iOS 11.0, *)) {
        return [device maxAvailableVideoZoomFactor];
    } else {
        return 2;
    }
}

-(float)getMinZoomFactor:(AVCaptureDevice*)device {
    if (@available(iOS 11.0, *)) {
        return [device minAvailableVideoZoomFactor];
    } else {
        return 1;
    }
}

-(float)getZoomFactor:(AVCaptureDevice*)device {
    return [device videoZoomFactor];
}


#pragma mark - focus

-(BOOL)isFocusModeSupported:(AVCaptureDevice*)device
                    modeNum:(NSInteger)modeNum {
    AVCaptureFocusMode mode = (AVCaptureFocusMode)modeNum;
    
    return [device isFocusModeSupported:mode];
}

-(AVCaptureFocusMode)getFocusMode:(AVCaptureDevice*)device {
    return [device focusMode];
}

-(BOOL)setFocusMode:(AVCaptureDevice*)device
            modeNum:(NSInteger)modeNum {
    AVCaptureFocusMode mode = (AVCaptureFocusMode)modeNum;
    
    if (![self isFocusModeSupported: device modeNum: modeNum]) {
        return FALSE;
    }
    
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        [device setFocusMode:mode];
        [device unlockForConfiguration];
        return TRUE;
    }
    
    if (error) {
        @throw [NSException exceptionWithName:@"Set Focus Mode excetion"
                                       reason:[NSString stringWithFormat:@"%@", error]
                                     userInfo:nil];
    }
    
    return FALSE;
}

-(BOOL)setFocusPoint:(AVCaptureDevice*)device
               point:(CGPoint) point {
    if (device.isFocusPointOfInterestSupported &&[device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        NSError *error = nil;
        if([device lockForConfiguration:&error]) {
            
            
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [device setFocusPointOfInterest:point];
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
            }
            
            if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [device setExposurePointOfInterest:point];
                [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            [device unlockForConfiguration];
            return TRUE;
        }
        
        if (error) {
            @throw [NSException exceptionWithName:@"Set focus point excetion"
                                           reason:[NSString stringWithFormat:@"%@", error]
                                         userInfo:nil];
        }
        
    }
    return FALSE;
}

-(float)getFocusPointLocked:(AVCaptureDevice*)device {
    return [device lensPosition];
}

-(BOOL)setFocusPointLocked:(AVCaptureDevice*)device
              lensPosition:(float)lensPosition {
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        [device setFocusModeLockedWithLensPosition:lensPosition completionHandler: nil];
        [device unlockForConfiguration];
        return TRUE;
    }
    
    if (error) {
        @throw [NSException exceptionWithName:@"Set exposure mode excetion"
                                       reason:[NSString stringWithFormat:@"%@", error]
                                     userInfo:nil];
    }
    
    return FALSE;
}

#pragma mark - set exposure

-(BOOL)setExposureMode:(AVCaptureDevice*)device
               modeNum:(NSInteger)modeNum {
    AVCaptureExposureMode mode = (AVCaptureExposureMode)modeNum;
    
    if (![self isExposureModeSupported:device modeNum: modeNum]) {
        return FALSE;
    }
    
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        [device setExposureMode:mode];
        [device unlockForConfiguration];
        return TRUE;
    }
    
    if (error) {
        @throw [NSException exceptionWithName:@"Set exposure mode excetion"
                                       reason:[NSString stringWithFormat:@"%@", error]
                                     userInfo:nil];
    }
    
    return FALSE;
}

-(BOOL)isExposureModeSupported:(AVCaptureDevice*)device
                       modeNum:(NSInteger)modeNum {
    AVCaptureExposureMode mode = (AVCaptureExposureMode)modeNum;
    
    return [device isExposureModeSupported:mode];
}


-(BOOL)changeISO:(AVCaptureDevice*)device
           value:(float)value {
    NSError *error;
    
    if([device lockForConfiguration:&error]) {
        [device setExposureModeCustomWithDuration:device.exposureDuration ISO:value completionHandler:nil];
        [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
        
        [device unlockForConfiguration];
        return TRUE;
    }
    if (error) {
        @throw [NSException exceptionWithName:@"Change ISO excetion"
                                       reason:[NSString stringWithFormat:@"%@", error]
                                     userInfo:nil];
    }
    return FALSE;
}

-(BOOL)changeBias:(AVCaptureDevice*)device
            value:(float)value {
    NSError *error;
    
    if([device lockForConfiguration:&error]) {
        [device setExposureTargetBias:value completionHandler:nil];
        [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
        
        [device unlockForConfiguration];
        return TRUE;
    }
    if (error) {
        @throw [NSException exceptionWithName:@"Change bias excetion"
                                       reason:[NSString stringWithFormat:@"%@", error]
                                     userInfo:nil];
    }
    return FALSE;
}

-(BOOL) changeExposureDuration:(AVCaptureDevice*)device
                         value:(float)value {
    
    float p = pow(value, kExposureDurationPower); // Apply power function to expand slider's low-end range
    float minDurationSeconds = MAX(CMTimeGetSeconds(device.activeFormat.minExposureDuration), kExposureMinimumDuration);
    float maxDurationSeconds = CMTimeGetSeconds(device.activeFormat.maxExposureDuration);
    float newDurationSeconds = p * ( maxDurationSeconds - minDurationSeconds ) + minDurationSeconds; // Scale from 0-1 slider range to actual duration
    
    NSError *error;
    
    if([device lockForConfiguration:&error]) {
        [device setExposureModeCustomWithDuration:CMTimeMakeWithSeconds(newDurationSeconds, 1000*1000*1000) ISO:device.ISO completionHandler:nil];
        [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
        
        [device unlockForConfiguration];
        return TRUE;
    }
    if (error) {
        @throw [NSException exceptionWithName:@"Change exposure dureation excetion"
                                       reason:[NSString stringWithFormat:@"%@", error]
                                     userInfo:nil];
    }
    return FALSE;
}

# pragma mark - white balance

-(AVCaptureWhiteBalanceMode)getWhiteBalanceMode:(AVCaptureDevice*)device {
    return [device whiteBalanceMode];
}

-(BOOL)isWhiteBalanceModeSupported:(AVCaptureDevice*)device
                           modeNum:(NSInteger)modeNum {
    AVCaptureWhiteBalanceMode mode = (AVCaptureWhiteBalanceMode)modeNum;
    
    return [device isWhiteBalanceModeSupported:mode];
}

-(BOOL)setWhiteBalanceMode:(AVCaptureDevice*)device
                   modeNum:(NSInteger)modeNum {
    AVCaptureWhiteBalanceMode mode = (AVCaptureWhiteBalanceMode)modeNum;
    
    if (![self isWhiteBalanceModeSupported:device modeNum: modeNum]) {
        return FALSE;
    }
    
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        [device setWhiteBalanceMode:mode];
        [device unlockForConfiguration];
        return TRUE;
    }
    
    if (error) {
        @throw [NSException exceptionWithName:@"Set white balance mode excetion"
                                       reason:[NSString stringWithFormat:@"%@", error]
                                     userInfo:nil];
    }
    
    return FALSE;
}

-(BOOL)setWhiteBalance:(AVCaptureDevice*)device
                 gains:(AVCaptureWhiteBalanceGains)gains {
    
    AVCaptureWhiteBalanceGains normilizedGains = [self normalizedGains:device gains:gains];
    
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked]) {
        NSError *error = nil;
        
        if([device lockForConfiguration:&error]) {
            [device setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:normilizedGains completionHandler:nil];
            
            [device unlockForConfiguration];
            return TRUE;
        }
        if (error) {
            @throw [NSException exceptionWithName:@"Set white balance excetion"
                                           reason:[NSString stringWithFormat:@"%@", error]
                                         userInfo:nil];
        }
    }
    return FALSE;
}

-(BOOL)changeWhiteBalanceTemperature:(AVCaptureDevice*)device
                         temperature:(float)temperature
                                tint:(float)tint {
    AVCaptureWhiteBalanceTemperatureAndTintValues gains;
    gains.temperature = temperature;
    gains.tint = tint;
    
    AVCaptureWhiteBalanceGains normalGains = [device deviceWhiteBalanceGainsForTemperatureAndTintValues:gains];
    
    return [self setWhiteBalance:device gains:normalGains];
}


-(float)getMaxBalanceGains:(AVCaptureDevice*)device {
    return device.maxWhiteBalanceGain;
}

-(AVCaptureWhiteBalanceGains)getCurrentBalanceGains:(AVCaptureDevice*)device {
    return device.deviceWhiteBalanceGains;
}

-(AVCaptureWhiteBalanceTemperatureAndTintValues)getCurrentTemperatureBalanceGains:(AVCaptureDevice*)device {
    AVCaptureWhiteBalanceGains gains = device.deviceWhiteBalanceGains;
    AVCaptureWhiteBalanceGains normalizedGains = [self normalizedGains:device gains:gains];
    
    return [device temperatureAndTintValuesForDeviceWhiteBalanceGains:normalizedGains];
}

-(AVCaptureWhiteBalanceGains)normalizedGains:(AVCaptureDevice*)device
                                       gains:(AVCaptureWhiteBalanceGains) gains {
    AVCaptureWhiteBalanceGains g = gains;
    
    g.redGain = MAX(1.0, g.redGain);
    g.greenGain = MAX(1.0, g.greenGain);
    g.blueGain = MAX(1.0, g.blueGain);
    
    g.redGain = MIN(device.maxWhiteBalanceGain, g.redGain);
    g.greenGain = MIN(device.maxWhiteBalanceGain, g.greenGain);
    g.blueGain = MIN(device.maxWhiteBalanceGain, g.blueGain);
    
    return g;
}

-(BOOL)lockWithGrayWorld:(AVCaptureDevice*)device {
    AVCaptureWhiteBalanceGains gains = [device grayWorldDeviceWhiteBalanceGains];
    return [self setWhiteBalance:device gains:gains];
}

@end
