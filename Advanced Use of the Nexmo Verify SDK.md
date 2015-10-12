Advanced use of the Nexmo Verify SDK
===================================

The following sections explain how to use the advanced features in the Nexmo Verify SDK:

* <a href="#search">Search User Status</a>
* <a href="#cancel">Cancel verification</a>
* <a href="#trigger">Trigger the next verification event</a>
* <a href="#logout">Logout</a>

## Search User Status<a name="search"></a>

You use *getUserStatus* to retrieve a user's current verification status. *getUserStatus* takes into account the device it is being executed on. Only query the status of the user using the current (device ID, phone number) pair.

To search for status:

1. Add the following to your code:
    **Swift**
    ```swift
    VerifyClient.getUserStatus(countryCode: "GB", number: "447777777777") { status, error in
        if let error = error {
            // unable to get user status for given device + phone number pair
            return
        }

        switch (status!) {
            case "pending":
        }
    }
    ```

    **Objective-C**
    ```objective-c
    [VerifyClient getUserStatusWithCountryCode:@"GB" withNumber:@"447777777777" withBlock:^(NSString *status, NSError *error) {
        if (error != nil) {
            // unable to get user status
            return;
        }

        if ([status isEqualToString:UserStatus.USER_UNKNOWN]) {
            // user has never before been verified
            // ..

        } else if (status isEqualToString:UserStatus.USER_PENDING) {
            // a verification request is currently in progress for this user
            // ..

        }

        // other user statuses can be found in the UserStatus class
        //..
    }];
    ```

## Cancel verification<a name="cancel"></a>

You can cancel an ongoing verification. For example, if a user no longer wishes to perform the verification. A cancelled verification will not send any further verification SMS or TTS requests to the device.

To cancel a verification request:

1. Add the following to your code:
    **Swift**
    ```swift
    VerifyClient.cancelVerification() { error in
        if let error = error {
            // something wen't wrong whilst attempting to cancel the current verification request
            return
        }

        // verification request successfully cancelled
    }
    ```

    **Objective-C**
    ```objective-c
    [VerifyClient cancelVerificationWithBlock:^(NSError *error) {
        if (error != nil) {
            // something wen't wrong whilst attempting to cancel the current verification request
            return;
        }

        // verification request successfully cancelled
    }];
    ```

## Trigger the next verification event<a name="trigger"></a>

Speed up the verification workflow by triggering the next workflow event early. For instance in an *SMS -> TTS -> TTS* workflow, at the SMS stage, call the *command* function with *Command.TRIGGER_NEXT_EVENT* action to trigger the *TTS* event.

To trigger the next event:

1. Add the following to your code:
    **Swift**
    ```swift
    VerifyClient.triggerNextEvent() { error in
        if let error = error {
            // unable to trigger next event
            return
        }

        // successfully triggered next event
    }
    ```

    **Objective-C**
    ```objective-c
    [VerifyClient triggerNextEventWithBlock:^(NSError *error) {
        if (error != nil) {
            // unable to trigger next event
            return;
        }

        // successfully triggered next event
    }];
    ```

## Logout<a name="logout"></a>

You can logout a user in order to reset their verification status. Subsequent verification requests will no longer return a *verified* response directly, they will execute the entire verification workflow again.

To logout a user:

1. Add the following to your code:
    **Swift**
    ```swift
    VerifyClient.logoutUser() { error in
        if let error = error {
            // unable to logout user
            return
        }

        // successfully logged out user
    }
    ```

    **Objective-C**
    ```objective-c
    [VerifyClient triggerNextEventWithBlock:^(NSError *error) {
        if (error != nil) {
            // unable to logout user
            return;
        }

        // successfully logged out user
    }];
    ```
