//
//  SampleBufferToVolumeLevelsEngine.h
//  GetVolumeLevelsFromeSampleBuffer
//
//  Created by huyangyang on 2017/12/8.
//  Copyright © 2017年 HuYangYang.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SampleBufferToVolumeLevelsEngine : NSObject
+(float)getVolumeLevelsFromeSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end
