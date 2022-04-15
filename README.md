# cordova-plugin-search-ads
A apple search ads attribution plugin for cordova

### Supported Platforms
- iOS

## Types

```
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

interface ISearchAdsPlugin {
	requestAttributionDetails(): Promise<ISearchAdsAttributionPayload>;
}

```


## Example

```typescript

cordova.plugins.SearchAds.requestAttributionDetails()
    .then((payload: ISearchAdsAttributionPayload) => console.log(payload))
    .catch((error?: any) => console.error(error));

```
