const canvas = document.getElementById('canvas');

const ctx = canvas.getContext('2d');

function draw(){
	const lines = document.getElementById('input').value;
	const line = lines.split(/\r\n|\r|\n/).join();
	const regexp = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/g;
	const poss = line.match(regexp);
	poss.forEach(
		pos => {
			const regexp2 = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/;
			pos = pos.match(regexp2)
			console.log(pos);
			plot(pos[1], pos[2]);
		}
	);
	console.log(poss);
}

function plot(x, y) {
	console.log(x);
	console.log(y);
	const scale = 10;
	ctx.fillRect(500+x*scale,500+y*scale,scale,scale);
}
