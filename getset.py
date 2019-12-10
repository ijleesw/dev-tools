#!/usr/bin/env python3

# Usage:
#
# (a) via command-line
#
# $ ./getset.py
# > int a_;
# > int *b_;
# > int* c_;
# > gen
# inline int a() const { return a_; }
# inline int *b() const { return b_; }
# inline int* c() const { return c_; }
#
# inline void set_a(int a) { a_ = a; }
# inline void set_b(int *b) { b_ = b; }
# inline void set_c(int* c) { c_ = c; }
#
# (b) via file open
#
# $ ./getset.py -i test.cpp
# inline int a() const { return a_; }
# inline int *b() const { return b_; }
# inline int* c() const { return c_; }
#
# inline void set_a(int a) { a_ = a; }
# inline void set_b(int *b) { b_ = b; }
# inline void set_c(int* c) { c_ = c; }
#
# NOTE: In case of a bug, check IsTokenSetValid first.

import argparse

keywords = ['asm', 'auto', 'break', 'case', 'catch', 'class', 'const', 'continue', 'default',
         'delete', 'delete[]', 'do', 'dynamic_cast', 'else', 'enum', 'explicit', 'export', 'extern',
         'false', 'for', 'friend', 'goto', 'if', 'inline', 'mutable', 'namespace', 'new', 'operator',
         'private', 'protected', 'public', 'register', 'reinterpret_cast', 'return', 'signed',
         'sizeof', 'static', 'static_cast', 'struct', 'switch', 'template', 'this', 'throw', 'true',
         'try', 'typedef', 'typeid', 'typename', 'union', 'unsigned', 'using', 'virtual', 'void',
         'volatile', 'wchar_t', 'while']

def PreprocessLine(line):
	return line.split(';')[0].strip()

def IsTokenSetValid(tokens):
    if len(tokens) < 2 or len(tokens[1]) < 2 or not tokens[0][0].isalpha() or tokens[1][-1] != "_":
      return False
    if tokens[0] in keywords or tokens[1] in keywords:
      return False
    return (len(tokens) == 2 or tokens[2] == "=")

def GenGetter(tokens):	# tokens example : ['int', 'a_'], ['int', '*b_'], ['int*', 'c_']
  type_str = tokens[0]
  name_str = tokens[1][:-1]   # last underbar truncated
  name_str_w_o_star = name_str[1:] if name_str[0] == '*' else name_str
  return "inline {:s} {:s}() const {{ return {:s}_; }}".format(
      type_str, name_str, name_str_w_o_star)

def GenSetter(tokens):	# tokens example : ['int', 'a_'], ['int', '*b_'], ['int*', 'c_']
  type_str = tokens[0]
  name_str = tokens[1][:-1]   # last underbar truncated
  name_str_w_o_star = name_str[1:] if name_str[0] == '*' else name_str
  return "inline void set_{:s}({:s} {:s}) {{ {:s}_ = {:s}; }}".format(
      name_str_w_o_star, type_str, name_str, name_str_w_o_star, name_str_w_o_star)

def Main():
  parser = argparse.ArgumentParser(description="Generate getters and setters.")
  parser.add_argument('-i', '--input_file', type=str, default=None, help="input source file path")
  args = parser.parse_args()

  line = None
  tokens_list = []

  if args.input_file is not None:
    with open(args.input_file, 'r') as source:
      for line in source:
        line = PreprocessLine(line)
        tokens = line.split()
        if IsTokenSetValid(tokens):
          tokens_list.append(tokens)
        else:
          continue
  else:
    while True:
      line = input("> ")
      line = PreprocessLine(line)
      if line == "gen":
        break

      tokens = line.split()
      if IsTokenSetValid(tokens):
        tokens_list.append(tokens)
      else:
        print("wrong input - ignored.")
        continue

  for tokens in tokens_list:
    print(GenGetter(tokens))
  print()
  for tokens in tokens_list:
    print(GenSetter(tokens))

if __name__ == '__main__':
  Main()
