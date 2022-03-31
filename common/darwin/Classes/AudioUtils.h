@interface AudioUtils : NSObject

+(void)ensureAudioSessionWithExternalMic:(BOOL)willUseExternalMic
                           withRecording:(BOOL)recording;

+ (void)ensureAudioSessionWithRecording:(BOOL)recording;
// needed for wired headphones to use headphone mic
+ (void)setPreferHeadphoneInput;

@end
