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

+(void)addObservers:(AVCaptureDevice*)device
           instance:(id)instance {
    [device addObserver:instance forKeyPath:@"focusMode" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [device addObserver:instance forKeyPath:@"lensPosition" options:NSKeyValueObservingOptionNew context:nil];
}

+(void)removeObservers:(AVCaptureDevice*)device
              instance:(id)instance {
    [device removeObserver:instance forKeyPath:@"focusMode" context:nil];
    [device removeObserver:instance forKeyPath:@"lensPosition" context:nil];
}

-(BOOL)isFocusModeSupported:(AVCaptureDevice*)device
                    modeNum:(NSInteger)modeNum {
    AVCaptureFocusMode mode = (AVCaptureFocusMode)modeNum;
    
    return [device isFocusModeSupported:mode];
}

-(BOOL)isLockingFocusWithCustomLensPositionSupported:(AVCaptureDevice*)device {
    return [device isLockingFocusWithCustomLensPositionSupported];
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

-(BOOL)isFocusPointOfInterestSupported:(AVCaptureDevice*)device {
    return device.isFocusPointOfInterestSupported;
}

-(BOOL)setFocusPoint:(AVCaptureDevice*)device
               point:(CGPoint)point {
    if (!device.isFocusPointOfInterestSupported || !device.isExposurePointOfInterestSupported) {
        @throw [NSException exceptionWithName:@"Set focus point failed"
                                       reason:@"Device does not have focus point capabilities"
                                     userInfo:nil];

    }
    
    
    
    NSError *error = nil;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if ([device lockForConfiguration:&error]) {
        CGPoint truePoint = [self getCGPointForCoordsWithOrientation:orientation
                                                                   x:point.x
                                                                   y:point.y];
        [device setFocusPointOfInterest:truePoint];
        [device setExposurePointOfInterest:truePoint];
        [device unlockForConfiguration];
        
        [self applyExposureMode: device];
    }
    
    if (error) {
        @throw [NSException exceptionWithName:@"Set focus point excetion"
                                       reason:[NSString stringWithFormat:@"%@", error]
                                     userInfo:nil];
    }
    
    return FALSE;
}

-(void)applyExposureMode:(AVCaptureDevice*)device {
    [device lockForConfiguration:nil];

    AVCaptureExposureMode mode = device.exposureMode;
    
    switch (mode) {
        case AVCaptureExposureModeLocked:
        case AVCaptureExposureModeCustom:
          [device setExposureMode:AVCaptureExposureModeAutoExpose];
          break;
        case AVCaptureExposureModeAutoExpose:
        case AVCaptureExposureModeContinuousAutoExposure:
          if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
          } else {
            [device setExposureMode:AVCaptureExposureModeAutoExpose];
          }
          break;
    }
    
    [device unlockForConfiguration];
}

-(CGPoint)getCGPointForCoordsWithOrientation:(UIDeviceOrientation)orientation
                                            x:(double)x
                                            y:(double)y {
    double oldX = x;
    double oldY = y;
    
    switch (orientation) {
    case UIDeviceOrientationPortrait:  // 90 ccw
      y = 1 - oldX;
      x = oldY;
      break;
    case UIDeviceOrientationPortraitUpsideDown:  // 90 cw
      x = 1 - oldY;
      y = oldX;
      break;
    case UIDeviceOrientationLandscapeRight:  // 180
      x = 1 - x;
      y = 1 - y;
      break;
    case UIDeviceOrientationLandscapeLeft:
    default:
      // No rotation required
      break;
    }
    return CGPointMake(x, y);
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
        @throw [NSException exceptionWithName:@"Set focus point excetion"
                                       reason:[NSString stringWithFormat:@"%@", error]
                                     userInfo:nil];
    }
    
    return FALSE;
}


@end
