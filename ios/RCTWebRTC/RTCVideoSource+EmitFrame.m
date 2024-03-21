//
//  RTCVideoSource+EmitFrame.m
//  react-native-webrtc
//
//  Created by MOMO on 2024/3/20.
//

#import "RTCVideoSource+EmitFrame.h"
#import <MPImage/MPImage.h>
#import <MediaPipeTasksVision/MediaPipeTasksVision.h>
@implementation RTCVideoSource (EmitFrame)
- (void)emitFrame:(RTCVideoCapturer *)capturer didCaptureVideoFrame:(RTCVideoFrame *)frame {
    NSLog(@"333333333");
    MPPFaceLandmarkerOptions *options = [[MPPFaceLandmarkerOptions alloc] init];
    options.numFaces = 1;
    options.baseOptions.modelAssetPath = [[NSBundle mainBundle] pathForResource:@"face_landmarker" ofType:@"task"];
    options.runningMode = MPPRunningModeImage;
    NSError *err;
    MPPFaceLandmarker *faceLandmarker = [[MPPFaceLandmarker alloc] initWithOptions:options error:&err];
    NSLog(@"===========1%@", err);
    RTCCVPixelBuffer *buffer = frame.buffer;
    MPPImage *img = [[MPPImage alloc] initWithPixelBuffer:buffer.pixelBuffer error:&err];
    NSLog(@"===========1%@", err);
//
    MPPFaceLandmarkerResult *result = [faceLandmarker detectImage:img error:&err];
    NSLog(@"==========T%@=== %@", result, err);
}
@end
