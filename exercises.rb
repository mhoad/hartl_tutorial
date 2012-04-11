#Exercise 1
def string_shuffle(s)
  s.split('').shuffle.join
end

#Test it works
puts string_shuffle("foobar")

#Exercise 2
class String
  def shuffle
    self.split('').shuffle.join
  end
end

#Test it works
puts "foobar".shuffle 

#Exercise 3
person1 = { first: "Homer", last: "Simpson" }
person2 = { first: "Marge", last: "Simpson" }
person3 = { first: "Bart", last: "Simpson" }
params  = { father: person1, mother: person2, child: person3 } 

#Test it works
puts params[:father][:first] 

#Just for fun - Test how long till shuffle returns the original string
highest = 0
1000.times do
	i = 0
	i += 1 until "foobar" == "foobar".shuffle
	if i > highest
		highest = i
	end
end
puts "Highest = " + highest.to_s