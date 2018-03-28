# snowyowl-app
Snowy Owl - App

## Get Started

```bash
git clone git@github.com:snowyowlanimatronic/snowyowl-app.git
cd snowyowl-app

# Install bower
npm install -g bower

# Install yarn
npm install -g yarn

# install nvm for windows following these instructions
https://github.com/coreybutler/nvm-windows

# After installing, set nvm in environment variable NVM_HOME, e.g.
# C:\Users\user\AppData\Roaming\nvm\nvm.exe

# Use nvm to see the node versions installed
nvm list

# Set the node version to use (e.g. 8.10.0).
nvm use 8.10.0

# Install npm, and yarn.
yarn run installPackages

# Make sure the 'dist' directory is deleted before running below script
yarn run buildDist
```

On Linux:
```bash
xdg-open dist/index.html
```

On Windows:
```bash
start .\dist\index.html
```

To run the project (currently up-to-date for Purescript 0.11.7):

```
# Follow the instructions how to install Node-Gyp on 
# https://github.com/nodejs/node-gyp
# as administrator
> npm install --global --production windows-build-tools

# If you have NOT installed Node-Gyp as described above, then
# Install Python 2.* 
# and add 'python2' in the environment variable PATH

# If you have NOT installed Node-Gyp as described above, then
# Install Windows SDK
# See https://developer.microsoft.com/en-us/windows/downloads/sdk-archive 
# as it is required by Visual Studio 2015, when installing node-sass, 
# and not provided by default

# Install node-sass@4.5.3
# It is now added to package.json

# Update npm to a version >= 5.7.0
> npm -g install npm

# Install dependencies
> bower install
> npm install

# Build
> npm run build

# Serve
> npm start

# Open the index page
> http://localhost:8080/
```

Call the Server's REST API as follows with e.g. Postman:

```javascript
GET http://localhost:8080/getorders?params=2
```

It will return:

```javascript
[{"values":[{"quantity":6,"productId":2}],"tag":"EndpointExample.Model.Order"}]
```

TO DO:

Make it so that we can call the Server's REST API with:

```javascript
GET http://localhost:8080/leds/2
```

The Server should apply the LED id to toggle the GREEN LED which has ID 2 on the Tessel 2.

TO DO Next, make the Server run on the Tessel 2 and listen to http://192.168.1.101 on WiFi Access Point "Snowy-Owl"

Now run the Snowy Owl web app on the Tessel 2:

```javascript
t2 run server_tessel2.js
```

Rewrite Server.purs so it includes the logic of server_tessels.js to toggle LEDs on the Tessel 2. Later include a REST API to manipulate a Servo motor.

References:

"Type-safe client-server communication with PureScript" at 
[https://frigoeu.github.io/phantomtypes.html](https://frigoeu.github.io/phantomtypes.html)

And accompanying example at [https://github.com/FrigoEU/purescript-endpoints-express-example](https://github.com/FrigoEU/purescript-endpoints-express-example)

"Halogen Menu" at [https://github.com/slamdata/purescript-halogen-menu](https://github.com/slamdata/purescript-halogen-menu)

What to do when the Tessel 2 is not detected.

First and foremost try unconnecting the USB cable of the Tessel 2 from the PC then reconnecting the USB cable of the Tessel 2 to the PC.

We got our windows 7 and windows 10 laptops detecting the Tessel 2 and running blinkie.
Here's what we did:

1) Install LTS v4.4.4 from http://nodejs.org
2) Get the zip file https://gist.github.com/tcr/992978a5dbe5bff2e18f495c5c0973c3
3) Run node driver-clean.js
4) Plug in Tessel 2
5) Get Zadig - http://zadig.akeo.ie/ and run it, which should show the Tessel 2; simply click the install WinUSB button w/o changing anything - If you go to Device Manager, you should now notice that the three Tessel devices which previously had an ❗️ are now ok w/ the WinUSB driver
6) Run cmd as Administrator
7) Run npm i -g t2-cli
8) Run t2 list which should show the USB connection
9) Do the rest... http://tessel.github.io/t2-start/
10) Rejoice 