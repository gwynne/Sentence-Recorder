//
//  SRAppDelegate.m
//  SentenceRecorder
//
//  Created by Gwynne on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SRAppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface SRAppDelegate()
- (void)nextSentence;
@end

@implementation SRAppDelegate
{
	AVAudioRecorder			*recorder;
	NSURL					*sentenceFileURL, *outputFolderURL;
	NSArray					*sentences;
	NSInteger				curSentence;
	BOOL					isRecording;
}

@synthesize	window, sentenceFileLabel, outputFolderLabel, sentenceLabel, sentenceCountLabel, recordStatusLabel,
			chooseSentencesButton, chooseOutputButton;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	recorder = nil;
	sentenceFileURL = nil;
	outputFolderURL = nil;
	sentences = [NSArray array];
	curSentence = NSNotFound;
	isRecording = NO;
	
	sentenceFileLabel.stringValue = @"(none selected)";
	outputFolderLabel.stringValue = @"(none selected)";
	sentenceLabel.stringValue = @"";
	sentenceLabel.delegate = self;
	sentenceCountLabel.stringValue = @"0/0";
	recordStatusLabel.stringValue = @"Standby";
}

- (IBAction)chooseSentences:(id)sender
{
	NSOpenPanel		*panel = [NSOpenPanel openPanel];
	
	[panel setAllowedFileTypes:[NSArray arrayWithObjects:(__bridge NSString *)kUTTypePlainText, nil]];
	[panel setResolvesAliases:YES];
	[panel setCanChooseFiles:YES];
	[panel setCanChooseDirectories:NO];
	[panel setAllowsMultipleSelection:NO];
	[panel beginSheetModalForWindow:self.window completionHandler:^ (NSInteger result) {
		if (result == NSFileHandlingPanelCancelButton)
			return;
		
		NSStringEncoding		encoding = NSASCIIStringEncoding;
		__autoreleasing NSError	*error = nil;
		NSString				*fileContents = [NSString stringWithContentsOfURL:[panel URL] usedEncoding:&encoding error:&error];

		if (!fileContents)
		{
			NSAlert			*alert = [NSAlert alertWithError:error];
			
			[alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
			return;
		}
		
		sentenceFileURL = [panel URL];
		sentenceFileLabel.stringValue = [sentenceFileURL path];
		
		NSArray					*potentialSentences = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSMutableArray			*finalists = [NSMutableArray arrayWithCapacity:potentialSentences.count];
		
		for (NSString *potentialSentence in potentialSentences)
			if ([potentialSentence length] > 0)
				[finalists addObject:potentialSentence];
		sentences = finalists;
		
		[self.window makeFirstResponder:sentenceLabel];
		
		curSentence = NSNotFound;
		[self nextSentence];
	}];
}

- (IBAction)chooseOutput:(id)sender
{
	NSOpenPanel		*panel = [NSOpenPanel openPanel];
	
	[panel setAllowedFileTypes:[NSArray arrayWithObjects:(__bridge NSString *)kUTTypeFolder, nil]];
	[panel setResolvesAliases:YES];
	[panel setCanChooseFiles:NO];
	[panel setCanChooseDirectories:YES];
	[panel setAllowsMultipleSelection:NO];
	[panel beginSheetModalForWindow:self.window completionHandler:^ (NSInteger result) {
		if (result == NSFileHandlingPanelCancelButton)
			return;
		
		outputFolderURL = [panel URL];
		outputFolderLabel.stringValue = [outputFolderURL path];

		[self.window makeFirstResponder:sentenceLabel];
	}];
}

- (void)didPressSpace
{
NSLog(@"space pressed");
	NSURL					*fileURL = [[outputFolderURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%04lu", curSentence]]
											URLByAppendingPathExtension:@"wav"];
	__autoreleasing NSError	*error = nil;
	NSDictionary			*settings = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
		[NSNumber numberWithFloat:48000.0], AVSampleRateKey,
		[NSNumber numberWithInt:2], AVNumberOfChannelsKey,
		[NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
		[NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
		[NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
		[NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleavedKey,
		nil, nil
	];
	
	if (isRecording || !sentenceFileURL || !outputFolderURL || ![sentences count])
		return;
	
	recorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settings error:&error];
	
	if (!recorder)
	{
		NSAlert			*alert = [NSAlert alertWithError:error];
		
		[alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
		return;
	}
	
	isRecording = YES;
	recordStatusLabel.stringValue = @"Recording...";
	[recorder record];
}

- (void)didReleaseSpace
{
	if (!isRecording)
		return;
	
	isRecording = NO;
	[recorder stop];
	recorder = nil;
	recordStatusLabel.stringValue = @"Standing by";
	[self nextSentence];
}

- (void)nextSentence
{
	if (curSentence == NSNotFound || curSentence == [sentences count] - 1)	// loops
		curSentence = -1;
	if (curSentence < [sentences count] - 1 || curSentence == -1)
	{
		++curSentence;
		sentenceCountLabel.stringValue = [NSString stringWithFormat:@"%lu/%lu", curSentence + 1, [sentences count]];
		sentenceLabel.stringValue = [sentences objectAtIndex:curSentence];
	}
}

@end
