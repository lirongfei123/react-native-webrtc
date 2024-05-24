//
//  FaceAvatarViewManager.m
//  react-native-webrtc
//
//  Created by rongping li on 2024/3/24.
//

#import "FaceAvatarViewManager.h"
#import "WebRTCModule.h"

@interface FaceAvatarView : UIImageView
@property(nonatomic, weak) WebRTCModule *module;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSArray *points;
@property(nonatomic, strong) NSArray *avatarPoints;
@end

@implementation FaceAvatarView

- (void)setName:(NSString *)name {
    _name = name;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    UIImage *image = [UIImage imageNamed:@"3m"];
    [self setImage:image];
}

@end

@implementation FaceAvatarViewManager
RCT_EXPORT_MODULE()


RCT_EXPORT_VIEW_PROPERTY(name, NSString *)
RCT_EXPORT_VIEW_PROPERTY(points, NSArray *)
RCT_EXPORT_VIEW_PROPERTY(avatarPoints, NSArray *)


-(UIView *)view {
    FaceAvatarView *faceView = [[FaceAvatarView alloc] init];
    faceView.module = [self.bridge moduleForName:@"WebRTCModule"];
    faceView.clipsToBounds = YES;
    return faceView;
}
@end
