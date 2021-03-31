//
//  ChatDetailsViewController.m
//  Lavigne
//
//  Created by gao on 7/26/18.
//  Copyright © 2018 developer. All rights reserved.
//

#import "ChatDetailsViewController.h"

static ChatDetailsViewController *_sharedViewController = nil;

@interface ChatDetailsViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    PFUser *me;
    
    NSMutableArray *messages;
    JSQMessagesBubbleImage *outgoingBubbleImageData;
    JSQMessagesBubbleImage *incomingBubbleImageData;
    
    BOOL isLoading;
    
    BOOL isCamera;
    BOOL isPhoto;

}
@end

@implementation ChatDetailsViewController
@synthesize toUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    me = [PFUser currentUser];
    
    isCamera = NO;
    isPhoto = NO;
    
    _sharedViewController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage) name:kChatReceiveNotification object:nil];
    
//    self.inputToolbar.contentView.textView.pasteDelegate = self;
    self.inputToolbar.contentView.rightBarButtonItem.enabled = YES;
    [self.inputToolbar setBackgroundColor:[UIColor clearColor]];
    self.inputToolbar.contentView.textView.placeHolder = @"Type message here...";
    [self.inputToolbar.contentView setBackgroundColor:[UIColor clearColor]];
    self.inputToolbar.contentView.textView.textColor = [UIColor whiteColor];
    [self.inputToolbar.contentView.textView setBackgroundColor:[UIColor clearColor]];
    [self.inputToolbar.contentView.leftBarButtonContainerView setBackgroundColor:[UIColor clearColor]];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [JSQMessagesBubbleImageFactory new];
    outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor lightTextColor]];
    
    messages = [NSMutableArray new];
    isLoading = NO;
    
    /**  hide avatars **/
    //    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    //    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.showLoadEarlierMessagesHeader = NO;
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
    
    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */
    
    /** Set a maximum height for the input toolbar **/
    self.inputToolbar.maximumHeight = 150;
    self.senderId = @"";
    self.senderDisplayName = @"";
    
    if (toUser){
        [self refreshUI];
    } else {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshUI {
    [AppStateManager sharedInstance].chatRoomId = self.room.objectId;
    self.senderId = me.objectId;
    self.senderDisplayName = me[PARSE_USER_FULL_NAME];
    
    [self loadMessages];
}

- (void) refreshMessage {
    self.room[PARSE_ROOM_IS_READ] = @YES;
    [self.room saveInBackground];
    
    [self loadMessages];
}

- (void)loadMessages {
    if (!isLoading) {
        isLoading = true;
        MessageModel *message_last = messages.lastObject;
        
        PFQuery *query = [PFQuery queryWithClassName:PARSE_TABLE_CHAT_HISTORY];
        [query whereKey:PARSE_CHAT_ROOM equalTo:self.room];
        if (message_last != nil) {
            [query whereKey:PARSE_FIELD_CREATED_AT greaterThan:message_last.date];
        }
        [query orderByDescending:PARSE_FIELD_CREATED_AT];
        [query includeKey:PARSE_CHAT_SENDER];
        [query setLimit:100];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error && objects.count > 0) {
                self.automaticallyScrollsToMostRecentMessage = NO;
                for (int i = objects.count - 1; i>=0; i--) {
                    [self addMessage:objects[i]];
                }
                
                [self finishReceivingMessage];
                [self scrollToBottomAnimated:NO];
                self.automaticallyScrollsToMostRecentMessage = YES;
            }
            isLoading = NO;
        }];
    }
}

- (void)addMessage:(PFObject *)object {
    
    PFUser *sender = object[PARSE_ROOM_SENDER]; // me
    NSString *senderId = sender.objectId;
    
    if (![senderId isEqualToString:me.objectId] && ![senderId isEqualToString:toUser.objectId]){
        return;
    }
    
    PFFile *fileVideo = object[PARSE_CHAT_VIDEO];
    PFFile *filePhoto = object[PARSE_CHAT_IMAGE];
    
    
    if (!filePhoto && !fileVideo)
    {
        NSString *chatText = object[PARSE_CHAT_MESSAGE];
        MessageModel *message = [[MessageModel alloc] initWithSenderId:senderId senderDisplayName:sender[PARSE_USER_FULL_NAME] date:object.createdAt text:chatText];
        //        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:sender[USER_FIELD_FULLNAME] date:object.createdAt text:chatText];
        message.objectId = object.objectId;
        [messages addObject:message];
    }
    
    if (fileVideo)
    {
        JSQVideoMediaItem *mediaItem = [[JSQVideoMediaItem alloc] initWithFileURL:[NSURL URLWithString:fileVideo.url] isReadyToPlay:YES];
        
        mediaItem.appliesMediaViewMaskAsOutgoing = [senderId isEqualToString:me.objectId];
        
        MessageModel *videoMsg = [[MessageModel alloc] initWithSenderId:senderId senderDisplayName:sender[PARSE_USER_FULL_NAME] date:object.createdAt media:mediaItem];
        videoMsg.objectId = object.objectId;
        mediaItem.fileURL = [NSURL URLWithString:fileVideo.url];
        videoMsg.video = fileVideo;
        [messages addObject:videoMsg];
    }
    
    if (filePhoto)
    {
        JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
        
        mediaItem.appliesMediaViewMaskAsOutgoing = [senderId isEqualToString:me.objectId];
        
        MessageModel *photoMsg = [[MessageModel alloc] initWithSenderId:senderId senderDisplayName:sender[PARSE_USER_FULL_NAME] date:object.createdAt media:mediaItem];
        photoMsg.objectId = object.objectId;
        [filePhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                mediaItem.image = [UIImage imageWithData:data];
                photoMsg.image = mediaItem.image;
                [self.collectionView reloadData];
            }
        }];
        
        [messages addObject:photoMsg];
    }
}

/// Helper methods
- (BOOL)inComing:(JSQMessage *)message {
    BOOL isOutGoing = [message.senderId isEqualToString:me.objectId];
    return !isOutGoing;
}

- (BOOL)outGoing:(JSQMessage *)message {
    BOOL isOutGoing = [message.senderId isEqualToString:me.objectId];
    return isOutGoing;
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    text = [Util trim:text];
    UITextView *textView = self.inputToolbar.contentView.textView;
    textView.text = text;
    if (toUser){
        if (text.length == 0) {
            [Util showAlertTitle:self title:@"Error" message:@"Please enter your message."];
            return;
        }
        if (text.length > 1000) {
            //            text = [text substringToIndex:1000];
            [Util showAlertTitle:self title:@"Error" message:@"Your message is too long."];
            return;
        }
        [self sendMessage:text video:nil photo:nil];
    } else {
        [Util showAlertTitle:self title:@"Error" message:@"No receiver"];
    }
}

- (void)sendMessage:(NSString *)text video:(PFFile *)video photo:(PFFile *)photo {
    if (!self.room || !toUser){
        [Util showAlertTitle:self title:@"Error" message:@"Please select recipient first."];
        return;
    }
    NSString *shortMsg = @"";
    PFObject *object = [PFObject objectWithClassName:PARSE_TABLE_CHAT_HISTORY];
    object[PARSE_CHAT_ROOM] = self.room;
    object[PARSE_CHAT_SENDER] = me;
    object[PARSE_CHAT_RECEIVER] = toUser;
    
    if (text) {
        object[PARSE_CHAT_MESSAGE] = text;
        object[PARSE_CHAT_TYPE] = [NSNumber numberWithInt:CHAT_TYPE_MESSAGE];
        
        shortMsg = [NSString stringWithFormat:@"'%@'", text];
        if (text.length > 20) {
            shortMsg = [NSString stringWithFormat:@"'%@...'", [text substringToIndex:20]];
        }
    }
    
    if (video) {
        object[PARSE_CHAT_VIDEO] = video;
        object[PARSE_CHAT_TYPE] = [NSNumber numberWithInt:CHAT_TYPE_VIDEO];
        shortMsg = @"with video";
    }
    
    if (photo) {
        object[PARSE_CHAT_IMAGE] = photo;
        object[PARSE_CHAT_TYPE] = [NSNumber numberWithInt:CHAT_TYPE_IMAGE];
        shortMsg = @"with photo";
    }
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [JSQSystemSoundPlayer jsq_playMessageSentSound];
            if (text.length > 0)
                self.room[PARSE_ROOM_LAST_MSG] = text;
            else if (video)
                self.room[PARSE_ROOM_LAST_MSG] = @"Sent video file";
            else if (photo)
                self.room[PARSE_ROOM_LAST_MSG] = @"Sent photo file";
            self.room[PARSE_ROOM_MSG_SENDER] = me;
            self.room[PARSE_ROOM_IS_READ] = @NO;
            [self.room saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
                [self sendPushNotification:shortMsg];
            }];
            [self loadMessages];
        }
    }];
    
    [self finishSendingMessage];
}

+ (ChatDetailsViewController *)getInstance{
    return _sharedViewController;
}


- (void)sendPushNotification:(NSString *)msg {
    BOOL isEnableChatNotify = YES;
    if (isEnableChatNotify) {
        NSString *name = me[PARSE_USER_FULL_NAME];
        NSString *pushMsg = [NSString stringWithFormat:@"%@ sent a message %@", name, msg];
        NSDictionary *data = @{
                               @"alert" : pushMsg,
                               @"badge" : @"Increment",
                               @"sound" : @"cheering.caf",
                               @"email" : toUser.username,
                               @"type"  : [NSNumber numberWithInt:PUSH_TYPE_CHAT],
                               @"data"  : self.room.objectId
                               };
        
        [PFCloud callFunctionInBackground:@"SendPush" withParameters:data block:^(id object, NSError *err) {
            if (err) {
                NSLog(@"Fail APNS: %@", @"SendChat");
            } else {
                NSLog(@"Success APNS: %@", @"SendChat");
            }
        }];
    }
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
    UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self onTakePhoto:nil];
    }]];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Choose from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self onChoosePhoto:nil];
    }]];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Send video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self onChooseVideo:nil];
    }]];
    
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:actionsheet animated:YES completion:nil];
}

- (void)onChoosePhoto:(id)sender {
    if (![Util isPhotoAvaileble]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Photo"];
        return;
    }
    isPhoto = YES;
    isCamera = NO;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)onChooseVideo:(id)sender {
    isPhoto = YES;
    isCamera = NO;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
    [self.parentViewController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)onTakePhoto:(id)sender {
    if (![Util isCameraAvailable]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Camera"];
        return;
    }
    isCamera = YES;
    isPhoto = NO;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (isCamera &&![Util isCameraAvailable]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Camera"];
        return;
    }
    if (isPhoto && ![Util isPhotoAvaileble]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Photo"];
        return;
    }
    
    NSString *type = info[UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *videoUrl = info[UIImagePickerControllerMediaURL];
        NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
        
        float filesize = (float)videoData.length/1024.0f/1024.0f;
        NSLog(@"File size is : %.2f MB",filesize);
        
        if (filesize > 3.0){
            [Util showAlertTitle:self title:@"Error" message:@"You cannot send larger than 3 MB"];
            return;
        }
        [self sendMessage:@"" video:[PFFile fileWithName:@"video.mov" data:videoData] photo:nil];
    } else {
        UIImage *image = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
        image = [Util getUploadingImageFromImage:image];
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        [self sendMessage:@"" video:nil photo:[PFFile fileWithData:data]];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self.inputToolbar.contentView.textView becomeFirstResponder];
        return;
    }
    
    //    switch (buttonIndex) {
    //        case 0:
    //            [self.demoData addPhotoMediaMessage];
    //            break;
    //
    //        case 1:
    //        {
    //            __weak UICollectionView *weakView = self.collectionView;
    //
    //            [self.demoData addLocationMediaMessageCompletion:^{
    //                [weakView reloadData];
    //            }];
    //        }
    //            break;
    //
    //        case 2:
    //            [self.demoData addVideoMediaMessage];
    //            break;
    //    }
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessageAnimated:YES];
}



#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    //    MessageModel *message = messages[indexPath.item];
    //    NSString *senderId = message.senderId;
    //    if (![senderId isEqualToString:me.objectId]) {
    //        //        [CommonUtils showAlertView:@"" message:@"Can't delete messages from others" delegate:nil tag:TAG_ERROR];
    //        NSLog(@"Cant delete messages from others");
    //        return;
    //    }
    //
    //    PFQuery *query = [PFQuery queryWithClassName:PARSE_TABLE_CHAT];
    //    [query whereKey:PARSE_FIELD_OBJECT_ID equalTo:message.objectId];
    //    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
    //        if (object) {
    //            [object deleteInBackground];
    //        }
    //    }];
    //
    //    [messages removeObjectAtIndex:indexPath.item];
    //    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    //    [collectionView.collectionViewLayout invalidateLayout];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return outgoingBubbleImageData;
    }
    
    return incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    else {
        return nil;
    }
    
    // can add avatar image
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = MAIN_COLOR;
            if (!me[PARSE_USER_AVATAR])
                cell.avatarImageView.image = [JSQMessagesAvatarImageFactory circularAvatarImage:[UIImage imageNamed:@"default_profile"] withDiameter:48];
            else{
                [Util setCircleView:cell.avatarImageView];
            }
        }
        else {
            cell.textView.textColor = MAIN_COLOR;
            if (!self.toUser[PARSE_USER_AVATAR])
                cell.avatarImageView.image = [JSQMessagesAvatarImageFactory circularAvatarImage:[UIImage imageNamed:@"default_profile"] withDiameter:48];
            else{
                [Util setCircleView:cell.avatarImageView];
            }
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
    [self.inputToolbar.contentView.textView resignFirstResponder];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
    [self.inputToolbar.contentView.textView resignFirstResponder];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
    JSQMessage *msg = [messages objectAtIndex:indexPath.item];
    if (msg.isMediaMessage){
        MessageModel *model = [messages objectAtIndex:indexPath.row];
        if (model.image){
            
        } else if (model.video){
            
        }
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
    [self.inputToolbar.contentView.textView resignFirstResponder];
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods


- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSString *username = textField.text;
    if (![username isEmail]){
        return;
    }
    PFQuery *query = [PFUser query];
    [query whereKey:PARSE_USER_USERNAME notEqualTo:textField.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error && object){
            //            self.other = (PFUser *)object;
            //            [self refreshUI];
        }
    }];
}

#pragma  alertview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger tag = alertView.tag;
    //    if (tag == TAG_ERROR) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
