package com.oney.WebRTCModule;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.Event;

public class MediaPipeEvent extends Event<MediaPipeEvent> {
    private WritableMap params;
   public MediaPipeEvent(int surfaceId, int viewId, WritableMap params) {
       super(surfaceId, viewId);
       this.params = params;
   }

    @Override
    public String getEventName() {
       return "MediaPipeEventFaceLandmarker";
    }

    @Nullable
    @Override
    protected WritableMap getEventData() {
        return this.params;
    }
}
