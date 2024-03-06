import sys, re, traceback, collections

tag2col = {
    # tags mapped to rows in "Excluded" mini-table:
    'unrelated': 'unrelated',
    'test': 'unrelated',
    'library': 'library',
    'importboilerplate': 'imports',
    'administrativia': 'imports',
    'administrivia': 'imports',
    'doc': 'doc',

    # tags mapped to columns in main table:
    'code': 'implementation',
    'compiletimecode': 'implementation',
    'spec': 'interface',
    'proof': 'interesting proof',
    'loopinv': 'interesting proof',
    'workaround': 'low-insight proof',
    'bitvector': 'low-insight proof',
    'symex': 'low-insight proof',
    'obvious': 'low-insight proof',
    'lists': 'low-insight proof',
    'maps': 'low-insight proof'
}

def maplabel(l):
    return tag2col[l]

def count_lines_in_file(filepath):
  counts = dict()
  current = 'UNTAGGED'

  invalidUtf8 = 0
  lines=[]
  try:
      with open(filepath, 'rb') as f:
          lines = f.read().splitlines()
  except Exception as e:
      traceback.print_exc(file=sys.stderr)

  for line in lines:
      try:
          line = line.decode('utf-8')
      except UnicodeDecodeError: #
          line = 'a line containing invalid utf-8'
          invalidUtf8 += 1
      line = line.strip()
      if not line:
          continue
      m = re.match(r'\(\*tag:(\w+)\*\)', line)
      if m:
          current = maplabel(m[1])
      else:
          counts[current] = counts.get(current, 0) + 1
          #if current == 'UNTAGGED':
          #    print(f'UNTAGGED {filepath}')
          #    current = 'UNTAGGED2'
  return counts

rows = []

row = 'NOCATEGORY'
table = collections.Counter()
for line in sys.stdin.read().splitlines():
    line = line.strip()
    if line.startswith('#='):
        row = line[2:].strip()
        rows.append(row)
        continue
    if line.startswith('#'):
        continue
    cts = count_lines_in_file(line)
    table += collections.Counter(dict((row+':'+k, v) for (k,v) in cts.items()))

def countBy(p):
    items = [(k,v) for (k, v) in table.items() if p(k)]
    for k,v in items:
        del table[k]
    return sum(v for (k,v) in items)

with open('loc.tex', 'w') as f2:
    for row in rows:
        print(f'{row:20s} & ', end='', file=f2)
        for column in ['implementation', 'interface', 'interesting proof', 'low-insight proof']:
            c = countBy(lambda s: s == row+':'+column)
            print(f'{c:4d} & ', end='', file=f2)
        f2.write(' \\\\ \\hline\n')

print('code unaccounted for:')
for k,v in table.items():
    print (k, v)
