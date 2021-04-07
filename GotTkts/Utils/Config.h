//
//  Config.h
//
//  Created by IOS7 on 12/16/14.
//  Copyright (c) 2014 iOS. All rights reserved.
//

#import "AppStateManager.h"
/* ***************************************************************************/
/* ***************************** Paypal config ********************************/
/* ***************************************************************************/
#define PAYPAL_APP_ID_SANDBOX       @"APP-80W284485P519543T"
#define PAYPAL_APP_ID_LIVE          @"APP-62661738FK1903841"
#define PAYPAL_IS_PRODUCT_MODE      YES
#define PAYPAL_APP_ID               (PAYPAL_IS_PRODUCT_MODE ? PAYPAL_APP_ID_LIVE : PAYPAL_APP_ID_SANDBOX)
#define PAYPAL_ENV                  (PAYPAL_IS_PRODUCT_MODE ? ENV_LIVE : ENV_SANDBOX)


/* ***************************************************************************/
/* ***************************** Stripe config ********************************/
/* ***************************************************************************/

#define STRIPE_KEY                              @"pk_test_iLIGvGi71bzKVInlXC6csGJO"
//#define STRIPE_KEY                              @"pk_live_wFsQcA8xNgvRdhkSf1xxSUj7"
#define STRIPE_CONNECT_URL                      @"https://gottkts.com/stripe_mobile"
//#define STRIPE_CONNECT_URL                      @"https://10.70.1.109/stripe_mobile"

#define APP_NAME                                                @"GotTkts"
#define PARSE_FETCH_MAX_COUNT                                   10000
#define APP_THEME                                               [AppStateManager sharedInstance].app_theme
//#define APP_THEME                                                @"business"
#define APP_TEHME_CUSTOMER                                      @"customer"
#define APP_THEME_BUSINESS                                      @"business"

#define WEB_END_POINT_ITEM_SEARCH_URL                           @"http://data.enzounified.com:19551/bsc/AmazonPA/ItemSearch"
#define WEB_END_POINT_ITEM_LOOKUP_URL                           @"http://data.enzounified.com:19551/bsc/AmazonPA/ItemLookup/%@"

#define AUTH_TOKEN_KEY                                          @"98c9c3d6-6c1e-4b8a-acd3-9177a1176d90"

/* Friend / SO status values */
#define FRIEND_INVITE_SEND                                      @"Invite"
#define FRIEND_INVITE_ACCEPT                                    @"Accept"
#define FRIEND_INVITE_REJECT                                    @"Reject"

#define SO_INVITE_SEND                                          @"SOInviteSend"
#define SO_INVITE_ACCEPT                                        @"SOInviteAccept"
#define SO_INVITE_REJECT                                        @"SOInviteReject"

/* Pending Type values */
#define PENDING_TYPE_FRIEND_INVITE                              @"Pending_Friend_Invite"
#define PENDING_TYPE_SO_SEND                                    @"Pending_SO_Send"
#define PENDING_TYPE_INTANGIBLE_SEND                            @"Pending_Intangible_Send"

// Push Notification
#define PARSE_CLASS_NOTIFICATION_FIELD_TYPE                     @"type"
#define PARSE_CLASS_NOTIFICATION_FIELD_DATAINFO                 @"dataInfo"
#define PARSE_NOTIFICATION_APP_ACTIVE                           @"app_active"

/* Pagination values  */
#define PAGINATION_DEFAULT_COUNT                                10000
#define PAGINATION_START_INDEX                                  1

/* IWant Type values */
#define IWANT_INTANGIBLE_CATEGORY                                @"Intangible"

/* Notification values */
#define NOTIFICATION_SHOW_PENDING_PAGE                          @"ShowPending"
#define NOTIFICATION_HIDE_PENDING_PAGE                          @"HidePending"

#define NOTIFICATION_SHOW_INPUTSO_PAGE                          @"ShowInputSO"
#define NOTIFICATION_HIDE_INPUTSO_PAGE                          @"HideInputSO"

#define NOTIFICATION_SHOW_INTANGIBLE_PAGE                       @"ShowIntangible"
#define NOTIFICATION_HIDE_INTANGIBLE_PAGE                       @"HideIntangible"

#define NOTIFICATION_SHOW_SOPREVIEW_PAGE                        @"ShowSOPreview"
#define NOTIFICATION_HIDE_SOPREVIEW_PAGE                        @"HideSOPreview"

#define MAIN_COLOR          [UIColor colorWithRed:31/255.f green:168/255.f blue:250/255.f alpha:1.f]
#define MAIN_BORDER_COLOR   [UIColor colorWithRed:186/255.f green:186/255.f blue:186/255.f alpha:1.f]
#define MAIN_BORDER1_COLOR  [UIColor colorWithRed:209/255.f green:209/255.f blue:209/255.f alpha:1.f]
#define MAIN_BORDER2_COLOR  [UIColor colorWithRed:95/255.f green:95/255.f blue:95/255.f alpha:1.f]
#define MAIN_HEADER_COLOR   [UIColor colorWithRed:103/255.f green:103/255.f blue:103/255.f alpha:1.f]
#define MAIN_SWDEL_COLOR    [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
#define MAIN_DESEL_COLOR    [UIColor colorWithRed:206/255.f green:89/255.f blue:37/255.f alpha:1.f]
#define MAIN_HOLDER_COLOR   [UIColor colorWithRed:170/255.f green:170/255.f blue:170/255.f alpha:1.f]
#define MAIN_TRANS_COLOR          [UIColor colorWithRed:204/255.f green:227/255.f blue:244/255.f alpha:1.f]
#define PLACEHOLDER_COLOR          [UIColor colorWithRed:199/255.f green:199/255.f blue:205/255.f alpha:1.f]

/* Page Notifcation */
#define NOTIFICATION_START_PAGE                                 @"StartMainPage"
#define NOTIFICATION_SIGNIN_PAGE                                @"SignInPage"
#define NOTIFICATION_PASSWDRESET_PAGE                           @"PasswdResetPage"
#define NOTIFICATION_WANTLIST_PAGE                              @"WantListPage"
#define NOTIFICATION_PROFILE_PAGE                               @"ProfilePage"
#define NOTIFICATION_FRIENDS_PAGE                               @"FriendsPage"
#define NOTIFICATION_INVITE_PAGE                                @"InvitePage"
#define NOTIFICATION_INSTRUCTIONS_PAGE                          @"InstructionsPage"
#define NOTIFICATION_NEWITEM_PAGE                               @"NewItemPage"
#define NOTIFICATION_NEWCATEGORY_PAGE                           @"NewCategoryPage"
#define NOTIFICATION_HIDENEW_PAGE                               @"HideNewPage"

/* Refresh Notifcation */
#define NOTIFICATION_REFRESH_FRIENDS                            @"RefreshFriends"
#define NOTIFICATION_REFRESH_MYLIST                             @"RefreshMyList"
#define NOTIFICATION_CHANGED_PAGE                               @"ChangedPage"
#define NOTIFICATION_REFRESH_BADGE                              @"RefreshBadge"

/* Remote Notification Type values */
#define REMOTE_NF_TYPE_NEW_ITEM                                 @"New_Iwant_Item"
#define REMOTE_NF_TYPE_NEW_CATEGORY                             @"New_Category"
#define REMOTE_NF_TYPE_FRIEND_INVITE                            @"Friend_Invite"
#define REMOTE_NF_TYPE_INVITE_ACCEPT                            @"Invite_Result_Accept"
#define REMOTE_NF_TYPE_INVITE_REJECT                            @"Invite_Result_Reject"
#define REMOTE_NF_TYPE_CLICK_EMPTY_CATEGORY                     @"Click_Empty_Category"

/* JCWheelView Notification */
#define NOTIFICATION_SPIN_STOP                                  @"spin_stopped"

/* Spin Notification Data */
#define SPIN_POINT_X                                             @"point_x"
#define SPIN_POINT_Y                                             @"point_y"

enum {
    USER_TYPE_CUSTOMER = 0,
    USER_TYPE_SUB_PROMOTER = 1,
    USER_TYPE_PROMOTER = 2
};

enum {
    FLAG_FAQ,
    FLAG_PRIVACY,
    FLAG_TERMS
};

enum {
    TRADE_STATE_PENDING,
    TRADE_STATE_ACCEPTED,
    TRADE_STATE_DECLIEND,
    TRADE_STATE_COMPLETED
};

enum {
    CHAT_TYPE_MESSAGE = 100,
    CHAT_TYPE_IMAGE = 200,
    CHAT_TYPE_VIDEO = 300
};

enum {
    PUSH_TYPE_CHAT = 1,
    PUSH_TYPE_OFFER_SEND,
    PUSH_TYPE_OFFER_ACCEPT,
    PUSH_TYPE_OFFER_DECLINE,
    PUSH_TYPE_OFFER_COMPLETE
};

#define PUSH_NOTIFICATION_TYPE                                  @"type"
#define kChatReceiveNotification                                @"ChatReceiveNotification"
#define kChatReceiveRoomsNotification                           @"kChatReceiveRoomsNotification"

/* Pages Notifications */
#define NOTIFICATION_PAGE_HOME                                  @"NOTIFICATION_PAGE_HOME"
#define NOTIFICATION_PAGE_PROFILE                               @"NOTIFICATION_PAGE_PROFILE"
#define NOTIFICATION_PAGE_CATEGORY                              @"NOTIFICATION_PAGE_CATEGORY"
#define NOTIFICATION_PAGE_TRADE                                 @"NOTIFICATION_PAGE_TRADE"
#define NOTIFICATION_PAGE_FAVORITE                              @"NOTIFICATION_PAGE_FAVORITE"
#define NOTIFICATION_PAGE_MESSAGE                               @"NOTIFICATION_PAGE_MESSAGE"
#define NOTIFICATION_PAGE_ABOUT                                 @"NOTIFICATION_PAGE_ABOUT"
#define NOTIFICATION_PAGE_SETTINGS                              @"NOTIFICATION_PAGE_SETTINGS"
#define NOTIFICATION_PAGE_SIGNOUT                               @"NOTIFICATION_PAGE_SIGNOUT"

/* HTTP URL */
#define REQUEST_BASE_URL                                        @"https://gotticketz.com/api/"
//#define REQUEST_BASE_URL                                        @"https://gottkts.com/api/"
//#define REQUEST_BASE_URL                                        @"http://10.70.1.109/api/"
#define REQUEST_SIGN_UP                                         [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"signup"]
#define REQUEST_SIGN_IN                                         [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"login"]
#define REQUEST_RESET_PWD                                         [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"resetPassword"]
#define REQUEST_UPDATE_PROFILE                                  [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"user/updateProfile"]
#define REQUEST_LIVE_EVENT                                      [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"event/live"]
#define REQUEST_CREATE_EVENT                                    [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"event/create"]
#define REQUEST_UPDATE_EVENT                                    [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"event/update"]
#define REQUEST_ALL_CATEGORY                                    [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"event/categories"]
#define REQUEST_TICKETS                                         [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"eventticket/gettickets/"]
#define REQUEST_TICKETS_BOOK                                    [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"eventticket/book"]
#define REQUEST_TICKETS_PURCHASE                                [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"eventticket/purchase"]
#define REQUEST_ORDERED_TICKETS                                 [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"eventticket/getMyTkts/"]
#define REQUEST_FAQ                                             [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"faq"]
#define REQUEST_PRIVACY                                         [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"privacy"]
#define REQUEST_TERMS                                           [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"terms"]
#define REQUEST_EVENT_DASH                                      [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"event/dashbord/"]
#define REQUEST_EVENT_CHECKIN                                   [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"ticketcode/"]
#define REQUEST_GET_ORDERS_LIST                                 [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"order/ticktes/list/"]
#define REQUEST_GET_ACCOUNTID                                   [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"user/accountId"]
#define REQUEST_ADD_BANK                                        [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"user/addBank"]

// sub promoter side
#define REQUEST_SUB_EVENTS      [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"event/subpromoter"]
#define REQUEST_SUB_PROMOTING   [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"event/promoting"]
#define REQUEST_SUB_PENDING     [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"event/pending"]
#define REQUEST_SUB_SOLD_TKTS   [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"eventticket/soldTickets"]
#define REQUEST_SUB_PAID_TKTS   [NSString stringWithFormat:@"%@%@", REQUEST_BASE_URL, @"eventticket/payment"]

#define FOOD_COURSE               [[NSArray alloc] initWithObjects:@"Appetizers", @"Soups", @"Main Course", @"Salad", @"Dessert", nil]
// #define RESTURANT_CUISINE         [[NSArray alloc] initWithObjects:@"Indian", @"Polish", @"Asian", @"Irish", @"Greek", @"Seafood", @"American", @"French", @"Spanish", @"Russian", @"Southern", @"German", @"Middle Eastern", @"Italian", @"Mexican", @"Carribean", nil]
#define RESTURANT_CUISINE         [[NSArray alloc] initWithObjects:@"American", @"Asian", @"Carribean", @"French", @"German", @"Greek", @"Indian", @"Italian", @"Irish", @"Middle Eastern", @"Mexican", @"Polish", @"Seafood", @"Southern", @"Spanish", @"Russian", nil]

#define CATEGORY_ARRAY                     [[NSArray alloc] initWithObjects:@"Comedy", @"Events", @"Conference", @"Ski Trips", @"Night Club", @"Screening", @"Kids", @"Live Performance", @"One day Gateways", @"Sporting Events", @"Live Music", nil]

#define CATEGORY_ICON_ARRAY                 [[NSArray alloc] initWithObjects: @"ic_cat_daycard", @"ic_cat_health", @"ic_cat_rest", @"ic_cat_homemade", @"ic_cat_hotel", @"ic_cat_private", @"ic_cat_event", @"ic_cat_news", @"ic_cat_pet", @"ic_cat_educ", @"ic_cat_vol", @"ic_cat_coach", @"ic_cat_fashion", @"ic_cat_tech", @"ic_cat_general", @"ic_cat_travel", @"ic_cat_beauty", @"ic_cat_home", @"ic_cat_art", @"ic_cat_car", @"ic_cat_entertainment", @"ic_cat_private", @"ic_cat_real_est", @"ic_cat_sport", @"ic_cat_other", nil]

#define PROMO_TYPE                     [[NSArray alloc] initWithObjects:@"Free", @"Discount Percentage", nil]

