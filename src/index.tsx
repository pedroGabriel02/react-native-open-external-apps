import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-open-external-apps' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const { OpenExternalAppModule } = NativeModules.OpenExternalApps
  ? NativeModules.OpenExternalApps
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const OpenExternalApp = {
  open: function (bundleId) {
    return new Promise((resolve, reject) => {
      if (OpenExternalAppModule) {
        OpenExternalAppModule.openApp(bundleId)
          .then((result) => {
            if (result === 'Success') {
              resolve(result);
            } else {
              reject(new Error(`Failed to open app: ${result}`));
            }
          })
          .catch((error) => {
            reject(error);
          });
      } else {
        reject(new Error("OpenExternalAppModule not available"));
      }
    });
  },

  openWithToken: function (bundleId, token) {
    return new Promise((resolve, reject) => {
      if (OpenExternalAppModule) {
        const tokenData = JSON.stringify(token);
        OpenExternalAppModule.openAppWithToken(bundleId, tokenData)
          .then((result) => {
            if (result === 'Success') {
              resolve(result);
            } else {
              reject(new Error(`Failed to open app with token: ${result}`));
            }
          })
          .catch((error) => {
            reject(error);
          });
      } else {
        reject(new Error("OpenExternalAppModule not available"));
      }
    });
  },

  isInstalled: function (bundleId) {
    return new Promise((resolve, reject) => {
      if (OpenExternalAppModule) {
        OpenExternalAppModule.isAppInstalled(bundleId)
          .then((isInstalled) => {
            resolve(isInstalled);
          })
          .catch((error) => {
            reject(error);
          });
      } else {
        reject(new Error("OpenExternalAppModule not available"));
      }
    });
  },
};

export default OpenExternalApp;
