/**
 * Use Three.js's collada loader to load a model
 * */

var model = 'colonial.dae';
var container;
var scene;
var camera;
var renderer;
var loaderEnabled = true;

init();
animate();

function init() {

	container = document.getElementById("container");

	scene = new THREE.Scene();

	var WIDTH = 800, HEIGHT = 800;

	renderer = new THREE.WebGLRenderer({
		antialias : true
	});
	renderer.setSize(WIDTH, HEIGHT);
	renderer.setClearColor(0x00ccff, 1);
	renderer.shadowMapEnabled = true;
	container.appendChild(renderer.domElement);

	camera = new THREE.PerspectiveCamera(45, WIDTH / HEIGHT, 0.1, 10000);
	camera.position.set(0, 50, 200);
	scene.add(camera);

	scene.add(new THREE.AmbientLight(0x666666));

	var directionalLight = new THREE.DirectionalLight(0xffffff);
	directionalLight.position.set(-1, 1, 1).normalize();
	directionalLight.castShadow = true;
	scene.add(directionalLight);

	var offsetY = 0.25;
	var gridXZ = new THREE.GridHelper(400, 10);
	gridXZ.setColors(new THREE.Color(0x336633), new THREE.Color(0x336633));
	gridXZ.position.set(0, offsetY, 0);
	scene.add(gridXZ);

	var axes = new THREE.AxisHelper(1000);
	axes.position.set(0, offsetY, 0);
	scene.add(axes);

	var planeGeometry = new THREE.PlaneGeometry(800, 800, 1, 1);
	var planeMaterial = new THREE.MeshLambertMaterial({
		color : 0x006000
	});
	var plane = new THREE.Mesh(planeGeometry, planeMaterial);
	plane.receiveShadow = true;
	plane.rotation.x = -0.5 * Math.PI;
	plane.position.x = 0;
	plane.position.y = offsetY;
	plane.position.z = 0;
	scene.add(plane);

	var sphereGeometry = new THREE.SphereGeometry(10, 20, 20);
	var sphereMaterial = new THREE.MeshLambertMaterial({
		color : 0xff0000
	});
	var sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
	sphere.position.x = -60;
	sphere.position.y = 0.5;
	sphere.position.z = 0;
	sphere.castShadow = true;
	scene.add(sphere);

	if (loaderEnabled) {
		var loader = new THREE.ColladaLoader();
		loader.options.convertUpAxis = true;
		loader.load(model, function(collada) {
			overlay.innerHTML = "";
			overlay.style.display = "none";
			var dae = collada.scene;
			dae.position.set(-30, 0, 0); // x, z, y
			dae.scale.set(0.1, 0.1, 0.1);
			dae.castShadow = true;
			dae.receiveShadow = true;
			scene.add(dae);
			console.log(model + ' loaded with ' + dae.children.length + ' children');
		}, function(collada) {
			overlay.innerHTML = "<table width='100%' height='100%'><tr valign='center'><td align='center'><h1>Loading " + model + "...</h1></td></tr></table>";
			overlay.style.display = "block";
		});
	}

	controls = new THREE.OrbitControls(camera, renderer.domElement);

}

function animate() {
	requestAnimationFrame(animate);
	renderer.render(scene, camera);
	controls.update();
}
