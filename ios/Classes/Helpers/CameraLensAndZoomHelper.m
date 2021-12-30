//
//  CameraLensAndZoomHelper.m
//  flutter_webrtc
//
//  Created by Denys Dudka on 23.12.2021.
//

#import "CameraLensAndZoomHelper.h"
#import <AVFoundation/AVFoundation.h>
#include <math.h>

@implementation CameraLensAndZoomHelper

#pragma mark - lens switching

-(int)cameraLensAmount {
    if (@available(iOS 13.0, *)) {
        if ([AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInTripleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack]) {
            return 3;
        }
    } else if (@available(iOS 10.2, *)) {
        if ([AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack]) {
            return 2;
        }
    }
    return 1;
}

+(AVCaptureDevice *)getCameraWithPosition:(AVCaptureDevicePosition)position {
    AVCaptureDevice* device;
    if (@available(iOS 13.0, *)) {
        device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInTripleCamera mediaType:AVMediaTypeVideo position:position];
        
        if (device != nil) {
            return device;
        }
        
        device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:position];
        
        if (device != nil) {
            return device;
        }
    }
    
    if (position == AVCaptureDevicePositionUnspecified) {
        return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    NSArray<AVCaptureDevice*> *devices = [AVCaptureDevice devices];
    
    for(AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return devices[0];
}

-(AVCaptureDevice*)getWideAngleCamera {
    return [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
}

-(AVCaptureDevice*)getUltraWideCamera {
    if (@available(iOS 13.0, *)) {
        return [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInUltraWideCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    } else {
        return nil;
    }
}

-(NSArray*)getSupportedCameraLens {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    if ([AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack]) {
        [data addObject:AVCaptureDeviceTypeBuiltInWideAngleCamera];
    }
    
    if (@available(iOS 13.0, *)) {
        if ([AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInUltraWideCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack]) {
            
            [data addObject:AVCaptureDeviceTypeBuiltInUltraWideCamera];
        }
    }
    
    if ([AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInTelephotoCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack]) {
        [data addObject:AVCaptureDeviceTypeBuiltInTelephotoCamera];
    }
    
    return data;
}

-(AVCaptureDevice*)getCameraByName:(NSString*)name {
    if ([name isEqual:@"AVCaptureDeviceTypeBuiltInWideAngleCamera"]) {
        return [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    }
    if (@available(iOS 13.0, *)) {
        if ([name isEqual:@"AVCaptureDeviceTypeBuiltInUltraWideCamera"]) {
            
            return [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInUltraWideCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        }
    }
    if ([name isEqual:@"AVCaptureDeviceTypeBuiltInTelephotoCamera"]) {
        return [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInTelephotoCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    }
    return nil;
}

-(AVCaptureDeviceType)getCurrentDeviceType:(AVCaptureDevice*)device {
    return device.deviceType;
}

-(BOOL)setPreferredStabilizationMode:(AVCaptureConnection*)connection
                    modeNum:(NSInteger)modeNum {
    if (![connection isVideoStabilizationSupported]) {
        return FALSE;
    }
    
    AVCaptureVideoStabilizationMode mode = (AVCaptureVideoStabilizationMode)modeNum;
    [connection setPreferredVideoStabilizationMode:mode];
    
    return TRUE;
}

-(AVCaptureVideoStabilizationMode)getPreferredStabilizationMode:(AVCaptureConnection*)connection {
    return [connection preferredVideoStabilizationMode];
}

-(AVCaptureVideoStabilizationMode)getActiveStabilizationMode:(AVCaptureConnection*)connection {
    return [connection activeVideoStabilizationMode];
}

-(BOOL)setStabilizationMode:(AVCaptureConnection*)connection
                    modeNum:(NSInteger)modeNum{
    if (![connection isVideoStabilizationSupported]) {
        return FALSE;
    }
    AVCaptureVideoStabilizationMode mode = (AVCaptureVideoStabilizationMode)modeNum;
    [connection setPreferredVideoStabilizationMode:mode];

    
    return TRUE;
}

-(NSArray*)getSupportedStabilizationMode {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [array addObject:[NSNumber numberWithInteger:AVCaptureVideoStabilizationModeOff]];
    [array addObject:[NSNumber numberWithInteger:AVCaptureVideoStabilizationModeStandard]];
    [array addObject:[NSNumber numberWithInteger:AVCaptureVideoStabilizationModeCinematic]];
    [array addObject:[NSNumber numberWithInteger:AVCaptureVideoStabilizationModeAuto]];
    
    if (@available(iOS 13.0, *)) {
        [array addObject:[NSNumber numberWithInteger:AVCaptureVideoStabilizationModeCinematicExtended]];
    }
    return array;
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
    AVCaptureDevice *ultraWide = [self getUltraWideCamera];
    
    if (ultraWide != nil) {
        if (@available(iOS 11.0, *)) {
            return [device minAvailableVideoZoomFactor];
        } else {
            return 1;
        }
    }
    
    if (@available(iOS 11.0, *)) {
        return [device minAvailableVideoZoomFactor];
    } else {
        return 1;
    }
}

-(float)getZoomFactor:(AVCaptureDevice*)device {
    return [device videoZoomFactor];
}

-(BOOL)canSwitchToUltraWideCamera:(AVCaptureDevice*)device
                             zoom:(float)zoom {
    float currentZoom = [device videoZoomFactor];
    
    if (currentZoom <= 0.5) {
        return FALSE;
    }
    
    if (@available(iOS 13.0, *)) {
        if (device.deviceType == AVCaptureDeviceTypeBuiltInUltraWideCamera) {
            return FALSE;
        }
    }
    
    if (currentZoom >= 1 && zoom >= 0.5 && zoom < 1) {
        AVCaptureDevice *newDevice = [self getUltraWideCamera];
        if (newDevice != nil) {
            return TRUE;
        }
    }
    
    return FALSE;
}

@end
