const canvas = document.getElementById('canvas');

const ctx = canvas.getContext('2d');


function clearCanvas(){
    console.log("clear");
	ctx.clearRect(0, 0, canvas.width, canvas.height);
}


function draw(){
    const scale = document.getElementById('scale').value;
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
			plot(pos[1], pos[2], scale, color);
		}
	);
}

const base = 500;

function plot(x, y, scale, color) {
	ctx.fillRect(conv(x, scale), conv(y, scale), scale, scale);
}

function conv(x, scale){
	return base+ x*scale;
}

canvas.onclick = function(e) {
	const scale = document.getElementById('scale').value;
	// クリック位置の座標計算（canvasの左上を基準。-2ずつしているのはborderの分）
	var rect = e.target.getBoundingClientRect();
	mouseX = Math.floor(Math.floor((e.clientX - Math.floor(rect.left) - 2)/scale - base/scale));
	mouseY = Math.floor((e.clientY - Math.floor(rect.top) - 2)/scale - base/scale);

	document.getElementById("log").value += "\n(" + mouseX + ", " + mouseY + ")";
	console.log(mouseX, mouseY);
}
