package com.oney.WebRTCModule;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.google.mediapipe.tasks.components.containers.NormalizedLandmark;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class MediaPipeUtils {
    public static HashMap<String, ArrayList<Integer>> getMeshAnnotations() {
        return new HashMap<String, ArrayList<Integer>>(){{
            put("silhouette", new ArrayList<Integer>(Arrays.asList(10,338,297,332,284,251,389,356,454,323,361,288,397,365,379,378,400,377,152,148,176,149,150,136,172,58,132,93,234,127,162,21,54,103,67,109)));
            put("lipsUpperOuter", new ArrayList<Integer>(Arrays.asList(61,185,40,39,37,0,267,269,270,409,291)));
            put("lipsLowerOuter", new ArrayList<Integer>(Arrays.asList(146,91,181,84,17,314,405,321,375,291)));
            put("lipsUpperInner", new ArrayList<Integer>(Arrays.asList(78,191,80,81,82,13,312,311,310,415,308)));
            put("lipsLowerInner", new ArrayList<Integer>(Arrays.asList(78,95,88,178,87,14,317,402,318,324,308)));
            put("rightEyeUpper0", new ArrayList<Integer>(Arrays.asList(246,161,160,159,158,157,173)));
            put("rightEyeLower0", new ArrayList<Integer>(Arrays.asList(33,7,163,144,145,153,154,155,133)));
            put("rightEyeUpper1", new ArrayList<Integer>(Arrays.asList(247,30,29,27,28,56,190)));
            put("rightEyeLower1", new ArrayList<Integer>(Arrays.asList(130,25,110,24,23,22,26,112,243)));
            put("rightEyeUpper2", new ArrayList<Integer>(Arrays.asList(113,225,224,223,222,221,189)));
            put("rightEyeLower2", new ArrayList<Integer>(Arrays.asList(226,31,228,229,230,231,232,233,244)));
            put("rightEyeLower3", new ArrayList<Integer>(Arrays.asList(143,111,117,118,119,120,121,128,245)));
            put("rightEyebrowUpper", new ArrayList<Integer>(Arrays.asList(156,70,63,105,66,107,55,193)));
            put("rightEyebrowLower", new ArrayList<Integer>(Arrays.asList(35,124,46,53,52,65)));
            put("rightEyeIris", new ArrayList<Integer>(Arrays.asList(473,474,475,476,477)));
            put("leftEyeUpper0", new ArrayList<Integer>(Arrays.asList(466,388,387,386,385,384,398)));
            put("leftEyeLower0", new ArrayList<Integer>(Arrays.asList(263,249,390,373,374,380,381,382,362)));
            put("leftEyeUpper1", new ArrayList<Integer>(Arrays.asList(467,260,259,257,258,286,414)));
            put("leftEyeLower1", new ArrayList<Integer>(Arrays.asList(359,255,339,254,253,252,256,341,463)));
            put("leftEyeUpper2", new ArrayList<Integer>(Arrays.asList(342,445,444,443,442,441,413)));
            put("leftEyeLower2", new ArrayList<Integer>(Arrays.asList(446,261,448,449,450,451,452,453,464)));
            put("leftEyeLower3", new ArrayList<Integer>(Arrays.asList(372,340,346,347,348,349,350,357,465)));
            put("leftEyebrowUpper", new ArrayList<Integer>(Arrays.asList(383,300,293,334,296,336,285,417)));
            put("leftEyebrowLower", new ArrayList<Integer>(Arrays.asList(265,353,276,283,282,295)));
            put("leftEyeIris", new ArrayList<Integer>(Arrays.asList(468,469,470,471,472)));
            put("midwayBetweenEyes", new ArrayList<Integer>(Arrays.asList(168)));
            put("noseTip", new ArrayList<Integer>(Arrays.asList(1)));
            put("noseBottom", new ArrayList<Integer>(Arrays.asList(2)));
            put("noseRightCorner", new ArrayList<Integer>(Arrays.asList(98)));
            put("noseLeftCorner", new ArrayList<Integer>(Arrays.asList(327)));
            put("rightCheek", new ArrayList<Integer>(Arrays.asList(205)));
            put("leftCheek", new ArrayList<Integer>(Arrays.asList(425)));
        }};
    }
    public static HashMap<String, ArrayList<Integer>> getFaceMeshModel() {
        return new HashMap<String, ArrayList<Integer>>(){{
            put("lips", new ArrayList<Integer>(Arrays.asList(61,146,91,181,84,17,314,405,321,375,61,185,40,39,37,0,267,269,270,409,78,95,88,178,87,14,317,402,318,324,78,191,80,81,82,13,312,311,310,415,308)));
            put("leftEye", new ArrayList<Integer>(Arrays.asList(263,249,390,373,374,380,381,382,263,466,388,387,386,385,384,398,362)));
            put("leftEyebrow", new ArrayList<Integer>(Arrays.asList(276,283,282,295,300,293,334,296,336)));
            put("leftIris", new ArrayList<Integer>(Arrays.asList(474,475,476,477,474)));
            put("rightEye", new ArrayList<Integer>(Arrays.asList(33,7,163,144,145,153,154,155,33,246,161,160,159,158,157,173,133)));
            put("rightEyebrow", new ArrayList<Integer>(Arrays.asList(46,53,52,65,70,63,105,66,107)));
            put("rightIris", new ArrayList<Integer>(Arrays.asList(469,470,471,472,469)));
            put("faceOval", new ArrayList<Integer>(Arrays.asList(10,338,297,332,284,251,389,356,454,323,361,288,397,365,379,378,400,377,152,148,176,149,150,136,172,58,132,93,234,127,162,21,54,103,67,109,10)));
        }};
    }
    public static ReadableMap convertResultToModel(List<NormalizedLandmark> list, HashMap<String, ArrayList<Integer>> model) {
        WritableMap result = Arguments.createMap();
        for (String key: model.keySet()) {
            ArrayList<Integer> values = model.get(key);
            WritableArray items = Arguments.createArray();
            for (int i = 0; i < values.size(); i++) {
                WritableArray pointArr = Arguments.createArray();
                int index = values.get(i);
                NormalizedLandmark point = (NormalizedLandmark) list.get(index);
                pointArr.pushDouble(point.x());
                pointArr.pushDouble(point.y());
                pointArr.pushDouble(point.z());
                items.pushArray(pointArr);
            }
            result.putArray(key, items);
        }
        return result;
    }
}
