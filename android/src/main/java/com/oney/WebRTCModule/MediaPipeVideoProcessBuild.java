package com.oney.WebRTCModule;

import com.oney.WebRTCModule.videoEffects.VideoFrameProcessor;
import com.oney.WebRTCModule.videoEffects.VideoFrameProcessorFactoryInterface;

import org.webrtc.SurfaceTextureHelper;
import org.webrtc.VideoFrame;

public class MediaPipeVideoProcessBuild implements VideoFrameProcessorFactoryInterface {
    @Override
    public VideoFrameProcessor build() {
        return new VideoFrameProcessor() {
            @Override
            public VideoFrame process(VideoFrame frame, SurfaceTextureHelper textureHelper) {
                return null;
            }
        };
    }
}
