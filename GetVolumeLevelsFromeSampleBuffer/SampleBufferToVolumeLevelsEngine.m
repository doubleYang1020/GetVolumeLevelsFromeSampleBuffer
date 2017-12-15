//
//  SampleBufferToVolumeLevelsEngine.m
//  GetVolumeLevelsFromeSampleBuffer
//
//  Created by huyangyang on 2017/12/8.
//  Copyright © 2017年 HuYangYang.com. All rights reserved.
//

#import "SampleBufferToVolumeLevelsEngine.h"
@implementation SampleBufferToVolumeLevelsEngine
//+(float)getVolumeLevelsFromeSampleBuffer:(CMSampleBufferRef)sampleBuffer{
//    AudioBufferList bufferList;
//    int listSize = sizeof(bufferList);
//    CMBlockBufferRef blockBuffer;
//    OSStatus result;
//    result = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, nil, &bufferList, listSize, nil, nil, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &blockBuffer);
//    if (result == 0) {
//        for( int y=0; y< bufferList.mNumberBuffers; y++ ){
//            AudioBuffer audioBuffer = bufferList.mBuffers[y]; 
//
//            Byte *frame = (Byte *)audioBuffer.mData;
//            float sum = 0;
//            int d = audioBuffer.mDataByteSize/2;
//            for(long i=0; i < d; i++) 
//
//            {
//                long x1 = frame[i*2+1]<<8; 
//
//                long x2 = frame[i*2];
//                short int w = x1 | x2;
//                sum += w*w;
//            } 
//
//            NSLog(@"audio_volume = %lf",(sqrtf(sum/d)));
//            return (sqrtf(sum/d));

+(float)getVolumeLevelsFromeSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
    const AudioStreamBasicDescription asbd = *CMAudioFormatDescriptionGetStreamBasicDescription(formatDescription);
    
    AudioBufferList bufferList;
    int listSize = sizeof(bufferList);
    CMBlockBufferRef blockBuffer;
    OSStatus result;
    result = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, nil, &bufferList, listSize, nil, nil, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &blockBuffer);
    
    float avgLevel = 0.0;
    if (result == 0) {
        AudioBuffer audioBuffer = bufferList.mBuffers[0];
        if (asbd.mFormatFlags & kAudioFormatFlagIsFloat) { // float
            
            float* x = (float*) audioBuffer.mData;
            float sum = 0;
            int count = audioBuffer.mDataByteSize / sizeof(float);
            for (long i = 0; i < count; i ++) {
                sum += (*x) * (*x);
                x++;
            }
            
            avgLevel = sqrtf(sum / count);
            
        }
        else {
            assert(asbd.mFormatFlags & kLinearPCMFormatFlagIsSignedInteger); // signed int
            Byte *frame = (Byte *)audioBuffer.mData;
            float sum = 0;
            for (long i = 0; i < audioBuffer.mDataByteSize; i++) {
                long x1, x2;
                if (asbd.mFormatFlags & kAudioFormatFlagIsPacked) {
                    x1 = frame[i * 2 + 1] << 8;
                    x2 = frame[i * 2];
                }
                else {
                    x1 = frame[i * 2 + 1];
                    x2 = frame[i * 2] << 8;
                }
                short int w = x1 | x2;
                
                sum += w*w;
            }
            
            avgLevel = sqrtf(sum/audioBuffer.mDataByteSize);
        }
        
    }
    return avgLevel;
}
@end
