//
//  RTCMTLVideoViewMediaPipe.h
//  react-native-webrtc
//
//  Created by rongping li on 2024/5/24.
//

#import <WebRTC/WebRTC.h>

#import <React/RCTView.h>
typedef RCTDirectEventBlock (^GetRTCViewOnFaceLandmarkerBlock)(void);
typedef BOOL (^GetRTCViewMediapipeBlock)(void);

@protocol RTCVideoRendererMidiaPipe<RTCVideoRenderer>
- (void)renderFirstFrame:(RTCVideoFrame *)frame pixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (void)setGetOnFaceLandmarkerBlock:(GetRTCViewOnFaceLandmarkerBlock)getOnFaceLandmarker;
- (void)setGetMediaPipeEnableBlock:(GetRTCViewMediapipeBlock)getMediaPipeEnable;


@end

NS_ASSUME_NONNULL_BEGIN

@interface RTCMTLVideoViewMediaPipe : RTCMTLVideoView<RTCVideoRendererMidiaPipe>

@end

NS_ASSUME_NONNULL_END
