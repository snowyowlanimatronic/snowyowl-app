# snowyowl-app
Snowy Owl - App

## Get Started

```bash
git clone git@github.com:snowyowlanimatronic/snowyowl-app.git
cd snowyowl-app
# Install nvm, npm, and yarn.
nvm use
yarn run installPackages
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

References:

"Type-safe client-server communication with PureScript" at 
[https://frigoeu.github.io/phantomtypes.html](https://frigoeu.github.io/phantomtypes.html)

And accompanying example at [https://github.com/FrigoEU/purescript-endpoints-express-example](https://github.com/FrigoEU/purescript-endpoints-express-example)

"Halogen Menu" at [https://github.com/slamdata/purescript-halogen-menu](https://github.com/slamdata/purescript-halogen-menu)
