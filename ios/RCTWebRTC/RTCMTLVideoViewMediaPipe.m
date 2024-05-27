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
@property(nonatomic, strong) NSDictionary *faceMeshModel;
@property(nonatomic, strong) NSDictionary *meshAnnotationModel;
@property(nonatomic, assign) bool mediapipe;
@property (nonatomic, copy) RCTDirectEventBlock onFaceLandmarker;

@property (nonatomic, copy) GetRTCViewOnFaceLandmarkerBlock getOnFaceLandmarkerBlock;
@property (nonatomic, copy) GetRTCViewMediapipeBlock getMediapipeBlock;
@property (nonatomic, copy) GetRTCViewResultTypeBlock getResultTypesBlock;

@property (nonatomic, assign) bool isInProcess;

@end

@implementation RTCMTLVideoViewMediaPipe
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFaceLandmarker];
        self.faceMeshModel = [self getMediaPipeFaceMeshKeypoint];
        self.meshAnnotationModel = [self getMeshAnnotationKeypoint];
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

- (void)setGetResultTypesBlock:(GetRTCViewResultTypeBlock)getResultTypes {
    _getResultTypesBlock = getResultTypes;
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

- (NSDictionary*) getMeshAnnotationKeypoint {
    return @{
        @"silhouette": @[
            @(10), @(338), @(297), @(332), @(284), @(251), @(389), @(356), @(454), @(323), @(361), @(288),
            @(397), @(365), @(379), @(378), @(400), @(377), @(152), @(148), @(176), @(149), @(150), @(136),
            @(172), @(58), @(132), @(93), @(234), @(127), @(162), @(21), @(54), @(103), @(67), @(109)
        ],
        @"lipsUpperOuter": @[@(61), @(185), @(40), @(39), @(37), @(0), @(267), @(269), @(270), @(409), @(291)],
        @"lipsLowerOuter": @[@(146), @(91), @(181), @(84), @(17), @(314), @(405), @(321), @(375), @(291)],
        @"lipsUpperInner": @[@(78), @(191), @(80), @(81), @(82), @(13), @(312), @(311), @(310), @(415), @(308)],
        @"lipsLowerInner": @[@(78), @(95), @(88), @(178), @(87), @(14), @(317), @(402), @(318), @(324), @(308)],
        @"rightEyeUpper0": @[@(246), @(161), @(160), @(159), @(158), @(157), @(173)],
        @"rightEyeLower0": @[@(33), @(7), @(163), @(144), @(145), @(153), @(154), @(155), @(133)],
        @"rightEyeUpper1": @[@(247), @(30), @(29), @(27), @(28), @(56), @(190)],
        @"rightEyeLower1": @[@(130), @(25), @(110), @(24), @(23), @(22), @(26), @(112), @(243)],
        @"rightEyeUpper2": @[@(113), @(225), @(224), @(223), @(222), @(221), @(189)],
        @"rightEyeLower2": @[@(226), @(31), @(228), @(229), @(230), @(231), @(232), @(233), @(244)],
        @"rightEyeLower3": @[@(143), @(111), @(117), @(118), @(119), @(120), @(121), @(128), @(245)],
        @"rightEyebrowUpper": @[@(156), @(70), @(63), @(105), @(66), @(107), @(55), @(193)],
        @"rightEyebrowLower": @[@(35), @(124), @(46), @(53), @(52), @(65)],
        @"rightEyeIris": @[@(473), @(474), @(475), @(476), @(477)],
        @"leftEyeUpper0": @[@(466), @(388), @(387), @(386), @(385), @(384), @(398)],
        @"leftEyeLower0": @[@(263), @(249), @(390), @(373), @(374), @(380), @(381), @(382), @(362)],
        @"leftEyeUpper1": @[@(467), @(260), @(259), @(257), @(258), @(286), @(414)],
        @"leftEyeLower1": @[@(359), @(255), @(339), @(254), @(253), @(252), @(256), @(341), @(463)],
        @"leftEyeUpper2": @[@(342), @(445), @(444), @(443), @(442), @(441), @(413)],
        @"leftEyeLower2": @[@(446), @(261), @(448), @(449), @(450), @(451), @(452), @(453), @(464)],
        @"leftEyeLower3": @[@(372), @(340), @(346), @(347), @(348), @(349), @(350), @(357), @(465)],
        @"leftEyebrowUpper": @[@(383), @(300), @(293), @(334), @(296), @(336), @(285), @(417)],
        @"leftEyebrowLower": @[@(265), @(353), @(276), @(283), @(282), @(295)],
        @"leftEyeIris": @[@(468), @(469), @(470), @(471), @(472)],
        @"midwayBetweenEyes": @[@(168)],
        @"noseTip": @[@(1)],
        @"noseBottom": @[@(2)],
        @"noseRightCorner": @[@(98)],
        @"noseLeftCorner": @[@(327)],
        @"rightCheek": @[@(205)],
        @"leftCheek": @[@(425)]
    };
}
- (NSDictionary*) getMediaPipeFaceMeshKeypoint {
    return @{
        @"lips": @[
            @(61),
            @(146),
            @(91),
            @(181),
            @(84),
            @(17),
            @(314),
            @(405),
            @(321),
            @(375),
            @(61),
            @(185),
            @(40),
            @(39),
            @(37),
            @(0),
            @(267),
            @(269),
            @(270),
            @(409),
            @(78),
            @(95),
            @(88),
            @(178),
            @(87),
            @(14),
            @(317),
            @(402),
            @(318),
            @(324),
            @(78),
            @(191),
            @(80),
            @(81),
            @(82),
            @(13),
            @(312),
            @(311),
            @(310),
            @(415),
            @(308)
        ],
        @"leftEye": @[
            @(263),
            @(249),
            @(390),
            @(373),
            @(374),
            @(380),
            @(381),
            @(382),
            @(263),
            @(466),
            @(388),
            @(387),
            @(386),
            @(385),
            @(384),
            @(398),
            @(362)
        ],
        @"leftEyebrow": @[
            @(276),
            @(283),
            @(282),
            @(295),
            @(300),
            @(293),
            @(334),
            @(296),
            @(336)
        ],
        @"leftIris": @[
            @(474),
            @(475),
            @(476),
            @(477),
            @(474)
        ],
        @"rightEye": @[
            @(33),
            @(7),
            @(163),
            @(144),
            @(145),
            @(153),
            @(154),
            @(155),
            @(33),
            @(246),
            @(161),
            @(160),
            @(159),
            @(158),
            @(157),
            @(173),
            @(133)
        ],
        @"rightEyebrow": @[
            @(46),
            @(53),
            @(52),
            @(65),
            @(70),
            @(63),
            @(105),
            @(66),
            @(107)
        ],
        @"rightIris": @[
            @(469),
            @(470),
            @(471),
            @(472),
            @(469)
        ],
        @"faceOval": @[
            @(10),
            @(338),
            @(297),
            @(332),
            @(284),
            @(251),
            @(389),
            @(356),
            @(454),
            @(323),
            @(361),
            @(288),
            @(397),
            @(365),
            @(379),
            @(378),
            @(400),
            @(377),
            @(152),
            @(148),
            @(176),
            @(149),
            @(150),
            @(136),
            @(172),
            @(58),
            @(132),
            @(93),
            @(234),
            @(127),
            @(162),
            @(21),
            @(54),
            @(103),
            @(67),
            @(109),
            @(10)
        ]
    };
}
- (NSDictionary *)convertResultToMeshModel:(NSArray<MPPNormalizedLandmark *> *)faceLandmark faceMeshModel:(NSDictionary*)faceMeshModel {
    NSMutableDictionary *modelDict = [[NSMutableDictionary alloc] init];
    NSArray *keys = [faceMeshModel allKeys];
    for (int i = 0; i < keys.count; i++) {
        NSArray *values = [faceMeshModel objectForKey:keys[i]];
        NSMutableArray *points = [[NSMutableArray alloc] init];
        for (int j = 0; j < values.count; j++) {
            NSInteger index = [(NSNumber*)values[j] integerValue];
            MPPNormalizedLandmark *point = [faceLandmark objectAtIndex:index];
            if (point != NULL) {
                [points addObject:@[@(point.x), @(point.y), @(point.z)]];
            } else {
                [points addObject:@[]];
            }
            
        }
        [modelDict setObject:points forKey:keys[i]];
    }
    return modelDict;
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
                CVPixelBufferRelease(pixelBuffer);
                MPPFaceLandmarkerResult *result = [strongSelf.faceLandmarker detectImage:img error:&err];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                NSArray *resultTypes = strongSelf.getResultTypesBlock();
                if (result.faceLandmarks.count > 0) {
                    NSArray<MPPNormalizedLandmark *> *faceLandmark = result.faceLandmarks[0];
                    for (int i = 0; i < resultTypes.count; i++) {
                        NSString *key = resultTypes[i];
                        if ([key isEqualToString:@"points"]) {
                            NSMutableArray *points = [[NSMutableArray alloc] init];
                            for (int i = 0; i < faceLandmark.count; i++) {
                                MPPNormalizedLandmark *point = faceLandmark[i];
                                [points addObject:@[@(point.x), @(point.y), @(point.z)]];
                            }
                            [dict setObject:points forKey:@"points"];
                        } else if ([key isEqualToString:@"faceMesh"]) {
                            [dict setObject:[strongSelf convertResultToMeshModel:faceLandmark faceMeshModel:strongSelf.faceMeshModel] forKey:@"faceMesh"];
                        } else if ([key isEqualToString:@"meshAnnotations"]) {
                            [dict setObject:[strongSelf convertResultToMeshModel:faceLandmark faceMeshModel:strongSelf.meshAnnotationModel] forKey:@"meshAnnotations"];
                        }
                    }
                } else {
                    for (int i = 0; i < resultTypes.count; i++) {
                        NSString *key = resultTypes[i];
                        if ([key isEqualToString:@"points"]) {
                            [dict setObject:@[] forKey:@"points"];
                        } else if ([key isEqualToString:@"faceMesh"]) {
                            [dict setObject:@{} forKey:@"faceMesh"];
                        } else if ([key isEqualToString:@"meshAnnotations"]) {
                            [dict setObject:@{} forKey:@"meshAnnotations"];
                        }
                    }
                }
                onFaceLandmarker(dict);
            }
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
