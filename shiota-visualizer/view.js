const canvas = document.getElementById('canvas');

const ctx = canvas.getContext('2d');

var fragment = window.location.hash.substr(1);
if(fragment != "" ){
	fragment = atob(fragment);
	const lines = document.getElementById('input').value = fragment;
}
var xbase = 0;
var ybase = 0;
var bigFlag = false;

function clearCanvas(){
    console.log("clear");
	ctx.clearRect(0, 0, canvas.width, canvas.height);
	xbase = 0;
	ybase = 0;
}


function draw(){
	bigFlag = false;
	const scale = Number(document.getElementById('scale').value);
	const lines = document.getElementById('input').value;
	const element = document.getElementById( "color" ) ;
	const color = element.color.value;
	ctx.fillStyle = color;

	const line = lines.split(/\r\n|\r|\n/).join();
	const regexp = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/g;
	const poss = line.match(regexp);
	if(xbase == 0 && ybase == 0){
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
		console.log(xbase);
		console.log(ybase);
	}
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
	return 500 + Number(scale) * (Number(base) + Number(x));
}

canvas.onclick = function(e) {
	const scale = document.getElementById('scale').value;
	var rect = e.target.getBoundingClientRect();
	mouseX = Math.floor((e.clientX - rect.left + 2 - 500)/scale ) - xbase;
	mouseY = Math.floor((e.clientY - rect.top + 2-500)/scale ) - ybase;

	document.getElementById("log").value += "\n(" + mouseX + ", " + mouseY + ")";
	console.log(mouseX, mouseY);
}
