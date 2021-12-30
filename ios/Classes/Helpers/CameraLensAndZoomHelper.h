//
//  CameraLensAndZoomHelper.h
//  flutter_webrtc
//
//  Created by Denys Dudka on 23.12.2021.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface CameraLensAndZoomHelper : NSObject

#pragma mark - lens switching

+(AVCaptureDevice*)getCameraWithPosition:(AVCaptureDevicePosition)position;

-(int)cameraLensAmount;

-(AVCaptureDevice*)getWideAngleCamera;

-(AVCaptureDevice*)getUltraWideCamera;

-(NSArray*)getSupportedCameraLens;

-(AVCaptureDevice*)getCameraByName:(NSString*)name;

-(AVCaptureDeviceType)getCurrentDeviceType:(AVCaptureDevice*)device;

-(BOOL)setPreferredStabilizationMode:(AVCaptureConnection*)connection
                             modeNum:(NSInteger)modeNum;

-(AVCaptureVideoStabilizationMode)getPreferredStabilizationMode:(AVCaptureConnection*)connection;

-(AVCaptureVideoStabilizationMode)getActiveStabilizationMode:(AVCaptureConnection*)connection;

-(NSArray*)getSupportedStabilizationMode;

#pragma mark - zoom

-(BOOL)setZoom:(AVCaptureDevice*)device
          zoom:(NSInteger)zoom;

-(float)getMaxZoomFactor:(AVCaptureDevice*)device;

-(float)getMinZoomFactor:(AVCaptureDevice*)device;

-(float)getZoomFactor:(AVCaptureDevice*)device;

-(BOOL)canSwitchToUltraWideCamera:(AVCaptureDevice*)device
                             zoom:(float)zoom;


@end

NS_ASSUME_NONNULL_END
