## [Processing.js](http://processingjs.org/) for native applications thanks to [electron](http://electron.atom.io/)

 This sample was inspired by [electron-threejs-example] (https://github.com/jeromeetienne/electron-threejs-example)


 ![processing.js with electron](https://github.com/JosephLaurino/electron-processingjs/blob/master/screenshot.png "processing.js with electron")

###### Getting Started

Install the latest node.js (w/c also installs the latest npm) from https://nodejs.org/en/

```
$ git clone https://github.com/JosephLaurino/electron-processingjs
$ cd electron-processingjs
$ npm install && npm start
```

Here's index.html.  

```javascript
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Hello World!</title>
  </head>
  <body>
    <script src="bower_components/Processing.js/processing.js"></script>
		<canvas data-processing-sources="infinite-arboretum.pde"></canvas>
	</body>
</html>
```
Processing.js sample is from http://beautifulprogramming.com/infinite-arboretum/
