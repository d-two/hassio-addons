#!/usr/bin/env python3
# This creates an HTTP message
# with the content of BODY as the enclosed representation
# for the resource http://localhost:8080/file

import http.client
import subprocess
import sys
from urllib.parse import urlparse

subprocess.run(["/nginx.sh"])

o = urlparse(sys.argv[1])

subprocess.run(["sed", "-i", "s|%%SSA_PORT%%|" + str(o.port) + "|g", "/etc/nginx/servers/ingress.conf"])
