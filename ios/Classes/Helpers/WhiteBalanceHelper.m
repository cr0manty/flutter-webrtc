//
//  WhiteBalanceHelper.m
//  flutter_webrtc
//
//  Created by Denys Dudka on 29.12.2021.
//

#import "WhiteBalanceHelper.h"
#import "FlutterDataHandler.h"
#import "FlutterWebRTCPlugin.h"

#if TARGET_OS_IPHONE
#import <Flutter/Flutter.h>
#elif TARGET_OS_MAC
#import <FlutterMacOS/FlutterMacOS.h>
#endif


@implementation WhiteBalanceHelper

+(void)registerAdditionalHandlers:(NSObject<FlutterPluginRegistrar>*)registrar
                          instance:(FlutterWebRTCPlugin*)instance {
    FlutterEventChannel* dataChannel = [FlutterEventChannel
                                        eventChannelWithName:@"whiteBalanceMode.dataChannel"
                                        binaryMessenger: [registrar messenger]];
    FlutterSinkDataHandler *dataHandler = [[FlutterSinkDataHandler alloc]init];
    [dataChannel setStreamHandler:dataHandler];
    instance.whiteBalanceModeHandler = dataHandler;
    
    FlutterEventChannel* whiteBalanceGainsChannel = [FlutterEventChannel
                                                     eventChannelWithName:@"whiteBalanceGainsHandler.dataChannel"
                                                     binaryMessenger: [registrar messenger]];
    FlutterSinkDataHandler *whiteBalanceGainsHandlerHandler = [[FlutterSinkDataHandler alloc]init];
    [whiteBalanceGainsChannel setStreamHandler:whiteBalanceGainsHandlerHandler];
    instance.whiteBalanceGainsHandler = whiteBalanceGainsHandlerHandler;
}

-(AVCaptureWhiteBalanceMode)getWhiteBalanceMode:(AVCaptureDevice*)device {
    return [device whiteBalanceMode];
}

-(BOOL)isWhiteBalanceLockSupported:(AVCaptureDevice*)device {
    return [device isLockingWhiteBalanceWithCustomDeviceGainsSupported];
}

-(NSArray*)getSupportedWhiteBalanceMode:(AVCaptureDevice*)device {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked]) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureWhiteBalanceModeLocked]];
    }
    
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureWhiteBalanceModeAutoWhiteBalance]];
    }
    
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]];
    }
    
    return array;
}

-(BOOL)isWhiteBalanceModeSupported:(AVCaptureDevice*)device
                           modeNum:(NSInteger)modeNum {
    AVCaptureWhiteBalanceMode mode = (AVCaptureWhiteBalanceMode)modeNum;
    
    return [device isWhiteBalanceModeSupported:mode];
}

-(BOOL)setWhiteBalanceMode:(AVCaptureDevice*)device
                   modeNum:(NSInteger)modeNum {
    AVCaptureWhiteBalanceMode mode = (AVCaptureWhiteBalanceMode)modeNum;
    
    if (![device isWhiteBalanceModeSupported:mode]) {
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
