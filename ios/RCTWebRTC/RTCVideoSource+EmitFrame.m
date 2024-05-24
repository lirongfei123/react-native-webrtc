//
//  RTCVideoSource+EmitFrame.m
//  react-native-webrtc
//
//  Created by MOMO on 2024/3/20.
//

#import "RTCVideoSource+EmitFrame.h"
#import <MediaPipeTasksVision/MediaPipeTasksVision.h>
typedef void (^JsCallbackParamStringBlock)(NSString * _Nullable folderPath);
typedef void (^FaceLandMarkerCallback)(NSArray *data);

static FaceLandMarkerCallback  faceLandmarkerListenerBlock;

@implementation RTCVideoSource (EmitFrame)
+ (void)setOnFaceLandmarker:(RCTDirectEventBlock)faceLandmarker {
    faceLandmarkerListenerBlock = ^(NSArray *data) {
        NSLog(@"============1111111111%@", data);
        faceLandmarker(@{
            @"points": data
        });
    };
}
- (void)emitFrame:(RTCVideoCapturer *)capturer didCaptureVideoFrame:(RTCVideoFrame *)frame {
    NSLog(@"333333333");
    MPPFaceLandmarkerOptions *options = [[MPPFaceLandmarkerOptions alloc] init];
    options.numFaces = 1;
    options.baseOptions.modelAssetPath = [[NSBundle mainBundle] pathForResource:@"face_landmarker" ofType:@"task"];
    options.runningMode = MPPRunningModeImage;
    NSError *err;
    MPPFaceLandmarker *faceLandmarker = [[MPPFaceLandmarker alloc] initWithOptions:options error:&err];
    RTCCVPixelBuffer *buffer = frame.buffer;
    MPPImage *img = [[MPPImage alloc] initWithPixelBuffer:buffer.pixelBuffer error:&err];
//
    MPPFaceLandmarkerResult *result = [faceLandmarker detectImage:img error:&err];
    if (faceLandmarkerListenerBlock) {
        if (result.faceLandmarks.count > 0) {
            NSMutableArray *points = [[NSMutableArray alloc] init];
            NSArray<MPPNormalizedLandmark *> *faceLandmark = result.faceLandmarks[0];
            for (int i = 0; i < faceLandmark.count; i++) {
                MPPNormalizedLandmark *point = faceLandmark[i];
                [points addObject:@[@(point.x), @(point.y), @(point.z)]];
            }
            faceLandmarkerListenerBlock(points);
        }
        
    }
}
@end
