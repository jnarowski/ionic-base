karmacrm3_ionic
===============

KarmaCRM PhoneGap multiplatform mobile application based on Ionic Framework and AngularJS.

One time tools setup
-----------

1. Install [Node.js](http://nodejs.org/download/)
2. Install grunt

    `sudo npm -g install grunt-cli bower`

3. Browser live reload plugin
    - [Chrome](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei)
    - [Firefox](http://download.livereload.com/2.0.8/LiveReload-2.0.8.xpi)
    - [Safari](http://download.livereload.com/2.0.9/LiveReload-2.0.9.safariextz)

Project setup
-------------

1. git clone this repository
2. cd pathToYourSources
3. Install the needed node modules configured by `package.json` into `node_modules` folder

    `npm install`

4. Download vendor dependencies configured by `bower.json` and `.bowerrc` into `vendor` folder

    `bower install`

5. Build the project

    `grunt`

6. Open the build/index.html file in your browser

7. To run the app on a real device:
    - Install the PhoneGap App from your usual App Store
    - in the project root folder, execute:

    `phonegap serve`

    - you get an IP address and Port, to enter in the PhoneGap App startup screen, which launches your app on the device.

8. Run tests with

    `grunt test`