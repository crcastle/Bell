# Bell Phone App #

_Note that this is an unfinished experimental phone management app. Use at your own risk_

- means in progress
+ means done
* means not started

**Feature todo**  
-	(emailed cv support) Create new Cloudvox app on user creation  
-	Fix hard-coded references to Cloudvox apps  
+	Assign SIP extension number programatically  
+	Don't allow SIP extension number to be changed by user  
+	Don't allow land or mobile number to be changed after verification  
+	Change phone type selection to drop-down and move above number input box  
+	Include validation of mobile and land numbers  
+	Expose SIP cloudvox username and password on id.haml page  
+	Change POST routes that modify data to PUT route  
+	Change POST routes that delete data to DELETE route  
+	Change username to email address  
- 	Require at least 6 character password
+	Finish admin interface buildout  
*	Change "attribute" to "reference" to represent relationship between user and phone and user and number
*	Improve UI for number provisioning page  
*	Incorporate Cloudvox number list on number provisioning page  
*	Provision Cloudvox number using provisioning page  
*	Provision Tropo numbers (when Tropo API is available)  
*	Provision virtualphoneline.com (per minute) and phone2net.com (fixed monthly) numbers  
*	Update call history to show accurate in/out calls by user (i.e. app)  
*	Translate call history dates to human readable format  
*	Translate call history duration to minutes and seconds  
*	Add pagination to tables in phone and number listing  
*	Allow sorting of tables (use query string parameter)  
*	Move table page numbering to query string parameter  
*	Verify email address before allowing adding of phones or numbers  
*	Add forgot password functionality  
*	vendor all gems  
*	Add billing...  