interface Cordova {
	plugins: CordovaPlugins;
}

interface CordovaPlugins {
	SearchAds: ISearchAdsPlugin;
}

/**
 * See:
 * https://developer.apple.com/documentation/iad/setting_up_apple_search_ads_attribution?language=objc
 * https://developer.apple.com/documentation/ad_services?language=objc
 */
interface ISearchAdsAttributionPayload {
	[key: string]: string | number | boolean;
}

interface ISearchAdsErrorPayload {
	/**
	 * error code , see https://github.com/apple/swift/blob/3a75394c670bb7143397327ac7bf5b5fe8d50588/stdlib/public/SDK/Foundation/NSError.swift#L642
	 */
	code?: string;
	/**
	 * relevant only for unexpected flow
	 */
	reason?: string;
	/**
	 * localized description from error, for example: The Internet connection appears to be offline.
	 */
	localizedDescription?: string;
}

/**
 * Return ISearchAdsAttributionPayload
 * Error:
 */
interface ISearchAdsPlugin {
	requestAttributionDetails(): Promise<ISearchAdsAttributionPayload>;
}
