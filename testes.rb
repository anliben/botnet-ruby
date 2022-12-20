
arr = ['betway']

d = 'https://sports.betway.it/it/sports/aoc/10667686/278695989/1049241687/'

arr.each do |a|
  if d.include? a
    p "include #{a}"
  end
end


