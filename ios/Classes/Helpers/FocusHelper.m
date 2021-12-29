//
//  FocusHelper.m
//  flutter_webrtc
//
//  Created by Denys Dudka on 29.12.2021.
//

#import "FocusHelper.h"
#import "FlutterDataHandler.h"
#import "FlutterWebRTCPlugin.h"

#if TARGET_OS_IPHONE
#import <Flutter/Flutter.h>
#elif TARGET_OS_MAC
#import <FlutterMacOS/FlutterMacOS.h>
#endif


@implementation FocusHelper

+(void)registerAdditionalHandlers:(NSObject<FlutterPluginRegistrar>*)registrar
                         instance:(FlutterWebRTCPlugin*)instance {
    FlutterEventChannel* focusModeDataChannel = [FlutterEventChannel
                                        eventChannelWithName:@"focusModeHandler.dataChannel"
                                        binaryMessenger: [registrar messenger]];
    FlutterSinkDataHandler *focusModeDataHandler = [[FlutterSinkDataHandler alloc]init];
    [focusModeDataChannel setStreamHandler:focusModeDataHandler];
    instance.focusModeHandler = focusModeDataHandler;
    
    FlutterEventChannel* focusLensPositionChannel = [FlutterEventChannel
                                                     eventChannelWithName:@"focusLensPositionHandler.dataChannel"
                                                     binaryMessenger: [registrar messenger]];
    FlutterSinkDataHandler *focusLensPositionHandler = [[FlutterSinkDataHandler alloc]init];
    [focusLensPositionChannel setStreamHandler:focusLensPositionHandler];
    instance.focusLensPositionHandler = focusLensPositionHandler;
}

-(BOOL)isFocusModeSupported:(AVCaptureDevice*)device
                    modeNum:(NSInteger)modeNum {
    AVCaptureFocusMode mode = (AVCaptureFocusMode)modeNum;
    
    return [device isFocusModeSupported:mode];
}

-(NSArray*)getSupportedFocusMode:(AVCaptureDevice*)device {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([device isFocusModeSupported:AVCaptureFocusModeLocked]) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureFocusModeLocked]];
    }
    
    if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureFocusModeAutoFocus]];
    }
    
    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureFocusModeContinuousAutoFocus]];
    }
    
    return array;
}

-(AVCaptureFocusMode)getFocusMode:(AVCaptureDevice*)device {
    return [device focusMode];
}

-(BOOL)setFocusMode:(AVCaptureDevice*)device
            modeNum:(NSInteger)modeNum {
    AVCaptureFocusMode mode = (AVCaptureFocusMode)modeNum;
    
    if (![device isFocusModeSupported:mode]) {
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
    if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
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


@end
