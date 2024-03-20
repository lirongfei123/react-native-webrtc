//
//  RTCVideoSource+EmitFrame.m
//  react-native-webrtc
//
//  Created by MOMO on 2024/3/20.
//

#import "RTCVideoSource+EmitFrame.h"
#import <MPImage/MPImage.h>

@implementation RTCVideoSource (EmitFrame)
- (void)emitFrame:(RTCVideoCapturer *)capturer didCaptureVideoFrame:(RTCVideoFrame *)frame {
    NSLog(@"333333333");
}
@end
