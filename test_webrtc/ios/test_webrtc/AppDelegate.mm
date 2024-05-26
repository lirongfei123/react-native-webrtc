#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <MediaPipeTasksVision/MediaPipeTasksVision.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"test_webrtc";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};

  MPPFaceLandmarkerOptions *options = [[MPPFaceLandmarkerOptions alloc] init];
//  options.baseOptions.modelAssetPath = modelPath;
  options.numFaces = 1;
  NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"face_landmarker" ofType:@"task"];
  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:modelPath];
  options.runningMode = MPPRunningModeImage;
  options.baseOptions.modelAssetPath = modelPath;
  NSError *err;
MPPFaceLandmarker *faceDetector =
        [[MPPFaceLandmarker alloc] initWithOptions:options error:nil];
  
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self getBundleURL];
}

- (NSURL *)getBundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
