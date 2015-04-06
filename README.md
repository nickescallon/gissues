A Git Issues viewer for the rails project.

## Requirements

* This app depends on `node` & `npm`, and assumes you have `gulp` and `bower` installed globally.
 * If not, please run `npm install -g gulp` and `npm install -g bower`
* Caveat! Although noted in the `package.json`, in order to run tests, you'll need `node` v0.10.x.
* I chose to downgrade here from 0.12.0 because of this existing (issue)[https://github.com/facebook/jest/issues/243], and the time constraints of this project.

## Getting up and running

* Navigate to the project root and run: ```npm install```
* Then run: ```bower install```
 * Then run: ```gulp```
 * This will build the project, and run an express server available at `localhost:3000`
* Browse to `localhost:3000` to load the app

## Running Jest Unit Tests

* From the project root, run ```npm test```
