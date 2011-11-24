//
//  SRAppDelegate.h
//  SentenceRecorder
//
//  Created by Gwynne on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SRSentenceField.h"

/******************************************************************************/
@interface SRAppDelegate : NSObject <NSApplicationDelegate, SRSentenceFieldDelegate>

@property(nonatomic,assign) IBOutlet	NSWindow		*window;
@property(nonatomic,weak)	IBOutlet	NSTextField		*sentenceFileLabel, *outputFolderLabel,
														*sentenceCountLabel, *recordStatusLabel;
@property(nonatomic,weak)	IBOutlet	SRSentenceField	*sentenceLabel;
@property(nonatomic,weak)	IBOutlet	NSButton		*chooseSentencesButton, *chooseOutputButton;

- (IBAction)chooseSentences:(id)sender;
- (IBAction)chooseOutput:(id)sender;

@end
