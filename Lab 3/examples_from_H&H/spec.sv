// requirement for operation of 2-street
//   intersection traffic control
// g y r = green, yellow, red lights
// each column = a street's signals
// 6-state solution with two all-red states
// lights always go in the following sequence
// green phases are elongated by presence of respective traffi
// absent any traffic, around and around it goes
g   r		      // green for street A
y   r
r   r	  B		  // all-red before street B green
r   g
r   y
r   r	  A		  // all-red before street A green


// 5 state solution -- no distinction between all red states
// default state = all red
// stays there until traffic appears
// requires decision on priority between the two states in case 
//   traffic arrives simultaneously on both
//  (need an arbiter -- very common problem in computer science
//     with shared resoures of any kind)
g   r
y   r
r   r

r   g
r   y
r	r



// brute force way of handling traffic light w/ timers on yellow and green
// green can last 10 clock cycles, so have 10 green states per direction
state machine lab 3

logic [4:0] present_state, next_state;

00000:    all red
00001:   g     r    1
00010:   g     r    2 
...
01010:	 g     r   10
01011:   y     r    1
01100:   y     r    2