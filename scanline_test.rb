require './scanline_fill.rb'

def generate
  m = 30
  p = 0.1

  a = []

  for x in 0..m do
    b = []
    for y in 0..m do
      if rand > p
        b[y] = '/'
      else
        b[y] = '-'
      end
    end
    a.push(b)
  end

  a
end

a = generate
scan = ScanlineFill.new

arr = scan.fill(a, 13,13, '8')
m = arr.size
for y in 0...m do
  s = ''
  for x in 0...m do
    s << a[x][y].to_s
  end
  p s
end