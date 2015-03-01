======DESCRIPTION=========================================================
Video attachment for "Particle Computation: Device Fan-Out and Binary Memory" by Hamed Mohtasham Shad, Rose Morris-Wright, Erik D. Demaine, Sándor P. Fekete, Aaron T. Becker, at MIT, Technische Universität Braunschweig, and the University of Houston. 

We present progress on the computational universality of swarms of micro- or nano-scale robots in complex environments, controlled not by individual navigation, but by a uniform global, external force.

Swarms of robots, such as this single-celled organism, can be grown or built in large numbers, but are usually controlled by global forces such as a magnetic field. While the motion planning for one robot may be trivial, the problem becomes complex when many robots receive the same motion commands.

We consider a 2D grid world, in which all obstacles and robots are unit squares, and for each actuation, robots move maximally until they collide with an obstacle or another robot. In previous work, we designed configurations to implement AND, OR, NOR, and NAND logic gates.

However, we were unable to design a FAN-OUT gate. FAN-OUT gates are necessary for simulating arbitrary digital circuits, such as a half adder.

 In this work we resolve the problem by proving unit-sized robots cannot generate a fan-out gate.  On the positive side, we resolve the missing component with the help of 2x1 robots, painted white in this prototype. These can create fan-out gates that produce multiple copies of the inputs.  Using these gates we are able to establish the full range of computational universality as presented by complex digital circuits. 

 As an example we connect our logic elements to produce a 3-bit counter.  This counter requires three FAN-OUT gates, two adders, and one gate for the carry.  Our paper gives instructions for wiring logic gates together, and explains how all gates and wiring are actuated by the same CW sequence of commands.   We also demonstrate how to implement a data storage element.

A large-scale prototype was built. The experimental setup consists of Plexiglas square boards, which can be assembled together to form a bigger board. Experimental data on success rate as a function of tipping angle are in our paper.


A full resolution version is available at [http://youtu.be/EJSv8ny31r8], all code is available online at [https://github.com/aabecker/particleComputation].



=====PLAYER INFORMATION===================================================

.mp4 is playable by quicktime and other standard video players 
[online: http://www.apple.com/quicktime/download/]
Codec: MPEG-4



=====CONTACT INFORMATION==================================================

Seyed Hamed Mohtasham Shad, Rose Morris-Wright, Erik Demaine[1], Sándor Fekete [2], Becker, Aaron [3]

[1] CSAIL, MIT,  Cambridge, MA 02139, USA 
[2] Department of Computer Science, TU Braunschweig, 38106 Braunschweig, Germany
[3] Department of Electrical and Computer Engineering, University of Houston,  Houston, TX 77004, USA

[atbecker@uh.edu]



Author Websites:

[www.youtube.com/user/aabecker5]

[http://www.swarmcontrol.net/]

[http://www.ibr.cs.tu-bs.de/users/fekete/?lang=en]

[http://erikdemaine.org]

