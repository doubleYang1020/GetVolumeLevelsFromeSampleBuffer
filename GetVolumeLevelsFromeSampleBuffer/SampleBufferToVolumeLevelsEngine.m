//
//  SampleBufferToVolumeLevelsEngine.m
//  GetVolumeLevelsFromeSampleBuffer
//
//  Created by huyangyang on 2017/12/8.
//  Copyright © 2017年 HuYangYang.com. All rights reserved.
//

#import "SampleBufferToVolumeLevelsEngine.h"

@implementation SampleBufferToVolumeLevelsEngine



+(float)getVolumeLevelsFromeSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    AudioBufferList bufferList;
    int listSize = sizeof(bufferList);
    CMBlockBufferRef blockBuffer;
    
    OSStatus result;
    result = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, nil, &bufferList, listSize, nil, nil, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &blockBuffer);
    
    if (result == 0) {
        
        for( int y=0; y< bufferList.mNumberBuffers; y++ ){
            AudioBuffer audioBuffer = bufferList.mBuffers[y]; 
            
            Byte *frame = (Byte *)audioBuffer.mData;
            float sum = 0;
            int d = audioBuffer.mDataByteSize/2;
            for(long i=0; i < d; i++) 
            {
                long x1 = frame[i*2+1]<<8; 
                long x2 = frame[i*2];
                short int w = x1 | x2;
                sum += w*w;
                
                
            } 
            NSLog(@"audio_volume = %lf",(sqrtf(sum/d)));
            return (sqrtf(sum/d));
        } 
        
    }
    return 0.0;
}
@end
