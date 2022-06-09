#if TARGET_OS_IPHONE
#import <Flutter/Flutter.h>
#elif TARGET_OS_MAC
#import <FlutterMacOS/FlutterMacOS.h>
#endif

#import <Foundation/Foundation.h>
#import <WebRTC/WebRTC.h>


NS_ASSUME_NONNULL_BEGIN

@class FlutterRTCVideoRenderer;
@class FlutterRTCFrameCapturer;
@class FlutterRTCCameraVideoCapturer;
@class FlutterSinkDataHandler;

@interface FlutterWebRTCPlugin : NSObject<FlutterPlugin, RTCPeerConnectionDelegate>

@property (nonatomic, strong) RTCPeerConnectionFactory *peerConnectionFactory;
@property (nonatomic, strong) NSMutableDictionary<NSString *, RTCPeerConnection *> *peerConnections;
@property (nonatomic, strong) NSMutableDictionary<NSString *, RTCMediaStream *> *localStreams;
@property (nonatomic, strong) NSMutableDictionary<NSString *, RTCMediaStreamTrack *> *localTracks;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, FlutterRTCVideoRenderer *> *renders;
#if TARGET_OS_IPHONE
@property (nonatomic, retain) UIViewController *viewController;/*for broadcast or ReplayKit */
#endif
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger>* messenger;
@property (nonatomic, strong) FlutterRTCCameraVideoCapturer *videoCapturer;
@property (nonatomic, strong) FlutterRTCFrameCapturer *frameCapturer;
@property (nonatomic) BOOL _usingFrontCamera;
@property (nonatomic) int _targetWidth;
@property (nonatomic) int _targetHeight;
@property (nonatomic) int _targetFps;


@property (nonatomic, strong) FlutterSinkDataHandler* deviceChandgedHandler;

#pragma mark - event streams
@property (nonatomic, strong) FlutterSinkDataHandler* whiteBalanceModeHandler;
@property (nonatomic, strong) FlutterSinkDataHandler* whiteBalanceGainsHandler;

@property (nonatomic, strong) FlutterSinkDataHandler* focusModeHandler;
@property (nonatomic, strong) FlutterSinkDataHandler* focusLensPositionHandler;

@property (nonatomic, strong) FlutterSinkDataHandler* exposureModeHandler;
@property (nonatomic, strong) FlutterSinkDataHandler* exposureDurationHandler;
@property (nonatomic, strong) FlutterSinkDataHandler* ISOHandler;
@property (nonatomic, strong) FlutterSinkDataHandler* exposureTargetBiasHandler;
@property (nonatomic, strong) FlutterSinkDataHandler* exposureTargetOffsetHandler;

- (RTCMediaStream*)streamForId:(NSString*)streamId peerConnectionId:(NSString *)peerConnectionId;
- (NSDictionary*)mediaStreamToMap:(RTCMediaStream *)stream ownerTag:(NSString*)ownerTag;
- (NSDictionary*)mediaTrackToMap:(RTCMediaStreamTrack*)track;
- (NSDictionary*)receiverToMap:(RTCRtpReceiver*)receiver;
- (NSDictionary*)transceiverToMap:(RTCRtpTransceiver*)transceiver;

@end
NS_ASSUME_NONNULL_END
