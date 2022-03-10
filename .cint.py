#!/usr/bin/python3

import os
import subprocess

MAIN = 'main'
GLOBAL = 'global'
STATES = [MAIN, GLOBAL]

RUN = 'run'
RESET = 'reset'
EXITS = ['q', 'quit', 'exit']
REMOVE = 'remove'
PRINT = 'print'
OPTION = 'option'
HELPS = ['h', 'help']
NONE = ''

CODE =  {
            NONE: [],
            MAIN: [],
            GLOBAL: [],
        }

STATUS = NONE

compile_opt = ["clang++", "-Og", "-std=c++17"]

def Help():
    str = 'Avaliable commands : {} | {} | {} | {} | {}'.format(RUN, RESET, REMOVE, OPTION, PRINT)
    for help in HELPS:
        str += ' | {}'.format(help)
    for exit in EXITS:
        str += ' | {}'.format(exit)
    print(str)

def ResetCode():
    global STATUS, CODE
    STATUS = NONE
    CODE[MAIN] = []
    CODE[GLOBAL] = []
    print('Code reset.')

def CodeGen():
    full_code = """
#include <bits/stdc++.h>
#include <arpa/inet.h>
#include <pthread.h>
using namespace std;
"""
    for g in CODE[GLOBAL]:
        full_code += ('\n' + g)

    full_code += """

int main(int argc, char** argv) {
"""

    for g in CODE[MAIN]:
        full_code += ('\n    ' + g)

    full_code += """

    return 0;
}
"""
    return full_code

def CompileAndRun():
    # Hope the file name does not overlap..
    src = "/tmp/88def13009d4646b0948daa827b58c48a75aa84410789603f4238cd7f8a02c4a9cfd826241f9c9d2.cpp"
    out = "/tmp/88def13009d4646b0948daa827b58c48a75aa84410789603f4238cd7f8a02c4a9cfd826241f9c9d2.out"

    if os.path.isfile(src):
        os.remove(src)
    if os.path.isfile(out):
        os.remove(out)

    f = open(src, "w+")
    f.write(CodeGen())
    f.close()

    cmd = compile_opt + [src, "-o", out]
    p = subprocess.Popen(cmd);
    p.wait()

    if os.path.isfile(src):
        os.remove(src)

    if os.path.isfile(out):
        subprocess.call([out])
        os.remove(out)

def Main():
    global STATUS, compile_opt

    while True:
        print(STATUS, end='')
        try:
            line = input("> ")
        except EOFError:
            print('\nBye.')
            exit(0)

        if line in EXITS:
            print('Bye.')
            exit(0)

        elif line in HELPS:
            Help()

        elif line == OPTION:
            print("Current option : " + " ".join(compile_opt))
            print("New option (press ENTER if you don't want to change the option) :")
            opts = input("  clang++ ")
            compile_opt = ["clang++"] + opts.split()

        elif line == RUN:
            CompileAndRun()

        elif line == RESET:
            ResetCode()

        elif line in STATES:
            STATUS = line

        elif line == PRINT:
            print(CodeGen())

        elif STATUS == NONE:
            print("Code status not set. Options: main global")

        elif line == REMOVE:
            CODE[STATUS] = CODE[STATUS][:-1]

        else:   # input is a code with valid status
            if STATUS == MAIN:
                CODE[MAIN].append(line)
            elif STATUS == GLOBAL:
                CODE[GLOBAL].append(line)
            else:
                assert false, "Invalid status: {}".STATUS

if __name__ == '__main__':
    Main()
