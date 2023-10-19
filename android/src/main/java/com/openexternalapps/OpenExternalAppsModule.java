package com.openexternalapps;

import androidx.annotation.NonNull;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;

import org.json.JSONException;
import org.json.JSONObject;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

import java.util.List;

@ReactModule(name = OpenExternalAppsModule.NAME)
public class OpenExternalAppsModule extends ReactContextBaseJavaModule {
  public static final String NAME = "OpenExternalApps";

  public OpenExternalAppsModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void openApp(String bundleId, Promise promise) {
      PackageManager packageManager = getCurrentActivity().getPackageManager();
      Intent intent = packageManager.getLaunchIntentForPackage(bundleId);

      if (intent != null) {
          getCurrentActivity().startActivity(intent);
          promise.resolve("Success");
      } else {
        Intent marketIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + bundleId));
        List<ResolveInfo> resolveInfos = packageManager.queryIntentActivities(marketIntent, 0);

        if (resolveInfos.size() > 0) {
            promise.reject("AppNotInstalled", "The app with bundleId " + bundleId + " is not installed, but it is available on the Google Play Store.");
        } else {
            promise.reject("AppNotFound", "The app with bundleId " + bundleId + " was not found.");
        }
      }
  }

  @ReactMethod
  public void openAppWithToken(String bundleId, String tokenData, Promise promise) {
    PackageManager packageManager = getCurrentActivity().getPackageManager();
    Intent intent = new Intent(Intent.ACTION_SEND);

    if (intent != null) {
        try {
            JSONObject tokenJson = new JSONObject(tokenData);
            intent.setType("text/plain");
            intent.putExtra(Intent.EXTRA_TEXT, tokenJson.toString());
            intent.setPackage(bundleId);

            try {
                getCurrentActivity().startActivity(intent);
                promise.resolve("Success");
            } catch (ActivityNotFoundException e) {
                e.printStackTrace();
                promise.reject("ActivityNotFoundError", "Error search Activity");
                return;
            }
        } catch (JSONException e) {
            e.printStackTrace();
            promise.reject("JSONError", "Error parsing JSON");
            return;
        }
    } else {
        promise.reject("AppNotFound", "The app with bundleId " + bundleId + " was not found.");
    }
  }

  @ReactMethod
    public void isAppInstalled(String bundleId, Promise promise) {
      PackageManager packageManager = getCurrentActivity().getPackageManager();
      Intent intent = packageManager.getLaunchIntentForPackage(bundleId);

      if (intent != null) {
          promise.resolve(true);
      } else {
          promise.resolve(false);
      }
    }
}
