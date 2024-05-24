//
//  RTCMTLVideoViewMediaPipe.h
//  react-native-webrtc
//
//  Created by rongping li on 2024/5/24.
//

#import <WebRTC/WebRTC.h>

#import <React/RCTView.h>

@protocol RTCVideoRendererMidiaPipe<RTCVideoRenderer>
- (void)renderFirstFrame:(RTCVideoFrame *)frame pixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (void)setFaceLandmarkerCallback:(RCTDirectEventBlock)onFaceLandmarker;
@end

NS_ASSUME_NONNULL_BEGIN

@interface RTCMTLVideoViewMediaPipe : RTCMTLVideoView<RTCVideoRendererMidiaPipe>

@end

NS_ASSUME_NONNULL_END
