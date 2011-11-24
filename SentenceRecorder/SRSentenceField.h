//
//  SRSentenceField.h
//  SentenceRecorder
//
//  Created by Gwynne on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SRSentenceFieldDelegate <NSObject>

@required
- (void)didPressSpace;
- (void)didReleaseSpace;

@end

@interface SRSentenceField : NSTextField

@property(nonatomic, weak)	id<SRSentenceFieldDelegate>		delegate;

@end

@interface SRSentenceCell : NSTextFieldCell
@end
