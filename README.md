# flutter_auth
blog: https://hackernoon.com/instagram-authentication-with-flutter-df6424d2d56c

An example of an app with Instagram Authentication on Flutter.

// Info.plist
```
	<!-- flutter webview plugin -->
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
		<key>NSAllowsArbitraryLoadsInWebContent</key>
		<true/>
	</dict>
	<!-- GOOGLE, TWITTER LOGIN -->
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>twitterkit-TWITTERAPPID</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>com.googleusercontent.apps.TOKEN</string>
			</array>
		</dict>
	</array>
				<!-- FACEBOOK LOGIN -->
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>FBAPPID</string>
		</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>com.googleusercontent.apps.BUNDLEID</string>
			</array>
		</dict>
	</array>
	<key>FacebookAppID</key>
	<string>APPID</string>
	<key>FacebookDisplayName</key>
	<string>Tassel App</string>
	<key>NSAppTransportSecurity</key>
    <dict>
        <key>NSExceptionDomains</key>
        <dict>
            <key>graph.facebook.com</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSExceptionRequiresForwardSecrecy</key>
                <false/>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <true/>
            </dict>
            <key>facebook.com</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSExceptionRequiresForwardSecrecy</key>
                <false/>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <true/>
            </dict>
            <key>fbcdn.net</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSExceptionRequiresForwardSecrecy</key>
                <false/>
            </dict>
            <key>akamaihd.net</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSExceptionRequiresForwardSecrecy</key>
                <false/>
            </dict>
        </dict>
    </dict>
	<key>LSApplicationQueriesSchemes</key>
        <array>
            <string>fbapi</string>
            <string>fb-messenger-share-api</string>
            <string>fbauth2</string>
            <string>fbshareextension</string>
        </array>
        <!-- End of Facebook Login configuration -->
        ```