//
//  RTCVideoSource+EmitFrame.h
//  react-native-webrtc
//
//  Created by MOMO on 2024/3/20.
//
#import <React/RCTViewManager.h>
#import "WebRTCModule.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTCVideoSource (EmitFrame)<RTCVideoCapturerDelegate>
+ (void)setOnFaceLandmarker:(RCTDirectEventBlock)faceLandmarker;
@end

NS_ASSUME_NONNULL_END
