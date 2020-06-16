#!/usr/bin/env python

# Copyright 2020-present Open Networking Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import time
from flask import Flask, jsonify, abort, request

app = Flask(__name__)
edges = [
    {
        'name': 'prod-edge-example',
        'status': {
            'control_plane': 'connected',
            'user_plane': 'connected'
        },
        'last_update': time.time()
    }
]


@app.route('/edges/healthz', methods=['GET'])
def get_health():
    return {'message': 'healthy'}


@app.route('/edges', methods=['GET'])
def get_edges():
    return jsonify({'edges': edges})


@app.route('/edges/<string:name>', methods=['GET'])
def get_edge(name):
    edge = [edge for edge in edges if edge['name'] == name]
    if len(edge) == 0:
        abort(404)
    return jsonify({'edge': edge[0]})


@app.route('/edges', methods=['POST'])
def create_or_update_edge():
    if not request.json:
        abort(400)
    if 'name' not in request.json:
        abort(400)
    if 'status' not in request.json:
        abort(400)

    req_edge = {
        'name': request.json['name'],
        'status': {
            'control_plane': request.json['status']['control_plane'],
            'user_plane': request.json['status']['user_plane']
        },
        'last_update': time.time()
    }

    edge = [edge for edge in edges if edge['name'] == req_edge['name']]
    if len(edge) == 0:
        print("new edge request " + req_edge['name'])
        edges.append(req_edge)
    else:
        edge[0]['status']['control_plane'] = req_edge['status']['control_plane']
        edge[0]['status']['user_plane'] = req_edge['status']['user_plane']
        edge[0]['last_update'] = req_edge['last_update']

    return jsonify({'edge': req_edge}), 201


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)
