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
@property(nonatomic, assign) bool mediapipe;
@property (nonatomic, copy) RCTDirectEventBlock onFaceLandmarker;

@property (nonatomic, copy) GetRTCViewOnFaceLandmarkerBlock getOnFaceLandmarkerBlock;
@property (nonatomic, copy) GetRTCViewMediapipeBlock getMediapipeBlock;

@end

@implementation RTCMTLVideoViewMediaPipe
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFaceLandmarker];
    }
    return self;
}
- (void)setFaceLandmarker {
    MPPFaceLandmarkerOptions *options = [[MPPFaceLandmarkerOptions alloc] init];
    options.numFaces = 1;
    options.baseOptions.modelAssetPath = [[NSBundle mainBundle] pathForResource:@"face_landmarker" ofType:@"task"];
    options.runningMode = MPPRunningModeImage;
    NSError *err;
    MPPFaceLandmarker *faceLandmarker = [[MPPFaceLandmarker alloc] initWithOptions:options error:&err];
    self.faceLandmarker = faceLandmarker;
}

- (void)setGetMediaPipeEnableBlock:(GetRTCViewMediapipeBlock)getMediaPipeEnable {
    _getMediapipeBlock = getMediaPipeEnable;
}

- (void)setGetOnFaceLandmarkerBlock:(GetRTCViewOnFaceLandmarkerBlock)getOnFaceLandmarker {
   _getOnFaceLandmarkerBlock = getOnFaceLandmarker;
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
    [self emitEvent:pixelBuffer];
}

- (void)emitEvent: (CVPixelBufferRef)pixelBuffer {
    BOOL mediapipe = self.getMediapipeBlock();
    RCTDirectEventBlock onFaceLandmarker = self.getOnFaceLandmarkerBlock();
    if (mediapipe && onFaceLandmarker != NULL) {
        __weak typeof(self) weakSelf = self;
        CVPixelBufferRetain(pixelBuffer);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.faceLandmarker) {
                NSError *err;
                MPPImage *img = [[MPPImage alloc] initWithPixelBuffer:pixelBuffer error:&err];
                MPPFaceLandmarkerResult *result = [strongSelf.faceLandmarker detectImage:img error:&err];
                NSLog(@"=============111111111111%@", img);
                if (result.faceLandmarks.count > 0) {
                    NSMutableArray *points = [[NSMutableArray alloc] init];
                    NSArray<MPPNormalizedLandmark *> *faceLandmark = result.faceLandmarks[0];
                    for (int i = 0; i < faceLandmark.count; i++) {
                        MPPNormalizedLandmark *point = faceLandmark[i];
                        [points addObject:@[@(point.x), @(point.y), @(point.z)]];
                    }
                    onFaceLandmarker(@{
                        @"points": points
                    });
                } else {
                    onFaceLandmarker(@{
                        @"points": @[]
                    });
                }
            }
            
            
            CVPixelBufferRelease(pixelBuffer);
        });
    }
}

- (void)renderFirstFrame:(RTCVideoFrame *)frame {
    
}
- (void)renderFrame:(RTCVideoFrame *)frame {
    [super renderFrame:frame];
    RTCCVPixelBuffer *buffer = frame.buffer;
    [self emitEvent:buffer.pixelBuffer];
}

@end
