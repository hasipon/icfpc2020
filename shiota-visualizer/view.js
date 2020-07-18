const canvas = document.getElementById('canvas');

const ctx = canvas.getContext('2d');

var fragment = window.location.hash.substr(1);
if(fragment != "" ){
	fragment = atob(fragment);
	const lines = document.getElementById('input').value = fragment;
}

function clearCanvas(){
    console.log("clear");
	ctx.clearRect(0, 0, canvas.width, canvas.height);
}

var xbase = 1000;
var ybase = 1000;
var bigFlag = false;

function draw(){
	bigFlag = false;
    xbase = 1000;
	ybase = 1000;
	const scale = Number(document.getElementById('scale').value);
	const lines = document.getElementById('input').value;
	const element = document.getElementById( "color" ) ;
	const color = element.color.value;
	ctx.fillStyle = color;

	const line = lines.split(/\r\n|\r|\n/).join();
	const regexp = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/g;
	const poss = line.match(regexp);
	poss.forEach(
		pos => {
			const regexp2 = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/;
			pos = pos.match(regexp2)
			xbase = Math.min(Number(pos[1]), xbase);
			ybase = Math.min(Number(pos[2]), ybase);
		}
	);
	xbase *= -1;
	ybase *= -1;
	xbase += 2;
	ybase += 2;
	console.log(xbase);
	console.log(ybase);
	poss.forEach(
		pos => {
			const regexp2 = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/;
			pos = pos.match(regexp2)
			plot(pos[1], pos[2], scale, color);
		}
	);
	if(bigFlag){
		document.getElementById("log").value += "scale is too BIG!!!\n";
	}
}

function plot(x, y, scale){
    const nx = conv(x, scale, xbase);
	const ny = conv(y, scale, ybase);
	ctx.fillRect(nx, ny, scale, scale);
	if(Math.max(nx + scale, ny + scale) >= 1000){
		bigFlag = true;
	}
}

function conv(x, scale, base){
	return Number(scale) * (Number(base) + Number(x));
}

canvas.onclick = function(e) {
	const scale = document.getElementById('scale').value;
	var rect = e.target.getBoundingClientRect();
	mouseX = Math.floor((e.clientX - rect.left + 2)/scale ) - xbase;
	mouseY = Math.floor((e.clientY - rect.left + 2)/scale ) - ybase;

	document.getElementById("log").value += "\n(" + mouseX + ", " + mouseY + ")";
	console.log(mouseX, mouseY);
}
