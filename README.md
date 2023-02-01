# Multicycle-Processor
### The single-cycle processor has three primary weaknesses. First, it requires
a clock cycle long enough to support the slowest instruction (lw), even
though most instructions are faster. Second, it requires three adders
(one in the ALU and two for the PC logic); adders are relatively expensive
circuits, especially if they must be fast. And third, it has separate instruction and data memories, which may not be realistic. Most computers have
a single large memory that holds both instructions and data and that can
be read and written.
The multicycle processor addresses these weaknesses by breaking an
instruction into multiple shorter steps. In each short step, the processor can read or write the memory or register file or use the ALU. Different
instructions use different numbers of steps, so simpler instructions can
complete faster than more complex ones.
##### - Datapath block diagram
![Screenshot (134)](https://user-images.githubusercontent.com/96621514/216062259-29614ce9-fedb-4048-903c-79eed9b3ac0f.png)
##### - Control unit block diagram
![Screenshot (136)](https://user-images.githubusercontent.com/96621514/216062964-87b892d1-723a-4908-a08e-c6a332b7201e.png)
##### - FSM (The main decoder acts as a FSM)
![Screenshot (135)](https://user-images.githubusercontent.com/96621514/216063197-81b9f02d-9dc9-4c62-b466-d3e7a29dbe88.png)
##### - The simulation was done on Modelsim and here is a screenshot with the output
![Screenshot (130)](https://user-images.githubusercontent.com/96621514/216063735-82969bb5-cc80-486f-8601-c11e1b0619c5.png)
### Reference: David M. Harris, Sarah L. Harris - Digital Design and Computer Architecture
