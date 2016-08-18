#!/usr/bin/env python
import winrm
import sys
print winrm.Session('192.168.99.100', auth=('IEUser','Passw0rd!')).run_ps(open(sys.argv[1]).read()).std_out,
