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
# limitations under the License

import os
import time
import requests
import json
import enum
import daemon
from collections import namedtuple
from pyadb import ADB

'''
Check Aether network operational status and report it to
central monitoring server

1) check mobile connctivity after toggling the airplane mode
2) check if ping to 8.8.8.8 works
'''

CONF = json.loads(
    open(os.getenv('CONFIG_FILE', "./config.json")).read(),
    object_hook=lambda d: namedtuple('X', d.keys())(*d.values())
)

ADB_GET_COMMANDS = {
    "apn_mode": "settings get global airplane_mode_on",
    "lte_state": "dumpsys telephony.registry | grep -m1 mDataConnectionState",
    "ping_result": "ping -c 3 8.8.8.8&>/dev/null; echo $?"
}
ADB_APN_COMMANDS = {
    "home": "input keyevent 3",
    "setting": "am start -a android.settings.AIRPLANE_MODE_SETTINGS",
    "toggle": "input tap 550 700"
}


class State(enum.Enum):
    error = "-1"
    disconnected = "0"
    connecting = "1"
    connected = "2"

    @classmethod
    def has_value(cls, value):
        return value in cls._value2member_map_


edge_status = {
    'name': CONF.edge_name,
    'status': {
        'control_plane': None,
        'user_plane': 'connected'
    }
}


def _run_adb_shell(adb, command):
    result = adb.shell_command(command)
    if adb.lastFailed():
        err = "[ERROR]: " + command + " failed"
        return False, err
    time.sleep(2)
    result = result[0] if result is not None else None
    return True, result


def get_control_plane_state():
    '''
    check aether control plane works by toggling airplane mode
    '''
    adb = ADB()
    if adb.set_adb_path(CONF.adb.path) is False:
        err = "[ERROR]: " + CONF.adb.path + " not found"
        return State.error, err

    # get the current airplane mode
    success, result = _run_adb_shell(adb, ADB_GET_COMMANDS['apn_mode'])
    if not success or result is None:
        return State.error, result
    apn_mode_on = True if result == "1" else False

    # toggle the airplane mode
    for command in ADB_APN_COMMANDS.values():
        success, result = _run_adb_shell(adb, command)
        if not success:
            return State.error, result
    if not apn_mode_on:
        success, result = _run_adb_shell(adb, ADB_APN_COMMANDS['toggle'])
        if not success:
            return State.error, result

    # additional wait for UE to fully attach
    time.sleep(3)

    # get connection state
    state = State.connecting.value
    while state == State.connecting.value:
        success, result = _run_adb_shell(adb, ADB_GET_COMMANDS['lte_state'])
        if not success or result is None:
            return State.error, result
        state = result.split("=")[1]

    if not State.has_value(state):
        return State.error, None
    return State(state), None


def get_user_plane_state():
    '''
    checks aether user plane connectivity with ping to 8.8.8.8
    '''
    adb = ADB()
    if adb.set_adb_path(CONF.adb.path) is False:
        err = "[ERROR]: " + CONF.adb.path + " not found"
        return State.error, err

    success, result = _run_adb_shell(adb, ADB_GET_COMMANDS['ping_result'])
    if not success or result is None:
        return State.error, result

    state = State.connected if result == "0" else State.disconnected
    return state, None


def report_aether_network_state():
    '''
    report the aether network state to the monitoring server
    '''
    response = requests.post(CONF.report_url, json=edge_status)
    return requests.codes.ok,
    if response == requests.codes.ok:
        print("[INFO]: reported the status")
    else:
        response.raise_for_status()


def run():
    while True:
        cp_state, err = get_control_plane_state()
        up_state, err = get_user_plane_state()

        edge_status['status']['control_plane'] = cp_state.name
        edge_status['status']['user_plane'] = up_state.name

        report_aether_network_state()
        time.sleep(600)


def main():
    with daemon.DaemonContext():
        run()


if __name__ == "__main__":
    main()
