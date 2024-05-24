//
//  RTCMTLVideoViewMediaPipe.m
//  react-native-webrtc
//
//  Created by rongping li on 2024/5/24.
//

#import "RTCMTLVideoViewMediaPipe.h"
#import <MediaPipeTasksVision/MediaPipeTasksVision.h>
@interface RTCMTLVideoViewMediaPipe()
@property(nonatomic, strong) MPPFaceLandmarker *faceLandmarker;
@property (nonatomic, copy) RCTDirectEventBlock onFaceLandmarker;
@end

@implementation RTCMTLVideoViewMediaPipe
- (void)setFaceLandmarkerCallback:(RCTDirectEventBlock)onFaceLandmarker {
    self.onFaceLandmarker = onFaceLandmarker;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)renderFirstFrame:(RTCVideoFrame *)frame pixelBuffer:(CVPixelBufferRef)pixelBuffer {
    [super renderFrame:frame];
    if (self.faceLandmarker == NULL) {
        NSLog(@"==========+%@", frame);
        MPPFaceLandmarkerOptions *options = [[MPPFaceLandmarkerOptions alloc] init];
        options.numFaces = 1;
        options.baseOptions.modelAssetPath = [[NSBundle mainBundle] pathForResource:@"face_landmarker" ofType:@"task"];
        options.runningMode = MPPRunningModeImage;
        NSError *err;
        MPPFaceLandmarker *faceLandmarker = [[MPPFaceLandmarker alloc] initWithOptions:options error:&err];
        self.faceLandmarker = faceLandmarker;
    }
    [self emitEvent:pixelBuffer];
}

- (void)emitEvent: (CVPixelBufferRef)pixelBuffer {
    CVPixelBufferRetain(pixelBuffer);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *err;
        if (self.faceLandmarker) {
            MPPImage *img = [[MPPImage alloc] initWithPixelBuffer:pixelBuffer error:&err];
            MPPFaceLandmarkerResult *result = [self.faceLandmarker detectImage:img error:&err];
            if (self.onFaceLandmarker) {
                if (result.faceLandmarks.count > 0) {
                    NSMutableArray *points = [[NSMutableArray alloc] init];
                    NSArray<MPPNormalizedLandmark *> *faceLandmark = result.faceLandmarks[0];
                    for (int i = 0; i < faceLandmark.count; i++) {
                        MPPNormalizedLandmark *point = faceLandmark[i];
                        [points addObject:@[@(point.x), @(point.y), @(point.z)]];
                    }
                    self.onFaceLandmarker(@{
                        @"points": points
                    });
                    
                }
                
            }
        }
        CVPixelBufferRelease(pixelBuffer);
        
    });
}

- (void)renderFirstFrame:(RTCVideoFrame *)frame {
    
}
- (void)renderFrame:(RTCVideoFrame *)frame {
    [super renderFrame:frame];
    RTCCVPixelBuffer *buffer = frame.buffer;
    [self emitEvent:buffer.pixelBuffer];
}

@end
