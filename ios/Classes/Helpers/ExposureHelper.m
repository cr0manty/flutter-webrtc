//
//  ExposureHelper.m
//  flutter_webrtc
//
//  Created by Denys Dudka on 29.12.2021.
//

#import "ExposureHelper.h"
#import "FlutterDataHandler.h"
#import "FlutterWebRTCPlugin.h"

#if TARGET_OS_IPHONE
#import <Flutter/Flutter.h>
#elif TARGET_OS_MAC
#import <FlutterMacOS/FlutterMacOS.h>
#endif


@implementation ExposureHelper

__const float kExposureDurationPower = 5.0;
__const float kExposureMinimumDuration = 1.0/1000;


+(void)registerAdditionalHandlers:(NSObject<FlutterPluginRegistrar>*)registrar
                         instance:(FlutterWebRTCPlugin*)instance {
    FlutterEventChannel* exposureModeChannel = [FlutterEventChannel
                                                     eventChannelWithName:@"exposureModeHandler.dataChannel"
                                                     binaryMessenger: [registrar messenger]];
    FlutterSinkDataHandler *exposureModeHandler = [[FlutterSinkDataHandler alloc]init];
    [exposureModeChannel setStreamHandler:exposureModeHandler];
    instance.exposureModeHandler = exposureModeHandler;
    
    FlutterEventChannel* exposureDurationChannel = [FlutterEventChannel
                                                     eventChannelWithName:@"exposureDurationHandler.dataChannel"
                                                     binaryMessenger: [registrar messenger]];
    FlutterSinkDataHandler *exposureDurationHandler = [[FlutterSinkDataHandler alloc]init];
    [exposureDurationChannel setStreamHandler:exposureDurationHandler];
    instance.exposureDurationHandler = exposureDurationHandler;
    
    FlutterEventChannel* ISOChannel = [FlutterEventChannel
                                                     eventChannelWithName:@"ISOHandler.dataChannel"
                                                     binaryMessenger: [registrar messenger]];
    FlutterSinkDataHandler *ISOHandler = [[FlutterSinkDataHandler alloc]init];
    [ISOChannel setStreamHandler:ISOHandler];
    instance.ISOHandler = ISOHandler;
    
    FlutterEventChannel* exposureTargetBiasChannel = [FlutterEventChannel
                                                     eventChannelWithName:@"exposureTargetBiasHandler.dataChannel"
                                                     binaryMessenger: [registrar messenger]];
    FlutterSinkDataHandler *exposureTargetBiasHandler = [[FlutterSinkDataHandler alloc]init];
    [exposureTargetBiasChannel setStreamHandler:exposureTargetBiasHandler];
    instance.exposureTargetBiasHandler = exposureTargetBiasHandler;
    
    FlutterEventChannel* exposureTargetOffsetChannel = [FlutterEventChannel
                                                     eventChannelWithName:@"exposureTargetOffsetHandler.dataChannel"
                                                     binaryMessenger: [registrar messenger]];
    FlutterSinkDataHandler *exposureTargetOffsetHandler = [[FlutterSinkDataHandler alloc]init];
    [exposureTargetOffsetChannel setStreamHandler:exposureTargetOffsetHandler];
    instance.exposureTargetOffsetHandler = exposureTargetOffsetHandler;
}

-(NSArray*)getSupportedExposureMode:(AVCaptureDevice*)device {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureExposureModeLocked]];
    }
    
    if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureExposureModeAutoExpose]];
    }
    
    if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureExposureModeContinuousAutoExposure]];
    }
    
    if ([device isExposureModeSupported:AVCaptureExposureModeCustom]) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureExposureModeCustom]];
    }
    
    return array;
}

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
    
    if (value < [device activeFormat].minISO || value > [device activeFormat].maxISO) {
        @throw [NSException exceptionWithName:@"Change ISO excetion"
                                       reason:@"value is not in minISO and maxISO range"
                                     userInfo:nil];
    }
    
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
    
    if (value < [device minExposureTargetBias] || value > [device maxExposureTargetBias]) {
        @throw [NSException exceptionWithName:@"Change bias excetion"
                                       reason:@"value is not in minExposureTargetBias and maxExposureTargetBias range"
                                     userInfo:nil];
    }
    
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

-(float)getMinISO:(AVCaptureDevice*)device {
    return [device activeFormat].minISO;
}

-(float)getMaxISO:(AVCaptureDevice*)device {
    return [device activeFormat].maxISO;
}

-(BOOL)changeExposureDuration:(AVCaptureDevice*)device
                         value:(float)value {
    
    if (device.deviceType == AVCaptureDeviceTypeBuiltInTelephotoCamera) {
        return FALSE;
    }
    
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

-(CMTime)minExposureDuration:(AVCaptureDevice*)device {
    return [device activeFormat].minExposureDuration;
}

-(CMTime)maxExposureDuration:(AVCaptureDevice*)device {
    return [device activeFormat].maxExposureDuration;
}

-(AVCaptureExposureMode)getExposureMode:(AVCaptureDevice*)device {
    return [device exposureMode];
}

-(float)getExposureTargetOffset:(AVCaptureDevice*)device {
    return [device exposureTargetOffset];
}

-(float)getExposureTargetBias:(AVCaptureDevice*)device {
    return [device exposureTargetBias];
}

-(float)getMaxExposureTargetBias:(AVCaptureDevice*)device {
    return [device maxExposureTargetBias];
}

-(float)getMinExposureTargetBias:(AVCaptureDevice*)device {
    return [device minExposureTargetBias];
}


-(float)getISO:(AVCaptureDevice*)device {
    return [device ISO];
}


-(CMTime)getExposureDuration:(AVCaptureDevice*)device {
    return [device exposureDuration];
}

-(NSDictionary*)getExposureDurationSeconds:(AVCaptureDevice*)device {
    CMTime duration = [self getExposureDuration:device];
    
    return [ExposureHelper getExposureDurationSeconds:device duration:duration];
}

+(NSDictionary*)getExposureDurationSeconds:(AVCaptureDevice*)device
                                  duration:(CMTime) duration {
    CMTime min = [device activeFormat].minExposureDuration;
    CMTime max = [device activeFormat].maxExposureDuration;
    
    NSUInteger exposureDurationSeconds = CMTimeGetSeconds(duration);
    NSUInteger minExposureDurationSeconds = MAX(CMTimeGetSeconds(min), kExposureMinimumDuration);
    NSUInteger maxExposureDurationSeconds = CMTimeGetSeconds(max);
    // Map from duration to non-linear UI range 0-1
    float p = (exposureDurationSeconds - minExposureDurationSeconds) / (maxExposureDurationSeconds - minExposureDurationSeconds); // Scale to 0-1
    float value = pow(p, 1 / kExposureDurationPower);

    return @{@"duration": [NSNumber numberWithFloat:value],@"value": [NSNumber numberWithInteger:duration.value], @"timescale": [NSNumber numberWithInteger:duration.timescale], @"seconds": [NSNumber numberWithFloat:exposureDurationSeconds]};
}



@end
