import os
import subprocess
import sys
import http.server
import socketserver
import json
import time
import urllib.parse

from pathlib import Path

print(os.get_exec_path())
print(sys.executable)
print(sys.argv[0])

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

        p = subprocess.Popen(
            [sys.executable, Path(__file__).parent / 'a.py', *sys.argv[1:]],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            encoding='utf-8')

        print("history", history)

        pos = history.split("_")
        p.stdin.write('\n'.join(pos) + '\n')
        p.stdin.flush()
        time.sleep(0.2)
        for i in range(len(pos)//2-1):
            print("skip", i)
            for line in p.stdout:
                if "----" in line:
                    break

        print("wait a.py")

        history = None
        lines = []
        for line in p.stdout:
            line = line.rstrip()
            lines.append(line)
            if "history:" in line:
                history = line[line.find("history:") + len("history:"):].strip()
            if "----" in line:
                break

        print("done a.py")

        p_output = json.dumps(lines)
        self.send_response(200)
        self.send_header("Content-type", "text/html;charset=utf-8")
        self.end_headers()

        html = r"""
<!DOCTYPE html>
<html>
<body>
""" + history + r"""<br>
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
<canvas id="canvas" width="1000" height="1000" style="border:1px solid;"></canvas>
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


function draw(){
	bigFlag = false;
	const scale = Number(document.getElementById('scale').value);
	const lines = document.getElementById('input').value;

	const line = lines.split(/\r\n|\r|\n/).join();
	const regexp = /[\(\[](-?[0-9]+), *(-?[0-9]+)[\)\]]/g;
	const poss = line.match(regexp);

    if (!poss) {
        document.getElementById("log").value += "no poss\n";
        return;
    }

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
			plot(pos[1], pos[2], scale);
		}
	);
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

port = os.getenv("PORT", 8000)
with http.server.HTTPServer(("", port), Handler) as httpd:
    print("serving at port", port)
    httpd.serve_forever()