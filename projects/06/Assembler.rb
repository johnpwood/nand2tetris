arr= IO.readlines ARGV[0]

#remove comments
arr.each do |x|
  x.gsub!(/\/\/.*/, "")
  x.strip!
end
arr.select! {|x| x != ""}

symbols = {"SP"=>0, "LCL"=>1, "ARG"=>2, "THIS"=>3,
           "THAT"=>4, "SCREEN"=>16384, "KBD"=>24576}
(0..15).each { |x| symbols["R#{x}"] = x }

#accumulate labels into symbol table
line=0
arr.each do |x|
  if x =~ /\((.*)\)/
    symbols[$1] = line
    x.replace("")
  else
    line += 1
  end
end
arr.select! { |x| x != "" }

#replace pre-existing symbols or define new symbols:
n = 0
arr.each do |x|
  if x =~ /@(.*\D+.*)/
    if symbols[$1]
      x.replace("@#{symbols[$1]}")
    else
      symbols[$1] = 16 + n
      n += 1
      x.replace("@#{symbols[$1]}")
    end
  end
end

#assemble
jmp = ["", "jgt", "jeq", "jge", "jlt", "jne", "jle", "jmp"]

comp = {  "0"=>"101010",   "1"=>"111111", "-1"  =>"111010",
          "d"=>"001100",   "a"=>"110000", "!d"  =>"001101",
         "!a"=>"110001", "-d" =>"001111", "-a"  =>"110011",
        "d+1"=>"011111", "a+1"=>"110111", "d-1" =>"001110",
        "a-1"=>"110010", "d+a"=>"000010", "d-a" =>"010011",
        "a-d"=>"000111", "d&a"=>"000000", "d|a" =>"010101"}        

arr.each do |x|
  x.replace(x.downcase)
  # A-type instructions:
  if x[0] == "@"
    x.replace(sprintf("0%015b", x[1..-1].to_i))
  else
  # C-type instructions:
    x =~ /(\w*)=?([^;]+);?(\w*)/
    d = $1
    c = $2
    j = $3

    dest = 0
    dest += 4 if d.include? "a"
    dest += 2 if d.include? "d"
    dest += 1 if d.include? "m"
    
    a = c.include?("m")? "1": "0"
    c.gsub!("m", "a")    
    x.replace(sprintf("111%s%s%03b%03b", a, comp[c], dest, jmp.index(j)))
  end
end
filename = ARGV[0].gsub(/.asm$/, ".hack")
out = File.open(filename, "w")
arr.each do |x|
  out << x << "\n"
end
