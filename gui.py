import os
import subprocess
import sys
import http.server
import socketserver
import json
import time
import urllib.parse

from pathlib import Path
from logic import Vect, run

def calc(history):
    hist = history.split('_')
    assert len(hist) % 2 == 0
    inputs = [Vect(int(x), int(y)) for x, y in zip(hist[::2], hist[1::2])]
    a = run(iter(inputs))
    counter = 0
    outputs = []
    while True:
        while True:
            x = next(a)
            if x is None:
                break
            if counter == len(inputs):
                outputs.append(x)
        if counter == len(inputs):
            return outputs
        counter += 1


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        print(self.path)
        if not self.path.startswith("/gui/"):
            self.send_response(404)
            self.end_headers()
            return

        history = self.path[len("/gui/"):]
        if not history:
            self.send_response(400)
            self.end_headers()
            return

        p_output = '\n'.join(str(x) for x in calc(history))
        self.send_response(200)
        self.send_header("Content-type", "text/html;charset=utf-8")
        self.end_headers()

        html = r"""
<!DOCTYPE html>
<html>
<body>
<canvas id="canvas" width="2000" height="2000" style="border:1px solid;"></canvas>
<br>
history: """ + history + r"""<br>

セーブデータ<br>
<a href="/gui/0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_8_4_2_-8_3_6_0_-14_-4_10_9_-3_-4_10_1_4_0_0_1_0_1_1_0_1_1_0_2_2_0_1_0_1_1_0">メニュー画面</a>
<a href="/gui/0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_8_4_2_-8_3_6_0_-14_-4_10_9_-3_-4_10_1_4_0_0_1_0_1_1_0_1_1_0_2_2_0_1_0_1_1_0_18_2_1_0_1_0_1_0_1_0_0_0_0_0_0_0_0_0_0_1_0_1_0_1_0_1_0_1_0_1_0_1_0_1_0_1_24_0_18_0_1_1">2面クリア</a>
<a href="/gui/0_0_0_0_0_0_1_1_0_0_0_0_0_0_1_0_8_4_8_4_2_-7_2_-8_2_-9_4_6_3_7_3_6_3_7_0_-13_0_-14_0_-15_-4_10_-4_10_9_-3_9_-3_-4_9_-4_10_1_4_-1_3_-1_2_0_1_1_1_0_1_0_0_0_0_1_1_1_0_73_1_19_1_18_1_0_0_1_0_1_0_1_0_1_0_1_0_23_1_15_1_23_1_0_1_0_1_8_-49_8_-49_22_1_1_0_-1_1_15_0_11_1_0_1_1_0_1_0_1_-1_1_-1_1_-1_1_-1_1_-1_1_-1_1_-1_1_1_0_2_0_2_0_2_0_2_0_2_0_2_0_2_0_2_24_0_16_0_24_1_1_0_1_0_24_1_18_0_24_0_1_0_-1_0_17_1_11_0_16_0_10_0_17_0_15_-5_11_-7_1_0_18_1_16_-7_14_-12_1_1_0_-1_12_-12_1_1_2_0_0_0_-1_-1_1_-2_1_0_31_7_29_7_30_0_29_4_2_0_32_7_25_6_0_0_1_2_17_1_11_8_35_-1_16_-6_11_-7_17_-1_15_-7_16_0_17_-6_11_-8_2_0_17_1_17_-7_12_-6_1_1_19_0_19_-7_15_-7_2_0_2_1_2_1_2_1_2_1_34_1_28_1_1_-1">3面クリア<a/>
<a href="/gui/0_0_0_0_0_0_1_1_0_0_0_0_0_0_1_0_8_4_8_4_2_-7_2_-8_2_-9_4_6_3_7_3_6_3_7_0_-13_0_-14_0_-15_-4_10_-4_10_9_-3_9_-3_-4_9_-4_10_1_4_-1_3_-1_2_0_1_1_1_0_1_0_0_0_0_1_1_1_1_73_1_19_1_18_1_1_0_1_0_1_0_1_0_1_0_1_0_23_1_15_1_23_1_0_1_0_1_8_-49_8_-49_22_1_1_0_-1_1_15_0_11_1_0_1_1_0_1_0_1_-1_1_-1_1_-1_1_-1_1_-1_1_-1_1_-1_1_1_0_2_0_2_0_2_0_2_0_2_0_2_0_2_0_2_24_0_16_0_24_1_1_0_1_0_24_1_18_0_24_0_1_0_-1_0_17_1_11_0_16_0_10_0_17_0_15_-5_11_-7_1_0_18_1_16_-7_14_-12_1_1_0_-1_12_-12_1_1_2_0_0_0_-1_-1_1_-2_1_0_31_7_29_7_30_0_29_4_2_0_32_7_25_6_0_0_1_2_17_1_11_8_35_-1_16_-6_11_-7_17_-1_15_-7_16_0_17_-6_11_-8_2_0_17_1_17_-7_12_-6_1_1_19_0_19_-7_15_-7_2_0_2_1_2_1_2_1_2_1_34_1_28_1_1_-1_1_-1_3_1_1_15_1_11_0_14_1_16_0_10_2_17_2_16_2_17_2_17_1_16_1_10_0_3_1_16_0_16_0_0_1_16_-1_9_0_5_0_1_1_20_2_10_0_8_0_1_1_22_1_22_1_22_0_22_1_22_0_0_-1_-3_0_0_-5_22_1_1_1_1_1_15_1_17_1_1_2_1_2_2_2_1_2_0_0_-1_-1_1_1_1_3_2_3_2_3_2_3_2_3_2_3_2_3_2_3_2_-1_-1_1_-1_0_-1_1_16_1_9_2_14_0_15_1_1_2_14_2_15_2_15_1_17_1_1_1_1_1_14_2_7_0_11_0_12_1_12_2_1_1_11_1_4_-6_11_0_9_0_-1_0_9_0_2_0_6_1_9_1_8_1_-3_0_4_0_-2_0_3_1_-2_1_1_1_-6_0_-12_1_-8_5_8_1_1_0_-12_2_0_1_3_1_-13_0_-1_1_1_0_0_0_0_1_-3_2_1_1_15_1_10_-4_4_1_18_1_2_1_18_3_10_3_5_2_7_1_5_2_1_2_20_-5_19_1_-1_1_0_0_16_2_9_0_4_-1_0_1_18_1_11_1_5_2_0_0_18_-6_19_1_2_1_1_0_16_1_9_0_5_-1_-1_1_17_1_-1_0_0_1_17_1_-1_1_18_0_10_-5_6_0_3_1_20_0_13_1_9_1_-1_3_22_1_1_-5_24_1_1_2_1_0_17_0_8_0_4_1_2_1_17_1_17_1_0_0_19_0_18_1_0_0_2_2_2_1_22_0_14_0_8_2_-2_1_23_2_1_1_17_1_10_3_1_1_29_1_26_0_18_0_15_1_-1_0_30_0_23_0_18_-1_0_1_35_0_27_-5_23_0_-1_1_1_1_0_0_-1_1_-2_0_0_2_-1_7_77_2_1_7_77_0_1_1_16_-1_10_1_4_2_0_1_18_1_10_-4_5_1_1_2_20_1_19_2_4_2_0_1_3_1_-1_1_1_6_28_0_29_1_1_2_0_0_16_-1_9_0_4_1_1_1_18_-1_11_1_4_1_2_1_20_1_19_2_19_1_20_2_3_0_2_-6_20_0_0_1_1_1_16_1_10_0_3_0_-1_2_18_0_1_0_18_2_12_1_5_2_-2_0_21_1_13_1_8_1_-1_1_23_0_23_1_0_1_27_-4_26_-6_26_2_1_2_1_1_16_1_10_1_5_1_16_1_16_1_2_1_17_1_11_1_4_-1_1_1_19_2_19_0_18_1_19_-7_19_2_1_1_1_1_17_0_9_-4_10_0_0_1_16_2_7_-4_9_1_0_5_16_4_16_3_0_-3_16_2_0_0_0_0_17_3_9_0_8_0_3_1_1_1_16_0_11_1_5_1_17_0_10_1_0_0_19_0_12_0_5_0_0_1_0_0_23_-1_16_1_9_3_-1_0_25_0_18_1_13_0_1_1_29_-8_30_0_-1_0_3_1_16_1_10_-5_3_2_2_1_3_3_18_3_11_-2_5_2_1_2_2_8_23_7_22_6_15_7_11_3_2_8_25_10_27_8_26_2_3_11_28_11_22_11_15_1_-1_13_32_12_33_1_0_15_38_15_35_15_30_14_24_-1_-1_17_41_17_34_22_30_2_2_2_2_2_0_19_59_19_58_1_1_1_1_3_0_23_78_15_76_1_0_1_2_1_17_1_10_0_5_-1_0_0_2_1_18_0_12_0_6_3_1_2_2_1_23_0_16_-4_11_2_1_1_1_4_28_3_29_2_22_3_17_2_0_5_34_0_1_4_37_4_30_5_24_3_1_1_0_7_47_6_38_7_34_2_1_2_1_8_59_2_1_8_59_0_0_0_0_0_0_12_77_4_77_2_4_2_2_2_0">5面クリア</a>
</br>
(x, y)の形式で含まれていれば、改行区切りでもコンマ区切りでもなんでもOK
(x, y)っぽい部分を正規表現からとってきます
<br>
<textarea id="input" rows="10" cols="100">""" + p_output + r"""</textarea>
<br>
scale<input id="scale" value="10">
<button type="button" onclick="draw()">draw</button>
<button type="button" onclick="clearCanvas()">clear</button>
<br>
<textarea rows="3" cols="50" id="log" ></textarea>
<br>
<script>

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

const canvasSize=2000;


function draw(){
	ctx.globalAlpha = 1;
	ctx.fillStyle = "black";
    ctx.fillRect(0, 0, canvasSize, canvasSize);
	bigFlag = false;
	const scale = Number(document.getElementById('scale').value);
	const lines = document.getElementById('input').value.split("\n");
	if(xbase == 0 && ybase == 0){
	    for(let i = 0; i<lines.length; i++){
	        const line = lines[i];
	        console.log("line = " + line);
	        const regexp = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/g;
    	    const poss = line.match(regexp);
    	    if(poss == null){
    	        continue;
    	    }
    	    console.log("poss = " + poss);
		    poss.forEach(
		    	pos => {
    	            console.log("pos = " + pos);
		    		const regexp2 = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/;
		    		pos = pos.match(regexp2)
		    		xbase = Math.min(Number(pos[1]), xbase);
		    		ybase = Math.min(Number(pos[2]), ybase);
		    	}
		    );
	    }
		xbase *= -1;
		ybase *= -1;
		console.log(xbase);
		console.log(ybase);
	}
	const colorList = ["green", "white", "orange", "red", "blue", "purple", "purple"];
	ctx.globalAlpha = 0.5;
	for(let i = 0; i<lines.length; i++){
	    const line = lines[i];
	    ctx.fillStyle = colorList[i%colorList.length];
	    const regexp = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/g;
    	const poss = line.match(regexp);
    	if(poss == null){
    	    continue;
    	}
	    poss.forEach(
	    	pos => {
	    		const regexp2 = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/;
	    		pos = pos.match(regexp2)
	    		plot(pos[1], pos[2], scale);
	    	}
	    );
	}
	if(bigFlag){
        if (1 < scale) {
            document.getElementById('scale').value = "" + (scale-1);
            console.log("rescale");
            clearCanvas();
            draw();
        } else {
            document.getElementById("log").value += "scale is too BIG!!!\n";
        }
	}
}

function plot(x, y, scale){
    const nx = conv(x, scale, xbase);
	const ny = conv(y, scale, ybase);
	ctx.fillRect(nx, ny, scale, scale);
	if(Math.max(nx + scale, ny + scale) >= canvasSize){
		bigFlag = true;
	}
}

function conv(x, scale, base){
	return canvasSize/2 + Number(scale) * (Number(base) + Number(x));
}

canvas.onclick = function(e) {
	const scale = document.getElementById('scale').value;
	var rect = e.target.getBoundingClientRect();
	mouseX = Math.floor((e.clientX - rect.left + 2 - canvasSize/2)/scale ) - xbase;
	mouseY = Math.floor((e.clientY - rect.top + 2-canvasSize/2)/scale ) - ybase;

	document.getElementById("log").value += "\n(" + mouseX + ", " + mouseY + ")";
    console.log(location.href);
    var history = '""" + history + r"""';
    var nexturl = window.location.origin + "/gui/" + history + "_" + mouseX + "_" + mouseY;
    console.log(nexturl);
    location.href = nexturl;
	console.log(mouseX, mouseY);
}

draw();
</script>
</body>
</html>
"""
        self.wfile.write(html.encode())
        self.wfile.flush()


class ThreadedHTTPServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
    """Handle requests in a separate thread."""

if __name__ == '__main__':
	port = int(os.getenv("PORT", 8000))
	with ThreadedHTTPServer(("", port), Handler) as httpd:
		print("serving at port", port)
		httpd.serve_forever()
