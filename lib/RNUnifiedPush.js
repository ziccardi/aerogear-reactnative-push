import {NativeModules} from "react-native";

const NativeRnUnifiedPush = NativeModules.RnUnifiedPush;

// const { RNUnifiedPushEmitter } = NativeModules;

// const eventEmitter = new NativeEventEmitter(RNUnifiedPushEmitter);
//
// const subscription = eventEmitter.addListener(
//   'onUPSPushNotificationReceived',
//   (msg) => console.log('RN Event received:', msg),
// );

export class RNUnifiedPush {
  init(config, successCallback, errorCallback) {
    console.log('init', config, NativeModules);
    NativeRnUnifiedPush.initialize(config, (err, res) => {
      console.log('JS PUSH => Initialized', {err, res});
      if (err) return errorCallback(err);
      return successCallback(res);
    })
  }
}
